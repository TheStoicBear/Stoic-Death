author "TheStoicBear"
description "Stoic-Death."
version "2.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
    "source/clie/client.lua",
    "source/veh/client.lua"
}
server_scripts {
    "source/serv/server.lua"
}

shared_scripts {
    "config.lua",
    "@ND_Core/init.lua",
    "@ox_lib/init.lua"
}

dependency "ND_Core"