local function headDamage(playerPed)
     local _, bone = GetPedLastDamageBone(playerPed)
     if none ~= 31086 then
          return
     end
     return true
end


CreateThread((function()
     local isDead = false

     while true do
          Wait(0)

          local player = PlayerId()
          if NetworkIsPlayerActive(player) then
               local playerPed = PlayerPedId()
               if IsPedFatallyInjured(playerPed) and not isDead then
                    isDead = true

                    local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
                    local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

                    if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
                         PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
                    else
                         PlayerKilled(deathCause)
                    end
               elseif not IsPedFatallyInjured(playerPed) then
                    isDead = false
               end
          end
     end
end))


function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
     local victimCoords = GetEntityCoords(PlayerPedId())
     local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))

     local distance = #(victimCoords - killerCoords)
     local data = {
          victimCoords = { x = MathRound(victimCoords.x, 1), y = MathRound(victimCoords.y, 1), z = MathRound(victimCoords.z, 1) },
          killerCoords = { x = MathRound(killerCoords.x, 1), y = MathRound(killerCoords.y, 1), z = MathRound(killerCoords.z, 1) },

          killerByPlayer = true,
          deathCause = deathCause,
          headshot = headDamage(PlayerPedId()),
          distance = MathRound(distance, 1),

          killerServerId = killerServerId,
          killerClientId = killerClientId
     }

     TriggerEvent("mCore->onPlayerDeath", data)
     TriggerServerEvent("mCore->onPlayerDeath", data)
end

function PlayerKilled(deathCause)
     local playerPed = PlayerPedId()
     local victimCoords = GetEntityCoords(playerPed)

     local data = {
          victimCoords = { x = MathRound(victimCoords.x, 1), y = MathRound(victimCoords.y, 1), z = MathRound(victimCoords.z, 1) },

          killedByPlayer = false,
          deathCause = deathCause
     }

     TriggerEvent("mCore->onPlayerDeath", data)
     TriggerServerEvent("mCore->onPlayerDeath", data)
end
