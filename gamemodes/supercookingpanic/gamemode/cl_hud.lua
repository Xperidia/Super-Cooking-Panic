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

GM.default_hud_color = Color(206, 182, 214)

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

	self:HUDPaintComboAndPoints(ply)

	draw.DrawText("Super Cooking Panic\n" .. (self.Version or "?") .. "\n" .. (self.VersionDate or ""), nil, ScrW() - 4, 0, nil, TEXT_ALIGN_RIGHT)

	-- Development / Debug values
	self:DebugHUDPaint(ply)

end

local clock_mat = Material("supercookingpanic/hud/clock")
local clock_w, clock_h = 512, 64
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintClock()
	Desc: Paint clock
-----------------------------------------------------------]]
function GM:HUDPaintClock()

	local w, h = self:ScreenScale(clock_w, clock_h)
	local color = self.default_hud_color
	local time = self:GetRoundTime()
	local state = self:GetRoundState()
	local shake = nil

	if time < 30 and time > 0 and state == RND_PLAYING then
		color = self:RainbowColor(2, nil, 220)
		shake = true
	elseif time < 30 and time > 0 then
		color = self:RainbowColor(2, nil, 220)
	end

	surface.SetDrawColor(color)
	surface.SetMaterial(clock_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	local txt = self:FormatTime(time)
	local t_w, t_h = self:ScreenScale(32, 32)
	local x, y = ScrW() / 2 - t_w * (#txt / 2), t_h * 0.42

	if txt == "∞" then
		txt = "i"
	end

	self:HUDPaintNumbers(txt, x, y, t_w, t_h, nil, true, true, shake)

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

	local txt = tostring(t.Score)
	local t_w, t_h = self:ScreenScale(24, 24)
	local x, y = (ScrW() / 2 - w * 0.20625) - t_w * (#txt / 2), t_h * 0.67

	self:HUDPaintNumbers(txt, x, y, t_w, t_h, nil, true, true)

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

	local txt = tostring(t.Score)
	local t_w, t_h = self:ScreenScale(24, 24)
	local x, y = (ScrW() / 2 + w * 0.20625) - t_w * (#txt / 2), t_h * 0.67

	self:HUDPaintNumbers(txt, x, y, t_w, t_h, nil, true, true)

end

local status_mat = Material("supercookingpanic/hud/status")
local status_w, status_h = 512, 128
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintStatus()
	Desc: Paint round status
-----------------------------------------------------------]]
function GM:HUDPaintStatus()

	local state = self:GetRoundState()

	if state == RND_PLAYING then return end

	local txt = self.GameStates[state]
	local font = self:GetScaledFont("text")
	local color = self.default_hud_color

	if state == RND_ENDING then
		txt = ""
		for _, v in pairs(self:GetWinningTeams()) do
			if txt == "" then
				txt = v.Name
				color = v.Color
			else
				txt =  txt .. " & " .. v.Name
			end
		end
		txt = self:FormatLangPhrase("$scookp_round_win_str", txt)
	end

	if not txt then return end

	local w, h = self:ScreenScale(status_w, status_h)
	if color == self.default_hud_color then
		color = self:RainbowColor(2, nil, 220)
	end

	surface.SetDrawColor(color)
	surface.SetMaterial(status_mat)
	surface.DrawTexturedRect(ScrW() / 2 - w / 2, 0, w, h)

	draw.DrawText(txt, font, ScrW() / 2, h * 0.52, nil, TEXT_ALIGN_CENTER)

end

local bonus_mat = Material("supercookingpanic/hud/bonus")
local bonus_w, bonus_h = 256, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintBonus()
	Desc: Paint bonus ingredient
-----------------------------------------------------------]]
function GM:HUDPaintBonus()

	local model = self:GetBonusIngredientModel()

	if not model or model == "" then return end

	local w, h = self:ScreenScale(bonus_w, bonus_h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(bonus_mat)
	surface.DrawTexturedRect(0, 0, w, h)

	local m_x, m_y = self:ScreenScale(34, 37)
	local m_w, m_h = self:ScreenScale(75, 75)

	self:DrawHUDModel(model, "bonus", m_x, m_y, m_w, m_h)

	local t_x, t_y = self:ScreenScale(138, 58)
	local t_w, t_h = self:ScreenScale(32, 32)
	local txt = "x" .. self.bonus_ingredient_score_multiplier

	self:HUDPaintNumbers(txt, t_x, t_y, t_w, t_h, self:RainbowColor(6, 128), true, true, true)

end

local stats_mat = Material("supercookingpanic/hud/stats")
local stats_mat_background = Material("supercookingpanic/hud/stats_background")
local stats_w, stats_h = 512, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintStats()
	Desc: Paint stats
-----------------------------------------------------------]]
function GM:HUDPaintStats(ply)

	if not ply:IsValidPlayingState() then return end

	local w, h = self:ScreenScale(stats_w, stats_h)
	local x, y = 0, ScrH() - h
	local color = self:GetTeamColor(ply)
	local ingredient = ply:GetHeldIngredient()

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(stats_mat_background)
	surface.DrawTexturedRect(x, y, w, h)

	if IsValid(ingredient) then

		local model = ingredient:GetModel()
		local m_x, m_y = self:ScreenScale(34, 37)
		local m_w, m_h = self:ScreenScale(75, 75)
		m_y =  ScrH() - m_h - m_y

		self:DrawHUDModel(model, "hold", m_x, m_y, m_w, m_h)

	end

	surface.SetDrawColor(color)
	surface.SetMaterial(stats_mat)
	surface.DrawTexturedRect(0, ScrH() - h, w, h)

	if IsValid(ingredient) then

		local points = ingredient:GetPoints() * self:GetScoreMultiplier(ply:Team())
		local txt = tostring(points)
		local t_w, t_h = self:ScreenScale(48, 48)
		local t_x, t_y = (w * 0.43) - t_w * (#txt / 2), ScrH() - h * 0.25

		self:HUDPaintNumbers(txt, t_x, t_y, t_w, t_h, self:GetTeamColor(ingredient), true, true)

		if not self:ConVarGetBool("hide_tips") then

			draw.SimpleText(self:FormatLangPhrase("$scookp_tip_press_x_to_drop",
							self:CheckBind("+reload") ),
							self:GetScaledFont("text"),
							m_x, ScrH() - h * 0.609375, nil, nil, TEXT_ALIGN_BOTTOM)

		end

	end

end

local power_up_mat = Material("supercookingpanic/hud/power-up")
local unknown_power_up_mat = Material("supercookingpanic/powerup/unknown")
local power_up_w, power_up_h = 256, 256
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintPowerUP()
	Desc: Paint Power-UP
-----------------------------------------------------------]]
function GM:HUDPaintPowerUP(ply)

	if not ply:HasPowerUP() then return end

	local w, h = self:ScreenScale(power_up_w, power_up_h)
	local x, y = ScrW() - w, ScrH() - h
	local font = self:GetScaledFont("text")
	local color = color_white

	surface.SetDrawColor(color)
	surface.SetMaterial(power_up_mat)
	surface.DrawTexturedRect(x, y, w, h)

	local power_up = self.PowerUPs[ply:GetPowerUP()]
	local mat = power_up.icon
	local p_x, p_y = self:ScreenScale(16, 18)
	local p_w, p_h = self:ScreenScale(114, 114)
	local is_valid_mat = not (not mat or mat:IsError())

	if is_valid_mat then

		surface.SetDrawColor(color)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(ScrW() - p_x - p_w, ScrH() - p_w - p_y, p_w, p_h)

	else

		surface.SetDrawColor(self.ErrorColor)
		surface.SetMaterial(unknown_power_up_mat)
		surface.DrawTexturedRect(ScrW() - p_x - p_w, ScrH() - p_w - p_y, p_w, p_h)

		local p_txt = self:GetPowerUPName(power_up.key)
		local pt_x, pt_y = ScrW(), ScrH()

		draw.SimpleText(p_txt, font, pt_x, pt_y, nil, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

	end

	if not self:ConVarGetBool("hide_tips") then

		surface.SetFont(font)

		local txt = ""
		if self:IsValidGamerMoment() then
			txt = self:FormatLangPhrase("$scookp_tip_press_x_to_use",
							self:CheckBind("+attack2"))
		end
		txt = txt .. "\n" .. self:FormatLangPhrase("$scookp_tip_press_x_to_drop",
						self:CheckBind("gmod_undo"))

		local _, t_h = surface.GetTextSize(txt)

		draw.DrawText(txt, font, ScrW() - self:ScreenScaleMin(6), ScrH() - h * 0.5390625 - t_h, nil, TEXT_ALIGN_RIGHT)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintCombo()
	Desc: Paint combo
-----------------------------------------------------------]]
function GM:HUDPaintCombo(ply, x, y, w, h)

	local team = ply:Team()
	local time = self:GetComboTime(team)

	local mult = self:GetScoreMultiplier(team)
	local txt = "x" .. mult
	local color = Color(255, 255, 255, 8)

	if time >= 0 and mult > 1 then
		local alpha = math.Remap(time, 0, self.combo_time_length, 8, 255)
		color = ColorAlpha(self:GetTeamColor(ply), alpha)
		mult = mult - 1
	else
		mult = false
	end

	self:HUDPaintNumbers(txt, x, y, w, h, color, true, true, mult)

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintEntPoints()
	Desc: Paint looked ent points
