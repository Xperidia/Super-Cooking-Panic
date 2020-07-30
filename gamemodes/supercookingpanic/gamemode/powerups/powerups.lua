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

function GM.PlayerMeta:UsePowerUP()

	if not GAMEMODE:IsValidGamerMoment() then return end

	local result
	local powerup_id = self:GetPowerUP()

	if powerup_id and GAMEMODE.PowerUPs[powerup_id] then

		if GAMEMODE.PowerUPs[powerup_id].func then

			result = GAMEMODE.PowerUPs[powerup_id].func(self)

		end

		if result then

			GAMEMODE:DebugLog(self:GetName() .. " has used power-up " .. powerup_id)

			self:SetPowerUP(0)

			self:EmitSound(GAMEMODE.PowerUPs[powerup_id].use_sound or "scookp_power_up_use")

		elseif result == nil then

			GAMEMODE:Log(self:GetName() .. " has tried to use power-up " .. powerup_id .. " but no result was found!")

			self:SetPowerUP(0)

			self:EmitSound(GAMEMODE.PowerUPs[powerup_id].use_sound or "scookp_power_up_use")

		end

	end

	return result

end

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

--[[---------------------------------------------------------
	Name: gamemode:SpawnPowerUP( number howmuch )
	Desc: Spawns how many Power-UPs
-----------------------------------------------------------]]
function GM:SpawnPowerUP(howmuch)

	while howmuch > 0 do

		self:CreatePowerUP(self:EntSelectSpawn())

		howmuch = howmuch - 1

	end

end
