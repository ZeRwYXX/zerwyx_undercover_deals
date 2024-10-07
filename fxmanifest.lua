fx_version 'cerulean'
game 'gta5'

author 'ZeRwYX'
description 'Script de vente de drogue notifications NUI, Free version'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html'
}

dependencies {
    'es_extended'
}
shared_script '@es_extended/imports.lua'
