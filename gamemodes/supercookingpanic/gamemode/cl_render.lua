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

			if ply_distance_from_cooking_pot < self.ConvDistance then
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
	Name: gamemode:PreDrawHalos()
	Desc:	Called before rendering the halos.
			This is the place to call halo.Add.
-----------------------------------------------------------]]
function GM:PreDrawHalos()

	self:CookingPotHalo()
	self:MouseOverHalo()

end
