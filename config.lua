Config = {}

Config.MateLicenseKey = 'matehun-KteQObyBcApk8CB7exNU03ezv8GGdxDzfLuoJEHcAAoYa6J5dW2XICWOKetsaP'

Config.BotToken = "NzkxMzM0NTY4NjAyNTAxMTUx.GoAzCP.n0ScX6B4KxF3j3h7v2UXNGEEHxR6r2fydF6MJs"


Config.Webhook = -- GLOBAL
"https://discord.com/api/webhooks/1237308115972784178/OiGCZCXFiar0oT3kZxfDNO9rVlGkGGK1W8TABLDjUGu4Gg9J_z3OOV_kSq947i0gket2"

Config.Webhooks = {
     ['money'] =
     "https://discord.com/api/webhooks/1251335113283862559/c_-UE7UPv5basJY0l1RX7qTet1esCcy8JlfnIczdxIHfxB7UP9x1cv8KRhxdXVpswzbh",
     ["error"] =
     "https://discord.com/api/webhooks/1249423124487999558/d_H0nOeSG8xSecRc93GnZXaSwUSP3sUKS-KZ-ETI04_lYm-pwSoXcQyA8jgwswyMoWWs",
     ["exploit"] =
     "https://discord.com/api/webhooks/1240105530702430228/YZ7AzYbu_NqgQsZ5U3huwPPei1N0oKppDfZfTNTv_06ERP3QGXeiMrFzp5KWzAi1Q0oS",
     ["harvest"] =
     "https://discord.com/api/webhooks/1251961082130727013/AjOwBkkWvqM9sE0V0aHzZ2pB9i_FYyRi6AaJhpKAMrqsnp1hIbtOGRLqvIq25kn65XFr"
}

Config.NotifyTypes = {
     ["info"] = true,
     ["success"] = true,
     ["error"] = true,
     ["lsp"] = true,
     ["ems"] = true,
}

Config.Notify = (function(playerId, title, message, type, dur)
     for t in pairs(Config.NotifyTypes) do
          if not type == t then type = Config.NotifyTypes[1] end
     end
     if not dur or dur == 0 then dur = 5000 end
     TriggerClientEvent("codem-notification:Create", playerId, message, type, title, dur)
end)

Config.CNotify = (function(title, message, type, dur)
     for t in pairs(Config.NotifyTypes) do
          if not type == t then type = Config.NotifyTypes[1] end
     end
     if not dur or dur == 0 then dur = 5000 end
     TriggerEvent("codem-notification:Create", message, type, title, dur)
end)


function rndColor()
     return {
          r = math.random(0, 255),
          g = math.random(0, 255),
          b = math.random(0, 255)
     }
end

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


Config.Icons = {
     "rime"
}
