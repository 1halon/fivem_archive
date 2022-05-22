author "HALON"
client_scripts {
    "@halon_utilities/functions.lua",
    "@halon_utilities/scaleform.lua",
    "client.lua",
    "death.lua",
    "gps.lua",
    "spawn.lua",
    "vehicle.lua"
}
data_file "HANDLING_FILE" "handling.meta"
dependency "mysql-async"
files {
    "handling.meta"
}
fx_version "cerulean"
game "gta5"
server_scripts {"@mysql-async/lib/MySQL.lua", "server.lua"}
version "1.0.0"
