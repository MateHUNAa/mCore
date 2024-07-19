if Config.UseCustomDeathEvent then
     Citizen.CreateThread(function()
          local isDead = false
          local hasBeenDead = false
          local diedAt

          while true do
               Wait(1)

               local player = PlayerId()

               if NetworkIsPlayerActive(player) then
                    local ped = PlayerPedId()

                    if IsPedFatallyInjured(ped) and not isDead then
                         isDead = true
                         if not diedAt then
                              diedAt = GetGameTimer()
                         end

                         local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                         local killerentitytype = GetEntityType(killer)
                         local killertype = -1
                         local killerinvehicle = false
                         local killervehiclename = ''
                         local killervehicleseat = 0
                         if killerentitytype == 1 then
                              killertype = GetPedType(killer)
                              if IsPedInAnyVehicle(killer, false) == 1 then
                                   killerinvehicle = true
                                   killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(
                                   GetVehiclePedIsUsing(
                                        killer)))
                                   killervehicleseat = GetPedVehicleSeat(killer)
                              else
                                   killerinvehicle = false
                              end
                         end

                         local killerid = GetPlayerByEntityID(killer)
                         if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
                              killerid = GetPlayerServerId(killerid)
                         else
                              killerid = -1
                         end

                         TriggerEvent('mateExports:playerDied', killerId, killertype, killerweapon,
                              { table.unpack(GetEntityCoords(ped)) })
                         TriggerServerEvent('mateExports:playerDied', killerId, killertype, killerweapon,
                              { table.unpack(GetEntityCoords(ped)) })
                    elseif not IsPedFatallyInjured(ped) then
                         isDead = false
                         diedAt = nil
                    end
               end
          end
     end)

     function GetPlayerByEntityID(id)
          for i = 0, 128 do
               if (NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
          end
          return nil
     end
end
