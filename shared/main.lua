function split(iunputstr, sep)
     local t = {}
     for str in string.gmatch(iunputstr, "([^" .. sep .. "]+)") do
          table.insert(t, str)
     end
     return t
end

exports("split", split)

function trim(s)
     return s:match("^%s*(.-)%s*$")
end

exports("trim", trim)

function getWebhook()
     return Config.Webhook
end

exports('getHook', getWebhook)



MathRound = (function(value, numDecimals)
     return tonumber(string.format("%." .. (numDecimals or 0) .. "f", value))
end)