-----------------------------------------------------------]]
function GM:HUDPaintEntPoints(ply, x, y, w, h)

	local ent = self:EntityLookedAt()

	if not IsValid(ent) or not ent:IsIngredient() then return end

	local points = tostring(ent:GetPoints() or 0)
	x = x - w * (#points * .7)

	self:HUDPaintNumbers(points, x, y, w, h, self:GetTeamColor(ent), true, true, ent:IsBonusIngredient())

	if not self:ConVarGetBool("hide_tips")
	and ply:IsValidPlayingState()
	and not ply:IsHoldingIngredient()
	and not ent:IsPlayer()
	and self:IsValidGamerMoment() then

		draw.DrawText(	self:FormatLangPhrase( "$scookp_tip_press_x_to_grab",
						self:CheckBind("+attack") ),
						self:GetScaledFont("text"),
						ScrW() / 2, y * 0.9, nil, TEXT_ALIGN_CENTER)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintComboAndPoints()
	Desc: Paint combo
-----------------------------------------------------------]]
function GM:HUDPaintComboAndPoints(ply)

	local w, h = self:ScreenScale(64, 64)
	local x, y = ScrW() / 2, ScrH() * 0.7 - h

	self:HUDPaintEntPoints(ply, x, y, w, h)
	self:HUDPaintCombo(ply, x, y, w, h)

