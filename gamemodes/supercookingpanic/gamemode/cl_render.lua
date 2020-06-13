--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:SetCookingPotHalo()
	Desc: Renders an halo around every 'cooking pot' entity
			The color matches the entity's team
-----------------------------------------------------------]]
function GM:SetCookingPotHalo()
	for k, v in pairs(ents.FindByClass("scookp_cooking_pot")) do
		halo.Add({v}, v:GetTeamColor(), 2, 2, 10)
	end
end
hook.Add("PreDrawHalos", "AddPropHalos", GM.SetCookingPotHalo)
