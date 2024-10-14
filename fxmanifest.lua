

fx_version 'adamant'
game 'gta5'

author 'glensowV5#0001'
description 'Bank'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua', --Enable if you want ox target/menu
    "config.lua",
}

server_scripts { 
	"@oxmysql/lib/MySQL.lua",
    "server/*.lua",
    "bridge/server.lua"
}

client_scripts { 
    "client/*.lua",
    "bridge/client.lua"
}

escrow_ignore {
  'config.lua',
}
dependency '/assetpacks'