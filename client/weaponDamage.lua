----------------------------------------------------------------------------
-- MADE BY: MATEHUN
----------------------------------------------------------------------------
local MeeleWeapons = {
	["WEAPON_BAT"] = 0.1,
	["WEAPON_KNIFE"] = 0.1,
	["weapon_dagger"] = 0.2,
	['weapon_unarmed'] = 0.1,
	['weapon_nightstick'] = 0.1,
	['weapon_wrench'] = 0.2

}


----------------------------------------------------------------------------
-- Set melee damages
----------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		for weapon, modifier in pairs(MeeleWeapons) do
			if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(weapon) then
				N_0x4757f00bc6323cfe(GetHashKey(weapon), modifier)
			end
		end
	end
end)
----------------------------------------------------------------------------
-- Disable Pistole Whiping
----------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedArmed(ped, 4) then
			local weapon = GetCurrentPedWeapon(ped, 1)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			SetPedAccuracy(ped, 100)
			SetWeaponRecoilShakeAmplitude(weapon, 100)
		end
	end
end)

----------------------------------------------------------------------------
-- MADE BY: MATEHUN
----------------------------------------------------------------------------
