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
	[RND_NULL] = "null",
	[RND_WAITING] = "waiting",
	[RND_PREPARING] = "preparing",
	[RND_PLAYING] = "playing",
	[RND_ENDING] = "ending",
	[RND_VOTEMAP] = "voting",
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
