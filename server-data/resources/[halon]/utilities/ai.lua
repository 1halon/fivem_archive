Citizen.CreateThread(
    function()
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

            local player, ped = PlayerId(), PlayerPedId()
            local x, y, z, h = table.unpack(vector4(GetEntityCoords(ped), GetEntityHeading(ped)))

            ClearAreaOfCops(x, y, z, 100, 0)
            ClearPlayerWantedLevel(player)
            SetPoliceIgnorePlayer(player, true)
            SetPoliceRadarBlips(false)
        end
    end
)
