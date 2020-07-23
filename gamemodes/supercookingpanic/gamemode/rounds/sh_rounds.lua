--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.RoundVars = GM.RoundVars or {}

--[[---------------------------------------------------------
	Name: gamemode.GetRoundStatus()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GM:GetRoundStatus()
	return self.RoundVars.status or false
end

--[[---------------------------------------------------------
	Name: gamemode.GetRoundTimer()
	Desc: Called to know the endtime value of the round timer
-----------------------------------------------------------]]
function GM:GetRoundTimer()
	return self.RoundVars.timer or 0
end
