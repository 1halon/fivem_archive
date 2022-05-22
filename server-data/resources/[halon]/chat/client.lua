Citizen.CreateThread(
    function()
        SetTextChatEnabled(false)
        SetNuiFocus(false, false)

        Citizen.Wait(1000)
        for _, suggestion in pairs(suggestions) do
            Citizen.Wait(0)
            TriggerEvent("halon_chat:AddSuggestion", suggestion)
        end

        while true do
            Citizen.Wait(0)

            if IsControlJustReleased(0, 245) then
                SetNuiFocus(true, false)
                SendNUIMessage({type = "ON"})
            end
        end
    end
)

AddEventHandler(
    "halon_chat:AddSuggestion",
    function(suggestion)
        SendNUIMessage(
            {
                type = "AddSuggestion",
                suggestion = suggestion
            }
        )
    end
)

AddEventHandler(
    "halon_chat:RemoveSuggestion",
    function(name)
        SendNUIMessage(
            {
                type = "RemoveSuggestion",
                name = name
            }
        )
    end
)

AddEventHandler(
    "halon_chat:OverrideSuggestion",
    function(name, suggestion)
        SendNUIMessage(
            {
                type = "OverrideSuggestion",
                name = name,
                suggestion = suggestion
            }
        )
    end
)

RegisterNUICallback(
    "execute",
    function(data, callback)
        ExecuteCommand(data.commandString)
        SetNuiFocus(false, false)
        callback({})
    end
)
