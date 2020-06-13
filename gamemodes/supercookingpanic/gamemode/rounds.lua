--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

util.AddNetworkString("scookp_roundupdate")

-- Constants
local round_time_length = 10 -- Seconds
--

local round_status = false -- Active = true
local round_timer = 0 -- Endtime float value (since the server uptime)

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
	round_status = true

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

	round_status = false
	round_timer = 0

	self:UpdateClientRoundValues()

	-- TODO:	Update the scoreboard
end

--[[---------------------------------------------------------
	Name: gamemode:GetRoundStatus()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GM:GetRoundStatus()
	return round_status
end

--[[---------------------------------------------------------
	Name: gamemode:StartRoundTimer()
	Desc: Creates a new round timer / Stores the value of its endtime
-----------------------------------------------------------]]
function GM:StartRoundTimer()
	round_timer = CurTime() + round_time_length
end

--[[---------------------------------------------------------
	Name: gamemode:GetRoundTimer()
	Desc: Called to know the endtime value of the round timer
-----------------------------------------------------------]]
function GM:GetRoundTimer()
	return round_timer
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
	net.WriteBool(round_status)
	net.WriteFloat(round_timer)
	net.Broadcast()
end

--[[---------------------------------------------------------
	Name: gamemode.RoundThink()
	Desc: Called every frame to handle rounds logic
-----------------------------------------------------------]]
function GM:RoundThink()
	-- If no round is live, constantly try to start one
	if not round_status then
		self:CheckToStartRound()
	end

	-- If a round is live, constantly try to end it
	if round_status then
		self:CheckToEndRound()
	end
end