end

--[[---------------------------------------------------------
	Name: gamemode:HUDPaintNumbers()
	Desc: Paint numbers
-----------------------------------------------------------]]
function GM:HUDPaintNumbers(str, x, y, width, height, color, draw_shadow, tilt, shake)

	if not color then
		color = Color(255, 255, 255)
	end

	for k, v in pairs(string.ToTable(str)) do

		local tilted_y = y

		if tilt or shake then

			local tilt_offset = self:ScreenScaleMin(tilt and isnumber(tilt) and tilt or 1)

			if shake then
				tilt_offset = tilt_offset * math.random(0, isnumber(skake) and shake or 1)
			end

			if k % 2 == 1 then
				tilted_y = tilted_y + tilt_offset
			else
				tilted_y = tilted_y - tilt_offset
			end

		end

		if v == ":" or v == "." or v == "x" or v == "X" then
			x = x + width * 0.4
		end

		self:HUDPaintNumber(v, x, tilted_y, width, height, color, draw_shadow)

		-- x = x + width

		x = x + width * 0.8

		if v == ":" or v == "." or v == "x" or v == "X" then
			x = x + width * 0.4
		end

	end

end

local numbers_mat = Material("supercookingpanic/hud/numbers")
--[[---------------------------------------------------------
	Name: gamemode:HUDPaintNumber()
	Desc: Paint number
-----------------------------------------------------------]]
function GM:HUDPaintNumber(c, x, y, width, height, color, draw_shadow)

	local n

	if c == " " or c == "" then
		return
	elseif c == "x" or c == "X" then
		n = 10
	elseif c == "." then
		n = 11
	elseif c == ":" then
		n = 12
	elseif c == "i" then
		n = 13
	else
		n = tonumber(c)
	end

	if not n then
		n = 15
	end

	local startU = n * 0.0625
	local endU = (n + 1) * 0.0625

	if draw_shadow then

		local sx, sy = self:ScreenScale(2, 2)

		surface.SetDrawColor(Color(0, 0, 0, color.a))
		surface.SetMaterial(numbers_mat)
		surface.DrawTexturedRectUV(x + sx, y + sy, width, height, startU, 0, endU, 1)

	end

	surface.SetDrawColor(color)
	surface.SetMaterial(numbers_mat)
	surface.DrawTexturedRectUV(x, y, width, height, startU, 0, endU, 1)

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

	draw.SimpleText("Round Status: " .. self:GetPhrase(self.GameStates[self:GetRoundState()]),
		nil, x, y)
	y = y + 10

	draw.SimpleText("Round Timer: " .. self:FormatTime(self:GetRoundTime()),
		nil, x, y)
	y = y + 20

	for k, v in pairs(self:GetPlayingTeams()) do
		draw.SimpleText("Score " .. v.Name .. ": " .. v.Score, nil, x, y)
		draw.SimpleText("Combo Timer: " .. self:FormatTime(self:GetComboTime(k)), nil, x, y + 10)
		draw.SimpleText("Combo: x" .. self:GetScoreMultiplier(k), nil, x, y + 20)
		y = y + 40
	end

	if #self.MusicsChans > 0 then

		draw.SimpleText("Music channels:", nil, x, y)
		y = y + 10

		for k, v in pairs(self.MusicsChans) do

			if IsValid(v) then

				local txt = string.format("%d➡\tT=%fs\tV=%f", k, v:GetTime(), v:GetVolume())
				local color = nil

				if self.CurMusChan and k == self.CurMusChan then
					color = Color(255, 255, 0)
				end

				draw.SimpleText(txt, nil, x, y, color)
				y = y + 10

			end

		end

	end

	local bonus_ingredient = self:GetBonusIngredientModel()

	if bonus_ingredient ~= "" then

		y = y + 20
		draw.SimpleText("Bonus Ingredient: " .. bonus_ingredient, nil, x, y)

	end

	if ply:HasPowerUP() then

		y = y + 20
		draw.SimpleText("Power-UP: " .. self.PowerUPs[ply:GetPowerUP()].key, nil, x, y)

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

--[[---------------------------------------------------------
	Name: gamemode:DrawHUDModel()
	Desc: Draws a 3D model on the HUD
-----------------------------------------------------------]]
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

		local b1, b2 = self.HUDModels[name_id]:GetModelBounds()
		local model_sizes = (b2 - b1):ToTable()
		local max_edge = math.max(unpack(model_sizes))

		local model_distance_from_cam = max_edge / math.sqrt(max_edge / 40)
		local hypo = math.sqrt(math.pow(model_distance_from_cam, 2) + math.pow(model_sizes[3], 2))
		local cam_angle = (math.acos(model_distance_from_cam / hypo) * 180 / math.pi) * 0.70

		local pos = Vector(model_distance_from_cam, 0, b2:ToTable()[3] + 5)

		self.HUDModels[name_id]:SetAngles(Angle(0, math.Remap(math.sin(CurTime()), -1, 1, -180, 180), 0))

		cam.Start3D(pos, Vector(-model_distance_from_cam, 0, -cam_angle):Angle(), 70, x, y, w, h)
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
