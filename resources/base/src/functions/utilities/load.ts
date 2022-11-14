class LoadFunctions {
  static AnimDict(anim_dict: string) {
    DoesAnimDictExist(anim_dict) && RequestAnimDict(anim_dict);

    while (!HasAnimDictLoaded(anim_dict)) Wait(0);

    return anim_dict;
  }

  static Model(model: string | number, timeout?: number) {
    RequestModel(model);

    let wait = 0;
    while (!HasModelLoaded(model)) {
      Wait(100);
      if (timeout) {
        wait += 100;
        if (wait > timeout) break;
      }
    }

    return model;
  }

  static Scaleform(scaleformName: string) {
    const scaleform = RequestScaleformMovie("instructional_buttons");

    while (HasScaleformMovieLoaded(scaleform)) Wait(0);

    return scaleform;
  }
}
