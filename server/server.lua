local currentFileName = GetCurrentResourceName()
ESX = exports["es_extended"]:getSharedObject()

mCore = {}

mCore["webhooks"] = {}

Citizen.CreateThread(function()
    local s, r = pcall(function()
        for i, v in pairs(Config.Webhooks) do
            mCore["webhooks"][i] = v
        end
    end)

    if not s then mCore.error(r) end
end)

function getSharedObj()
    return mCore
end

exports("getSharedObj", getSharedObj)
RegisterNetEvent("mCore:getSharedObj", getSharedObj)

---@param webhookName string
---@return string as Webhook
mCore.RequestWebhook = (function(webhookName)
    for i, v in pairs(mCore["webhooks"]) do
        if string.lower(i) == string.lower(webhookName) then
            return v
        end
    end

    return Config.Webhook
end)
RegisterNetEvent("mCore:RequestWebhook", mCore.RequestWebhook)


---@param name string
---@param v string
---@return boolean as Successfully
mCore.LoadWebhook = (function(name, v)
    for i, v in pairs(mCore["webhooks"]) do
        if string.lower(i) == string.lower(name) then
            return false
        end
    end
    mCore["webhooks"][name] = v
    return true
end)




mCore.versionCheck = function(repository)
    local updateASCII = [[


                    /$$   /$$ /$$$$$$$  /$$$$$$$   /$$$$$$  /$$$$$$$$ /$$$$$$$$
                    | $$  | $$| $$__  $$| $$__  $$ /$$__  $$|__  $$__/| $$_____/
                    | $$  | $$| $$  \ $$| $$  \ $$| $$  \ $$   | $$   | $$
                    | $$  | $$| $$$$$$$/| $$  | $$| $$$$$$$$   | $$   | $$$$$
                    | $$  | $$| $$____/ | $$  | $$| $$__  $$   | $$   | $$__/
                    | $$  | $$| $$      | $$  | $$| $$  | $$   | $$   | $$
                    |  $$$$$$/| $$      | $$$$$$$/| $$  | $$   | $$   | $$$$$$$$
                     \______/ |__/      |_______/ |__/  |__/   |__/   |________/


]]
    local resource = GetInvokingResource() or GetCurrentResourceName()

    local currentVersion = GetResourceMetadata(resource, 'version', 0)

    if currentVersion then
        currentVersion = currentVersion:match('%d+%.%d+%.%d+')
    end

    if not currentVersion then
        return print(("^1Unable to determine current resource version for '%s' ^0"):format(
            resource))
    end

    SetTimeout(1000, function()
        PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(repository),
            function(status, response)
                if status ~= 200 then return end

                response = json.decode(response)
                if response.prerelease then return end

                local latestVersion = response.tag_name:match('%d+%.%d+%.%d+')
                if not latestVersion or latestVersion == currentVersion then return end

                local cv = { string.strsplit('.', currentVersion) }
                local lv = { string.strsplit('.', latestVersion) }

                for i = 1, #cv do
                    local current, minimum = tonumber(cv[i]), tonumber(lv[i])

                    if current ~= minimum then
                        if current < minimum then
                            print(updateASCII)
                            return print(('^3An update is available for %s (current version: %s) (Latest version: %s)\r\n%s^0')
                                :format(
                                    resource, currentVersion, latestVersion,
                                    "Please update the resoruce.  https://keymaster.fivem.net/asset-grants"))
                        else
                            break
                        end
                    end
                end
            end, 'GET')
    end)
end
if Config.VersionCheck then
    mCore.versionCheck("MateHUNAa/mCore")
end

local disableAscii = GetConvar("matehun:disableAscii", "0")
local debug        = GetConvar("matehun:global_debug", "0") ~= '0'
local serverName   = GetConvar("mCore:serverName", "mCore")

CreateThread(function()
    Wait(1300)

    if disableAscii ~= "0" then
        print("[ ^4MateHUN-Exports ^0]: Loaded ! Version: " ..
            GetResourceMetadata(GetCurrentResourceName(), "version", 0))
    end
    if not disableAscii then
        print(art)
    end
end)


function getServerName()
    return serverName or "[mCore] ServerName Not set"
end

mCore.getServerName     = getServerName
mCore.requestServerName = getServerName

--
-- Initial Load
--

