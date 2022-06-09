Citizen.CreateThread(
    function()
        local isPlayerInAnyVehicle = false
        local playerCurrentVehicle = {}

        while true do
            Citizen.Wait(0)
            local player = PlayerId()
            local ped = PlayerPedId()

            if isPlayerInAnyVehicle then
                if not IsPedInAnyVehicle(ped, false) then
                    isPlayerInAnyVehicle = false
                    playerCurrentVehicle.coords = GetEntityCoords(playerCurrentVehicle.entity)
                    TriggerEvent("PLAV", playerCurrentVehicle)
                    TriggerServerEvent("PLAV", playerCurrentVehicle)
                    playerCurrentVehicle = {}
                end
            else
                if IsPedInAnyVehicle(ped, false) then
                    isPlayerInAnyVehicle = true
                    local vehicle = GetVehiclePedIsUsing(ped)
                    local model = GetEntityModel(vehicle)
                    playerCurrentVehicle = {
                        entity = vehicle,
                        model = model,
                        name = GetDisplayNameFromVehicleModel(model),
                        seat = GetPedVehicleSeat(ped),
                        coords = GetEntityCoords(vehicle),
                        netID = VehToNet(vehicle)
                    }
                    TriggerEvent("PEAV", playerCurrentVehicle)
                    TriggerServerEvent("PEAV", playerCurrentVehicle)
                end
            end
        end
    end
)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if (GetPedInVehicleSeat(vehicle, i) == ped) then
            return i
        end
    end
    return -2
end

RegisterCommand(
    "veh",
    function(source, args)
        local subcommand, p1 = table.unpack(args)
        if subcommand ~= nil then
            local player = PlayerId()
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)

            if vehicle ~= 0 and subcommand == "fix" then
                SetVehicleBodyHealth(vehicle, 1000)
                SetVehicleDirtLevel(vehicle, 0)
                SetVehicleDoorsShut(vehicle, false)
                SetVehicleEngineHealth(vehicle, 1000)
                SetVehicleEngineOn(vehicle, true, true)
                SetVehicleFixed(vehicle)
            end
            if subcommand == "delete" then
                SetEntityAsMissionEntity(p1 or vehicle, true, true)
                DeleteVehicle(p1 or vehicle)
            elseif subcommand == "spawn" then
                Citizen.CreateThread(
                    function()
                        local x, y, z = table.unpack(GetEntityCoords(ped))
                        local vehicle_hash = GetHashKey(p1)
                        local waiting = 0
                        RequestModel(vehicle_hash)
                        while not HasModelLoaded(vehicle_hash) do
                            waiting = waiting + 100
                            Citizen.Wait(100)
                            if waiting > 5000 then
                                break
                            end
                        end
                        local vehicle = CreateVehicle(vehicle_hash, x, y, z, GetEntityHeading(ped), true, false)
                        SetModelAsNoLongerNeeded(vehicle_hash)
                        SetPedIntoVehicle(ped, vehicle, -1)
                        SetVehicleNumberPlateText(vehicle, "ADMIN")
                    end
                )
            end
        end
    end
)

