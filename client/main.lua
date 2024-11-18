mCore = {}

function export()
     return mCore
end

exports("getSharedObj", export)
local debug   = GetConvar("matehun:global_debug", "0") ~= '0'

mCore.isDebug = (function()
     return debug
end)

mCore.Notify  = (function(title, message, type, dur)
     Config.CNotify(title, message, type, dur)
end)



--
-- VAR's
--
local inv = exports.ox_inventory

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

Citizen.CreateThread(function()
     for i = 1, #Config.Icons do
          -- mCore.log(("^2 Createing texture ^7(^6%s^7) ^7"):format(Config.Icons[i]))
          local txd = CreateRuntimeTxd(Config.Icons[i])

          if not HasStreamedTextureDictLoaded(Config.Icons[i]) then
               return print(("^7[^3mCore^7]: ^1Err:^7 ^1CANNOT^2 create texture dict ^7'^6%s^7'^7"):format(Config.Icons
                    [i]))
          end

          local textureLoaded = CreateRuntimeTextureFromImage(txd, Config.Icons[i],
               string.format("icons/%s.png", Config.Icons[i]))

          if not textureLoaded then
               return print(("^7[^3mCore^7]: ^1Err:^7 Failed to create texture from image ^7'^6%s.png^7'^7"):format(
                    Config.Icons[i]))
          end

          local textureResolution = GetTextureResolution(Config.Icons[i], Config.Icons[i])

          if textureResolution.x == 0 and textureResolution.y == 0 then
               return print(("^7[^3mCore^7]: ^2Err^7:^2 Texture is MISSING^7:  ^7(^6%s^7)"):format(Config.Icons[i]))
          end
     end

     print("^7[^3mCore^7]: ^2All textures loaded successfully.^7")
end)


mCore.DrawCustomIcon = function(coords, icon)
     if not icon or type(icon) ~= "string" then return end
     if not coords or type(coords) ~= "vector3" then return print(type(coords)) end

     DrawMarker(9, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 90.0, 0.0, 180.0, 0.5, 0.5, 0.5, 255, 255, 255, 255,
          false, true, 2, false, icon, icon, false)
end



mCore.DrawCustomMarker = (function(coords, markerType, size, color)
     DrawMarker(9, coords.x, coords.y, coords.z + 1.5, 0.0, 0.0, 0.0, 90.0, 0.0, 180.0, .5, .5, .5, 255, 255, 255, 255,
          false, true, 2, false, "rimeMarker", Config.Icons[1], false)

     DrawMarker(markerType, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size.x, size.y, size.z, color.x,
          color.y,
          color.z, color.w,
          false, false, 2, false, nil, nil, false)
end)


function draw3DTextiWthRainbowFlow(firstCoord, text, colors, interval)
     if not firstCoord then return end
     if not colors or type(colors) ~= "table" then
          colors = {
               "~r~", -- Red
               "~o~", -- Orange
               "~y~", -- Yellow
               "~g~", -- Green
               "~b~", -- Blue
               "~p~"  -- Purple
          }
     end
     if not text then
          text = "Text was no set !"
     end

     function getColoredText(index, time)
          local colorIndex = (index + time) % #colors + 1
          return colors[colorIndex]
     end

     local coloredText = ""

     local time = GetGameTimer() // interval

     for i = 1, #text do
          local color = getColoredText(i, time)
          coloredText = coloredText .. color .. text:sub(i, i)
     end

     mCore.Draw3DText(firstCoord.x, firstCoord.y, firstCoord.z + .4, 2, coloredText)
end

mCore.Draw3DRainbowText = draw3DTextWithRainbowFlow


mCore.drawWaveText = function(coords, text, colors, interval)
     if not coords then return end
     if not colors or type(colors) ~= "table" then
          colors = {
               "~r~", -- Red
               "~o~", -- Orange
               "~y~", -- Yellow
               "~g~", -- Green
               "~b~", -- Blue
               "~p~"  -- Purple
          }
     end
     if not text then
          text = "Text was no set !"
     end
     function getColoredText(index, time)
          local colorIndex = (index + time) % #colors + 1
          return colors[colorIndex]
     end

     local time = GetGameTimer() / interval

     for i = 1, #text do
          local color = getColoredText(i, time)
          local waveOffset = math.sin(time + i * .5) * .2


          local zOffset = waveOffset

          mCore.Draw3DText(coords.x, coords.y, coords.z + .4 + zOffset, 2, color .. text:sub(i, i))
     end
end

mCore.Draw3DLinearTextFlow = function(firstCoords, text, colors, interval)
     if not firstCoords then return end
     if not colors or type(colors) ~= "table" then
          colors = { "~o~", "~r~", "~y~" }
     end
     if not text then
          text = "Text was not set!"
     end

     local coloredText = ""
     local numColors = #colors

     local timeOffset = math.floor(GetGameTimer() / interval)
     for i = 1, #text do
          local colorIndex = (i - 1 + timeOffset) % #colors + 1
          local color = colors[colorIndex]
          coloredText = coloredText .. color .. text:sub(i, i)
     end

     mCore.Draw3DText(firstCoords.x, firstCoords.y, firstCoords.z + 0.4, 1, coloredText)
end


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
               mCore.debug.log("^2Turning Player to^7: '^6" .. entity .. "^7'")
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
-- TODO: Rework most of the start/play fx's
-- TODO: Use class

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
