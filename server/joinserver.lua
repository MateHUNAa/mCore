ESX = exports["es_extended"]:getSharedObject()

function getDiscordId(source)
    local discordId = GetPlayerIdentifierByType(source, 'discord')
    if discordId then
        local extractedId = discordId:match("discord:(%d+)")
        return extractedId
    end
    return nil
end

function IsDiscordIdVIP(discordId)
    local isVip = exports["mate-vipsystem"]:isVip(discordId)
    return isVip
end

function IsSuperVIP(discordId)
    local query = "SELECT vip_level FROM discord_vip WHERE user_id = ?"
    local result = exports.oxmysql:scalarSync(query, { discordId })
    local vipLevel = tonumber(result) or 0

    return vipLevel == 1
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player, xPlayer, isNew)

    local group = xPlayer.getGroup()
    local job = xPlayer.getJob()
    local color = "#00FFFF"
    local discordId = getDiscordId(source)

    if group == "superadmin" then
        group = "Superadmin"
        color = "#bb89ff"
    elseif group == "admin" then
        group = "Admin"
        color = "#ff3333"
    elseif group == "mod" then
        group = "Moderátor"
        color = "#4f84cc"
    elseif group == "owner" then
        group = "Tulajdonos"
        color = "#1ab5bb"
    elseif group == "developer" then
        group = "Head Developer"
        color = "#be5d11"
    elseif group == "user" then
        if discordId ~= nil then
            if IsDiscordIdVIP(discordId) then
                if IsSuperVIP(discordId) then
                    group = "SuperVIP"
                    color = "#ccc952"
                else
                    group = "VIP"
                    color = "#6b6d35"
                end
            else
                group = "Játékos"
                color = "#ffa500"
            end
        else
            group = "Játékos"
            color = "#ffa500"
        end
    end
    TriggerClientEvent("chat:addMessage", -1, {
        template =
        '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 0.5rem;"><span style="color:black;"> <span style="background-color: #40bf40; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900"><i class="fa-solid fa-right-to-bracket"></i> Csatlakozás</span></span><span style="color:{1}; font-weight: 900"><b> {0}</b></span> csatlakozott a szerverre.</div>',
        args = { GetPlayerName(player), color },
    })

    TriggerClientEvent("mCore:loadDefault", player)
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    local color = "#00FFFF"


    if group == "superadmin" then
        group = "Superadmin"
        color = "#bb89ff"
    elseif group == "admin" then
        group = "Admin"
        color = "#ff3333"
    elseif group == "mod" then
        group = "Moderátor"
        color = "#4f84cc"
    elseif group == "owner" then
        group = "Tulajdonos"
        color = "#1ab5bb"
    elseif group == "developer" then
        group = "Head Developer"
        color = "#be5d11"
    elseif group == "user" then
        local discordId = getDiscordId(source)

        if discordId ~= nil then
            if IsDiscordIdVIP(discordId) then
                if IsSuperVIP(discordId) then
                    group = "SuperVIP"
                    color = "#ccc952"
                else
                    group = "VIP"
                    color = "#6b6d35"
                end
            else
                group = "Játékos"
                color = "#ffa500"
            end
        else
            group = "Játékos"
            color = "#ffa500"
        end
    end
    TriggerClientEvent("chat:addMessage", -1, {
        template =
        '<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 0.5rem;"><span style="color:black;"> <span style="background-color: #e65245; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900"><i class="fa-solid fa-person-walking-arrow-right"></i> Kilépés</span></span><span style="color:{1}; font-weight: 900"><b> {0}</b></span> kilépett a szerverről.<span style="color:#ffffff"> (</span><span style="color:#ffa500; font-weight: 900"> {2}</span><span style="color:#ffffff"> )</span></div>',
        args = { GetPlayerName(source), color, reason },
    })
end)
