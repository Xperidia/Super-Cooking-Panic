--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:SetCookingPotHalo()
	Desc: Renders an halo around every 'cooking pot' entity
			The color matches the entity's team
			At range of use the halo is stronger
-----------------------------------------------------------]]
function GM:CookingPotHalo()

	local ply = LocalPlayer()
	local plyTeam = ply:Team()
	local cooking_pots = ents.FindByClass("scookp_cooking_pot")
	local lots_of_cooking_pots = #cooking_pots > 4

	for _, v in pairs(cooking_pots) do

		local is_own_team = plyTeam == v:Team()
		local ply_distance_from_cooking_pot = ply:GetPos():Distance(v:GetPos())

		if not lots_of_cooking_pots or is_own_team then

			if v == self:EntityLookedAt()
			or ply_distance_from_cooking_pot < self.ConvDistance --TODO: Remove this if we can get a cooking pot with GM:EntityLookedAt()
			then

				halo.Add({v}, v:GetTeamColor(), 6, 6, 1, true, is_own_team)

			else

				halo.Add({v}, v:GetTeamColor(), 2, 2, 1, true, is_own_team)

			end

		end

	end

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
function GM:DrawCookingPotTips()

	local ply = LocalPlayer()

	if not GAMEMODE:ConVarGetBool("hide_tips")
	and ply:IsValidPlayingState()
	and ply:IsHoldingIngredient()
	and GAMEMODE:IsValidGamerMoment() then

		local text = GAMEMODE:FormatLangPhrase( "$scookp_tip_cooking_pot",
						GAMEMODE:CheckBind("+attack"))

		for _, v in pairs(ents.FindByClass("scookp_cooking_pot")) do

			if IsValid(v) and v:Team() == ply:Team() then

				v:DrawTip(text, Vector(0, 0, 32))

			end

		end

	end

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

	self:DrawCookingPotTips()

end
