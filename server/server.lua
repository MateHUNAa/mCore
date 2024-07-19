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

RegisterNetEvent("mCore:getSharedObj", getSharedObj)

mCore.RequestWebhook = (function(webhookName)
    for i, v in pairs(mCore["webhooks"]) do
        if i == string.lower(webhookName) then
            return v
        end
    end

    return Config.Webhook
end)
RegisterNetEvent("mCore:RequestWebhook", mCore.RequestWebhook)


exports("getSharedObj", getSharedObj)



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
mCore.versionCheck("MateHUNAa/mateExports")

Citizen.CreateThread(function()
    local vc = GetConvar("matehun:versionCheckLoop", "0") ~= '0'
    mCore.debug.log(("^7[^2Version^7]: ^2 Check Loop: ^6%s"):format(vc))
    if vc then
        while true do
            Citizen.Wait(35 * 1000)
            mCore.versionCheck("MateHUNAa/mateExports")
        end
    end
end)

mCore.getPlayers = function()
    local xPlayers = ESX.GetPlayers()
    local mPlayers = {}

    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local discordId = split(GetPlayerIdentifierByType(xPlayer.source, "discord"), ":")[2]
        table.insert(mPlayers, {
            source     = xPlayer.source,
            identifier = xPlayer.identifier,
            name       = xPlayer.name,
            job        = xPlayer.job,
            discordId  = discordId,
            isAdmin    = isAdmin(xPlayer.getGroup())
        })
    end
end

mCore.mPlayer = function(source)
    return mCore.getPlayers[tonumber(source)]
end



if currentFileName ~= 'mateExports' then
    for i = 1, 10 do
        print("You cannot use this resource server will shutdown in 5 sec")
    end

    os.exit(5)
end


local disableAscii = GetConvar("matehun:disableAscii", "0")
local debug        = GetConvar("matehun:global_debug", "0") ~= '0'
local webhook      =
"https://discord.com/api/webhooks/1194944024482676766/hE67q3OiRvk96txTFgGD98PiYm0-8XWhzD3U6bcQGhhwFK5-Et1Wm3NT-tFy2rbraIbt"

if debug then
    StartResource("[devTools]")
end

local art = [[
    oooo     oooo               o8               ooooo ooooo ooooo  oooo oooo   oooo
 8888o   888    ooooooo   o888oo  ooooooooo8  888   888   888    88   8888o  88
 88 888o8 88    ooooo888   888   888oooooo8   888ooo888   888    88   88 888o88
 88  888  88  888    888   888   888          888   888   888    88   88   8888
o88o  8  o88o  88ooo88 8o   888o   88oooo888 o888o o888o   888oo88   o88o    88

----------------------------------------------------------------------------------------

 oooooooo8    oooooooo8 oooooooooo  ooooo oooooooooo  ooooooooooo  oooooooo8
888         o888     88  888    888  888   888    888 88  888  88 888
 888oooooo  888          888oooo88   888   888oooo88      888      888oooooo
        888 888o     oo  888  88o    888   888            888             888
o88oooo888   888oooo88  o888o  88o8 o888o o888o          o888o    o88oooo888

]]

local validKeyArt = [[



                     $$$$$$\   $$$$$$$\  $$$$$$$\  $$$$$$\   $$$$$$$\  $$$$$$$\
                     \____$$\ $$  _____|$$  _____|$$  __$$\ $$  _____|$$  _____|
                     $$$$$$$ |$$ /      $$ /      $$$$$$$$ |\$$$$$$\  \$$$$$$\
                    $$  __$$ |$$ |      $$ |      $$   ____| \____$$\  \____$$\
                    \$$$$$$$ |\$$$$$$$\ \$$$$$$$\ \$$$$$$$\ $$$$$$$  |$$$$$$$  |
                     \_______| \_______| \_______| \_______|\_______/ \_______/



                                                            $$\                     $$\
                                                            $$ |                    $$ |
                     $$$$$$\   $$$$$$\  $$$$$$\  $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$$ |
                    $$  __$$\ $$  __$$\ \____$$\ $$  __$$\\_$$  _|  $$  __$$\ $$  __$$ |
                    $$ /  $$ |$$ |  \__|$$$$$$$ |$$ |  $$ | $$ |    $$$$$$$$ |$$ /  $$ |
                    $$ |  $$ |$$ |     $$  __$$ |$$ |  $$ | $$ |$$\ $$   ____|$$ |  $$ |
                    \$$$$$$$ |$$ |     \$$$$$$$ |$$ |  $$ | \$$$$  |\$$$$$$$\ \$$$$$$$ |
                     \____$$ |\__|      \_______|\__|  \__|  \____/  \_______| \_______|
                    $$\   $$ |
                    \$$$$$$  |
                     \______/



]]


