import { Delay } from "@base/shared/functions";

export default class LoadFunctions {
  static async AnimDict(anim_dict: string) {
    DoesAnimDictExist(anim_dict) && RequestAnimDict(anim_dict);

    while (!HasAnimDictLoaded(anim_dict)) await Delay(0);

    return anim_dict;
  }

  static async Model(model: string | number, timeout?: number) {
    RequestModel(model);

    let wait = 0;
    while (!HasModelLoaded(model)) {
      await Delay(100);
      if (timeout) {
        wait += 100;
        if (wait > timeout) break;
      }
    }

    return model;
  }

  static async Scaleform(scaleformName: string) {
    const scaleform = RequestScaleformMovie(scaleformName);

    while (HasScaleformMovieLoaded(scaleform)) await Delay(0);

    return scaleform;
  }
};
