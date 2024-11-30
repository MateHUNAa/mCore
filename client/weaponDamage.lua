local MeeleWeapons = {
	["WEAPON_BAT"]        = 0.1,
	["WEAPON_KNIFE"]      = 0.1,
	["weapon_dagger"]     = 0.2,
	['weapon_unarmed']    = 0.1,
	['weapon_nightstick'] = 0.1,
	['weapon_wrench']     = 0.2
}

----------------------------------------------------------------------------
-- Set melee damages
----------------------------------------------------------------------------

Citizen.CreateThread(function()
	if Config.weaponDamage.Enable then
		if Config.weaponDamage.ChangeMeeleDamage then
			while true do
				Citizen.Wait(5)

				for weapon, modifier in pairs(MeeleWeapons) do
					if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(weapon) then
						N_0x4757f00bc6323cfe(GetHashKey(weapon), modifier)
					end
				end
			end
		end
	end
end)
