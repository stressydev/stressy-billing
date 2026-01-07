local Config = lib.require('shared.config')
local Framework = lib.require('bridge.sv_bridge')

-- Runtime DB creation
CreateThread(function()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `stressy_billing` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `citizenid` VARCHAR(50) NOT NULL,
            `sender` VARCHAR(100) NOT NULL,
            `job` VARCHAR(50) NOT NULL,
            `amount` INT(11) NOT NULL,
            `description` VARCHAR(255) NOT NULL,
            `account` ENUM('bank','cash') NOT NULL DEFAULT 'bank',
            `paid` TINYINT(1) NOT NULL DEFAULT 0,
            `time` BIGINT(20) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
        print("^2[Billing] Runtime database table ensured^7")
    end)
end)


RegisterNetEvent('billing:addBill', function(targetPlayerId, amount, description, account)
    print(targetPlayerId, amount, description, account)
    local src = source
    local xPlayer = Framework.GetPlayer(src)
    local tPlayer = Framework.GetPlayer(targetPlayerId)

    if not tPlayer then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Player not Found'})
    end

    if amount <= 0 or amount > Config.MaxAmount then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Invalid Amount'})
    end

    description = description or "Service Fee"
    account = account or 'bank'
    -- Insert into MySQL table
    exports.oxmysql:insert([[
        INSERT INTO stressy_billing (citizenid, sender, job, amount, description, account, time)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ]], {
        Framework.GetPlayerByCitizenId(targetPlayerId),
        Framework.GetName(src),
        Framework.GetJob(src),
        amount,
        description,
        account,
        os.time()
    }, function(id)
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = 'Bill sent to ' .. Framework.GetName(targetPlayerId)})
        TriggerClientEvent('ox_lib:notify', targetPlayerId, {type = 'info', description = 'You received a bill: ' .. description .. ' - $' .. amount .. ' ('..account..')'})
    end)

end)


-- Get bills for the player
lib.callback.register('billing:getMyBills', function(source)
    local xPlayer = Framework.GetPlayer(source)
    local citizenid = Framework.GetPlayerByCitizenId(source)
    print(citizenid)
    local result = MySQL.query.await('SELECT * FROM stressy_billing WHERE citizenid = ? ORDER BY time DESC', {citizenid})
    return result or {}
end)


RegisterNetEvent('billing:payBill', function(billId, billAmount , billAccount , billSociety)
    print(billId)
    local src = source
    local xPlayer = Framework.GetPlayer(src)
    if not xPlayer then return end

    local citizenid = Framework.GetPlayerByCitizenId(src)

    local MyAccountMoney = Framework.GetMoney(src, billAccount)

    if MyAccountMoney < billAmount then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Not enough money'})
        return
    end

    Framework.RemoveMoney(src, billAccount, billAmount, 'bill-payment')
    Framework.PaySociety(billSociety, billAmount)
    exports.oxmysql:execute('DELETE FROM stressy_billing WHERE id = ?',{ billId })

    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        description = ('Bill paid and removed: $%s'):format(billAmount)
    })
end)
