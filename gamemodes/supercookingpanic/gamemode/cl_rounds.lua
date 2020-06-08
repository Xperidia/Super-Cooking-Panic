--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local round_status = false -- Active = true
local round_timer = 0 -- Endtime value

--[[---------------------------------------------------------
	Name: gamemode.GetRoundStatus()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GM:GetRoundStatus()
	return round_status
end

--[[---------------------------------------------------------
	Name: gamemode.UpdateRoundStatus( number )
	Desc: Receives the updated game status value from the server
-----------------------------------------------------------]]
function GM:UpdateRoundStatus(len)
	round_status = net.ReadBool()
end
net.Receive("UpdateRoundStatus", GM.UpdateRoundStatus)

--[[---------------------------------------------------------
	Name: gamemode.GetRoundTimer()
	Desc: Called to know the endtime value of the round timer
-----------------------------------------------------------]]
function GM:GetRoundTimer()
	return round_timer
end

--[[---------------------------------------------------------
	Name: gamemode.UpdateRoundTimer( number )
	Desc: Receives the updated endtime value of the round time from the server
-----------------------------------------------------------]]
function GM:UpdateRoundTimer(len)
	round_timer = net.ReadFloat()
end
net.Receive("UpdateRoundTimer", GM.UpdateRoundTimer)
