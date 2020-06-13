--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:RemoveCookingPots()
	Desc: Removes all the spawned 'cooking pot' entities
-----------------------------------------------------------]]
function GM:RemoveCookingPots()
	for k, v in pairs(ents.FindByClass("scookp_cooking_pot")) do
		v:Remove()
	end
end

--[[---------------------------------------------------------
	Name: gamemode:SpawnCookingPots()
	Desc: Prepares and spawns a 'cooking pot' entity for all teams
-----------------------------------------------------------]]
function GM:SpawnCookingPots()
	for k, v in pairs(self.team_list) do
		self:SpawnCookingPot(k)
	end
end

--[[---------------------------------------------------------
	Name: gamemode:SpawnCookingPot( number team_index )
	Desc: Prepares and spawns a 'cooking pot' entity linked to a team
-----------------------------------------------------------]]
function GM:SpawnCookingPot(team_index)
	local ent = ents.Create("scookp_cooking_pot")

	ent:SetPos(Vector(0, 50 * team_index, 0))
	ent:SetTeamIndex(team_index)
	ent:Spawn()
end
