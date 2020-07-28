--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_player.lua")

if not GM.PlayerMeta.IsListenServerHost then

	function GM.PlayerMeta:IsListenServerHost()

		return self:GetNWBool("IsListenServerHost", false)

	end

end

function GM:PlayerBindPress(ply, bind, down)

	if down and bind == "gmod_undo" then

		RunConsoleCommand("scookp_powerup_drop")

	end

	return false

end
