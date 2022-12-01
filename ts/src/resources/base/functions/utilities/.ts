export default class UtilityFunctions {
  static DrawHelp(
    {
      beep,
      duration,
      label,
    }: { beep?: boolean; duration?: number; label?: string },
    cb?: () => void
  ) {
    BeginTextCommandDisplayHelp(label || "STRING");
    typeof cb === "function" && cb();
    EndTextCommandDisplayHelp(0, false, beep || false, duration || -1);
  }

  static DrawText(
    { label, x, y }: { label?: string; x?: number; y?: number },
    cb: () => void
  ) {
    BeginTextCommandDisplayText(label || "STRING");
    SetTextColour(255, 255, 255, 255);
    SetTextScale(1.0, 0.5);
    //SetTextCentre(true)
    //SetTextJustification(0)
    typeof cb === "function" && cb();
    EndTextCommandDisplayText(x || 0, y || 0);
  }

  static DrawText2(
    { duration, label }: { duration?: number; label?: string },
    cb: () => void
  ) {
    BeginTextCommandPrint(label || "STRING");
    typeof cb === "function" && cb();
    EndTextCommandPrint(duration || 5000, true);
  }

  static FeedPostTicker(
    {
      text,
      type,
      blink,
      label,
      message_text,
      showInBrief,
      stats,
      timeout,
    }: {
      blink?: boolean;
      label?: string;
      message_text?: {
        iconType?: number;
        flash?: boolean;
        sender?: string;
        subject?: string;
      };
      stats?: {
        statTitle: string;
        iconEnum?: number;
        stepVal: boolean;
        barValue: number;
        isImportant?: boolean;
      };
      showInBrief?: boolean;
      text: string;
      timeout?: number;
      type: "NOTIFICATION" | "MESSAGE_TEXT" | "STATS";
    },
    ped?: number
  ) {
    BeginTextCommandThefeedPost(label || "STRING");
    AddTextComponentSubstringPlayerName(text);

    let post = -1;
    if (["MESSAGE_TEXT", "STATS"].includes(type)) {
      setTick(function () {
        const headshot = RegisterPedheadshot(ped || PlayerPedId());
        while (IsPedheadshotReady(headshot) && !IsPedheadshotValid(headshot))
          Wait(0);

        const txd = GetPedheadshotTxdString(headshot);
        if (type === "MESSAGE_TEXT")
          post = EndTextCommandThefeedPostMessagetext(
            txd,
            txd,
            message_text?.flash || false,
            message_text?.iconType || 0,
            message_text?.sender || GetPlayerName(PlayerId()),
            message_text?.subject || "New Message"
          );

        if (type === "STATS") {
          // @ts-ignore
          AddTextComponentInteger(stats.barValue);
          post = EndTextCommandThefeedPostStats(
            // @ts-ignore
            stats.statTitle,
            stats?.iconEnum || 14,
            // @ts-ignore
            stats.stepVal,
            // @ts-ignore
            stats.barValue,
            stats?.isImportant || false,
            txd,
            txd
          );
        }

        EndTextCommandThefeedPostTicker(blink || false, showInBrief || false);
        UnregisterPedheadshot(headshot);
      });
    }

    if (type === "NOTIFICATION") {
      post = EndTextCommandThefeedPostTicker(
        blink || false,
        showInBrief || false
      );
    }

    timeout && post && setTimeout(() => ThefeedRemoveItem(post), timeout * 1e3);
  }
}
