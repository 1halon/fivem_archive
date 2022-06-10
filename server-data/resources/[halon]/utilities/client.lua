Citizen.CreateThread(
    function()
        AddTextEntry("COORDS", "X: ~a~~n~Y: ~a~~n~Z: ~a~~n~H: ~a~")
        while true do
            Citizen.Wait(0)
            for id = 1, 22 do
                for _, control in pairs({19,20, 37, 85, 199 }) do
                    DisableControlAction(0, control, true)
                end
                HideHudComponentThisFrame(id)
            end
            HudWeaponWheelIgnoreSelection()

            local player, ped = PlayerId(), PlayerPedId()
            local x, y, z, h = table.unpack(vector4(GetEntityCoords(ped), GetEntityHeading(ped)))

            DrawText(
                { label = "COORDS" },
                function()
                    AddTextComponentSubstringPlayerName(string.format("%.2f", x))
                    AddTextComponentSubstringPlayerName(string.format("%.2f", y))
                    AddTextComponentSubstringPlayerName(string.format("%.2f", z))
                    AddTextComponentSubstringPlayerName(string.format("%.2f", h))
                end
            )
        end
    end
)

--[[
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
--]]
