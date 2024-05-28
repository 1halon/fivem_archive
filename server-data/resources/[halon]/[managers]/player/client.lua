RegisterCommand(
    "tpm",
    function()
        if GetFirstBlipInfoId(8) ~= 0 then
            local ped = PlayerPedId()
            local waypointBlip = GetFirstBlipInfoId(8)
            local x, y, z = table.unpack(GetBlipCoords(waypointBlip))

            for height = 1, 800 do
                Citizen.Wait(0)
                SetPedCoordsKeepVehicle(ped, x, y, z + height)

                local ground, _ = GetGroundZFor_3dCoord(x, y, z + height)
                if ground then
                    break
                end
            end
        end
    end
)
