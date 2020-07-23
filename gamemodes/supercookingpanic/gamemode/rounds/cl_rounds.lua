--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_rounds.lua")

net.Receive("scookp_roundupdate", function(len)

	GAMEMODE.RoundVars.status = net.ReadBool()
	GAMEMODE.RoundVars.timer = net.ReadFloat()

end)
