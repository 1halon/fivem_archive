interface Deferrals {
  defer: () => void;
  done: (failureReason?: string) => void;
  handover: (data: object) => void;
  presentCard: (
    card: string | object,
    cb?: (data: any, rawData: string) => void
  ) => void;
  update: (message: string) => void;
}

interface Identifiers {
  discord: string | null;
  fivem: string | null;
  ip: string | null;
  license: string | null;
  steam: string | null;
  [key: string]: string | null;
}

interface Player {
  identifiers: Identifiers;
}

const players: Record<string, Player> = {};

on(
  "playerConnecting",
  function (
    playerName: string,
    setKickReason: (reason: string) => void,
    deferrals: Deferrals
  ) {
    const identifiers = GetPIdentifiers(source);
    players[source] = {
      identifiers,
    };

    if (identifiers.steam === null) {
      return deferrals.done("Steam");
    }

    deferrals.defer();
    deferrals.update("Checking for whitelist privilege...");

    deferrals.done();
  }
);

on("playerJoining", function (oldID: string) {
  players[source] = players[oldID];
  delete players[oldID];
});

on("playerDropped", function (reason: string) {
  delete players[source];
});

function GetPIdentifiers(source: number) {
  const pIdentifiers = getPlayerIdentifiers(source).map((pIdentifier) =>
      pIdentifier.split(":")
    ) as [key: string, value: string][],
    identifiers: Identifiers = {
      discord: null,
      fivem: null,
      ip: null,
      license: null,
      steam: null,
    };

  for (const key in identifiers)
    identifiers[key] =
      pIdentifiers.find((pIdentifier) => pIdentifier[0] === key)?.[1] ?? null;

  return identifiers;
}
