class PlayerFunctions {
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
}
