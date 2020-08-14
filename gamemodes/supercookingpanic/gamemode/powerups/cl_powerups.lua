--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_powerups.lua")

local function PlayerUsedPowerUP()

	local ply = net.ReadEntity()
	local powerup_id = net.ReadUInt(4)

	if not IsValid(ply) then return end

	local powerup = GAMEMODE.PowerUPs[powerup_id]

	local class = powerup.ent_class or "scookp_pu_" .. powerup.key

	GAMEMODE:AddDeathNotice(nil, 0, class, ply:Name(), ply:Team())

end
net.Receive("scookp_PlayerUsedPowerUP", PlayerUsedPowerUP)

function GM:SetupPowerUPkillicon()

	for _, v in ipairs(self.PowerUPs) do

		local icon = v.icon

		if icon and not icon:IsError() then

			local class = v.ent_class or "scookp_pu_" .. v.key

			killicon.Add(class, icon:GetName(), color_white)

		end

	end

end
