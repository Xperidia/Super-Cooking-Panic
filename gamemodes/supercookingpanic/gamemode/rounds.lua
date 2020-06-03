--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

util.AddNetworkString("UpdateRoundStatus")

local round_status = 0 -- Active = 1

--[[---------------------------------------------------------
	Name: CheckToStartRound()
	Desc: Checks necessary conditions to start a round
-----------------------------------------------------------]]
function CheckToStartRound()
	-- TODO:	Checks on the number of players
	-- 			Are the teams balanced?
end

--[[---------------------------------------------------------
	Name: StartRound()
	Desc: Starts a game round
-----------------------------------------------------------]]
function StartRound()
	round_status = 1
	UpdateClientRoundStatus()

	-- TODO:	Set the timer
	--			Spawn the players
	--			Set the game parameters
end

--[[---------------------------------------------------------
	Name: CheckToEndRound()
	Desc: Checks necessary conditions to end a round
-----------------------------------------------------------]]
function CheckToEndRound()
	-- TODO:	Checks if a team got the goal score
	--			Timer out?
	-- 			Are all the players still on the game?

	-- EndRound()
end

--[[---------------------------------------------------------
	Name: EndRound()
	Desc: Ends a game round
-----------------------------------------------------------]]
function EndRound()
	round_status = 0
	UpdateClientRoundStatus()

	-- TODO:	Update the scoreboard
end

--[[---------------------------------------------------------
	Name: GetRoundStatus()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GetRoundStatus()
	return round_status
end

--[[---------------------------------------------------------
	Name: UpdateClientRoundStatus()
	Desc: Updates the client game status via a network message
-----------------------------------------------------------]]
function UpdateClientRoundStatus()
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
	if !round_status then
		CheckToStartRound()
	end

	-- If a round is live, constantly try to end it
	if round_status then
		CheckToEndRound()
	end
end
