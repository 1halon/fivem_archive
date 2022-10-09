---@alias button table<number, table<number, string> | string>
---@param buttons table<number, button>
function InstructionalButtons(buttons)
    local scaleform = RequestScaleformMovie('instructional_buttons')
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    function AddButton(int, button, message)
        PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
        PushScaleformMovieFunctionParameterInt(int)
        if type(button) == 'table' then
            for _, button in pairs(button) do
                Button(button)
            end
        else
            Button(button)
        end
        ButtonMessage(message)
        PopScaleformMovieFunctionVoid()
    end

    function Button(ControlButton)
        ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
    end

    function ButtonMessage(text)
        BeginTextCommandScaleformString('STRING')
        AddTextComponentScaleform(text)
        EndTextCommandScaleformString()
    end

    for int, button in pairs(buttons) do
        AddButton(type(button[1]) == 'number' and (v[1]) or int - 1, table.unpack(button))
    end

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
