local noclip, noclip_speed = false, 3
Citizen.CreateThread(
    function()
        local NCIBForm =
            exports["utilities"]:SetupIBScaleform(
            {
                {
                    {GetControlInstructionalButton(2, 36, true), GetControlInstructionalButton(2, 21, true)},
                    "Accelerate/Decelerate"
                },
                {
                    {GetControlInstructionalButton(2, 26, true), GetControlInstructionalButton(2, 20, true)},
                    "Up/Down"
                },
                {
                    {GetControlInstructionalButton(2, 35, true), GetControlInstructionalButton(2, 34, true)},
                    "Left/Right"
                },
                {
                    {GetControlInstructionalButton(2, 33, true), GetControlInstructionalButton(2, 32, true)},
                    "Forward/Backward"
                }
            }
        )
        while true do
            Citizen.Wait(0)
            if noclip then
                DrawScaleformMovieFullscreen(NCIBForm, 255, 255, 255, 255, 0)

                DisableAllControlActions()
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                EnableControlAction(0, 245, true)

                local ped, entity, _y, _z = PlayerPedId(), PlayerPedId(), 0.0, 0.0

                if IsDisabledControlPressed(0, 32) then
                    _y = 0.5
                elseif IsDisabledControlPressed(0, 33) then
                    _y = -0.5
                end
                if IsDisabledControlPressed(0, 34) then
                    SetEntityHeading(entity, GetEntityHeading(entity) + 5.0)
                elseif IsDisabledControlPressed(0, 35) then
                    SetEntityHeading(entity, GetEntityHeading(entity) - 5.0)
                end
                if IsDisabledControlPressed(0, 20) then
                    _z = 0.5
                elseif IsDisabledControlPressed(0, 26) then
                    _z = -0.5
                end
                if IsDisabledControlPressed(0, 21) then
                    if noclip_speed < 5 then
                        noclip_speed = noclip_speed + 1
                    end
                elseif IsDisabledControlPressed(0, 36) then
                    if noclip_speed > 1 then
                        noclip_speed = noclip_speed - 1
                    end
                end

                local x, y, z =
                    table.unpack(
                    GetOffsetFromEntityInWorldCoords(entity, 0.0, _y * noclip_speed, _z * noclip_speed)
                )
                local h = GetEntityHeading(entity)
                SetEntityVelocity(entity, 0.0, 0.0, 0.0)
                SetEntityRotation(entity, 0.0, 0.0, 0.0, 0, false)
                SetEntityHeading(entity, h)
                SetEntityCoordsNoOffset(entity, x, y, z, true, true, true)
            end
        end
    end
)

RegisterCommand(
    "noclip",
    function(source, args)
        Citizen.CreateThread(
            function()
                local ped, entity = PlayerPedId(), PlayerPedId()
                local function NCM(entity, boolean)
                    FreezeEntityPosition(entity, boolean)
                    SetEntityCollision(entity, not boolean, not boolean)
                    SetEntityInvincible(entity, boolean)
                    SetEntityAlpha(entity, boolean and 204 or 255, false)
                end

                noclip, noclip_speed = not noclip, 3
                if noclip then
                    NCM(entity, true)
                else
                    NCM(entity, false)
                end
            end
        )
    end
)

RegisterKeyMapping("noclip", "Noclip", "keyboard", "F1")

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
