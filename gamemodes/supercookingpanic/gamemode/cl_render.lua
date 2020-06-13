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
		halo.Add({v}, v:GetTeamColor(), 0, 0, 1)
	end
end

--[[---------------------------------------------------------
	Name: gamemode:PreDrawHalos()
	Desc:	Called before rendering the halos.
			This is the place to call halo.Add.
-----------------------------------------------------------]]
function GM:PreDrawHalos()
	self:CookingPotHalo()
end
