--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Constants
local ingredient_class = {
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true,
	["prop_physics_respawnable"] = true,
	["item_healthkit"] = true,
	["prop_ragdoll"] = true,
	["player"] = true,
	["npc_citizen"] = true,
	["npc_metropolice"] = true,
	["npc_zombie"] = true,
	["npc_zombie_torso"] = true,
	["npc_fastzombie"] = true,
	["npc_headcrab"] = true,
	["npc_headcrab_black"] = true,
	["npc_headcrab_fast"] = true,
	["npc_antlion"] = true,
	["npc_antlion_worker"] = true,
	["npc_vortigaunt"] = true,
	["npc_odessa"] = true,
	["npc_kleiner"] = true,
	["npc_breen"] = true,
	["npc_crow"] = true,
	["npc_pigeon"] = true,
	["npc_seagull"] = true,
	["npc_antlion_grub"] = true,
	["npc_manhack"] = true,
	["npc_rollermine"] = true,
	["npc_cscanner"] = true,
	["npc_clawscanner"] = true,
	["npc_stalker"] = true,
	["npc_turret_floor"] = true,
}

local model_list = {
	--TODO: fill models or replace with a way to get any prop model
}

function GM:GetRandomPropModel()
	return Model(model_list[math.random(1, #model_list)]) --TODO
end

--[[---------------------------------------------------------
	Name: Entity:IsIngredient()
	Desc: Returns true if the entity is an ingredient.
-----------------------------------------------------------]]
function GM.EntityMeta:IsIngredient()

	if CLIENT then
		return self:GetNWBool("scookp_IsIngredient", ingredient_class[self:GetClass()])
	end

	if self._ingredient == false then
		return false
	end

	return self._ingredient or ingredient_class[self:GetClass()]

end

--[[---------------------------------------------------------
	Name: Entity:GetPoints()
	Desc: Returns the points the entity is worth.
-----------------------------------------------------------]]
function GM.EntityMeta:GetPoints()

	--TODO: do point stuff

	--TODO: do actual check when trap is ready
	--[[if ent_is_trap then
		return 0
	end]]

	if self:IsIngredient() then

		if CLIENT then
			return self:GetNWInt("scookp_points", self:GetBasePoints())
		end

		return self:GetBasePoints()

	end

	return nil

end

--[[---------------------------------------------------------
	Name: Entity:GetBasePoints()
	Desc: Returns the base points the entity is worth.
-----------------------------------------------------------]]
function GM.EntityMeta:GetBasePoints()

	return math.Round(self:GetModelRadius())

end
