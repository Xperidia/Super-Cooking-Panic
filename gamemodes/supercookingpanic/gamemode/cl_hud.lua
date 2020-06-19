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

	if not self._c_loaded then
		self._c_loaded = true
	end

	if not GetConVar("cl_drawhud"):GetBool() then
		return
	end

	-- Draw all of the default stuff
	self.BaseClass.HUDPaint(self)

	-- Development / Debug values
	if self:ConVarGetBool("dev_mode") then

		draw.SimpleText("Round Status: " .. tostring(self:GetRoundStatus()),
			"DermaDefault", 50, 50)
		draw.SimpleText("Round Timer: " .. self:FormatTime(self:GetRoundTimer() - CurTime()),
			"DermaDefault", 50, 60)

		local y = 80
		for k, v in pairs(self:GetPlayingTeams()) do
			--v.Score doesn't work
			draw.SimpleText("Score " .. v.Name .. ": " .. team.GetScore(k), "DermaDefault", 50, y)
			draw.SimpleText("Combo Timer: " .. self:FormatTime(self:GetComboTimer(k) - CurTime()), "DermaDefault", 50, y + 10)
			draw.SimpleText("Combo: x" .. self:GetScoreMultiplier(k), "DermaDefault", 50, y + 20)
			y = y + 40
		end

		draw.SimpleText("Bonus Ingredient: " .. self:GetBonusIngredientModel(), "DermaDefault", 50, y)
		y = y + 40


	end

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintBackground()
	Desc: Same as HUDPaint except drawn before
-----------------------------------------------------------]]
function GM:HUDPaintBackground()

	-- Draw all of the default stuff
	self.BaseClass.HUDPaintBackground(self)

end
