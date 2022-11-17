const { garbagetrucks, multiplier, randomboats, randomcops } = BaseConfig["ai"],
  multiplier_funcs = [
    SetAmbientVehicleRangeMultiplierThisFrame,
    SetParkedVehicleDensityMultiplierThisFrame,
    SetPedDensityMultiplierThisFrame,
    SetRandomVehicleDensityMultiplierThisFrame,
    SetScenarioPedDensityMultiplierThisFrame,
    SetVehicleDensityMultiplierThisFrame,
  ];

setTick(function () {
  while (true) {
    Wait(0);
    SetGarbageTrucks(garbagetrucks);
    for (const key in multiplier_funcs)
      multiplier_funcs[key](multiplier, multiplier);
    SetRandomBoats(randomboats);

    const player = PlayerId(),
      [x, y, z] = GetEntityCoords(PlayerPedId());

    ClearAreaOfCops.bind(null, ...GetEntityCoords(PlayerPedId()))(100, 0);
    //ClearAreaOfCops(x, y, z, 100, 0);
    ClearPlayerWantedLevel(player);
    SetPoliceIgnorePlayer(player, randomcops);
    SetPoliceRadarBlips(randomcops);
  }
});
