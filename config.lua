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
     ['money']   = "",    -- Each is optional please use false if not using !
     ["error"]   = "",    -- Each is optional please use false if not using !
     ["exploit"] = "",    -- Each is optional please use false if not using !
     ["harvest"] = "",    -- Each is optional please use false if not using !
     ["example"] = false, -- Each is optional please use false if not using !
}

Config.NotifyTypes         = {
     ["info"]    = true,
     ["success"] = true,
     ["error"]   = true,
     ["lsp"]     = true,
     ["ems"]     = true,
}

Config.Icons               = { -- For custom marker you can adjust the .png name here! only the file name needed dont add .extension after file name
     "rime"
}


Config.Notify  = (function(playerId, title, message, type, dur)
     if not Config.NotifyTypes[type] then
          for t in pairs(Config.NotifyTypes) do
               if not type == t then type = Config.NotifyTypes[1] end
          end
     end

     if not dur or dur == 0 then dur = 5000 end

     -- Change Notification here ! VV
     TriggerClientEvent("codem-notification:Create", playerId, message, type, title, dur)
end)

Config.CNotify = (function(title, message, type, dur)
     if not Config.NotifyTypes[type] then
          for t in pairs(Config.NotifyTypes) do
               if not type == t then type = Config.NotifyTypes[1] end
          end
     end

     if not dur or dur == 0 then dur = 5000 end

     -- Change Notification here ! VV
     TriggerEvent("codem-notification:Create", message, type, title, dur)
end)


function rndColor()
     return {
          r = math.random(0, 255),
          g = math.random(0, 255),
          b = math.random(0, 255)
     }
end

--
-- Admin Groups will be removed later ! ( mCore not using )
--
Config.AdminGroups = {
     ["helper"] = {
          true,
          0,
          tag = "[ ASSISTANT ]",
          color = rndColor() -- { r= 12, g= 32, b=255 }
     },
     ["Staff"] = {
          true,
          1,
          tag = "[ Staff ]",
          color = rndColor()
     },
     ["general"] = {
          true,
          2,
          tag = "[ General ]",
          color = rndColor()
     },
     ["senior"] = {
          true,
          3,
          tag = "[ Senior ]",
          color = rndColor()
     },
     ["admincontroller"] = {
          true,
          4,
          tag = "[ AdminController ]",
          color = rndColor()
     },
     ["ac"] = {
          true,
          4,
          tag = "[ AdminController ]",
          color = rndColor()
     },
     ["dev"] = {
          true,
          5,
          tag = "[ DEVELOPER ]",
          color = rndColor()
     },
     ["developer"] = {
          true,
          5,
          tag = "[ DEVELOPER ]",
          color = rndColor()
     },
     ["coowner"] = {
          true,
          6,
          tag = "[ CO-OWNER ]",
          color = rndColor()
     },
     ["owner"] = {
          true,
          7,
          tag = "[ OWNER ]",
          color = rndColor()
     }
}

--
-- Do not touch
--

Config.profilePicTemplateString = "https://cdn.discordapp.com/avatars/%s/%s.png?size=1024"
