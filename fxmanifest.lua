fx_version 'cerulean'
game 'gta5'

author '`Stressy'
description 'Stressy Billing System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
    '@qbx_core/modules/lib.lua',
}

server_scripts {
    'bride/sv_bridge.lua',
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

client_scripts {
    'bridge/cl_bridge.lua',
    'client/*.lua',
    '@qbx_core/modules/playerdata.lua',
}
