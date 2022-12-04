import PlayerFunctions from "@base/functions/player";
import Logger from "@base/shared/logger";

RegisterCommand(
  "spawn",
  function (source: number, args: string[], rawCommand: string) {
    PlayerFunctions.Spawn();
    Logger.info(`${source}: SPAWN`);
  },
  false
);
