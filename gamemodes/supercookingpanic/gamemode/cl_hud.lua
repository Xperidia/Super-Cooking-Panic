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

	local ply = LocalPlayer()

	local teams = self:GetPlayingTeams()
	local team_showcase = {}

	if teams[ply:Team()] then

		team_showcase.left = teams[ply:Team()]

	end

	for k, v in pairs(self:GetPlayingTeams()) do

		if not team_showcase.left then

			team_showcase.left = v

		elseif not team_showcase.right and ply:Team() ~= k then

			team_showcase.right = v

		end

	end

	self:HUDPaintScoreLeftTeam(team_showcase.left)

	self:HUDPaintScoreRightTeam(team_showcase.right)

	self:HUDPaintClock()

	self:HUDPaintStatus()

	self:HUDPaintBonus()

	self:HUDPaintStats(ply)

	self:HUDPaintPowerUP(ply)

	draw.DrawText("Super Cooking Panic\n" .. (self.Version or "?") .. "\n" .. (self.VersionDate or ""), nil, ScrW() - 4, 0, nil, TEXT_ALIGN_RIGHT)

	-- Development / Debug values
	self:DebugHUDPaint(ply)

end

local clock_mat = Material("supercookingpanic/hud/clock")
local clock_w, clock_h = 1024, 64
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintClock()
	Desc: Paint clock
-----------------------------------------------------------]]
function GM:HUDPaintClock()

	local w, h = self:ScreenScale(clock_w, clock_h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(clock_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	draw.DrawText(self:FormatTime(self:GetRoundTime()), self:GetScaledFont("clock"), ScrW() / 2, 0, nil, TEXT_ALIGN_CENTER)

end

local team_left_mat = Material("supercookingpanic/hud/team_left")
local team_left_w, team_left_h = 1024, 64
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintScoreLeftTeam()
	Desc: Paint score left team
-----------------------------------------------------------]]
function GM:HUDPaintScoreLeftTeam(t)

	if not t then return end

	local w, h = self:ScreenScale(team_left_w, team_left_h)

	surface.SetDrawColor(t.Color)
	surface.SetMaterial(team_left_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	draw.DrawText(t.Score, self:GetScaledFont("clock"), ScrW() / 2 - w * 0.203125, 0, nil, TEXT_ALIGN_CENTER)

end

local team_right_mat = Material("supercookingpanic/hud/team_right")
local team_right_w, team_right_h = 1024, 64
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintScoreRightTeam()
	Desc: Paint score right team
-----------------------------------------------------------]]
function GM:HUDPaintScoreRightTeam(t)

	if not t then return end

	local w, h = self:ScreenScale(team_right_w, team_right_h)

	surface.SetDrawColor(t.Color)
	surface.SetMaterial(team_right_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	draw.DrawText(t.Score, self:GetScaledFont("clock"), ScrW() / 2 + w * 0.203125, 0, nil, TEXT_ALIGN_CENTER)

end

local status_mat = Material("supercookingpanic/hud/status")
local status_w, status_h = 1024, 128
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintStatus()
	Desc: Paint round status
-----------------------------------------------------------]]
function GM:HUDPaintStatus()

	local state = self:GetRoundState()

	if state == RND_PLAYING then return end

	local txt = self.GameStates[state]

	if not txt then return end

	local w, h = self:ScreenScale(status_w, status_h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(status_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	draw.DrawText(txt, self:GetScaledFont("text"), ScrW() / 2, h * 0.52, nil, TEXT_ALIGN_CENTER)

end

local bonus_mat = Material("supercookingpanic/hud/bonus")
local bonus_w, bonus_h = 256, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintBonus()
	Desc: Paint bonus ingredient
-----------------------------------------------------------]]
function GM:HUDPaintBonus()

	local w, h = self:ScreenScale(bonus_w, bonus_h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(bonus_mat)
	surface.DrawTexturedRect(0, 0, w, h)

	local model = self:GetBonusIngredientModel()

	if model ~= "" then

		local m_x, m_y = self:ScreenScale(8, 10)
		local m_w, m_h = self:ScreenScale(130, 130)

		self:DrawHUDModel(model, "bonus", m_x, m_y, m_w, m_h)

	end

end

local stats_mat = Material("supercookingpanic/hud/stats")
local stats_mat_background = Material("supercookingpanic/hud/stats_background")
local stats_w, stats_h = 512, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintStats()
	Desc: Paint stats
-----------------------------------------------------------]]
function GM:HUDPaintStats(ply)

	local w, h = self:ScreenScale(stats_w, stats_h)
	local x, y = 0, ScrH() - h
	local color = self:GetTeamColor(ply)
	local ingredient = ply:GetHeldIngredient()

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(stats_mat_background)
	surface.DrawTexturedRect(x, y, w, h)

	if IsValid(ingredient) then

		local model = ingredient:GetModel()
		local m_x, m_y = self:ScreenScale(12, 18)
		local m_w, m_h = self:ScreenScale(120, 122)

		self:DrawHUDModel(model, "hold", m_x, ScrH() - m_h - m_y, m_w, m_h)

	end

	surface.SetDrawColor(color)
	surface.SetMaterial(stats_mat)
	surface.DrawTexturedRect(0, ScrH() - h, w, h)

	if IsValid(ingredient) then

		local points = ingredient:GetPoints() * self:GetScoreMultiplier(ply:Team())

		draw.DrawText(points, self:GetScaledFont("big_text"), w * 0.4, ScrH() - h * 0.24, nil, TEXT_ALIGN_CENTER)

	end

