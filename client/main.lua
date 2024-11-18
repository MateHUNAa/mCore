mCore       = {}
local inv   = exports.ox_inventory
local debug = GetConvar("matehun:global_debug", "0") ~= '0'

function export()
     return mCore
end

exports("getSharedObj", export)

mCore.isDebug = (function()
     return debug
end)

mCore.Notify  = (function(title, message, type, dur)
     Config.CNotify(title, message, type, dur)
end)


--
-- Function's
--


---Draw3DText
---@param x number
---@param y number
---@param z number
---@param text string
---@param r integer | nil
---@param g integer | nil
---@param b integer | nil
---@param scales boolean
---@param font string | number
mCore.Draw3DText = (function(x, y, z, text, r, g, b, scales, font)
     if not x or not y or not z or not text then return end
     SetDrawOrigin(x, y, z)

     local scale = .80
     if scales then
          local camCoords = GetFinalRenderedCamCoord()
          local dist = #(vector3(x, y, z) - camCoords)

          scale = scale * (dist / 5);
     end

     local useFont = 4


     if font then
          if type(font) == "string" then
               useFont = mCore.getFont(font)
          else
               useFont = font
          end
     end

     SetTextScale(0.35 * scale, 0.35 * scale)
     SetTextFont(useFont or 4)
     SetTextProportional(true)
     SetTextDropshadow(0, 0, 0, 0, 255)
     SetTextEdge(2, 0, 0, 0, 150)
     SetTextDropShadow()

     SetTextWrap(0.0, 1.0)
     SetTextColour(r or 255, g or 255, b or 255, 2555)
     SetTextOutline()
     SetTextCentre(true)
     BeginTextCommandDisplayText("STRING")
     AddTextComponentString(text)
     EndTextCommandDisplayText(0.0, 0.0)

     ClearDrawOrigin()
end)

local loadedFonts = {}

local validFonts = {
     RobotoRegular = true,
     BebasNeueOtf = true,
     FontAwesome = true,
}

function GetFont(name)
     if name == "default" then
          return 0
     end

     assert(validFonts[name], ("font is invalid! (%s)"):format(name))

     if not loadedFonts[name] then
          RegisterFontFile(name)
          loadedFonts[name] = RegisterFontId(name)
     end
     return loadedFonts[name]
end

exports("getFont", GetFont)

mCore.getFont = GetFont
local loadedIcons = {}

