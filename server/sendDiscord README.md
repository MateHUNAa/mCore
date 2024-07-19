Csumiiii

sendMessage(webhook, name, message, image) ---- Sending Message to discord

sendEmbed(webhook, 'Name of The bot', embed) -- Sending embed to discord

log(msg) --- Sending log to server console

@ Examples

local embed = {
     {
          ["color"] = 16753920,
          ["title"] = "**" .. GetPlayerName(player) .. "**",
          ["description"] = "Test Embed",
          ["footer"] = {
               ["text"] = "Made by MateHUN",
          },
     }
}

webhook = 'discord.webhook'
exports["mateExports"]:sendMessage(webhook, 'test', 'MateHUN The beast')

server_export {
'sendMessage',
'sendEmbed',
'log',
}