Citizen.CreateThread(function()
    Wait(800)
    if Config.onServerStart.ReturnImpounded then
        local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `stored` = 1 WHERE `stored` = 0')

        print(string.format("[ ^4MateHUN-Exports ^0] Returned %s Vehicles from impunded", affectedRows))
    end
end)

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    while not xPlayer do Wait(255) end

    local discordId = GetPlayerIdentifierByType(xPlayer.source, "discord")
    local cleanId   = split(discordId, ":")[2]

    if not discordId then return mCore.error("Cannot fetch user discord id !") end

    exports.discord_rest:getUserForPlayer(xPlayer.source):next(function(user)
        local picture = string.format(Config.profilePicTemplateString, user.id, user.avatar)

        MySQL.update('UPDATE users SET discord_url = ?, discord_name = ? WHERE identifier = ?', {
            picture,
            user.global_name,
            xPlayer.identifier
        }, function(affectedRows)
        end)
    end)

    MySQL.Async.execute('UPDATE `users` SET discordid = @discordid WHERE identifier = @identifier', {
        ['@discordid'] = cleanId,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        mCore.debug.log('Rows changed: ' .. tostring(rowsChanged))
    end)
end)


--
-- Initial Default suff
--

mCore.createSQLTable = (function(tableName, tableRows)
    if type(tableRows) ~= "table" then
        return mCore.log("^7[^3SQL^7]: Expected table for tableRows, got " .. type(tableRows))
    end

    if not tableName then
        return mCore.log("^7[^3SQL^7]: tableName is nil")
    end

    if type(tableName) ~= "string" then
        return mCore.log("^7[^3SQL^7]: tableName is not a string, got " .. type(tableName))
    end

    local obj = {}
    obj.exists = false
    local p = promise.new()

    local query = "SHOW TABLES LIKE ?"
    MySQL.scalar(query, { tableName }, function(exists)
        if exists then
            mCore.log(("^7[^3SQL^7]: ^7'^6%s^7' table already exists !"):format(tableName))
            obj.exists = true
            return p:resolve(obj)
        end

        local createTableQuery = "CREATE TABLE `" .. tableName .. "` ("
        for i, row in ipairs(tableRows) do
            createTableQuery = createTableQuery .. row
            if i < #tableRows then
                createTableQuery = createTableQuery .. ", "
            end
        end
        createTableQuery = createTableQuery .. ")"

        MySQL.query(createTableQuery, {}, function(res)
            if res then
                print(json.encode(res, { indent = true }))
                mCore.log(("^7[^3SQL^7]: ^2Created^7: ^6SQL^7 table^7: ^7'^6%s^7' !"):format(tableName))
                obj.created = true
                obj.success = true
                return p:resolve(obj)
            else
                mCore.log(("^7[^3SQL^7]: ^1Failed^7: to create ^6SQL^7 table^7: ^7'^6%s^7' !"):format(tableName))
                obj.created = false
                obj.success = false
                return p:reject(obj)
            end
        end)
    end)

    return obj
end)


function createSQLColumnToUsers(name, type, size)
    local p = promise.new()

    local query = "SHOW COLUMNS FROM `users` LIKE ?"
    MySQL.scalar(query, { name }, function(exists)
        if exists then
            p:resolve(false)
        else
            local alterQuery = string.format("ALTER TABLE `users` ADD COLUMN `%s` %s(%d) NULL", tostring(name),
                tostring(type), tonumber(size))
            MySQL.query(alterQuery, function()
                p:resolve(true)
            end)
        end
    end)

    return p
end

mCore.createSQLColumnToUsers = (function(name, type, size)
    createSQLColumnToUsers(name, type, size)
end)

CreateThread(function()
    local columns = {
        { name = "discordid",    type = "VARCHAR", size = 255 },
        { name = "discord_url",  type = "VARCHAR", size = 255 },
        { name = "discord_name", type = "VARCHAR", size = 255 }
    }

    for _, col in ipairs(columns) do
        local added = Citizen.Await(createSQLColumnToUsers(col.name, col.type, col.size))
        if added then
            print("Added column " .. col.name)
        end
    end
end)

mCore.getXPlayer = function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    while not xPlayer do Wait(75) end
    return xPlayer
end

function getBotToken()
    return Config.BotToken
end

exports('getDiscordToken', getBotToken)
mCore.getBotToken = getBotToken()


mCore.Notify = (function(pid, title, message, type, dur)
    Config.Notify(pid, title, message, type, dur)
end)

mCore.GetDiscord = function(src, cb)
    local xPlayer = mCore.getXPlayer(src)
    local identifier = xPlayer.getIdentifier()
    local object = {}

    MySQL.query("SELECT discord_url, discord_name, discordid FROM `users` WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    }, function(res)
        if res and #res > 0 then
            local dUser = {
                img  = res[1].discord_url,
                name = res[1].discord_name,
                id   = res[1].discordid
            }
            object = {
                img     = res[1].discord_url,
                name    = res[1].discord_name,
                id      = res[1].discordid,
                dUser   = dUser,
                errCode = 0
            }
        else
            object = { error = "User not found or response is nil", errCode = 1 }
        end
        cb(object)
    end)
