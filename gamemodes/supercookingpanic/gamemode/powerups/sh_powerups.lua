--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.PowerUPs = {
	{
		key = "cannibalism",
		target = "player",
		icon = Material("supercookingpanic/powerup/cannibalism"),
		use_sound = nil,
		notify = false,
		ent_class = "scookp_arms",
		func = function(self)

			local trace = GAMEMODE:GetConvPlayerTrace(self)

			if not trace.Hit then return false end

			if not trace.HitNonWorld then return false end

			if not IsValid(trace.Entity) then return false end

			if not trace.Entity:IsPlayer() then return false end

			if SERVER then
				return trace.Entity:GoToRagdoll(self)
			end

			return true

		end,
	},
	{
		key = "fake",
		target = "world",
		icon = Material("supercookingpanic/powerup/fake"),
		use_sound = nil,
		notify = false,
		ent_class = "scookp_trap",
		func = function(self)

			if SERVER then
				return GAMEMODE:CreateTrap(self)
			end

			return true

		end,
	},
	{
		key = "reroll",
		target = "none",
		icon = Material("supercookingpanic/powerup/reroll"),
		use_sound = "scookp_reroll_bonus_ingredient",
		notify = true,
		ent_class = nil,
		func = function(self)

			if SERVER then
				GAMEMODE:AutoChooseBonusIngredient()
			end

			return true

		end,
	},
	--[[{
		key = "soapy",
		target = "player",
		icon = Material("supercookingpanic/powerup/soapy"),
		use_sound = nil,
		notify = true,
		ent_class = nil,
		think = function(self)
		end,
	},]]
	--[[{
		key = "spicy",
		target = "none",
		icon = Material("supercookingpanic/powerup/spicy"),
		use_sound = nil,
		notify = true,
		ent_class = nil,
		think = function(self)
		end,
	},]]
	{
		key = "respawn_pot",
		target = "none",
		icon = Material("supercookingpanic/powerup/respawn_pot"),
		use_sound = nil,
		notify = true,
		ent_class = nil,
		func = function(self)

			if SERVER then
				GAMEMODE:RemoveCookingPots()
				GAMEMODE:SpawnCookingPots()
			end

			return true

		end,
	},
}

function GM.PlayerMeta:HasPowerUP()

	if not self:IsValidPlayingState() then
		return false
	end

	return self:GetPowerUP() > 0

end

function GM.PlayerMeta:UsePowerUP()

	if not GAMEMODE:IsValidGamerMoment() then return end

	local result
	local powerup_id = self:GetPowerUP()

	if powerup_id and GAMEMODE.PowerUPs[powerup_id] then

		local powerup = GAMEMODE.PowerUPs[powerup_id]

		if powerup.func then

			result = powerup.func(self)

		end

		if SERVER and result then

			GAMEMODE:DebugLog(self:GetName() .. " has used power-up " .. (powerup.key or powerup_id))

			self:SetPowerUP(0)

			self:EmitSound(powerup.use_sound or "scookp_power_up_use")

			GAMEMODE:PlayerUsedPowerUP(self, powerup_id)

		elseif SERVER and result == nil then

			GAMEMODE:Log(self:GetName() .. " has tried to use power-up " .. (powerup.key or powerup_id) .. " but no result was found!")

			self:SetPowerUP(0)

			self:EmitSound(powerup.use_sound or "scookp_power_up_use")

			GAMEMODE:PlayerUsedPowerUP(self, powerup_id)

		end

	end

	return result

end

function GM:SelectRandomPowerUP()
	return math.random(1, #self.PowerUPs)
end

function GM:GetPowerUPByKey(powerup_key)

	for k, v in pairs(self.PowerUPs) do

		if v.key and v.key == powerup_key then
			return k
		end

	end

	return nil

end

function GM:GetPowerUPName(key)
	return self:GetPhrase("$scookp_power_up_" .. key)
end
