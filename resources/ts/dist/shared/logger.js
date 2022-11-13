"use strict";
class Logger {
    static colorize(text, color) {
        return `${Logger.Colors[color || "white"]}${text}${Logger.Colors.white}`;
    }
    static prefix(prefix, color) {
        return this.colorize(`[${prefix}]`, color);
    }
    static log(message, ...args) {
        console.log(message);
        //let out = "";
        //for (const arg of args) out += this.prefix(arg.prefix, arg.color);
        const out = args.reduce((prev, curr, index, arr) => {
            return prev + curr;
        }, "") + message;
        //out += message;
        console.log(out);
        return out;
    }
}
