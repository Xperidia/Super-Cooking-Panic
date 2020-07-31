--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile("cl_utils.lua")
AddCSLuaFile("cl_music.lua")
AddCSLuaFile("cl_scale.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_render.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_pickteam.lua")
AddCSLuaFile("cl_scoreboard.lua")

include("shared.lua")
include("player/player.lua")
include("teams/teams.lua")
include("rounds/rounds.lua")
include("entities/entities.lua")
include("powerups/powerups.lua")

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

	self:RoundThink()
	self:TeamThink()

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