function GetIcon(name)
     assert(type(Config.Icons) == "table" and #Config.Icons > 0, "Config.Icons must be a non-empty table.")

     if not loadedIcons[name] then
          local iconIndex = nil
          for i = 1, #Config.Icons do
               if Config.Icons[i] == name then
                    iconIndex = i
                    break
               end
          end

          if not iconIndex then
               return print(("^7[^3mCore^7]: ^1Err:^7 Icon name ^6'%s'^7 not found in Config.Icons."):format(name))
          end

          local iconPath = Config.Icons[iconIndex]

          if not HasStreamedTextureDictLoaded(iconPath) then
               RequestStreamedTextureDict(iconPath, true)
               while not HasStreamedTextureDictLoaded(iconPath) do
                    Citizen.Wait(0)
               end
          end

          local txd = CreateRuntimeTexture(iconPath)
          if not txd then
               return print(("^7[^3mCore^7]: ^1Err:^7 Failed to create runtime texture for ^6'%s'^7."):format(iconPath))
          end

          local textureLoaded = CreateRuntimeTextureFromImage(txd, iconPath, string.format("icons/%s.png", iconPath))
          if not textureLoaded then
               return print(("^7[^3mCore^7]: ^1Err:^7 Failed to create texture from image ^6'%s.png'^7."):format(
                    iconPath))
          end

          local textureResolution = GetTextureResolution(iconPath, iconPath)
          if textureResolution.x == 0 and textureResolution.y == 0 then
               return print(("^7[^3mCore^7]: ^1Err:^7 Texture resolution is invalid for ^6'%s'^7."):format(iconPath))
          end

          loadedIcons[name] = txd
     end

     return loadedIcons[name]
end

mCore.GetIcon = GetIcon
mCore.RequestIcon = GetIcon


---@param coords vector4
---@param icon string
---@param drawOnEnts boolean
mCore.DrawCustomIcon = function(coords, icon, drawOnEnts)
     mCore.RequestIcon(icon)
     if not icon or type(icon) ~= "string" then return end

     if not coords or (type(coords) ~= "vector3" and type(coords) ~= "vector4") then
          return print(type(coords))
     end

     local markerType = 9
     local scale = type(coords) == "vector4" and coords.w or 0.5
     DrawMarker(
          markerType,
          coords.x, coords.y, coords.z,
          0.0, 0.0, 0.0,
          90.0, 0.0, 180.0,
          scale, scale, scale,
          255, 255, 255, 255,
          false, true, 2,
          false,
          icon, icon,
          drawOnEnts or false
     )
end

---@param coords vector3
---@param icon string
---@param markerType number
---@param size vector3
---@param color vector4
mCore.DrawCustomMarker = (function(coords, icon, markerType, size, color)
     mCore.RequestIcon(icon)

     DrawMarker(9, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 90.0, 0.0, 180.0, .5, .5, .5, 255, 255, 255, 255,
          false, true, 2, false, icon, icon, false)

     DrawMarker(markerType, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size.x, size.y, size.z, color.x,
          color.y,
          color.z, color.w,
          false, false, 2, false, nil, nil, false)
end)

mCore.log = (function(message, isLocal)
     if isLocal then
          return print(("[ ^4%s ^0]: %s"):format(GetInvokingResource(), message))
     end
     TriggerServerEvent("mateExports:logger:log", message)
end)
mCore.error = (function(message, isLocal)
     if isLocal then
          return print(("[ ^4%s ^0] ^1[Err]:^0 %s"):format(GetInvokingResource(), message))
     end
     TriggerServerEvent("mateExports:logger:error", message)
end)

mCore.debug = {}

mCore.debug.log = (function(message)
     TriggerServerEvent("mateExports:logger:debugLog", message)
end)
mCore.debug.error = (function(message)
     TriggerServerEvent("mateExports:logger:debugErr", message)
end)


-- 1.6.3 UNDER

mCore.loadModel = (function(model)
     if GetResourceState("ox_lib") ~= "missing" then
          return lib.requestModel(model, 1000)
     end

     mCore.error("^6ox_lib^7 ^1NOT FOUND !^7")
end)

mCore.unloadModel = (function(model)
     mCore.debug.log("^2Removing Model^7: '^6" .. model .. "^7'")
     SetModelAsNoLongerNeeded(model)
end)

mCore.loadAnimDict = (function(dict)
     if not HasAnimDictLoaded(dict) then
          mCore.debug.log("^2Loading Anim Dictionary^7: '^6" .. dict .. "^7'")
          while not HasAnimDictLoaded(dict) do
               RequestAnimDict(dict)
               Wait(5)
          end
     end
end)

mCore.unloadAnimDict = (function(dict)
     mCore.debug.log("^2Removing Anim Dictionary^7: '^6" .. dict .. "^7'")
     RemoveAnimDict(dict)
end)

mCore.loadPtfxDict = (function(dict)
     if not HasNamedPtfxAssetLoaded(dict) then
          mCore.debug.log("^2Loading Ptfx Dictionary^7: '^6" .. dict .. "^7'")
          while not HasNamedPtfxAssetLoaded(dict) do
               RequestNamedPtfxAsset(dict)
               Wait(5)
          end
     end
end)

mCore.unloadPtfxDict = (function(dict)
     mCore.debug.log("^2Removing Ptfx Dictionary^7: '^6" .. dict .. "^7'")
     RemoveNamedPtfxAsset(dict)
end)

mCore.makeProp = (function(data, freeze, synced)
     mCore.loadModel(data.prop)
     local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z - 1.03, synced or false,
          false,
          false)
     SetEntityHeading(prop, data.coords.w + 180.0)
     FreezeEntityPosition(prop, freeze or false)

     if mCore.isDebug() then
          local coords = {
               string.format("%.2f", data.coords.x),
               string.format("%.2f", data.coords.y),
               string.format("%.2f", data.coords.z),
               string.format("%.2f", data.coords.w or 0.0)
          }

          mCore.debug.log("^1Prop ^2Created^7: '^6" ..
               prop ..
               "^7' | ^2Hash^7: ^7'^6" ..
               data.prop ..
               "^7' | ^2Coord^7: ^5vec4^7(^6" ..
               coords[1] .. "^7, ^6" .. coords[2] .. "^7, ^6" .. coords[3] .. "^7, ^6" .. coords[4] .. "^7)")
     end
     return prop
end)

