import PlayerFunctions from "@base/functions/player.js";
import Logger from "@base/shared/logger.js";

RegisterCommand(
  "spawn",
  function (source: number, args: string[], rawCommand: string) {
    PlayerFunctions.Spawn();
    Logger.info("SPAWN");
  },
  false
);
