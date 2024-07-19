function createSQLColumn(name)
	local p = promise.new()

	local exists = MySQL.scalar.await("SHOW COLUMNS FROM `users` LIKE '" .. name .. "'")
	if exists then
		return p:resolve(false)
	end

	MySQL.query([[
			ALTER TABLE `users`
			ADD COLUMN `]] .. name .. [[` INT(11) NULL DEFAULT '0';
		]], function()
		p:resolve(true)
	end)

	return p
end

CreateThread(function()
	Citizen.Await(createSQLColumn("playedTime"))

	for _, player in pairs(GetPlayers()) do
		local sb = Player(player).state

		if not sb.joinTime then
			Player(player).state.joinTime = os.time()
		end

		if not sb.playedTime then
			loadPlayerPlayedTime(player)
		end
	end
end)

AddEventHandler("esx:playerLoaded", function(player)
	Player(player).state.joinTime = os.time()
	loadPlayerPlayedTime(player)
end)


function loadPlayerPlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local playedTime = MySQL.scalar.await("SELECT playedTime FROM users WHERE identifier = ?", { xPlayer.identifier })
	Player(player).state.playedTime = playedTime
end

function savePlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local sb = Player(player).state
	local oldTime = sb.playedTime or 0
	local joinTime = sb.joinTime or os.time()
	local newTime = oldTime + (os.time() - joinTime)

	exports.oxmysql:update("UPDATE users SET playedTime = ? WHERE identifier = ?", { newTime, xPlayer.identifier })
end

AddEventHandler("playerDropped", function()
	savePlayedTime(source)
end)
