--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_rounds.lua")

net.Receive("scookp_roundupdate", function(len)

	GAMEMODE.RoundVars.state = net.ReadUInt(32)
	GAMEMODE.RoundVars.timer = net.ReadFloat()

end)
