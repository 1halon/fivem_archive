const Discord = require("discord.js"), mysql = require("mysql"), { join } = require("path"), { GatewayServer, SlashCreator } = require("slash-create");

module.exports = class Bot extends Discord.Client {
    constructor(options) {
        super(options); this.config = require("../config.json"); this.connection = mysql.createConnection(this.config.dbconfig); this.connection.connect();

        new SlashCreator({ applicationID: this.config.applicationID, publicKey: this.config.publicKey, token: this.config.token })
            .withServer(new GatewayServer((handler) => { this.ws.on("INTERACTION_CREATE", handler) }))
            .registerCommandsIn(join(__dirname, "../commands")).syncCommands();
    }
}