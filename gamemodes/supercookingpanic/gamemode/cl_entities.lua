--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local super_ingredients = {}

--[[---------------------------------------------------------
	Name: gamemode.GetSuperIngredients()
	Desc: Returns the super ingredients list of entities
-----------------------------------------------------------]]
function GM:GetSuperIngredients()
	return super_ingredients
end

--[[---------------------------------------------------------
	Name: gamemode.UpdateSuperIngredientsList()
	Desc: Updates the client list of super ingredients
-----------------------------------------------------------]]
function GM.UpdateSuperIngredientsList(len)

	super_ingredients = {} -- wipe the list

	for _, v in pairs(ents.FindByClass("prop_physics")) do

		if v:IsSuperIngredient() then
			table.insert(super_ingredients, v)
		end

	end

	PrintTable(super_ingredients)

end
net.Receive("scookp_SuperIngredientUpdate", GM.UpdateSuperIngredientsList)
