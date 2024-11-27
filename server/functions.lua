Functions = {
     ParseIdentifiers = (function(identifiers)
          local function hasIDTag(idf)
               if string.match(idf, '^discord:') then
                    return true, "discord", idf:sub(9)
               elseif string.match(idf, "^license:") then
                    return true, "license", idf:sub(9)
               end
               return false, nil, nil
          end

          if type(identifier) == "number" then
               for _, id in pairs(GetPlayers()) do
                    print("Checking for DiscordID")
                    local did = GetPlayerIdentifierByType(id, "discord"):sub(9)

                    if string.match(tostring(did), tostring(identifier)) then
                         return true, "discord", did
                    end
               end


               local len = #tostring(identifier)
               if len < 4 then -- Probably a PlayerID
                    for _, id in pairs(GetPlayers()) do
                         if string.match(tostring(id), tostring(identifier)) then
                              return true, "playerid", identifier
                         end
                    end
               end


               return false, nil, nil
          elseif type(identifier) == "string" then
               local hasTag, type, formated = hasIDTag(identifier)
               if hasTag then
                    return true, type, formated -- found, type, formatedLic
               else
                    return false, nil, nil
               end
          end
     end),
     GetPlayerIDByIdentifier = (function(identifier)
          local found, type, id = ParseIdentifier(identifier)
          if not found then return false end

          if type == "playerid" then return true, id end

          if type == "discord" then
               for _, pid in pairs(GetPlayers()) do
                    local did = GetPlayerIdentifierByType(pid, "discord")
                    if string.match(tostring(did), tostring(id)) then
                         return true, pid
                    end
               end
          elseif type == "license" then
               for _, pid in pairs(GetPlayers()) do
                    local did = GetPlayerIdentifierByType(pid, "license")
                    if string.match(tostring(did), tostring(id)) then
                         return true, pid
                    end
               end
          end

          return false, 0
     end),
     IsAdmin = (function(PlayerId)
          if Config.MHAdminSystem then
               return exports["mate-admin"]:isAdmin(pid)
          else
               local identifiers = GetPlayerIdentifiers(pid)

               for _, v in pairs(Config.ApprovedLicenses) do
                    for _, lic in pairs(identifiers) do
                         if v == lic then
                              return true
                         end
                    end
               end

               return false
          end
     end)
}