end

mCore.GetDiscordAwait = (function(pid)
    local xPlayer = mCore.getXPlayer(pid)
    local identifier = xPlayer.getIdentifier()
    local res = MySQL.single.await(
        "SELECT discord_url, discord_name, discordid FROM `users` WHERE identifier = @identifier", {
            ['@identifier'] = identifier })

    local obj = {
        name = res["discord_name"],
        img  = res["discord_url"],
        id   = res["discordid"]
    }
    return obj
end)

mCore.GetDiscordByIdentifier = (function(identifer, cb)
    if not identifer then
        mCore.error(("string excepted got nil; Identifier not specified"))
        return
    end

    MySQL.query("SELECT discord_url, discord_name, discordid FROM `users` WHERE identifier=?", {
        identifer
    }, function(res)
        local object = {}
        if not res then
            object = { error = "Cannot get discord user!", errCode = 1 }
            return cb(object)
        end
        object = { img = res[1]["discord_url"], name = res[1]["discord_name"], id = res[1]["discordid"], errCode = 0 }
        return cb(object)
    end)
end)

--
--  Logger
--

mCore.log = (function(message)
    log(("[ ^4%s^0 ]: %s"):format(GetInvokingResource(), message))
end)


mCore.error = (function(message, invoke)
    if not invoke then
        log(("[ ^4%s^0 ]: ^1[Err]:^0 %s"):format(GetInvokingResource(), message))
    else
        log(("[ ^4%s^0 ]: ^1[Err]:^0 %s"):format(invoke, message))
    end
end)

mCore.debug = {}
mCore.debug.log = (function(message)
    if debug then
        log(("[ ^4%s^0 ]: %s"):format(GetInvokingResource(), message))
    end
end)

mCore.debug.error = (function(message)
    if debug then
        log(("[ ^4%s^0 ]: ^1[Err]:^0 %s"):format(GetInvokingResource(), message))
    end
end)

RegisterNetEvent("mateExports:logger:log", mCore.log)
RegisterNetEvent("mateExports:logger:error", mCore.error)
RegisterNetEvent("mateExports:logger:debugLog", mCore.debug.log)
RegisterNetEvent("mateExports:logger:debugErr", mCore.debug.error)





--
--  Send To Discord
--


mCore.sendMessage = (function(message, webhook, botName)
    if not message then
        mCore.error("Error while sending message to discord! message not specified.",
            GetInvokingResource())
    end

    if not webhook then webhook = Config.Webhook end
    if not botName then botName = "mateExports" end

    sendMessage(webhook, botName, message)
end)

RegisterNetEvent("mCore:discord:sendMessage", mCore.sendMessage)

mCore.sendEmbed = (function(embed, webhook, botName)
    if not embed or type(embed) ~= "table" then
        mCore.error("Error while sending embed to discord! Embed not specified.", GetInvokingResource())
    end
    if not webhook then webhook = Config.Webhook end
    if not botName then botName = "mateExports" end

    sendEmbed(webhook, botName, embed)
end)

mCore.isDebug = (function()
    return debug
end)


mCore.getVIPUserAsync = (function(identifier)
    if GetResourceState("mate-vipsystem") ~= "started" then
        print("NO VIPSYS")
        return false, 0
    end

    local found, type, id = Functions.ParseIdentifiers(identifier)
    if not found then
        print("NOT FOUND")
        return false, 0
    end

    local has, lvl = exports["mate-vipsystem"]:GetPlayerVIPLevel(id)

    return has, lvl
end)
mCore.getVIPUser = (function(identifier, cb)
    if GetResourceState("mate-vipsystem") ~= "started" then
        print("NO VIPSYS")
        cb(false, 0)
    end

    local found, type, id = Functions.ParseIdentifiers(identifier)
    if not found then
        print("NOT FOUND")
        return false
    end

    local has, lvl = exports["mate-vipsystem"]:GetPlayerVIPLevel(id)

    cb(has, lvl)
end)


-- 1.6.4 - NOT DOCUMENTED

