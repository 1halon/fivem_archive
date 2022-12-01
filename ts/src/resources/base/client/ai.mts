//import { CWait } from "@base/shared/.js";
import Config from "@base/shared/config.js";

const { garbagetrucks, multiplier, randomboats, randomcops } = Config["ai"],
  multiplier_funcs = [
    SetAmbientVehicleRangeMultiplierThisFrame,
    SetParkedVehicleDensityMultiplierThisFrame,
    SetPedDensityMultiplierThisFrame,
    SetRandomVehicleDensityMultiplierThisFrame,
    SetScenarioPedDensityMultiplierThisFrame,
    SetVehicleDensityMultiplierThisFrame,
  ];

setTick(async function () {
  while (true) {
    //await CWait(1000);
    SetGarbageTrucks(garbagetrucks);
    for (const key in multiplier_funcs)
      multiplier_funcs[key](multiplier, multiplier);
    SetRandomBoats(randomboats);

    const player = PlayerId(),
      [x, y, z] = GetEntityCoords(PlayerPedId());

    ClearAreaOfCops(x, y, z, 100, 0);
    ClearPlayerWantedLevel(player);
    SetPoliceIgnorePlayer(player, randomcops);
    SetPoliceRadarBlips(randomcops);
  }
});
