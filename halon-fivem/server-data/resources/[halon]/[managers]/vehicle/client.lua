Citizen.CreateThread(
    function()
        local isInVeh, currentVehicle = false, {}

        while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()

            if isInVeh then
                if not IsPedInAnyVehicle(ped, false) then
                    isInVeh = false
                    currentVehicle.coords = GetEntityCoords(currentVehicle.entity)
                    TriggerEvent("PLAV", currentVehicle)
                    TriggerServerEvent("PLAV", currentVehicle)
                    currentVehicle = {}
                end
            else
                if IsPedInAnyVehicle(ped, false) then
                    isInVeh = true
                    local vehicle = GetVehiclePedIsUsing(ped)
                    local model = GetEntityModel(vehicle)
                    currentVehicle = {
                        entity = vehicle,
                        model = model,
                        name = GetDisplayNameFromVehicleModel(model),
                        seat = GetPedVehicleSeat(ped),
                        coords = GetEntityCoords(vehicle),
                        netID = VehToNet(vehicle)
                    }
                    TriggerEvent("PEAV", currentVehicle)
                    TriggerServerEvent("PEAV", currentVehicle)
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
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)

            if vehicle ~= 0 then
                if subcommand == "del" or subcommand == "delete" then
                    SetEntityAsMissionEntity(p1 or vehicle, true, true)
                    DeleteVehicle(p1 or vehicle)
                elseif subcommand == "fix" then
                    SetVehicleBodyHealth(vehicle, 1000)
                    SetVehicleDirtLevel(vehicle, 0)
                    SetVehicleDoorsShut(vehicle, false)
                    SetVehicleEngineHealth(vehicle, 1000)
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleFixed(vehicle)
                end
            end
            if subcommand == "spawn" then
                Citizen.CreateThread(
                    function()
                        local x, y, z = table.unpack(GetEntityCoords(ped))
                        local vehicle_hash = LoadModel(p1, 5000)
                        local vehicle = CreateVehicle(vehicle_hash, x, y, z, GetEntityHeading(ped), true, false)
                        SetModelAsNoLongerNeeded(vehicle_hash)
                        SetPedIntoVehicle(ped, vehicle, -1)
                        SetVehicleColours(vehicle, 0, 0)
                        --SetVehicleOnGroundProperly(vehicle)
                        SetVehicleNumberPlateText(vehicle, "ADMIN")
                        SetVehicleNumberPlateTextIndex(vehicle, 1)
                    end
                )
            end
        end
    end
)

RegisterCommand("f", function()
    Citizen.CreateThread(function()
        local plane_hash = LoadModel("nimbus")
        local plane_vector4 = vector4(-1641.25, -2739, 14, 328.5)
        local plane = CreateVehicle(plane_hash, plane_vector4, true, false)
        local max_speed = GetVehicleEstimatedMaxSpeed(plane)
        SetModelAsNoLongerNeeded(plane_hash)
        SetEntityProofs(plane, true, true, true, true, true, true, true, true)
        SetPedIntoVehicle(PlayerPedId(), plane, 1)
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleDoorsLocked(plane, 4)
        SetVehicleEngineOn(plane, true, true, true)
        SetVehicleOnGroundProperly(plane)

        local pilot_hash = LoadModel("s_m_m_pilot_01")
        local pilot = CreatePedInsideVehicle(plane, 26, pilot_hash, -1, true, false)
        SetModelAsNoLongerNeeded(pilot_hash)
        SetBlockingOfNonTemporaryEvents(pilot, true)
    end)
end)
