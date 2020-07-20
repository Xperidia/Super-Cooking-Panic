--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile("cl_player.lua")

--[[---------------------------------------------------------
	Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn(ply, transiton)

	if not ply:IsBot() then
		ply:SetTeam(TEAM_UNASSIGNED)
		ply:ConCommand("gm_showteam")
	else
		ply:SetTeam(math.random(1, #self.team_list))
	end

	if not game.IsDedicated() and ply:IsListenServerHost() then
		ply:SetNWBool("IsListenServerHost", true)
	end

end

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
	Name: gamemode:PlayerDeathThink(player)
	Desc: Called when the player is waiting to respawn
-----------------------------------------------------------]]
function GM:PlayerDeathThink(ply)

	if ply.oldteam
	and (ply.oldteam == TEAM_SPECTATOR or ply.oldteam == TEAM_UNASSIGNED) then

		ply:Spawn()

	elseif not ply.NextSpawnTime or ply.NextSpawnTime <= CurTime() then

		ply:Spawn()

	end

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
	Name: gamemode:PlayerDeathSound()
	Desc: Return true to not play the default sounds
-----------------------------------------------------------]]
function GM:PlayerDeathSound()
	return true
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

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTakeDamage
	Return true if this player should take damage from this attacker
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage(ply, attacker)

	if	not GetConVar("mp_friendlyfire"):GetBool()
	and	attacker:IsPlayer() and ply:Team() == attacker:Team()
	and ply ~= attacker then
		return false
	end

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerHurt( )
	Desc: Called when a player is hurt.
-----------------------------------------------------------]]
function GM:PlayerHurt(player, attacker, healthleft, healthtaken)
end
