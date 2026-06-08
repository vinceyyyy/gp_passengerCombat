fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'G_Pochico'
description 'This script lets you shoot your passengers while in the same car.'

client_scripts {
    'client/client.lua',
    'client/functions.lua'
}

server_scripts {
    'server/server.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}