RegisterCommand(
    "1gas",
    function(source, args)
        Citizen.CreateThread(
            function()
                local car_hash = GetHashKey("t20")
                LoadModel(car_hash)
                local driver_hash = GetHashKey("s_m_m_highsec_01")
                LoadModel(driver_hash)

                local ped = PlayerPedId()
                print(ped)
                local x, y, z = table.unpack(GetEntityCoords(ped))
                local retval, outPosition, outHeading =
                    GetClosestVehicleNodeWithHeading(
                    x + math.random(-100, 100),
                    y + math.random(-100, 100),
                    z,
                    0,
                    3.0,
                    0
                )
                local car = CreateVehicle(car_hash, outPosition, outHeading, true, false)
                SetModelAsNoLongerNeeded(car_hash)
                SetVehicleHasBeenOwnedByPlayer(car, true)
                SetVehicleOnGroundProperly(car)

                local blip = AddBlipForEntity(car)
                SetBlipFlashes(blip, true)
                SetBlipColour(blip, 5)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Personal Vehicle")
                EndTextCommandSetBlipName(blip)

                local driver = CreatePedInsideVehicle(car, 26, driver_hash, -1, true, false)
                SetModelAsNoLongerNeeded(ped_hash)
                SetEntityVisible(driver, false, 0)
                SetDriverAbility(driver, 1.0)
                SetDriverAggressiveness(driver, 0.0)
                TaskVehicleMissionPedTarget(driver, car, ped, 4, 15.0, 786603, 10, 0, true)

                while true do
                    Citizen.Wait(0)
                    local dist = Vdist2(x, y, z, GetEntityCoords(car))
                    print(dist, car)
                    if dist < 75 then
                        RemoveBlip(blip)
                        TaskVehicleTempAction(driver, car, 27, 5000)
                        Citizen.Wait(5000)
                        DeleteEntity(driver)
                        break
                    end
                end
            end
        )
    end
)

RegisterCommand(
    "fligth",
    function(source, args)
        Citizen.CreateThread(
            function()
                local plane_hash = GetHashKey("nimbus")
                RequestModel(plane_hash)
                while not HasModelLoaded(plane_hash) do
                    Citizen.Wait(0)
                end

                local pilot_hash = GetHashKey("s_m_m_pilot_01")
                RequestModel(pilot_hash)
                while not HasModelLoaded(pilot_hash) do
                    Citizen.Wait(0)
                end

                local startRunway = vector3(-1625.15, -2711.0, 13.98)
                local plane = CreateVehicle(plane_hash, startRunway, 335.25, true, false)
                local maxSpeed = GetVehicleEstimatedMaxSpeed(plane)
                SetModelAsNoLongerNeeded(plane_hash)
                SetEntityProofs(plane, true, true, true, true, true, true, true, true)
                SetVehicleDoorsLocked(plane, 4)
                SetVehicleColours(plane, 0, 0)
                SetVehicleOnGroundProperly(plane)
                SetVehicleEngineOn(plane, true, true, true)

                local pilot = CreatePedInsideVehicle(plane, 26, pilot_hash, -1, true, false)
                SetModelAsNoLongerNeeded(pilot_hash)
                SetBlockingOfNonTemporaryEvents(pilot, true)
                local ped = PlayerPedId()
                SetPedIntoVehicle(ped, plane, 2)

                local startRunwayEnd = vector3(1380.0, -2285.5, 13.98)
                TaskVehicleDriveToCoordLongrange(pilot, plane, startRunwayEnd, maxSpeed, 786603, 0.0)
                Citizen.Wait(10000)
                local endRunway = vector3(1079.5, 3092.25, 40.5)
                TaskPlaneMission(pilot, plane, 0, 0, endRunway, 4, 150.0, 0.0, 45.0, 0, 75.0)
                Citizen.Wait(2500)
                ControlLandingGear(plane, 1)

                local landing = false
                while true do
                    Citizen.Wait(5000)
                    if landing then
                        if not IsEntityInAir(plane) then
                            DeleteEntity(pilot)
                            if GetEntitySpeed(plane) < 1.0 then
                                SetVehicleDoorsLocked(plane, 1)
                                TaskLeaveVehicle(ped, plane, 0)
                                Citizen.Wait(5000)
                                DeleteVehicle(plane)
                                break
                            end
                        end
                    else
                        local landingRunway = vector3(1440.5, 3044.2, 40.5)
                        if IsEntityInZone(plane, "DESRT") and Vdist(GetEntityCoords(plane), endRunway) < 1500.0 then
                            TaskPlaneLand(pilot, plane, landingRunway.xy, landingRunway.z + 5.0, 1680.5, 3244.0, 40.75)
                            SetPedKeepTask(pilot, true)
                            landing = true
                        end
                    end
                end
            end
        )
    end
)
