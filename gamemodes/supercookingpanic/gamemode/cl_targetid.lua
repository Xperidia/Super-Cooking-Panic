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

	if ent:IsPlayer() then
		text = string.format("%s (%d points)", ent:Nick(), ent:GetPoints())
	elseif ent:IsIngredient() then
		local points = ent:GetPoints()
		text = string.format("%d points (%dx %d points)", points * multiplier, multiplier, points)
	elseif ent:GetClass() == "scookp_cooking_pot" then
		text = string.format("%s's cooking pot", team.GetName(ent:Team()))
	else
		return
	end

	surface.SetFont(font)
	local w, _ = surface.GetTextSize(text)

	local MouseX, MouseY = gui.MousePos()

	if MouseX == 0 and MouseY == 0 then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 120))
	draw.SimpleText(text, font, x + 4, y + 4, Color(0, 0, 0, 50))
	draw.SimpleText(text, font, x, y, self:GetTeamColor(ent))

end
