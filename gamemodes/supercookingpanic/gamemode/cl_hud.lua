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

	local ply = LocalPlayer()

	-- Draw all of the default stuff
	self.BaseClass.HUDPaint(self)

	draw.DrawText("Super Cooking Panic\nv" .. (self.Version and tostring(self.Version) or "?") .. "\n" .. (self.VersionDate or ""), "DermaDefault", ScrW() - 4, 0, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

	-- Development / Debug values
	if self:ConVarGetBool("dev_mode") then

		local y = 80

		draw.SimpleText("Round Status: " .. tostring(self:GetRoundStatus()),
			"DermaDefault", 50, y)
		y = y + 10

		draw.SimpleText("Round Timer: " .. self:FormatTime(self:GetRoundTimer() - CurTime()),
			"DermaDefault", 50, y)
		y = y + 20

		for k, v in pairs(self:GetPlayingTeams()) do
			--v.Score doesn't work
			draw.SimpleText("Score " .. v.Name .. ": " .. team.GetScore(k), "DermaDefault", 50, y)
			draw.SimpleText("Combo Timer: " .. self:FormatTime(self:GetComboTimer(k) - CurTime()), "DermaDefault", 50, y + 10)
			draw.SimpleText("Combo: x" .. self:GetScoreMultiplier(k), "DermaDefault", 50, y + 20)
			y = y + 40
		end

		draw.SimpleText("Bonus Ingredient: " .. self:GetBonusIngredientModel(), "DermaDefault", 50, y)
		y = y + 40

		self:DrawHUDModel(self:GetBonusIngredientModel(), "bonus", 50, y, 200, 200)
		y = y + 200

		if ply:IsHoldingIngredient() then

			local model = ply:GetHeldIngredient():GetModel()

			draw.SimpleText("Held Ingredient: " .. model, "DermaDefault", 50, y)
			y = y + 40

			self:DrawHUDModel(model, "hold", 50, y, 200, 200)
			y = y + 200

		end

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

function GM:CreateHUDModel(model, name_id)

	if IsValid(self.HUDModels[name_id]) then
		self.HUDModels[name_id]:Remove()
	end

	self.HUDModels[name_id] = ClientsideModel(model, RENDER_GROUP_OPAQUE_ENTITY)

	if IsValid(self.HUDModels[name_id]) then
		self.HUDModels[name_id]:SetNoDraw(true)
	end

end

function GM:DrawHUDModel(model, name_id, x, y, w, h)

	if not util.IsValidModel(model) then
		return
	end

	if not self.HUDModels then
		self.HUDModels = {}
	end

	if not IsValid(self.HUDModels[name_id]) then
		self:CreateHUDModel(model, name_id)
	end

	if IsValid(self.HUDModels[name_id]) then

		if self.HUDModels[name_id]:GetModel() ~= model then
			self:CreateHUDModel(model, name_id)
		end

		local radius = self.HUDModels[name_id]:GetModelRadius()
		local pos = Vector(radius * 2, 0, radius)

		self.HUDModels[name_id]:SetAngles(Angle(0, math.Remap(math.sin(CurTime()), -1, 1, -180, 180), 0))

		cam.Start3D(pos, Vector(-(radius * 2), 0, -radius):Angle(), 70, x, y, w, h)
		cam.IgnoreZ(true)

		render.OverrideDepthEnable(false)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(pos)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)

		self.HUDModels[name_id]:DrawModel()

		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)
		cam.End3D()

	end

	render.SetStencilEnable(false)

	render.SetStencilWriteMask(0)
	render.SetStencilReferenceValue(0)
	render.SetStencilTestMask(0)
	render.SetStencilEnable(false)
	render.OverrideDepthEnable(false)
	render.SetBlend(1)

	cam.IgnoreZ(false)

end
