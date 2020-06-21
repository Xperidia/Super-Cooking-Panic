--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

GM.Name 			= "Super Cooking Panic"
GM.Prefix			= "scookp"
GM.Author 			= "Xperidia"
GM.Website 			= "github.com/Xperidia/Super-Cooking-Panic"
GM.Version 			= "0.1.0"
GM.VersionDate 		= 200621
GM.TeamBased 		= true
GM.AllowAutoTeam	= true

GM.IsSuperCookingPanicDerived = true

GM.BaseClass = baseclass.Get("gamemode_base")
GM.PlayerMeta = GM.PlayerMeta or FindMetaTable("Player")
GM.EntityMeta = GM.EntityMeta or FindMetaTable("Entity")

include("sh_utils.lua")
include("sh_teams.lua")
include("sh_convars.lua")
include("sh_entities.lua")
include("player_class/player_cook.lua")

function GM:SharedInitialize()

	self.BaseClass.Initialize(self)

	if not file.IsDir(GAMEMODE_NAME, "DATA") then
		file.CreateDir(GAMEMODE_NAME)
	end

	self:CreateConVars()

end
