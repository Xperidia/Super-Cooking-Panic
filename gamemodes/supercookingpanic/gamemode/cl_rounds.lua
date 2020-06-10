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
	Name: gamemode.GetRoundTimer()
	Desc: Called to know the endtime value of the round timer
-----------------------------------------------------------]]
function GM:GetRoundTimer()
	return round_timer
end

--[[---------------------------------------------------------
	Name: gamemode.UpdateRoundValues( number )
	Desc: Receives multiple updated values from the server
-----------------------------------------------------------]]
function GM.UpdateRoundValues(len)
	round_status = net.ReadBool()
	round_timer = net.ReadFloat()
end
net.Receive("RoundUpdate", GM.UpdateRoundValues)
