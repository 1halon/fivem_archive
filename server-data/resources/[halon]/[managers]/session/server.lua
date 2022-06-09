local player_data = {}

AddEventHandler(
    "playerConnecting",
    function(playerName, setKickReason, deferrals)
        local identifiers, _source = {}, tostring(source)
        player_data[_source] = {}
        for _, v in pairs(GetPlayerIdentifiers(source)) do
            if string.match(v, "discord:") then
                identifiers.discord = string.sub(v, 8)
            elseif string.match(v, "fivem:") then
                identifiers.fivem = string.sub(v, 7)
            elseif string.match(v, "ip:") then
                identifiers.ip = string.sub(v, 3)
            elseif string.match(v, "license:") then
                identifiers.license = string.sub(v, 9)
            elseif string.match(v, "steam:") then
                identifiers.steam = string.sub(v, 7)
            end
        end
        if identifiers.steam ~= nil then
            deferrals.defer()
            deferrals.update("Checking for whitelist privilege...")
            MySQL.Async.fetchAll(
                "SELECT id FROM whitelist WHERE id=@id",
                {["@id"] = identifiers.steam},
                function(result)
                    if #result == 0 then
                        deferrals.done("You're not whitelisted. Your SteamHEX: " .. identifiers.steam)
                    else
                        MySQL.Async.fetchAll(
                            "SELECT perm, pid, last_coords, job FROM players WHERE id=@id",
                            {["@id"] = identifiers.steam},
                            function(result)
                                if #result ~= 0 then
                                    local perm, pid, last_coords, job =
                                        result[1].perm,
                                        result[1].pid,
                                        result[1].last_coords,
                                        result[1].job
                                    local function AddPrincipal(perm)
                                        ExecuteCommand(("remove_principal identifier.steam:%s %s"):format(id, perm))
                                        ExecuteCommand(("add_principal identifier.steam:%s %s"):format(id, perm))
                                    end
                                    if perm then
                                        AddPrincipal(perm)
                                    end
                                    if job then
                                        AddPrincipal(job)
                                    end
                                    player_data[_source] = {
                                        identifiers = identifiers,
                                        perm = perm,
                                        pid = pid,
                                        last_coords = last_coords,
                                        job = job
                                    }
                                end
                            end
                        )
                    end
                end
            )
        else
            deferrals.done("STEAM")
        end
        deferrals.handover(
            {
                discord = identifiers.discord,
                ip = identifiers.ip,
                pid = player_data.pid,
                playerName = playerName,
                steam = identifiers.steam
            }
        )
        deferrals.done()
    end
)

AddEventHandler(
    "playerDropped",
    function(reason)
        local ped = GetPlayerPed(source)
        local last_coords = vector4(GetEntityCoords(ped), GetEntityHeading(ped))

        local _source = tostring(source)
        local id = player_data[_source] and player_data[_source]["identifiers"].steam

        if last_coords.xy ~= vector2(0, 0) and id then
            local last_coords_string, _ = json.encode(last_coords):gsub("w", "heading")
            MySQL.Async.execute(
                "UPDATE players SET last_coords=@last_coords WHERE id=@id",
                {
                    ["@last_coords"] = last_coords_string,
                    ["@id"] = id
                }
            )
        end

        player_data[_source] = nil
    end
)

AddEventHandler(
    "playerJoining",
    function(oldID)
        local _source, _oldID = tostring(source), tostring(oldID)
        player_data[_source] = player_data[_oldID]
        player_data[_oldID] = nil

        local pid, last_coords = player_data[_source].pid, player_data[_source].last_coords
    end
)

RegisterCommand(
    "wh",
    function(source, args)
        local query, cmd, id = nil, table.unpack(args)
        if cmd == "add" then
            query =
                "INSERT IGNORE INTO whitelist(id) VALUES (@id); INSERT IGNORE INTO players(id, perm, pid, last_coords, inventory, job, last_login) VALUES (@id, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, CURRENT_TIMESTAMP)"
        elseif cmd == "delete" then
            query = "DELETE FROM whitelist WHERE id=@id"
        elseif cmd == "clear" then
            MySQL.Async.execute("DELETE FROM whitelist WHERE 1")
        end
        MySQL.Async.execute(query, {["@id"] = id})
    end,
    true
)