local notValidKey = [[

              /$$$$$$  /$$$$$$ /$$   /$$ /$$$$$$$$ /$$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$       /$$$$$$$$ /$$   /$$
             /$$__  $$|_  $$_/| $$  /$$/| $$_____/| $$__  $$|__  $$__/| $$_____/| $$      | $$_____/| $$$ | $$
            | $$  \__/  | $$  | $$ /$$/ | $$      | $$  \ $$   | $$   | $$      | $$      | $$      | $$$$| $$
            |  $$$$$$   | $$  | $$$$$/  | $$$$$   | $$$$$$$/   | $$   | $$$$$   | $$      | $$$$$   | $$ $$ $$
             \____  $$  | $$  | $$  $$  | $$__/   | $$__  $$   | $$   | $$__/   | $$      | $$__/   | $$  $$$$
             /$$  \ $$  | $$  | $$\  $$ | $$      | $$  \ $$   | $$   | $$      | $$      | $$      | $$\  $$$
            |  $$$$$$/ /$$$$$$| $$ \  $$| $$$$$$$$| $$  | $$   | $$   | $$$$$$$$| $$$$$$$$| $$$$$$$$| $$ \  $$
             \______/ |______/|__/  \__/|________/|__/  |__/   |__/   |________/|________/|________/|__/  \__/



             /$$   /$$ /$$$$$$ /$$$$$$$$ /$$$$$$$$ /$$       /$$$$$$$$  /$$$$$$  /$$$$$$ /$$$$$$$$ /$$$$$$$$  /$$$$$$
            | $$  | $$|_  $$_/|__  $$__/| $$_____/| $$      | $$_____/ /$$__  $$|_  $$_/|__  $$__/| $$_____/ /$$__  $$
            | $$  | $$  | $$     | $$   | $$      | $$      | $$      | $$  \__/  | $$     | $$   | $$      | $$  \__/
            | $$$$$$$$  | $$     | $$   | $$$$$   | $$      | $$$$$   |  $$$$$$   | $$     | $$   | $$$$$   |  $$$$$$
            | $$__  $$  | $$     | $$   | $$__/   | $$      | $$__/    \____  $$  | $$     | $$   | $$__/    \____  $$
            | $$  | $$  | $$     | $$   | $$      | $$      | $$       /$$  \ $$  | $$     | $$   | $$       /$$  \ $$
            | $$  | $$ /$$$$$$   | $$   | $$$$$$$$| $$$$$$$$| $$$$$$$$|  $$$$$$/ /$$$$$$   | $$   | $$$$$$$$|  $$$$$$/
            |__/  |__/|______/   |__/   |________/|________/|________/ \______/ |______/   |__/   |________/ \______/








            ------------------------------------------------------------------------------------------------------------
                                                        Discord: _matehun
            ------------------------------------------------------------------------------------------------------------
]]


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


RegisterNetEvent('mateExports:ensureDevTools:protected', function(initiator)
    if debug then
        ExecuteCommand("ensure [devTools]")
    else
        exports['mateExports']:sendMessage(webhook, "EXPLOIT",
            string.format("%s Tried to ensure DevTools ( DEBUG ONLY ) ", GetPlayerName(initiator)))
    end
end)


--
-- Initial Load
--

