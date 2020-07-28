--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_powerups.lua")

AddCSLuaFile("cl_powerups.lua")

function GM:CreatePowerUP(ent, powerup_id, respawn)

	local PowerUP = ents.Create("scookp_powerup")

	PowerUP:SetPos(ent:GetPos())

	PowerUP:SetPowerUP(powerup_id or 0)
	PowerUP.IsRespawn = respawn
	PowerUP.WasDropped = ent

	PowerUP:Spawn()

	return PowerUP

end

function GM.PlayerMeta:UsePowerUP()

	local result
	local powerup_id = self:GetPowerUP()

	if powerup_id and GAMEMODE.PowerUPs[powerup_id] then

		if GAMEMODE.PowerUPs[powerup_id].func then

			result = GAMEMODE.PowerUPs[powerup_id].func(self)

		end

		if result then

			GAMEMODE:DebugLog(self:GetName() .. " has used power-up " .. powerup_id)

			self:SetPowerUP(0)

			self:EmitSound("scookp_power_up_use")

		elseif result == nil then

			GAMEMODE:Log(self:GetName() .. " has tried to use power-up " .. powerup_id .. " but no result was found!")

			self:SetPowerUP(0)

			self:EmitSound("scookp_power_up_use")

		end

	end

	return result

end

function GM.PlayerMeta:PickPowerUP(powerup_id)

	if not self:HasPowerUP() then

		if powerup_id and GAMEMODE.PowerUPs[powerup_id] then

			return self:SetPowerUP(powerup_id)

		end

		return self:SetPowerUP(GAMEMODE:SelectRandomPowerUP(self))

	end

	return false

end

function GM.PlayerMeta:DropPowerUP()

	if self:HasPowerUP() then

		GAMEMODE:CreatePowerUP(self, self:GetPowerUP())

		self:SetPowerUP(0)

		return true

	end

	return false

end

concommand.Add("scookp_powerup_drop", function(ply, cmd, args)
	if IsValid(ply) then
		ply:DropPowerUP()
	end
end, nil, "Drop a power-up", FCVAR_CLIENTCMD_CAN_EXECUTE)
