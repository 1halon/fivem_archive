Logger = {
    ["log"] = function(message, ...)
        print((message):format(...))
    end,
    ["info"] = function(message, ...)
        print(("[^5INFO^7] " .. message):format(...))
    end,
    ["warn"] = function(message, ...)
        print(("[^3WARNING^7] " .. message):format(...))
    end,
    ["error"] = function(message, ...)
        error((message):format(...))
    end,
    ["verbose"] = function(message, ...)
        print(("[^6VERBOSE^7] " .. message):format(...))
    end
}

--RegisterNetEvent("halon_system:Logger")
AddEventHandler(
    "halon_system:Logger",
    function(func, message, ...)
        Logger[func](message, ...)
    end
)