end

local power_up_mat = Material("supercookingpanic/hud/power-up")
local power_up_w, power_up_h = 256, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintPowerUP()
	Desc: Paint Power-UP
-----------------------------------------------------------]]
function GM:HUDPaintPowerUP(ply)

	local w, h = self:ScreenScale(power_up_w, power_up_h)
	local x, y = ScrW() - w, ScrH() - h

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(power_up_mat)
	surface.DrawTexturedRect(x, y, w, h)

	if ply:HasPowerUP() then

		local mat = self.PowerUPs[ply:GetPowerUP()].icon
		local p_x, p_y = self:ScreenScale(16, 18)
		local p_w, p_h = self:ScreenScale(114, 114)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(ScrW() - p_x - p_w, ScrH() - p_w - p_y, p_w, p_h)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:DebugHUDPaint()
	Desc: Draw dev/debug values
-----------------------------------------------------------]]
function GM:DebugHUDPaint(ply)

	if not self:ConVarGetBool("dev_mode") then
		return
	end

	local x, y = 0, ScrH() * 0.25

	draw.SimpleText("Round Status: " .. self.GameStates[self:GetRoundState()],
		nil, x, y)
	y = y + 10

	draw.SimpleText("Round Timer: " .. self:FormatTime(self:GetRoundTime()),
		nil, x, y)
	y = y + 20

	for k, v in pairs(self:GetPlayingTeams()) do
		draw.SimpleText("Score " .. v.Name .. ": " .. v.Score, nil, x, y)
		draw.SimpleText("Combo Timer: " .. self:FormatTime(self:GetComboTimer(k) - CurTime()), nil, x, y + 10)
		draw.SimpleText("Combo: x" .. self:GetScoreMultiplier(k), nil, x, y + 20)
		y = y + 40
	end

	if #self.MusicsChans > 0 then

		draw.SimpleText("Music channels:", nil, x, y)
		y = y + 10

		for k, v in pairs(self.MusicsChans) do

			local txt = string.format("%d➡\tT=%fs\tV=%f", k, v:GetTime(), v:GetVolume())
			local color = nil

			if self.CurMusChan and k == self.CurMusChan then
				color = Color(255, 255, 0)
			end

			draw.SimpleText(txt, nil, x, y, color)
			y = y + 10

		end

	end

	local bonus_ingredient = self:GetBonusIngredientModel()

	if bonus_ingredient ~= "" then

		y = y + 20
		draw.SimpleText("Bonus Ingredient: " .. bonus_ingredient, nil, x, y)

	end

	if ply:HasPowerUP() then

		y = y + 20
		draw.SimpleText("Power-UP: " .. self.PowerUPs[ply:GetPowerUP()].name, nil, x, y)

	end

	if ply:IsHoldingIngredient() then

		local model = ply:GetHeldIngredient():GetModel()

		y = y + 20
		draw.SimpleText("Held Ingredient: " .. model, nil, x, y)

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
