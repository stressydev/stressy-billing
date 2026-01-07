local Config = lib.require('shared.config')
local Framework = {}
Framework.Type =  Config.Framework or 'qbx'

if Framework.Type == 'qbx' then
    Framework.GetPlayer = function(src)
        return exports.qbx_core:GetPlayer(src)
    end
    Framework.GetMoney = function(src, acc)
        return exports.qbx_core:GetMoney(src, acc)
    end
    Framework.RemoveMoney = function(src, acc, amt, reason)
        exports.qbx_core:RemoveMoney(src, acc, amt, reason)
    end
    Framework.AddMoney = function(src, acc, amt, reason)
        exports.qbx_core:AddMoney(src, acc, amt, reason)
    end
    Framework.GetPlayerByCitizenId = function(cid)
        local Player = exports.qbx_core:GetPlayer(cid)
        return Player.PlayerData.citizenid
    end
    Framework.GetName = function(cid)
        local Player = exports.qbx_core:GetPlayer(cid)
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    end
    Framework.GetJob = function(cid)
        local Player = exports.qbx_core:GetPlayer(cid)
        return Player.PlayerData.job.name
    end

elseif Framework.Type == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework.GetPlayer = function(src)
        return QBCore.Functions.GetPlayer(src)
    end
    Framework.GetMoney = function(src, acc)
        local Player = QBCore.Functions.GetPlayer(src)
        if acc == 'bank' then return Player.PlayerData.money['bank'] end
        if acc == 'cash' then return Player.PlayerData.money['cash'] end
        return 0
    end
    Framework.RemoveMoney = function(src, acc, amt, reason)
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveMoney(acc, amt, reason)
    end
    Framework.AddMoney = function(src, acc, amt, reason)
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddMoney(acc, amt, reason)
    end
    Framework.GetPlayerByCitizenId = function(cid)
        for _, src in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(src)
            if Player.PlayerData.citizenid == cid then return Player end
        end
        return nil
    end
    Framework.GetName = function(cid)
       local Player = QBCore.Functions.GetPlayer(cid)
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    end
    Framework.GetJob = function(cid)
        local Player = QBCore.Functions.GetPlayer(cid)
        return Player.PlayerData.job.name
    end
elseif Framework.Type == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    Framework.GetPlayer = function(src)
        return ESX.GetPlayerFromId(src)
    end
    Framework.GetMoney = function(src, acc)
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return 0 end
        if acc == 'bank' then return xPlayer.getAccount('bank').money end
        if acc == 'cash' then return xPlayer.getMoney() end
        return 0
    end
    Framework.RemoveMoney = function(src, acc, amt, reason)
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        if acc == 'bank' then xPlayer.removeAccountMoney('bank', amt)
        elseif acc == 'cash' then xPlayer.removeMoney(amt) end
    end
    Framework.AddMoney = function(src, acc, amt, reason)
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        if acc == 'bank' then xPlayer.addAccountMoney('bank', amt)
        elseif acc == 'cash' then xPlayer.addMoney(amt) end
    end
    Framework.GetPlayerByCitizenId = function(cid)
        for _, id in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer and xPlayer.identifier == cid then return xPlayer end
        end
        return nil
    end
    Framework.GetName = function(cid)
        local xPlayer = ESX.GetPlayerFromId(cid)
        return xPlayer.getName()
    end
    Framework.GetJob = function(cid)
        local xPlayer = ESX.GetPlayerFromId(cid)
        return xPlayer.getJob()
    end
end


return Framework
