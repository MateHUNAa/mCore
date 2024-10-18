Config                     = {}

Config.BotToken            = "" -- Discord bot token for `discord_rest`

Config.Webhook             = "" -- Global Webhook !IMPORTANT!

Config.UseCustomDeathEvent = true

Config.JoinServer          = {
     Enable           = true,
     SendNotification = false
}

Config.PlayTime            = {
     Enable = true
}

Config.weaponDamage        = {
     Enable                = true,
     ChangeMeeleDamage     = false,
     DisablePistolWhipping = false,
}

Config.Webhooks            = {
     ['money']        = "",
     ["error"]        = "",
     ["exploit"]      = "",
     ["jobchange"]    = "",
     ["inventorylog"] = "",
     ["resource"]     = "",
}

Config.NotifyTypes         = {
     ["info"]    = true,
     ["success"] = true,
     ["error"]   = true,
     ["lsp"]     = true,
     ["ems"]     = true,
}

Config.Notify              = (function(playerId, title, message, type, dur)
     if not Config.NotifyTypes[type] then
          for t in pairs(Config.NotifyTypes) do
               if not type == t then type = Config.NotifyTypes[1] end
          end
     end

     if not dur or dur == 0 then dur = 5000 end

     -- Change Notification here ! VV
     TriggerClientEvent("codem-notification:Create", playerId, message, type, title, dur)
end)

Config.CNotify             = (function(title, message, type, dur)
     if not Config.NotifyTypes[type] then
          for t in pairs(Config.NotifyTypes) do
               if not type == t then type = Config.NotifyTypes[1] end
          end
     end

     if not dur or dur == 0 then dur = 5000 end

     -- Change Notification here ! VV
     TriggerEvent("codem-notification:Create", message, type, title, dur)
end)


Config.Icons                    = { -- For custom marker you can adjust the .png name here! only the file name needed dont add .extension after file name
     "mhScripts",

}

--
-- Do not touch
--

Config.profilePicTemplateString = "https://cdn.discordapp.com/avatars/%s/%s.png?size=1024"
