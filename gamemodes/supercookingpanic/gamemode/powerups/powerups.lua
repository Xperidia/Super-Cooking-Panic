--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_powerups.lua")

AddCSLuaFile("cl_powerups.lua")

function GM:CreatePowerUP(arg, powerup_id, respawn)

	local PowerUP = ents.Create("scookp_powerup")
	local pos

	if not arg then
		return nil
	elseif isvector(arg) then
		pos = arg
	elseif IsEntity(arg) then
		pos = arg:GetPos()
	end

	PowerUP:SetPos(pos)

	PowerUP:SetPowerUP(powerup_id or 0)
	PowerUP.IsRespawn = respawn
	PowerUP.WasDropped = IsEntity(arg) and arg

	PowerUP:Spawn()

	return PowerUP

end

concommand.Add("scookp_dev_create_power_up", function(ply, cmd, args)

	if not GAMEMODE:ConVarGetBool("dev_mode") then return end

	if IsValid(ply) and (ply:IsListenServerHost() or ply:IsSuperAdmin()) then

		GAMEMODE:CreatePowerUP(ply, args[1])

	end

end, nil, "Create a Power-UP", FCVAR_CLIENTCMD_CAN_EXECUTE)

function GM.PlayerMeta:PickPowerUP(powerup_id)

	if not self:HasPowerUP() and self:IsValidPlayingState() then

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
