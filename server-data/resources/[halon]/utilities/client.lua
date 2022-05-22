Citizen.CreateThread(
    function()
        AddTextEntry("COORDS", "X: ~a~~n~Y: ~a~~n~Z: ~a~~n~H: ~a~")
        local multiplier = 0
        while true do
            Citizen.Wait(0)

            SetAmbientVehicleRangeMultiplierThisFrame(multiplier)
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
            SetGarbageTrucks(false)
            SetParkedVehicleDensityMultiplierThisFrame(multiplier)
            SetPedDensityMultiplierThisFrame(multiplier)
            SetRandomBoats(false)
            SetRandomVehicleDensityMultiplierThisFrame(multiplier)
            SetScenarioPedDensityMultiplierThisFrame(multiplier, multiplier)
            SetVehicleDensityMultiplierThisFrame(multiplier)

            for i = 1, NetworkGetNumConnectedPlayers() do
                local blip = GetBlipFromEntity(GetPlayerPed(i))
                if DoesEntityExist(blip) then
                    SetBlipShowCone(blip, false)
                    SetBlipDisplay(blip, 0)
                end
            end

            local player, ped = PlayerId(), PlayerPedId()
            local x, y, z, h = table.unpack(vector4(GetEntityCoords(ped), GetEntityHeading(ped)))

            ClearAreaOfCops(x, y, z, 100, 0)
            ClearPlayerWantedLevel(player)
            SetPoliceIgnorePlayer(player, true)
            SetPoliceRadarBlips(false)

            if hideHUD then
                HideAreaAndVehicleNameThisFrame()
                HideHelpTextThisFrame()
                HideHudAndRadarThisFrame()
            else
                DrawText(
                    {label = "COORDS"},
                    function()
                        AddTextComponentSubstringPlayerName(string.format("%.2f", x))
                        AddTextComponentSubstringPlayerName(string.format("%.2f", y))
                        AddTextComponentSubstringPlayerName(string.format("%.2f", z))
                        AddTextComponentSubstringPlayerName(string.format("%.2f", h))
                    end
                )
            end
        end
    end
)

Citizen.CreateThread(
    function()
        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        while true do
            Citizen.Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end
    end
)

RegisterNetEvent("halon_utilities:hideHUD")
AddEventHandler(
    "halon_utilities:hideHUD",
    function(boolean)
        hideHUD = boolean
    end
)
