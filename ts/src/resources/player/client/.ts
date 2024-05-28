import PlayerFunctions from "@base/functions/player";

RegisterCommand(
  "spawn",
  async function (source: number, args: string[], rawCommand: string) {
    await PlayerFunctions.Spawn();
  },
  false
);

