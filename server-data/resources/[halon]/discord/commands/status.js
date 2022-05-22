const { CommandContext, CommandOptionType, SlashCommand } = require('slash-create');

module.exports = class Command extends SlashCommand {
    constructor(creator) {
        super(creator, {
            description: "Server Status",
            name: "status"
        });

        this.filePath = __filename;
    }

    /**
     * @param {CommandContext} ctx 
     */
    async run(ctx) {
        
    }
}