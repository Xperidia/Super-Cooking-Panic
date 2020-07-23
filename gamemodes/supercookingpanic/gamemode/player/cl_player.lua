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
