--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_rounds.lua")

AddCSLuaFile("cl_rounds.lua")

util.AddNetworkString("scookp_roundupdate")

-- Constants
local round_wait_length = 60 -- Seconds
local round_time_length = 180 -- Seconds
local round_end_length = 20 -- Seconds
--

--[[---------------------------------------------------------
	Name: gamemode.SetRoundState(number)
	Desc: Set current round state
-----------------------------------------------------------]]
function GM:SetRoundState(state)

	self.RoundVars.state = state or RND_NULL

	if state == RND_NULL then

		self.RemoveCookingPots()

		self:ResetScores()

		self:ResetScoreMultipliers()

		self:KillPlayers()

		game.CleanUpMap(true)

		self:SpawnPlayers()

	elseif state == RND_WAITING then

		self:StartRoundTimer(round_wait_length)

	elseif state == RND_PLAYING then

		self:KillPlayers()

		game.CleanUpMap(true)

		self:StartRoundTimer()

		self:SpawnCookingPots()

		self:AutoChooseBonusIngredient()

		self:SpawnPlayers()

	elseif state == RND_ENDING then

		self:StartRoundTimer(round_end_length)

	end

	self:UpdateClientRoundValues()

end

--[[---------------------------------------------------------
	Name: gamemode.CheckToStartRound()
	Desc: Checks necessary conditions to start a round
-----------------------------------------------------------]]
function GM:CheckToStartRound()

	-- TODO:	Are the teams balanced?

	-- Checks if there are enough of players on each team
	if not self:AreTeamsPopulated()
	or not self:IsRoundTimerOver()
	then
		return
	end

	self:SetRoundState(RND_PLAYING)

end

--[[---------------------------------------------------------
	Name: gamemode.StartRound()
	Desc: Starts a game round
-----------------------------------------------------------]]
function GM:StartRound()
	self:SetRoundState(RND_PLAYING)
end

--[[---------------------------------------------------------
	Name: gamemode.CheckToEndRound()
	Desc: Checks necessary conditions to end a round
-----------------------------------------------------------]]
function GM:CheckToEndRound()

	-- TODO:	Checks if a team got the goal score
	-- 			Are all the players still on the game?

	if not self:IsRoundTimerOver() then
		return
	end

	self:SetRoundState(RND_ENDING)

end

--[[---------------------------------------------------------
	Name: gamemode.EndRound()
	Desc: Ends a game round
-----------------------------------------------------------]]
function GM:EndRound()
	self:SetRoundState(RND_NULL)
end

--[[---------------------------------------------------------
	Name: gamemode:StartRoundTimer()
	Desc: Creates a new round timer / Stores the value of its endtime
-----------------------------------------------------------]]
function GM:StartRoundTimer(time)
	self.RoundVars.timer = CurTime() + (time or round_time_length)
end

--[[---------------------------------------------------------
	Name: gamemode:SetRoundTimeLength( number )
	Desc: Sets the rounds time length in seconds
-----------------------------------------------------------]]
function GM:SetRoundTimeLength(val)
	if val > 0 then
		round_time_length = val
	end
end

--[[---------------------------------------------------------
	Name: gamemode:GetRoundTimeLength()
	Desc: Called to know the rounds time length in seconds
-----------------------------------------------------------]]
function GM:GetRoundTimeLength()
	return round_time_length
end

--[[---------------------------------------------------------
	Name: gamemode:UpdateClientRoundValues(ply)
	Desc: Updates multiple client values about the round
-----------------------------------------------------------]]
function GM:UpdateClientRoundValues(ply)

	net.Start("scookp_roundupdate")

	net.WriteUInt(self.RoundVars.state or RND_NULL, 32)
	net.WriteFloat(self.RoundVars.timer or 0)

	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end

end

--[[---------------------------------------------------------
	Name: gamemode.RoundThink()
	Desc: Called every frame to handle rounds logic
-----------------------------------------------------------]]
function GM:RoundThink()

	if self:GetRoundState() == RND_NULL and self:AreTeamsPopulated() then

		self:SetRoundState(RND_WAITING)

	elseif self:GetRoundState() == RND_WAITING
	or self:GetRoundState() == RND_ENDING then

		self:CheckToStartRound()

	elseif self:GetRoundState() == RND_PLAYING then

		self:CheckToEndRound()

	end

end

--[[---------------------------------------------------------
	Name: gamemode.KillPlayers()
	Desc: Kill silentely all playing players
-----------------------------------------------------------]]
function GM:KillPlayers()

	for _, v in pairs(player.GetAll()) do

		if v:IsValidPlayingState() then

			v:DropPowerUP()
			v:KillSilent()

		end

	end

end

--[[---------------------------------------------------------
	Name: gamemode.SpawnPlayers()
	Desc: Spawn all playing players
-----------------------------------------------------------]]
function GM:SpawnPlayers()

	for _, v in pairs(player.GetAll()) do

		if v:Team() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_UNASSIGNED then

			v:Spawn()

		end

	end

end
