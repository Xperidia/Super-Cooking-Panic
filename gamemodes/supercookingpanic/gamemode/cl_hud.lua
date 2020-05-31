--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local hide = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudDamageIndicator = true,
	CHudGeiger = true,
	CHudHealth = true,
	CHudPoisonDamageIndicator = true,
	CHudSecondaryAmmo = true,
	CHudSquadStatus = true,
	CHudZoom = true,
	CHUDQuickInfo = true,
	CHudSuitPower = true,
}

--[[---------------------------------------------------------
	Name: gamemode:HUDShouldDraw(name)
	Desc: return true if we should draw the named element
-----------------------------------------------------------]]
function GM:HUDShouldDraw(name)

	local ply = LocalPlayer()

	--Don't draw weapon selection if we don't have two weapons or more
	if name == "CHudWeaponSelection" and #ply:GetWeapons() < 2 then
		return false
	end

	if hide[name] then
		return false
	end

	return self.BaseClass.HUDShouldDraw(self, name)

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaint()
	Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDPaint()

	-- Draw all of the default stuff
	self.BaseClass.HUDPaint(self)

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintBackground()
	Desc: Same as HUDPaint except drawn before
-----------------------------------------------------------]]
function GM:HUDPaintBackground()

	-- Draw all of the default stuff
	self.BaseClass.HUDPaintBackground(self)

end
