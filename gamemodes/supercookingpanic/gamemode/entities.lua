--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

util.AddNetworkString("scookp_SuperIngredientUpdate")

--[[---------------------------------------------------------
	Name: gamemode:RemoveCookingPots()
	Desc: Removes all the spawned 'cooking pot' entities
-----------------------------------------------------------]]
function GM:RemoveCookingPots()
	for _, v in pairs(ents.FindByClass("scookp_cooking_pot")) do
		v:Remove()
	end
end

--[[---------------------------------------------------------
	Name: gamemode:SpawnCookingPots()
	Desc: Prepares and spawns a 'cooking pot' entity for all teams
-----------------------------------------------------------]]
function GM:SpawnCookingPots()
	for k, _ in pairs(self.team_list) do
		self:SpawnCookingPot(k)
	end
end

--[[---------------------------------------------------------
	Name: gamemode:SpawnCookingPot( number tm )
	Desc: Prepares and spawns a 'cooking pot' entity linked to a team
-----------------------------------------------------------]]
function GM:SpawnCookingPot(tm)

	local ent = ents.Create("scookp_cooking_pot")

	ent:SetPos(Vector(0, 100 * (tm or 0), 0))
	ent:SetTeam(tm or 0)
	ent:SetColor(team.GetColor(tm))
	ent:Spawn()

end

--[[---------------------------------------------------------
	Name: Entity:SetSuperIngredient(bool)
	Desc: Set true, false or nil (auto) for super ingredient status.
-----------------------------------------------------------]]
function GM.EntityMeta:SetSuperIngredient(bool)

	self._super_ingredient = bool
	self:SetNWBool("scookp_IsSuperIngredient", bool)

	net.Start("scookp_SuperIngredientUpdate")
	net.Broadcast()

end

--[[---------------------------------------------------------
	Name: Entity:SetIngredient(bool)
	Desc: Set true, false or nil (auto) for ingredient status.
-----------------------------------------------------------]]
function GM.EntityMeta:SetIngredient(bool)

	self._ingredient = bool

	self:SetNWBool("scookp_IsIngredient", bool)

end

--[[---------------------------------------------------------
	Name: Entity:SetPoints(number points)
	Desc: Sets the points the entity is worth.
-----------------------------------------------------------]]
function GM.EntityMeta:SetPoints(points)

	if self:IsIngredient() then

		self._points = points

		self:SetNWInt("scookp_points", points)

		return true

	end

	return nil

end

--[[---------------------------------------------------------
	Name: Entity:AddPoints(number points)
	Desc: Add points to the entity's worth.
-----------------------------------------------------------]]
function GM.EntityMeta:AddPoints(points)

	return self:SetPoints(self:GetPoints() + points)

end

--[[---------------------------------------------------------
	Name: Entity:ResetPoints()
	Desc: Resets entity's points.
-----------------------------------------------------------]]
function GM.EntityMeta:ResetPoints()

	return self:SetPoints(self:GetBasePoints())

end

--[[---------------------------------------------------------
	Name: gamemode:ChooseSuperIngredient()
	Desc: Transforms an ingredient into a super ingredient
-----------------------------------------------------------]]
function GM:ChooseSuperIngredient()

	local all_props = ents.FindByClass("prop_physics")
	local super_ingredient = all_props[math.random(#all_props)]

	super_ingredient:SetSuperIngredient(true)

end
