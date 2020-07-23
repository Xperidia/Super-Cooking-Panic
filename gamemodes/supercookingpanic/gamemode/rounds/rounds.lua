--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_rounds.lua")

AddCSLuaFile("cl_rounds.lua")

util.AddNetworkString("scookp_roundupdate")

-- Constants
local round_time_length = 120 -- Seconds
--

--[[---------------------------------------------------------
	Name: gamemode.CheckToStartRound()
	Desc: Checks necessary conditions to start a round
-----------------------------------------------------------]]
function GM:CheckToStartRound()
	-- TODO:	Are the teams balanced?

	-- Checks if there are enough of players on each team
	if player.GetCount() < 2 or not self:AreTeamsPopulated() then
		return
	end

	self:StartRound()
end

--[[---------------------------------------------------------
	Name: gamemode.StartRound()
	Desc: Starts a game round
-----------------------------------------------------------]]
function GM:StartRound()
	self:SpawnCookingPots()

	self:StartRoundTimer()

	self:AutoChooseBonusIngredient()

	self.RoundVars.status = true

	self:UpdateClientRoundValues()

	-- TODO:	Spawn the players
	--			Set the game parameters
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

	self:EndRound()
end

--[[---------------------------------------------------------
	Name: gamemode.EndRound()
	Desc: Ends a game round
-----------------------------------------------------------]]
function GM:EndRound()
	self.RemoveCookingPots()
	self:ResetScores()
	self:ResetScoreMultipliers()

	self.RoundVars.status = false
	self.RoundVars.timer = 0

	game.CleanUpMap(true)

	self:UpdateClientRoundValues()

	-- TODO:	Update the scoreboard
end

--[[---------------------------------------------------------
	Name: gamemode:StartRoundTimer()
	Desc: Creates a new round timer / Stores the value of its endtime
-----------------------------------------------------------]]
function GM:StartRoundTimer()
	self.RoundVars.timer = CurTime() + round_time_length
end

--[[---------------------------------------------------------
	Name: gamemode:IsRoundTimerOver()
	Desc: Checks if the round time is over
-----------------------------------------------------------]]
function GM:IsRoundTimerOver()
	if self:GetRoundTimer() < CurTime() then
		return true
	end

	return false
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
	Name: gamemode:UpdateClientRoundValues()
	Desc: Updates multiple client values about the round
-----------------------------------------------------------]]
function GM:UpdateClientRoundValues()
	net.Start("scookp_roundupdate")
	net.WriteBool(self.RoundVars.status)
	net.WriteFloat(self.RoundVars.timer)
	net.Broadcast()
end

--[[---------------------------------------------------------
	Name: gamemode.RoundThink()
	Desc: Called every frame to handle rounds logic
-----------------------------------------------------------]]
function GM:RoundThink()
	-- If no round is live, constantly try to start one
	if not self.RoundVars.status then
		self:CheckToStartRound()
	end

	-- If a round is live, constantly try to end it
	if self.RoundVars.status then
		self:CheckToEndRound()
	end
end
