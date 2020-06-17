--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("shared.lua")
include("cl_hud.lua")
include("cl_player.lua")
include("cl_rounds.lua")
include("cl_render.lua")
include("cl_targetid.lua")

function GM:Initialize()

	self:SharedInitialize()

end

--[[---------------------------------------------------------
	Name: gamemode:Think()
	Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think()
end

--[[---------------------------------------------------------
	Name: gamemode:Tick()
	Desc: Like Think except called every tick on both client and server
-----------------------------------------------------------]]
function GM:Tick()
end
