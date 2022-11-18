class PlayerFunctions {
  static SpawnLock = false;

  static Freeze(player: number, freeze: boolean) {
    SetPlayerControl(player, !freeze, 0);

    const ped = GetPlayerPed(player);

    if (freeze) {
      if (IsEntityVisible(ped)) SetEntityVisible(ped, false, false);
      SetEntityCollision(ped, false, true);
      FreezeEntityPosition(ped, true);
      SetPlayerInvincible(player, true);
      if (!IsPedFatallyInjured(ped)) ClearPedTasksImmediately(ped);
      return;
    }

    if (!IsEntityVisible(ped)) SetEntityVisible(ped, true, false);
    if (!IsPedInAnyVehicle(ped, false)) SetEntityCollision(ped, true, true);
    FreezeEntityPosition(ped, false);
    SetPlayerInvincible(player, false);
  }

  static GetIAP(): [playerID: number, pedID: number] {
    return [PlayerId(), PlayerPedId()];
  }

  static SetModel(model: string | number) {
    LoadFunctions.Model(model);
    SetPlayerModel(PlayerId(), model);
    SetModelAsNoLongerNeeded(model);
  }

  static Spawn() {
    if (this.SpawnLock) return;
    this.SpawnLock = true;

    setTick(() => {
      const [playerID, pedID] = this.GetIAP();

      this.Freeze(playerID, true);
      this.SetModel("s_m_y_marine_03");

      SetEntityCoordsNoOffset(pedID, -1037, -2737.0, 20, false, false, false);
      NetworkResurrectLocalPlayer(-1037, -2737.0, 20, 329, true, true);
      ClearPedTasksImmediately(pedID);
      RemoveAllPedWeapons(pedID, false);
      ClearPlayerWantedLevel(playerID);

      ShutdownLoadingScreen();
      ShutdownLoadingScreenNui();
      this.Freeze(playerID, false);
      this.SpawnLock = false;
    });
  }
}
