--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.Name 			= "Super Cooking Panic"
GM.Prefix			= "scookp"
GM.Author 			= "Xperidia"
GM.Website 			= "github.com/Xperidia/Super-Cooking-Panic"
GM.Version 			= "0.1.0"
GM.VersionDate 		= 200719
GM.TeamBased 		= true
GM.AllowAutoTeam	= true

GM.IsSuperCookingPanicDerived = true

GM.BaseClass = baseclass.Get("gamemode_base")
GM.PlayerMeta = GM.PlayerMeta or FindMetaTable("Player")
GM.EntityMeta = GM.EntityMeta or FindMetaTable("Entity")

include("sh_utils.lua")
include("sh_convars.lua")
include("player_class/player_cook.lua")

GM.pm_list = {
	"male01",
	"male02",
	"male03",
	"male04",
	"male05",
	"male06",
	"male07",
	"male08",
	"male09",
	"male09",
	"female01",
	"female02",
	"female03",
	"female04",
	"female05",
	"female06",
}

function GM:SharedInitialize()

	self.BaseClass.Initialize(self)

	if not file.IsDir(GAMEMODE_NAME, "DATA") then
		file.CreateDir(GAMEMODE_NAME)
	end

	self:CreateConVars()

	for _, v in pairs(self.pm_list) do

		local pm = player_manager.TranslatePlayerModel(v)

		util.PrecacheModel(pm)

		local hm = player_manager.TranslatePlayerHands(v)

		if hm.model then

			util.PrecacheModel(hm.model)

		end

	end

end
