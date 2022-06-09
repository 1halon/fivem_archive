local default_spawn, default_model = {x = -1037.0, y = -2737.0, z = 20.0, heading = 329.0}, "mp_m_freemode_01"
local spawn_lock = false

function FreezePlayer(id, freeze)
    SetPlayerControl(id, not freeze, false)
    local ped = GetPlayerPed(id)
    if freeze then
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(id, true)
        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    else
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end
        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(id, false)
    end
    TriggerEvent("PF", freeze)
    TriggerServerEvent("PF", freeze)
end

function SetModel(model)
    exports["utilities"]:LoadModel(model)
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
end

RegisterNetEvent("SP")
AddEventHandler(
    "SP",
    function(spawn)
        SpawnPlayer(spawn)
    end
)

function SpawnPlayer(spawn)
    if spawn_lock then
        return
    end
    spawn_lock = true

    if type(spawn) ~= "table" then
        spawn = default_spawn
    end

    local spawn_coords = vector4(spawn.x, spawn.y, spawn.z, spawn.heading)
    spawn.model = spawn.model or default_model

    if not IsPlayerSwitchInProgress() then
    --SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
    Citizen.CreateThread(
        function()
            FreezePlayer(PlayerId(), true)
            SetModel(spawn.model)
            local ped = PlayerPedId()
            SetEntityCoordsNoOffset(ped, spawn_coords.xyz, false, false, false, true)
            NetworkResurrectLocalPlayer(spawn_coords.xyzw, true, true, false)
            ClearPedTasksImmediately(ped)
            RemoveAllPedWeapons(ped, false)
            ClearPlayerWantedLevel(PlayerId())

            --while not HasCollisionLoadedAroundEntity(ped) do
            --    Citizen.Wait(0)
            --end

            local player, ped = PlayerId(), PlayerPedId()
            local coords, coords2 = vector3(-1195.55, -1788.25, 50.0), GetEntityCoords(ped)
            local cam, cam2 =
                CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.xy, coords2.z + 75, 0.0, 0.0, 0.0, 90.0, false),
                CreateCameraWithParams(
                    "DEFAULT_SCRIPTED_CAMERA",
                    coords2.xy,
                    coords2.z + 75,
                    0.0,
                    0.0,
                    0.0,
                    90.0,
                    false
                )
            PointCamAtEntity(cam, ped, 0.0, 0.0, 0.0, true)
            PointCamAtEntity(cam2, ped, 0.0, 0.0, 0.0, true)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, false)
            local duration = Vdist2(coords, coords2) >= 2000000 and 7500 or 5000
            SetCamActiveWithInterp(cam2, cam, duration, 0, 0)
            RenderScriptCams(true, true, duration, true, false)

            --[[while GetPlayerSwitchState() ~= 5 do
                Citizen.Wait(0)
            end

            local timer = GetGameTimer()
            while true do
                Citizen.Wait(0)
                if GetGameTimer() - timer > 5000 then
                    SwitchInPlayer(PlayerPedId())
                    while GetPlayerSwitchState() ~= 12 do
                        Citizen.Wait(0)
                    end
                    break
                end
            end--]]
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
            Citizen.Wait(duration)
            RenderScriptCams(false, true, 1000, true, false)
            Citizen.Wait(1000)
            FreezePlayer(PlayerId(), false)
            spawn_lock = false
            TriggerEvent("PS", spawn)
            TriggerServerEvent("PS", spawn)
        end
    )
end

SpawnPlayer()

exports("FreezePlayer", FreezePlayer)
exports("SetModel", SetModel)
exports("SpawnPlayer", SpawnPlayer)
