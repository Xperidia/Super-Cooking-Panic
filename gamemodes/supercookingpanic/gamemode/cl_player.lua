--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

if not GM.PlayerMeta.IsListenServerHost then

	function GM.PlayerMeta:IsListenServerHost()

		return self:GetNWBool("IsListenServerHost", false)

	end

end
