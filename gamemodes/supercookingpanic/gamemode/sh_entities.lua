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
	["item_item_crate"] = true,
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

local super_ingredient_score_multiplier = 2
--

function GM:GetRandomPropModel()
	return Model(model_list[math.random(1, #model_list)]) --TODO
end

--[[---------------------------------------------------------
	Name: gamemode:GetBonusIngredientModel()
	Desc: Return bonus ingredient model
-----------------------------------------------------------]]
function GM:GetBonusIngredientModel()

	local model = GetGlobalString("scookp_BonusIngredientUpdate", nil)

	if model ~= nil then

		return Model(model)

	end

	return nil

end

--[[---------------------------------------------------------
	Name: Entity:IsBonusIngredient()
	Desc: Returns true if the entity is a super ingredient.
-----------------------------------------------------------]]
function GM.EntityMeta:IsBonusIngredient()

	if not self:IsIngredient() then
		return false
	end

	return self:GetModel() == GAMEMODE:GetBonusIngredientModel()

end

local function ent_is_ingredient(ent)

	if ent:GetModel() == nil then
		return false
	end

	return ingredient_class[ent:GetClass()]

end

--[[---------------------------------------------------------
	Name: Entity:IsIngredient()
	Desc: Returns true if the entity is an ingredient.
-----------------------------------------------------------]]
function GM.EntityMeta:IsIngredient()

	if CLIENT then
		return self:GetNWBool("scookp_IsIngredient", ent_is_ingredient(self))
	end

	if self._ingredient == false then
		return false
	end

	return self._ingredient or ent_is_ingredient(self)

end

--[[---------------------------------------------------------
	Name: Entity:GetPoints()
	Desc: Returns the points the entity is worth.
-----------------------------------------------------------]]
function GM.EntityMeta:GetPoints()

	if not self:IsIngredient() then
		return nil
	end

	--TODO: do point stuff

	--TODO: do actual check when trap is ready
	--[[if ent_is_trap then
		return 0
	end]]

	local points = self:GetBasePoints()

	if CLIENT then

		points = self:GetNWInt("scookp_points", points)

	end

	if self:IsBonusIngredient() then

		points = points * super_ingredient_score_multiplier

	end

	return points

end

--[[---------------------------------------------------------
	Name: Entity:GetBasePoints()
	Desc: Returns the base points the entity is worth.
-----------------------------------------------------------]]
function GM.EntityMeta:GetBasePoints()

	return math.Round(self:GetModelRadius())

end
