function SetupIBScaleform(buttons)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    --DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    function AddButton(int, button, message)
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(int)
        if type(button) == "table" then
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
        --N_0xe83a3e3557a56640(ControlButton)
        ScaleformMovieMethodAddParamPlayerNameString(ControlButton)
    end

    function ButtonMessage(text)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(text)
        EndTextCommandScaleformString()
    end

    for int, button in pairs(buttons) do
        AddButton(type(button[1]) == "number" and (v[1]) or int - 1, table.unpack(button))
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function SetupMSMScaleform(header, message)
    local scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "SHOW_COND_SHARD_MESSAGE")
    PushScaleformMovieMethodParameterString(header)
    PushScaleformMovieMethodParameterString(message)
    PushScaleformMovieMethodParameterInt(2)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

exports("SetupIBScaleform", SetupIBScaleform)
exports("SetupMSMScaleform", SetupMSMScaleform)
