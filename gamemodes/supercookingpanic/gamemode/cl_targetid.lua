--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

entity_looked_at = nil

--[[---------------------------------------------------------
	Name: gamemode:EntityLookedAt( )
	Desc: Refers the current entity looked by the player
-----------------------------------------------------------]]
function GM:EntityLookedAt()
	return entity_looked_at
end

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawTargetID( )
	Desc: Draw the target id (the name of the player you're currently looking at)
-----------------------------------------------------------]]
function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace(LocalPlayer())
	local trace = util.TraceLine(tr)

	entity_looked_at = trace.Entity

	if not trace.Hit or not trace.HitNonWorld then
		return
	end

	local text = "ERROR"
	local font = "DermaLarge"

	if trace.Entity:IsPlayer() then
		text = string.format("%s (%d points)", trace.Entity:Nick(), trace.Entity:GetPoints())
	elseif trace.Entity:IsIngredient() then
		text = string.format("%d points", trace.Entity:GetPoints())
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
	draw.SimpleText(text, font, x, y, self:GetTeamColor(trace.Entity))

end