mCore.makeBlip = (function(data)
     local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
     SetBlipAsShortRange(blip, true)
     SetBlipSprite(blip, data.sprite or 1)
     SetBlipColour(blip, data.col or 0)
     SetBlipScale(blip, data.scale or 0.7)
     SetBlipDisplay(blip, (data.disp or 6))
     if data.category then SetBlipCategory(blip, data.category) end
     BeginTextCommandSetBlipName('STRING')
     AddTextComponentString(tostring(data.name))
     EndTextCommandSetBlipName(blip)
     -- mCore.debug.log("^6Blip ^2created for location^7: '^6" .. data.name .. "^7'")
     return blip
end)
mCore.removeBlip = (function(b)
     RemoveBlip(b)
end)
mCore.makePed = (function(model, coords, freeze, collision, scenario, anim)
     mCore.loadModel(model)

     local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.03, coords.w, false, true)
     SetEntityInvincible(ped, true)
     SetBlockingOfNonTemporaryEvents(ped, true)
     FreezeEntityPosition(ped, freeze or true)
     if collision then
          SetEntityNoCollisionEntity(ped, PlayerPedId(), false)
     end
     if scenario then
          TaskStartScenarioInPlace(ped, scenario, 0, true)
     end
     if anim then
          mCore.loadAnimDict(anim[1])
          TaskPlayAnim(ped, anim[1], anim[2], 1.0, 1.0, -1, 1, 0.2, false, false, false)
     end

     mCore.debug.log(("^6Ped  ^2created for location^7: '^6%s^7'"):format(model))
     return ped
end)

mCore.destoryProp = (function(entity)
     if DoesEntityExist(entity) then
          mCore.debug.log("^2Destroying Prop^7: '^6" .. entity .. "^7'")
          SetEntityAsMissionEntity(entity)
          Wait(5)
          DetachEntity(entity, true, true)
          Wait(5)
          DeleteObject(entity)
     else
          mCore.debug.error("^7[^3destroyProp^7]: Cannot destory prop got ^6" .. type(entity) .. "^7")
     end
end)

mCore.loadDrillSound = (function()
     mCore.debug.log(("^2Loading Drill Sound Banks^7"))
     RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", false)
     RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false)
     RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false)
end)

mCore.unloadScriptHostedSounds = (function()
     mCore.debug.log(("^Releaseing Sounds Banks^7"))
     ReleaseScriptAudioBank()
end)

mCore.lookAtMe = (function(entity)
     if DoesEntityExist(entity) then
          if not IsPedHeadingTowardsPosition(entity, GetEntityCoords(PlayerPedId()), 30.0) then
               TaskTurnPedToFaceCoord(entity, GetEntityCoords(PlayerPedId()), 1500)
               mCore.debug.log("^2Turning Ped to^7: '^6" .. "Player" .. "^7'")
               Wait(1500)
          end
     end
end)

mCore.lookEnt = (function(entity)
     if type(entity) == "vec3" then
          if not IsPedHeadingTowardsPosition(PlayerPedId(), entity, 10.0) then
               TaskTurnPedToFaceCoord(PlayerPedId(), entity, 1500)
               mCore.debug.log("^2Turning Player to^7: '^6" .. json.encode(entity) .. "^7'")
               Wait(1500)
          end
     else
          if DoesEntityExist(entity) then
               if not IsPedHeadingTowardsPosition(PlayerPedId(), GetEntityCoords(entity), 30.0) then
                    TaskTurnPedToFaceCoord(PlayerPedId(), GetEntityCoords(entity), 1500)
                    mCore.debug.log("^2Turning Player to^7: '^6" .. entity .. "^7'")
                    Wait(1500)
               end
          end
     end
end)


mCore.toggleItem = function(give, item, amount)
     if not give then return mCore.error(("^7[^3toggleItem^7]:^2 execpted boolean got ^1%s^7"):format(type(give))) end
     if not item then return mCore.error(("^7[^3toggleItem^7]:^2 execpted item got ^1%s^7"):format(type(item))) end

     TriggerServerEvent("mCore:server:toggleItem", give, item, amount)
end

