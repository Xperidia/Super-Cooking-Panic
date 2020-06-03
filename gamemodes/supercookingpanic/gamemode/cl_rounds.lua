--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local round_status = 0 -- Active = 1

--[[---------------------------------------------------------
	Name: gamemode.GetRoundStatus()
	Desc: Called to know the current game round status
-----------------------------------------------------------]]
function GM:GetRoundStatus()
	return round_status
end

--[[---------------------------------------------------------
	Name: gamemode.UpdateRoundStatus()
	Desc: Receives the updated game status value from the server
-----------------------------------------------------------]]
function GM:UpdateRoundStatus(len)
	round_status = net.ReadBool()
end
net.Receive("UpdateRoundStatus", UpdateRoundStatus)
