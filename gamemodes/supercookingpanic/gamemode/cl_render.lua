--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:SetCookingPotHalo()
	Desc: Renders an halo around every 'cooking pot' entity
			The color matches the entity's team
-----------------------------------------------------------]]
function GM:CookingPotHalo()
	for _, v in pairs(ents.FindByClass("scookp_cooking_pot")) do
		halo.Add({v}, v:GetTeamColor(), 2, 2, 1, true, true)
	end
end

--[[---------------------------------------------------------
	Name: gamemode:SetCookingPotHalo()
	Desc: Renders an halo around the mouse over entity
-----------------------------------------------------------]]
function GM:MouseOverHalo()

	local ent = self:EntityLookedAt()

	if not IsValid(ent) or not ent:IsIngredient() then
		return
	end

	--TODO: remove debug check
	if self:ConVarGetBool("dev_mode") and ent:IsSuperIngredient() then
		return
	end

	halo.Add({ent}, self:GetTeamColor(ent), 2, 2, 1, true, true)

end

--TODO: remove debug function
function GM:SuperIngredientsHalo()

	if not self:ConVarGetBool("dev_mode") then return end

	halo.Add(self:GetSuperIngredients(), Color(0, 255, 0), 2, 2, 1, true, true)

end

--[[---------------------------------------------------------
	Name: gamemode:PreDrawHalos()
	Desc:	Called before rendering the halos.
			This is the place to call halo.Add.
-----------------------------------------------------------]]
function GM:PreDrawHalos()

	self:CookingPotHalo()
	self:MouseOverHalo()
	self:SuperIngredientsHalo() --TODO: remove debug function

end
