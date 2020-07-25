--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawTargetID( )
	Desc: Draw the target id (the name of the player you're currently looking at)
-----------------------------------------------------------]]
function GM:HUDDrawTargetID()

	local ent = self:EntityLookedAt()

	if not IsValid(ent) then
		return
	end

	local text = "ERROR"
	local font = "DermaLarge"
	local multiplier = self:GetScoreMultiplier(LocalPlayer():Team())
	local points = ent:GetPoints() or 0
	local cpoints = points * multiplier

	if ent:IsPlayer() then

		text = string.format("%s\n%d points\n(%dx %d points)", ent:Nick(), cpoints, multiplier, points)

	elseif ent:IsIngredient() then

		text = string.format("%d points\n(%dx %d points)", cpoints, multiplier, points)

	elseif ent:GetClass() == "scookp_cooking_pot" then

		text = string.format("%s's cooking pot", team.GetName(ent:Team()))

	else

		return

	end

	surface.SetFont(font)

	local MouseX, MouseY = gui.MousePos()

	if MouseX == 0 and MouseY == 0 then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.DrawText(text, font, x + 2, y + 2, Color(0, 0, 0, 120), TEXT_ALIGN_CENTER)
	draw.DrawText(text, font, x + 4, y + 4, Color(0, 0, 0, 50), TEXT_ALIGN_CENTER)
	draw.DrawText(text, font, x, y, self:GetTeamColor(ent), TEXT_ALIGN_CENTER)

end
