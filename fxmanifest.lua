fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.6.3'
author 'MateHUN'
description 'MateHUN <-> Exports'

shared_script '@es_extended/imports.lua'
server_script "@oxmysql/lib/MySQL.lua"

shared_script {
    '@es_extended/imports.lua',
    'shared/main.lua',
    'config.lua',
    '@ox_lib/init.lua',
}


dependency {
    'oxmysql',
    "es_extended",
    "ox_lib" -- Un Comment if not using or not needed ! ( Optional )
}

client_script {
    "client/*.*",
}

server_script {
    "server/*.*",
}

escrow_ignore {
    'config.lua',
    'client/*.*',
    'server/*.*',
    'shared/*.*',
    'icons/*.png',
    'user-snippets.json',
    'readme.md',

}

files {
    'icons/*.png'
}
