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
	local all_spawn_points = ents.FindByClass("info_player*")
	local random_spawn_point = all_spawn_points[math.random(#all_spawn_points)]

	-- Spawns a cooking pot at a random player spawn point location
	-- Downsides:	- There is no check to see if it spawns on a player location
	--				- If the cooking pot spawns in an unloaded room the halo
	--					will not appear untill the room is loaded
	ent:SetPos(random_spawn_point:GetPos())

	-- Spawns a cooking pot in front of a player
	-- Downsides:	- If the choosen player looks towards a wall at a close
	--			 		distance it will can spawn behind the wall

	-- if tm then
	-- 	local tm_players = team.GetPlayers(tm)
	-- 	local random_tm_player = tm_players[math.random(1, #tm_players)]
	--
	-- 	ent:SetPos(random_tm_player:GetPos() + random_tm_player:GetAimVector() * 100 - Vector(0, 0, -40 + random_tm_player:GetAimVector().z * 100))
	-- else
	-- 	ent:SetPos(Vector(0, 0, 0))
	-- end

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
