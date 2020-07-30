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

	local text = ""
	local font = self:GetScaledFont("big_text")

	if ent:IsPlayer() then

		text = ent:Nick()

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
	local _, t_h = surface.GetTextSize(text)

	y = y + t_h * .2

	draw.DrawText(text, font, x, y, self:GetTeamColor(ent), TEXT_ALIGN_CENTER)

end