Citizen.CreateThread(function()
    Wait(800)
    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `stored` = 1 WHERE `stored` = 0')

    print(string.format("[ ^4MateHUN-Exports ^0] Returned %s Vehicles from inbounded", affectedRows))
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




--
-- Admin Stuff
--

function isAdmin(group)
    for g in pairs(Config.AdminGroups) do
        if g == group then
            break
        end
    end
    if Config.AdminGroups[group] then
        return Config.AdminGroups[group][1] or false
    else
        return false
    end
end

mCore.isAdmin = function(group)
    isAdmin(group)
end

exports("isAdmin", isAdmin)

function getAdminLevel(group)
    for g in pairs(Config.AdminGroups) do
        if g == group then
            break
        end
    end
    if isAdmin(group) then
        return Config.AdminGroups[group][2] or nil
    end
end

exports("getAdminLevel", getAdminLevel)

ESX.RegisterServerCallback('mateExports:admin:isAdmin', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    while not xPlayer do Wait(100) end
    local xGroup = xPlayer.getGroup()
    cb(isAdmin(xGroup))
end)


function getAdminGroups()
    local groups = {}
    for group, _ in pairs(Config.AdminGroups) do
        table.insert(groups, group)
    end
    return groups
end

exports('getAdminGroups', getAdminGroups)


function getFullAdminGroups()
    return Config.AdminGroups
end

exports("getFullAdminGroups", getFullAdminGroups)

mCore.getAdminGroupTable = function()
    return Config.AdminGroups
end

mCore.getXPlayer = function(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    while not xPlayer do Wait(75) end
    return xPlayer
end

function getBotToken()
    local s, r = pcall(function()
        local token = Config.BotToken
        return token
    end)
    if not s then return mCore.debug.error(r) end
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
                img = res[1].discord_url,
                name = res[1].discord_name,
                id = res[1].discordid
            }
            object = {
                img = res[1].discord_url,
                name = res[1].discord_name,
                id = res[1].discordid,
                dUser = dUser,
                errCode = 0
            }
        else
            object = { error = "User not found or response is nil", errCode = 1 }
        end
        cb(object)
    end)
end



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



if GetResourceState("mate-vipsystem") == "started" then
    mCoreLoadVIP()
end

RegisterNetEvent("mCore:loadVIP", function()
    local invoke = GetInvokingResource()
    if not invoke == "mate-vipsystem" then
        mCore.error(("^1EXPLOIT^0 %s(%s) Tried to load VIP stuff"):format(
            GetPlayerName(source), source))
        mCore.sendMessage(("^1EXPLOIT^0 %s(%s) Tried to load VIP stuff"):format(
            GetPlayerName(source), source), mCore["webhooks"]["exploit"], "mCore")
        return
    end
    mCoreLoadVIP()
end)

function mCoreLoadVIP()
    if not GetResourceState("mate-vipsystem") == "started" then
        return mCore.error("[ ^4mCore ^0] Cannot load VIP releated stuff! [mate-vipsystem] is not running.")
    end
    mCore.getVIPUser = (function(pid, cb)
        local object = {}
        local discordid = nil
        mCore.GetDiscord(pid, function(res)
            if not res.errCore == 0 then
                object = { errCode = 1, message = "Cannot get the discord user !" }
                return cb(object)
            else
                discordid = res.id
            end -- TODO: Error handling

            exports["mate-vipsystem"]:isPlayerVipCB(discordid, function(isVip)
                local vipUser = {}
                if not isVip then
                    vipUser["isVip"] = false
                    vipUser["level"] = 0
                    goto endof
                end

                vipUser["isVip"] = true
                exports["mate-vipsystem"]:GetPlayerVipLevel(discordid, function(res)
                    if not res then
                        mCore.error(("Cannot get %s(%s) VIP level"):format(GetPlayerName(pid), pid))
                        vipUser["level"] = 0
                    end

                    vipUser["level"] = tonumber(res)
                    object = { errCode = 0, message = "Success", vipUser = vipUser }
                    return cb(object)
                end)
                ::endof::
                object = { errCode = 0, message = "Success", vipUser = vipUser }
                cb(object)
            end)
        end)
    end)
end