mCore.lockInv = (function(toggle)
     FreezeEntityPosition(PlayerPedId(), toggle)
     LocalPlayer.state:set("inv_busy", toggle, true)
     LocalPlayer.state:set("invBusy", toggle, true)
     TriggerEvent("inventory:client:busy:status", toggle)
     TriggerEvent("canUseInventoryAndHotbar:toggle", toggle)
end)

mCore.progressBar = (function(data)
     if GetResourceState("ox_lib") ~= "missing" then
          local result = nil

          if exports["ox_lib"]:progressBar({
                   duration = data.time,
                   label = data.label,
                   useWhileDead = data.dead or false,
                   canCancel = data.cancel or true,
                   anim = { dict = tostring(data.dict), clip = tostring(data.anim), flag = (data.flag == 8 and 32 or data.flag) or nil, scenario = data.task }, disable = { combat = true }
              }) then
               result = true
               mCore.lockInv(false)
          else
               result = false
               mCore.lockInv(false)
          end

          while result == nil do Wait(10) end
          return result
     end
     mCore.error("^6ox_lib^7 ^1NOT FOUND^7")
end)

mCore.HasItem = (function(items, amount)
     if GetResourceState("ox_inventory") == "missing" then
          mCore.error("^6ox_inventory^7 ^1NOT FOUND ^7")
          return
     end

     local count = exports["ox_inventory"]:Search("count", items)
     local amount = (amount or 1)
     if count >= amount then
          mCore.debug.log(("^3HasItem^7: ^5FOUND^7 ^3     %s ^7/^3 %s %s^7"):format(count, amount, items))
          return true
     else
          mCore.debug.log(("^3HasItem^7: ^1NOT FOUND ^2 %s ^7"):format(tostring(items)))
          return false
     end
end)

mCore.pairsByKeys = (function(t)
     local a = {}
     for n in pairs(t) do a[#a + 1] = n end
     table.sort(a)
     local i = 0
     local iter = function()
          i = i + 1
          if a[i] == nil then return nil else return a[i], t[a[i]] end
     end
     return iter
end)


-- 1.6.4 -- Not Documented

function CreatePlayerModePtfxLoop(tgtPedId, isSelf, PTFXDATA)
     CreateThread(function()
          if tgtPedId <= 0 or tgtPedId == nil then return end
          RequestNamedPtfxAsset(PTFXDATA.dict)

          -- Wait until it's done loading.
          while not HasNamedPtfxAssetLoaded(PTFXDATA.dict) do
               Wait(5)
          end

          local particleTbl = {}
          for i = 0, PTFXDATA.LoopAmmount do
               UseParticleFxAsset(PTFXDATA.dict)
               local partiResult = StartParticleFxLoopedOnEntity(
                    PTFXDATA.asset,
                    tgtPedId,
                    0.0, 0.0, 0.0,      -- offset
                    0.0, 0.0, 0.0,      -- rot
                    PTFXDATA.scale,
                    false, false, false -- axis
               )
               particleTbl[#particleTbl + 1] = partiResult
               Wait(PTFXDATA.delay or 500)
          end

          Wait(PTFXDATA.duration)
          for _, parti in ipairs(particleTbl) do
               StopParticleFxLooped(parti, true)
          end
          RemoveNamedPtfxAsset(PTFXDATA.dict)
     end)
end

---@param dict string
---@param asset string
---@param scale number
---@param delay number
---@param duration number
---@param loopAmmount number
mCore.PlayPTFX = (function(dict, asset, scale, delay, duration, loopAmmount)
     local players = GetActivePlayers()
     local nearbyPlayers = {}
     for _, player in ipairs(players) do
          nearbyPlayers[#nearbyPlayers + 1] = GetPlayerServerId(player)
     end

     TriggerServerEvent('mCore:playPtfx', nearbyPlayers, {
          dict        = dict,
          asset       = asset,
          scale       = scale,
          delay       = delay,
          duration    = duration,
          LoopAmmount = loopAmmount
     })
end)

RegisterNetEvent('mCore:showPtfx', function(tgtSrc, ptfxData)
     mCore.debug.log('Syncing particle effect for target netId: ' .. tgtSrc)
     local tgtPlayer = GetPlayerFromServerId(tgtSrc)
     if tgtPlayer == -1 then return end
     CreatePlayerModePtfxLoop(GetPlayerPed(tgtPlayer), false, ptfxData)
end)
