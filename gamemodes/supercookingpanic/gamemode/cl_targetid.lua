--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]


--[[---------------------------------------------------------
	Name: gamemode:HUDDrawTargetID( )
	Desc: Draw the target id (the name of the player you're currently looking at)
-----------------------------------------------------------]]
function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace(LocalPlayer())
	local trace = util.TraceLine(tr)
	if not trace.Hit then return end
	if not trace.HitNonWorld then return end

	local text = "ERROR"
	local font = "DermaLarge"

	if trace.Entity:IsPlayer() then
		text = trace.Entity:Nick()
	else
		return
		--text = trace.Entity:GetClass()
		--TODO: ingredient points
	end

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)

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
	draw.SimpleText(text, font, x + w * .02, y + h * .02, Color(0, 0, 0, 120))
	draw.SimpleText(text, font, x + w * .04, y + h * .04, Color(0, 0, 0, 50))
	draw.SimpleText(text, font, x, y, self:GetTeamColor(trace.Entity))

end
