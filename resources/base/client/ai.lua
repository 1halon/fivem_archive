local multiplier, randomcops = Config.ai.multiplier, Config.ai.randomcops

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            SetAmbientVehicleRangeMultiplierThisFrame(multiplier)
            SetCreateRandomCops(randomcops)
            SetCreateRandomCopsNotOnScenarios(randomcops)
            SetCreateRandomCopsOnScenarios(randomcops)
            SetGarbageTrucks(Config.ai.garbagetrucks)
            SetParkedVehicleDensityMultiplierThisFrame(multiplier)
            SetPedDensityMultiplierThisFrame(multiplier)
            SetRandomBoats(Config.ai.randomboats)
            SetRandomVehicleDensityMultiplierThisFrame(multiplier)
            SetScenarioPedDensityMultiplierThisFrame(multiplier, multiplier)
            SetVehicleDensityMultiplierThisFrame(multiplier)

            local player, ped = PlayerId(), PlayerPedId()
            local x, y, z = table.unpack(vector3(GetEntityCoords(ped)))

            ClearAreaOfCops(x, y, z, 100, 0)
            ClearPlayerWantedLevel(player)
            SetPoliceIgnorePlayer(player, randomcops)
            SetPoliceRadarBlips(randomcops)
        end
    end
)
