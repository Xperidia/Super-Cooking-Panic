--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

function GM.PlayerMeta:IsValidPlayingState()

	return self:Alive()
	and self:Team() ~= TEAM_SPECTATOR
	and self:Team() ~= TEAM_UNASSIGNED

end

function GM.PlayerMeta:IsHoldingIngredient()

	return self.GetHeldIngredient and IsValid(self:GetHeldIngredient())

end
