--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_entities.lua")

AddCSLuaFile("cl_entities.lua")

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
	Name: gamemode:SetBonusIngredientModel(model)
	Desc: Set bonus ingredient model
-----------------------------------------------------------]]
function GM:SetBonusIngredientModel(model)

	SetGlobalString("scookp_BonusIngredientUpdate", model)

end

--[[---------------------------------------------------------
	Name: gamemode:AutoChooseBonusIngredient()
	Desc: Transforms an ingredient into a bonus ingredient
-----------------------------------------------------------]]
function GM:AutoChooseBonusIngredient()

	local sel_model

	for _, v in RandomPairs(ents.GetAll()) do

		if IsValid(v) and v:IsIngredient() and not v:IsPlayer() then

			sel_model = v:GetModel()
			break

		end

	end

	self:SetBonusIngredientModel(sel_model)

end