RegisterNetEvent("mCore:server:toggleItem", (function(give, item, amount)
    local src      = source
    local xPlayer  = mCore.getXPlayer(source)
    local reamount = (amount or 1)

    if give == 0 or give == false then
        if hasItem(xPlayer.source, item, amount or 1) then
            if exports["ox_inventory"]:RemoveItem(src, item, reamount) then
                mCore.debug.log(("^4Removeing ^2Player^7(^2%s^7) ^2%s^7(^6" .. (amount or "1") .. "^7)"):format(src,
                    item))
            end
        else
            dupeWarn(xPlayer.source, item)
        end
    else
        if exports["ox_inventory"]:AddItem(xPlayer.source, item, reamount) then
            mCore.debug.log(("^4Giveing ^2Player^7(^2%s^7) ^2%s^7(^6" .. (amount or "1") .. "^7)"):format(xPlayer.source,
                item))
        end
    end
end))

RegisterNetEvent("mCore:loadAdminSystem", function()
    local invoke = GetInvokingResource()
    if not invoke == "mate-admin" then
        mCore.error(("^1EXPLOIT^0 %s(%s) Tried to load ADMIN stuff"):format(
            GetPlayerName(source), source))
        mCore.sendMessage(("^1EXPLOIT^0 %s(%s) Tried to load ADMIN stuff"):format(
            GetPlayerName(source), source), mCore["webhooks"]["exploit"], "mCore")
        return
    end
    mCoreLoadAdmin()
end)

function mCoreLoadAdmin()
    if not GetResourceState("mate-admin") == "started" then
        return mCore.error("[ ^4mCore ^0] Cannot load `mate-admin` releated stuff! [mate-admin] is not running.")
    end

    if GetResourceState("mate-admin") ~= "missing" then
        local s, r = pcall(function()
            function isAdmin(playerId)
                return exports["mate-admin"]:isAdmin(playerId, false)
            end

            mCore.isAdmin = (function(playerId, useNotification)
                return exports["mate-admin"]:isAdmin(playerId, useNotification)
            end)

            mCore.getAdminGroupTable = function()
                return exports["mate-admin"]:getAdminGroupTable()
            end

            mCore.getAdminLevel = (function(playerId)
                local xPlayer = mCore.getXPlayer(playerId)
                local g = xPlayer.getGroup()

                return exports["mate-admin"]:getAdminLevel(g)
            end)

            mCore.getAdminGroups = (function()
                return exports["mate-admin"]:getAdminGroups()
            end)

            mCore.getFullAdminGroups = (function()
                return exports["mate-exports"]:getFullAdminGroups()
            end)

            mCore.getAdminGroupTable = (function()
                return exports["mate-exports"]:getAdminGroupTable()
            end)
        end)

        if not s then mCore.debug.error(r) end
        if s then
            mCore.log(("Successfully loaded ^7`^6mate-admin^7`"))
        end
    end
end

function hasItem(src, items, amount)
    local amount, count = amount or 1, 0
    local xPlayer = mCore.getXPlayer(src)

    mCore.debug.log(("^3HasItem^7: ^2Checking if player has required item^7 ^3%s^7"):format(tostring(items)))

    for _, itemData in pairs(exports["ox_inventory"]:GetInventoryItems(xPlayer.source)) do
        if itemData and (itemData.name == items) then
            mCore.debug.log(("^3HasItem^7: ^2Item^7 '^3%s^7' ^2Slot^7: ^3%s^7 x(^3%s^7)"):format(tostring(items),
                itemData.slot, itemData.count))
            count += itemData.count
        end
    end
    if count >= amount then
        mCore.debug.log(("^3HasItem^7: ^2Items ^5FOUND^7 x^3%s^7"):format(count))
        return true
    end
    mCore.debug.log(("^3HasItem^7: ^2Items ^1NOT FOUND^7"))
    return false
end

function dupeWarn(src, item)
    local xPlayer = mCore.getXPlayer(src)
    print(("^5DupeWarn: ^1%s^7(^1%s^7) ^2 Tried to remove item ^7(^3%s^7)^2 but it wasn't there^7"):format(
        GetPlayerName(src), src, item))

    if not mCore.isDebug() then
        DropPlayer(src, "^1Kicked for attempting to duplicate items")
    end
    print(("^5DupeWarn: ^1%s^7(^1%s^7) ^2Dropped from server for item duplicating ^7"):format(GetPlayerName(src), src))
    mCore.sendMessage(("%s(%s) Dropped from server for item duplicating"):format(GetPlayerName(src), src),
        mCore.RequestWebhook("exploit"), "mCore - DupeWarn")
end

RegisterNetEvent('mCore:playPtfx', function(nearbyPlayers, ptfxData)
    for _, v in ipairs(nearbyPlayers) do
        TriggerClientEvent('mCore:showPtfx', v, source, ptfxData)
    end
end)
