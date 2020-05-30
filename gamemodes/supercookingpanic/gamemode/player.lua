--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]


--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawn()
	Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn(ply, transiton)

	--
	-- If the player doesn't have a team in a TeamBased game
	-- then spawn him as a spectator
	--
	if self.TeamBased and (ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED) then

		self:PlayerSpawnAsSpectator(ply)
		return

	end

	-- Stop observer mode
	ply:UnSpectate()

	local classes = team.GetClass(ply:Team())
	player_manager.SetPlayerClass(ply, classes[math.random(1, #classes)])

	player_manager.OnPlayerSpawn(ply, transiton)
	player_manager.RunClass(ply, "Spawn")

	hook.Call("PlayerLoadout", GAMEMODE, ply)

	-- Set player model
	hook.Call("PlayerSetModel", GAMEMODE, ply)

	ply:SetupHands()

end

--[[---------------------------------------------------------
	Name: gamemode:DoPlayerDeath( )
	Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath(ply, attacker, dmginfo)

	ply:CreateRagdoll() --TODO: make serverside ragdoll to use as ingredient

	ply:AddDeaths(1)

end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerSuicide( ply )
	Desc: Player typed KILL in the console. Can they kill themselves?
-----------------------------------------------------------]]
function GM:CanPlayerSuicide(ply)
	return false
end

--[[---------------------------------------------------------
	Name: gamemode:GetFallDamage()
	Desc: return amount of damage to do due to fall
-----------------------------------------------------------]]
function GM:GetFallDamage(ply, flFallSpeed)
	return 0
end
