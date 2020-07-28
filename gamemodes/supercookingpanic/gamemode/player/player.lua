--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_player.lua")

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

	self:UpdateClientRoundValues(ply)

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

		ply.oldteam = nil

	elseif not ply.NextSpawnTime or ply.NextSpawnTime <= CurTime() then

		ply:Spawn()

	end

end

--[[---------------------------------------------------------
	Name: gamemode:DoPlayerDeath( )
	Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath(ply, attacker, dmginfo)

	if not ply.GoneToRagdoll then
		ply:CreateRagdoll()
	else
		ply.GoneToRagdoll = nil
	end

	ply:DropHeldIngredient()
	ply:DropPowerUP()

	for _, wep in pairs(ply:GetWeapons()) do
		ply:DropWeapon(wep)
	end

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
	Name: gamemode:PlayerShouldTakeDamage
	Return true if this player should take damage from this attacker
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage(ply, attacker)

	if ply.GoneToRagdoll then
		return true
	elseif not GetConVar("mp_friendlyfire"):GetBool()
	and attacker:IsPlayer() and ply:Team() == attacker:Team()
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

--[[---------------------------------------------------------
	Name: ply:GrabIngredient( ent )
	Desc: Player will try to grab ent
-----------------------------------------------------------]]
function GM.PlayerMeta:GrabIngredient(ingredient)

	if GAMEMODE:GetRoundState() ~= RND_PLAYING then return end

	if not self:IsValidPlayingState() then return end

	if ingredient:IsIngredient() then

		if ingredient:IsNPC() then

			ingredient = ingredient:GoToRagdoll(self)

		end

		self:SetHeldIngredient(ingredient)
		ingredient:SetOwner(self)
		ingredient:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ingredient:SetRenderMode(RENDERMODE_NONE)
		ingredient:DrawShadow(false)

		GAMEMODE:DebugLog(self:GetName() .. " grabbed ingredient "
		.. ingredient:GetClass()
		.. ": " .. ingredient:GetModel())

	end

end

--[[---------------------------------------------------------
	Name: ply:DropHeldIngredient( bool forward )
	Desc: Player will drop their ingredient
-----------------------------------------------------------]]
function GM.PlayerMeta:DropHeldIngredient(forward)

	local ingredient = self:GetHeldIngredient()

	if IsValid(ingredient) then

		ingredient:SetOwner(NULL)
		ingredient:SetCollisionGroup(COLLISION_GROUP_NONE)
		ingredient:SetRenderMode(RENDERMODE_NORMAL)
		ingredient:DrawShadow(true)
		self:SetHeldIngredient(NULL)

		local Forward = self:GetAimVector()

		if forward then

			ingredient:SetPos(self:GetShootPos() + Forward * (32 + ingredient:GetModelRadius()))
			if not ingredient:IsNPC() then
				ingredient:SetAngles(self:EyeAngles())
			end
			ingredient:PhysWake()
			ingredient:Activate()
			ingredient:SetVelocity( Forward * 200 )

		else

			ingredient:SetPos(self:GetPos())
			ingredient:PhysWake()
			ingredient:Activate()

		end

		GAMEMODE:DebugLog(self:GetName() .. " dropped held ingredient "
		.. ingredient:GetClass()
		.. ": " .. ingredient:GetModel())

	end

	return ingredient

end
