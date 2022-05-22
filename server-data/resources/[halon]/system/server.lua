local aia = {}
RegisterNetEvent("halon_system:AIA")
AddEventHandler(
    "halon_system:AIA",
    function(object)
        local _source = tostring(source)
        if not aia[_source] then
            aia[_source] = {}
        end
        if not aia[_source][object] then
            aia[_source][object] = IsPlayerAceAllowed(source, object)
        end
        TriggerClientEvent("halon_system:YAA", source, aia[_source][object])
    end
)

MySQL.ready(
    function()
        MySQL.Async.fetchAll(
            "SELECT job, society FROM jobs",
            nil,
            function(result)
                if #result ~= 0 then
                    local function AddPrincipal(job, society)
                        ExecuteCommand(("remove_principal %s %s"):format(job, society))
                        ExecuteCommand(("add_principal %s %s"):format(job, society))
                    end
                    for i = 1, #result do
                        local job, society = result[i].job, result[i].society
                        AddPrincipal(job, society)
                    end
                end
            end
        )
    end
)
