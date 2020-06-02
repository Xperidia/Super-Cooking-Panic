--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_utils.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_player.lua")

include("shared.lua")
include("player.lua")


--[[---------------------------------------------------------
	Name: gamemode:Initialize()
	Desc: Called immediately after starting the gamemode
-----------------------------------------------------------]]
function GM:Initialize()

	self:SharedInitialize()

end

--[[---------------------------------------------------------
	Name: gamemode:InitPostEntity()
	Desc: Called as soon as all map entities have been spawned
-----------------------------------------------------------]]
function GM:InitPostEntity()
end

--[[---------------------------------------------------------
	Name: gamemode:Think()
	Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think()
end

--[[---------------------------------------------------------
	Name: gamemode:ShutDown()
	Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown()
end

--[[---------------------------------------------------------
	Name: gamemode:EntityTakeDamage( target, dmg )
	Desc: The entity has received damage
-----------------------------------------------------------]]
function GM:EntityTakeDamage(target, dmg)
end
