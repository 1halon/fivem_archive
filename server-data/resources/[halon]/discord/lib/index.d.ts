import { Client, ClientOptions } from "discord.js";
declare namespace Library {
    export class Bot extends Client {
        constructor(options: BotOptions)
        public config: typeof import("../config.json");
    }

    interface BotOptions extends ClientOptions {

    }
}

export = Library;