type Arg = { color: Color; prefix: string };
type Color = keyof typeof Logger.colors;
type Level = "error" | "log" | "warn";

export default class Logger {
  public static colors = {
    0: "^0",
    1: "^1",
    2: "^2",
    3: "^3",
    4: "^4",
    5: "^5",
    6: "^6",
    7: "^7",
    8: "^8",
    9: "^9",
    white: "^0",
    red: "^1",
    green: "^2",
    yellow: "^3",
    blue: "^4",
    light_blue: "^5",
    purple: "^6",
    white2: "^7",
    orange: "^8",
    blue2: "^9",
  };

  private static levels: Level[] = ["error", "log", "warn"];

  private static colorize(text: string, color?: Color) {
    return `${this.colors[color || "white"]}${text}${this.colors.white}`;
  }

  private static prefix(prefix: string, color?: Color) {
    return this.colorize(`[${prefix}] `, color || "white");
  }

  public static log(message: string, ...args: Array<Level | Arg>) {
    let level: Level = "log";
    if (typeof args[0] === "string" && this.levels.includes(args[0])) {
      level = args[0];
      args = args.slice(1).filter((arg) => typeof arg === "object");
    }
    const log =
      (args as Arg[]).reduce((prev, curr) => {
        return prev + this.prefix(curr.prefix, curr.color);
      }, "") + message;
    console[level](log);
    return log;
  }

  public static error(message: string, ...args: Arg[]) {
    return this.log(
      message,
      "error",
      { color: "red", prefix: "ERROR" },
      ...args
    );
  }

  public static info(message: string, ...args: Arg[]) {
    return this.log(message, { color: "green", prefix: "INFO" }, ...args);
  }

  public static verbose(message: string, ...args: Arg[]) {
    return this.log(message, { color: "purple", prefix: "VERBOSE" }, ...args);
  }

  public static warn(message: string, ...args: Arg[]) {
    return this.log(
      message,
      "warn",
      { color: "yellow", prefix: "WARNING" },
      ...args
    );
  }
}

Logger.info("INITIALIZED", { color: "yellow", prefix: "LOGGER" });

type LoggerType = typeof Logger;

declare global {
  var Logger: LoggerType;
}