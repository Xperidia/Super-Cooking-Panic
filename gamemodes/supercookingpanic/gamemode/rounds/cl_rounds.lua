--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_rounds.lua")

net.Receive("scookp_roundupdate", function(len)

	GAMEMODE.RoundVars.state = net.ReadUInt(32)
	GAMEMODE.RoundVars.timer = net.ReadFloat()

	if GAMEMODE.RoundVars.state == RND_PLAYING then

		surface.PlaySound("supercookingpanic/effects/time_up.wav")

	elseif GAMEMODE.RoundVars.state == RND_ENDING then

		surface.PlaySound("supercookingpanic/effects/time_running_up.wav")

	end

end)
