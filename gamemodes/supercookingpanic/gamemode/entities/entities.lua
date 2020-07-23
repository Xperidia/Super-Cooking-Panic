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
	Name: gamemode:IsCookingPotSpawnpointSuitable( cookingpot, spawnpoint )
	Desc: Find out if the spawnpoint is suitable or not
-----------------------------------------------------------]]
function GM:IsCookingPotSpawnpointSuitable(ent, spawnpointent)

	local Pos = spawnpointent:GetPos()

	local Ents = ents.FindInBox( Pos + Vector(-32, -32, 0), Pos + Vector(32, 32, 64) )

	local Blockers = 0

	for _, v in pairs(Ents) do

		if IsValid(v) and v ~= ent and v:GetClass() == "scookp_cooking_pot" then

			Blockers = Blockers + 1

		end

	end

	if Blockers > 0 then return false end

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:ListCookingPotSpawn( bool )
	Desc: List all possible spawn point for cooking pots
-----------------------------------------------------------]]
function GM:ListCookingPotSpawn(everything)

	local spawns = ents.FindByClass("info_cooking_pot")

	if #spawns == 0 or everything then

		-- Most spawn points
		spawns = table.Add(spawns, ents.FindByClass("info_player*"))

		-- (Old) GMod Maps
		spawns = table.Add(spawns, ents.FindByClass("gmod_player_start"))

		-- INS Maps
		spawns = table.Add(spawns, ents.FindByClass("ins_spawnpoint"))

		-- AOC Maps
		spawns = table.Add(spawns, ents.FindByClass("aoc_spawnpoint"))

		-- Dystopia Maps
		spawns = table.Add(spawns, ents.FindByClass("dys_spawn_point"))

		-- DIPRIP Maps
		spawns = table.Add(spawns, ents.FindByClass("diprip_start_team_blue"))
		spawns = table.Add(spawns, ents.FindByClass("diprip_start_team_red"))

		-- L4D Maps
		spawns = table.Add(spawns, ents.FindByClass("info_survivor_rescue"))

	end

	return spawns

end

--[[---------------------------------------------------------
	Name: gamemode:CookingPotSelectSpawn( ent cookingpot, bool force )
	Desc: Find a spawn point entity for this cooking pot
-----------------------------------------------------------]]
function GM:CookingPotSelectSpawn(ent, force)

	local random_spawn_point

	for _, v in RandomPairs( self:ListCookingPotSpawn(force) ) do

		local suitable = self:IsCookingPotSpawnpointSuitable(ent, v)

		if suitable or (not random_spawn_point and force) then

			random_spawn_point = v

			if suitable then break end

		end

	end

	if not random_spawn_point then
		return self:CookingPotSelectSpawn(ent, true)
	end

	return random_spawn_point

end

--[[---------------------------------------------------------
	Name: gamemode:SpawnCookingPot( number tm )
	Desc: Prepares and spawns a 'cooking pot' entity linked to a team
-----------------------------------------------------------]]
function GM:SpawnCookingPot(tm)

	local ent = ents.Create("scookp_cooking_pot")

	ent:SetTeam(tm or 0)
	ent:SetColor(team.GetColor(tm))

	ent:SetPos(self:CookingPotSelectSpawn(ent):GetPos() + Vector(0, 0, 32))

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
