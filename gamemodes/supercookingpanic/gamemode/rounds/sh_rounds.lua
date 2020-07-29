--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

RND_NULL = 0
RND_WAITING = 2
RND_PREPARING = 32
RND_PLAYING = 2048
RND_ENDING = 8388608
RND_VOTEMAP = 1073741824

GM.GameStates = {
	[RND_NULL] = "#scookp_round_null",
	[RND_WAITING] = "#scookp_round_waiting",
	[RND_PREPARING] = "#scookp_round_preparing",
	[RND_PLAYING] = "#scookp_round_playing",
	[RND_ENDING] = "#scookp_round_ending",
	[RND_VOTEMAP] = "#scookp_round_voting",
}

GM.RoundVars = GM.RoundVars or {}

--[[---------------------------------------------------------
	Name: gamemode.GetRoundState()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GM:GetRoundState()
	return self.RoundVars.state or RND_NULL
end

--[[---------------------------------------------------------
	Name: gamemode.GetRoundTimer()
	Desc: Called to know the endtime value of the round timer
-----------------------------------------------------------]]
function GM:GetRoundTimer()
	return self.RoundVars.timer or 0
end

--[[---------------------------------------------------------
	Name: gamemode:IsRoundTimerOver()
	Desc: Checks if the round time is over
-----------------------------------------------------------]]
function GM:IsRoundTimerOver()
	return self:GetRoundTimer() < CurTime()
end

--[[---------------------------------------------------------
	Name: gamemode.GetRoundTime()
	Desc: Returns the current time left for the round
-----------------------------------------------------------]]
function GM:GetRoundTime()
	return self:GetRoundTimer() - CurTime()
end
