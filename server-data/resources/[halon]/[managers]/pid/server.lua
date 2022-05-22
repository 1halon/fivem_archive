RegisterNetEvent("halon_pid:Create")
AddEventHandler(
    "halon_pid:Create",
    function(pid)
        TriggerEvent(
            "halon_session:GetPlayerData",
            [[function func(data, pid)
                if data["identifiers"] and data["identifiers"].steam then
                    local _source = tostring(source)
                    MySQL.Async.execute(
                        "UPDATE players SET pid=@pid WHERE id=@id",
                        {
                            ["@pid"] = pid and json.encode(pid) or nil,
                            ["@id"] = data["identifiers"].steam
                        },
                        function(rows)
                            if rows > 0 then
                                TriggerEvent("halon_pid:Created", pid)
                                TriggerClientEvent("halon_pid:Created", _source, pid)
                            end
                        end
                    )
                end
            end]],
            tostring(source),
            pid
        )
    end
)
