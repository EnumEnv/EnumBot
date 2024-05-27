local DiscordLuau = require('../../../Dependencies/DiscordLuau')

return {
	-- Basic --
	Name = "ping",
	Description = [[description]],

	-- Permissions --
	Permissions = { "UseApplicationCommands" },

	-- Command --
	ContextType = "Guild",
	Type = "ChatInput",

	-- Functionality --
	Execute = function(interaction: DiscordLuau.DiscordInteraction)
		print(interaction.channel)
	end
}
