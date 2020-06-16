--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Constants
local ingredient_class = {
	["prop_physics"] = true,
	["prop_ragdoll"] = true,
	["player"] = true,
	["npc_citizen"] = true,
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
