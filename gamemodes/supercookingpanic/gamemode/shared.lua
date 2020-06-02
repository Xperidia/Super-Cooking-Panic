--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_utils.lua")
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

GM.team_list = {
	{
		name = "Blue Team",
		color = Color(52, 152, 219),
	},
	{
		name = "Orange Team",
		color = Color(230, 126, 34),
	},
}

function GM:CreateTeams()

	for k, v in pairs(self.team_list) do
		team.SetUp(k, v.name, v.color)
		team.SetSpawnPoint(k, "info_player_start")
		team.SetClass(k, {"player_cook"})
	end

end

function GM:SharedInitialize()

	self.BaseClass.Initialize(self)

end
