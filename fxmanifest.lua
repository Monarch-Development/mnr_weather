fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mnr_weather'
description 'Weather manager resource'
author 'IlMelons'
version '1.0.0'
repository 'https://github.com/Monarch-Development/mnr_weather'


ox_lib 'locale'

-- files {
--     'locales/*.json'
-- }

shared_scripts {
    '@ox_lib/init.lua',
    'config/shared.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'config/server.lua',
    'server/*.lua',
}