export default class ScaleformFunctions {
  static InstructionalButtons(
    buttons: {
      controls: ReturnType<typeof GetControlInstructionalButton>[];
      name: string;
    }[]
  ) {
    const scaleform = RequestScaleformMovie("instructional_buttons");

    while (HasScaleformMovieLoaded(scaleform)) {
      Wait(0);
    }

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL");
    PopScaleformMovieFunctionVoid();

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE");
    PushScaleformMovieFunctionParameterInt(200);
    PopScaleformMovieFunctionVoid();

    for (let index = 0; index < buttons.length; index++) {
      const { controls, name } = buttons[index];

      PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT");
      PushScaleformMovieFunctionParameterInt(index);

      for (const control of controls) {
        ScaleformMovieMethodAddParamPlayerNameString(control);
        BeginTextCommandScaleformString("STRING");
        AddTextComponentScaleform(name);
        EndTextCommandScaleformString();
      }
    }

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS");
    PopScaleformMovieFunctionVoid();

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR");
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(80);
    PopScaleformMovieFunctionVoid();

    return scaleform;
  }

  static MidsizedMessage(header: string, message: string) {
    const scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE");
    while (!HasScaleformMovieLoaded(scaleform)) Wait(0);

    PushScaleformMovieFunction(scaleform, "SHOW_COND_SHARD_MESSAGE");
    PushScaleformMovieMethodParameterString(header);
    PushScaleformMovieMethodParameterString(message);
    PushScaleformMovieMethodParameterInt(2);
    PopScaleformMovieFunctionVoid();

    return scaleform;
  }
}
