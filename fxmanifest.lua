fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.6.9'
author 'MateHUN'
description 'MateHUN <-> Exports'

shared_script '@es_extended/imports.lua'
server_script "@oxmysql/lib/MySQL.lua"

shared_script {
    "my_config.lua",
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'shared/main.lua',
}


dependency {
    'oxmysql',
    "es_extended",
    "ox_lib"
}

client_script {
    "client/*.*",
}

server_script {
    "server/*.*",
}

escrow_ignore {
    "**.*" -- IGNORE *
}

files {
    'icons/*.png'
}



files {
    'stream/*',
    'assets/*'
}
