RegisterNetEvent("halon_pid:PID")
AddEventHandler(
    "halon_pid:PID",
    function(pid, last_coords)
        local model = "mp_m_freemode_01"
        pid = json.decode(pid)
        if pid then
            local gender = pid.gender
            if gender == "Female" then
                model = "mp_f_freemode_01"
            end
            print(json.encode({last_coords, model = model}))
            TriggerEvent("halon_player:SpawnPlayer", last_coords)
        else
            Citizen.Wait(2000)
            SetNuiFocus(true, true)
            SendNUIMessage({type = "ON"})
        end
    end
)

RegisterCommand(
    "pid",
    function()
        TriggerEvent("halon_pid:PID")
    end
)

RegisterNUICallback(
    "create",
    function(data, callback)
        SetNuiFocus(false, false)
        SendNUIMessage({type = "OFF"})
        TriggerEvent("halon_player:SpawnPlayer")
        TriggerServerEvent("halon_pid:Create", data)
    end
)
