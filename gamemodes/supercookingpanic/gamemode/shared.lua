--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_utils.lua")
include("sh_teams.lua")
include("player_class/player_cook.lua")

GM.Name 		= "Super Cooking Panic"
GM.Author 		= "Xperidia"
GM.Website 		= "github.com/Xperidia/Super-Cooking-Panic"
GM.Version 		= "0.1.0"
GM.VersionDate 	= 200530
GM.TeamBased 	= true

GM.BaseClass = baseclass.Get("gamemode_base")
GM.PlayerMeta = GM.PlayerMeta or FindMetaTable("Player")
GM.EntityMeta = GM.EntityMeta or FindMetaTable("Entity")

function GM:SharedInitialize()

	self.BaseClass.Initialize(self)

end
