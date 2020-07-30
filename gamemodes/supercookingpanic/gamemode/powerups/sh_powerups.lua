--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.PowerUPs = {
	{
		key = "canibalism",
		target = "player",
		icon = Material("supercookingpanic/powerup/canibalism"),
		func = function(self)

			local trace = util.TraceLine(util.GetPlayerTrace(self))

			if not trace.Hit then return false end

			if not trace.HitNonWorld then return false end

			if not IsValid(trace.Entity) then return false end

			if not trace.Entity:IsPlayer() then return false end

			if trace.HitPos:Distance(trace.StartPos) < GAMEMODE.ConvDistance then

				return trace.Entity:GoToRagdoll(self)

			end

			return false

		end,
	},
	--[[{
		key = "fake",
		target = "world",
		icon = Material("supercookingpanic/powerup/fake"),
		func = function(self)
			return false
		end,
	},]]
	{
		key = "reroll",
		target = "none",
		icon = Material("supercookingpanic/powerup/reroll"),
		use_sound = "scookp_reroll_bonus_ingredient",
		func = function(self)
			GAMEMODE:AutoChooseBonusIngredient()
			return true
		end,
	},
	--[[{
		key = "soapy",
		icon = Material("supercookingpanic/powerup/soapy"),
		think = function(self)
		end,
	},]]
	--[[{
		key = "spicy",
		icon = Material("supercookingpanic/powerup/spicy"),
		think = function(self)
		end,
	},]]
	{
		key = "respawn_pot",
		icon = Material("supercookingpanic/powerup/respawn_pot"),
		target = "none",
		func = function(self)
			GAMEMODE.RemoveCookingPots()
			GAMEMODE:SpawnCookingPots()
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
