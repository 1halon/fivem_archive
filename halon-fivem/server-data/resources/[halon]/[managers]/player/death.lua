Citizen.CreateThread(
    function()
        local tod = nil
        local wasVictimInAnyVehicle, victimVehicleName, victimVehicleSeat, killerPedType, isKillerInAnyVehicle, killerVehicleName, killerVehicleSeat, eventName
        while true do
            Citizen.Wait(0)
            local player = PlayerId()

            if NetworkIsPlayerActive(player) then
                local ped = PlayerPedId()

                if ped and ped ~= -1 then
                    if IsPedFatallyInjured(ped) and not diedAt then
                        tod = GetGameTimer()

                        if IsPedInAnyVehicle(ped, false) then
                            wasVictimInAnyVehicle = true
                            victimVehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(ped)))
                            victimVehicleSeat = GetPedVehicleSeat(ped)
                        else
                            wasVictimInAnyVehicle = false
                        end

                        local killer, weapon = NetworkGetEntityKillerOfPlayer(player)
                        local killer_coords = GetEntityCoords(killer)
                        local killer_type = GetEntityType(killer)

                        if killer_type == 1 then
                            killerPedType = GetPedType(killer)
                            if IsPedInAnyVehicle(killer, false) then
                                isKillerInAnyVehicle = true
                                killerVehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
                                killerVehicleSeat = GetPedVehicleSeat(killer)
                            else
                                isKillerInAnyVehicle = false
                            end
                        end

                        local killerID = GetPlayerServerId(killer)
                        if killer ~= ped and killerID ~= nil and NetworkIsPlayerActive(killerID) then
                            killerID = GetPlayerServerId(killerID)
                        else
                            killerID = -1
                        end

                        local info = {
                            player = player,
                            TOD = tod,
                            COF = GetPedCauseOfDeath(ped),
                            --SOF = GetPedSourceOfDeath(ped),
                            death_coords = IsPedInAnyVehicle(ped, false),
                            wasVictimInAnyVehicle = wasVictimInAnyVehicle,
                            victimVehicleName = victimVehicleName,
                            victimVehicleSeat = victimVehicleSeat,
                            killer_type = killer_type
                        }

                        if killer == ped or killer == -1 then
                            eventName = "PD"
                        else
                            info = table.insert(
                                info,
                                {
                                    killerID = killerID,
                                    killerPedType = killerPedType,
                                    weapon = weapon,
                                    killer_coords = killer_coords,
                                    isKillerInAnyVehicle = isKillerInAnyVehicle,
                                    killerVehicleName = killerVehicleName,
                                    killerVehicleSeat = killerVehicleSeat
                                }
                            )
                            eventName = "PK"
                        end

                        TriggerEvent(eventName, info)
                        TriggerServerEvent(eventName, info)
                    elseif not IsPedFatallyInjured(ped) then
                        tod = nil
                    end
                end
            end
        end
    end
)
