fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'X-CODE (sokey) BACK-END / Babicz Industries (.trampek) FRONT-END'
description 'Black Money System - discord.gg/x-code / discord.gg/babiczind'
version '1.0.0'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/assets/svg/*.svg'
}