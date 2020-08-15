--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:CookingPotHaloListThink()
	Desc: Make halo ready tables for GM:CookingPotHalo()
-----------------------------------------------------------]]
function GM:CookingPotHaloListThink()

	local ply = LocalPlayer()

	if not IsValid(ply) then return end

	local plyTeam = ply:Team()
	local cooking_pots_halos = {}
	local cooking_pots_halos_look = {}

	for _, v in pairs( ents.FindByClass("scookp_cooking_pot") ) do

		local vteam = v:Team()

		if not cooking_pots_halos[vteam] then
			cooking_pots_halos[vteam] = {}
		end

		if v == self:EntityLookedAt() and plyTeam == vteam then

			table.insert(cooking_pots_halos_look, v)

		else

			table.insert(cooking_pots_halos[vteam], v)

		end

	end

	self._cooking_pots_halos = cooking_pots_halos
	self._cooking_pots_halos_look = cooking_pots_halos_look

end

--[[---------------------------------------------------------
	Name: gamemode:CookingPotHalo()
	Desc: Renders an halo around every 'cooking pot' entity
			The color matches the entity's team
			At range of use the halo is stronger
-----------------------------------------------------------]]
function GM:CookingPotHalo()

	if not self._cooking_pots_halos then return end

	local ply = LocalPlayer()
	local plyTeam = ply:Team()

	for k, v in pairs(self._cooking_pots_halos) do

		halo.Add(v, team.GetColor(k), 2, 2, 1, true, plyTeam == k or plyTeam == TEAM_SPECTATOR)

	end

	if not self._cooking_pots_halos_look then return end

	halo.Add(self._cooking_pots_halos_look, team.GetColor(k), 2, 2, 1, true, true)

end

--[[---------------------------------------------------------
	Name: gamemode:SetCookingPotHalo()
	Desc: Renders an halo around the mouse over entity
-----------------------------------------------------------]]
function GM:MouseOverHalo()

	local ent = self:EntityLookedAt()

	if not IsValid(ent) or not ent:IsIngredient() then
		return
	end

	halo.Add({ent}, self:GetTeamColor(ent), 2, 2, 1, true, true)

end

--[[---------------------------------------------------------
	Name: entity:DrawTip(str, offset)
	Desc: Draw tip on entity
-----------------------------------------------------------]]
function GM.EntityMeta:DrawTip(str, offset)

	-- Get the game's camera angles
	local angle = EyeAngles()

	-- Only use the Yaw component of the angle
	angle = Angle(0, angle.y, 0)

	-- Apply some animation to the angle
	angle.y = angle.y + math.sin(CurTime()) * 10

	-- Correct the angle so it points at the camera
	-- This is usually done by trial and error using Up(), Right() and Forward() axes
	angle:RotateAroundAxis(angle:Up(), -90)
	angle:RotateAroundAxis(angle:Forward(), 90)

	local pos = self:GetPos() + (offset or Vector(0, 0, 0))

	cam.Start3D2D(pos, angle, 0.1)

		local font = GAMEMODE:GetScaledFont("text")

		surface.SetFont(font)

		draw.SimpleText(str, font, 0, 0, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	cam.End3D2D()

end

--[[---------------------------------------------------------
	Name: gamemode:DrawCookingPotTips()
	Desc: Draw the tip for the cooking pot
-----------------------------------------------------------]]
function GM:DrawCookingPotTips(ply)

	if not ply:IsHoldingIngredient() then return end

	local text = self:FormatLangPhrase( "$scookp_tip_cooking_pot",
										self:CheckBind("+attack") )

	for _, v in pairs(ents.FindByClass("scookp_cooking_pot")) do

		if IsValid(v) and v:Team() == ply:Team() then

			v:DrawTip(text, Vector(0, 0, 32))

		end

	end

end

--[[---------------------------------------------------------
	Name: gamemode:DrawGrabTips()
	Desc: Grab ingredient tips
-----------------------------------------------------------]]
function GM:DrawGrabTips(ply, ent)

	if ply:IsHoldingIngredient() then return end

	if not ent:IsIngredient() then return end

	local text = self:FormatLangPhrase("$scookp_tip_press_x_to_grab",
										self:CheckBind("+attack") )

	ent:DrawTip(text, Vector(0, 0, 32))

end

--[[---------------------------------------------------------
	Name: gamemode:DrawPowerUPgrabTips()
	Desc: Draw the Power-UP grab tips
-----------------------------------------------------------]]
function GM:DrawPowerUPgrabTips(ply, ent)

	if ply:HasPowerUP() then return end

	if not ent:IsPowerUP() then return end

	local text = self:FormatLangPhrase( "$scookp_tip_press_x_to_grab",
										self:CheckBind("+use") )

	ent:DrawTip(text)

end

--[[---------------------------------------------------------
	Name: gamemode:DrawTips()
	Desc: Called to draw the tips
-----------------------------------------------------------]]
function GM:DrawTips()

	if self:ConVarGetBool("hide_tips") then return end

	if not self:IsValidGamerMoment() then return end

	local ply = LocalPlayer()

	if not ply:IsValidPlayingState() then return end

	local ent = self:EntityLookedAt()

	self:DrawCookingPotTips(ply)

	if not IsValid(ent) then return end

	--self:DrawGrabTips(ply, ent)

	self:DrawPowerUPgrabTips(ply, ent)

end

--[[---------------------------------------------------------
	Name: gamemode:PreDrawHalos()
	Desc:	Called before rendering the halos.
			This is the place to call halo.Add.
-----------------------------------------------------------]]
function GM:PreDrawHalos()

	self:CookingPotHalo()
	self:MouseOverHalo()

end

--[[---------------------------------------------------------
	Name: gamemode:PreDrawOpaqueRenderables()
	Desc: Called before drawing opaque entities
-----------------------------------------------------------]]
function GM:PostDrawOpaqueRenderables(bDrawingDepth, bDrawingSkybox)
end

--[[---------------------------------------------------------
	Name: gamemode:PostDrawTranslucentRenderables()
	Desc: Called after all translucent entities are drawn
-----------------------------------------------------------]]
function GM:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
end

--[[---------------------------------------------------------
	Name: gamemode:PreDrawEffects()
	Desc: Called just after GM:PreDrawViewModel
-----------------------------------------------------------]]
function GM:PreDrawEffects()

	self:DrawTips()

end
