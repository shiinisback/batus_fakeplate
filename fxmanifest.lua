fx_version 'cerulean'
game 'gta5'

author 'batusdev'
description 'Fake Plate System (ox/qb inventory - ox/qb target - multi-language)'
version '1.0.0'

shared_scripts {
    "lang/lang.lua",
    "config.lua"
}

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'
