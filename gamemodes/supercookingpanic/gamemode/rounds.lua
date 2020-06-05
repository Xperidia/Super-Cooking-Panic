--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

util.AddNetworkString("UpdateRoundStatus")

local round_status = false -- Active = true

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
	round_status = 1
	self:UpdateClientRoundStatus()

	-- TODO:	Set the timer
	--			Spawn the players
	--			Set the game parameters
end

--[[---------------------------------------------------------
	Name: gamemode.CheckToEndRound()
	Desc: Checks necessary conditions to end a round
-----------------------------------------------------------]]
function GM:CheckToEndRound()
	-- TODO:	Checks if a team got the goal score
	--			Timer out?
	-- 			Are all the players still on the game?

	-- self:EndRound()
end

--[[---------------------------------------------------------
	Name: gamemode.EndRound()
	Desc: Ends a game round
-----------------------------------------------------------]]
function GM:EndRound()
	round_status = 0
	self:UpdateClientRoundStatus()

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
	Name: gamemode:UpdateClientRoundStatus()
	Desc: Updates the client game status via a network message
-----------------------------------------------------------]]
function GM:UpdateClientRoundStatus()
	net.Start("UpdateRoundStatus")
	net.WriteBool(round_status)
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
