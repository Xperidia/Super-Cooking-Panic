--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.Name 			= "Super Cooking Panic"
GM.Prefix			= "scookp"
GM.Author 			= "Xperidia"
GM.Website 			= "steamcommunity.com/sharedfiles/filedetails/?id=2180715133"
GM.Version 			= "v0.9.0"
GM.VersionDate 		= 200816
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

GM.ConvDistance = 160
GM.ErrorColor = Color(255, 0, 255, 255)

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

	sound.Add({
		name = "scookp_combo_trigger",
		channel = CHAN_ITEM,
		level = 80,
		sound = "supercookingpanic/effects/combo_trigger.wav"
	})

	sound.Add({
		name = "scookp_ingredient_grab",
		channel = CHAN_WEAPON,
		level = 66,
		sound = "supercookingpanic/effects/ingredient_grab.wav"
	})

	sound.Add({
		name = "scookp_ingredient_release",
		channel = CHAN_WEAPON,
		level = 66,
		sound = "supercookingpanic/effects/ingredient_release.wav"
	})

	sound.Add({
		name = "scookp_power_up_drop",
		channel = CHAN_ITEM,
		level = 66,
		sound = "supercookingpanic/effects/power_up_drop.wav"
	})

	sound.Add({
		name = "scookp_power_up_pickup",
		channel = CHAN_ITEM,
		level = 66,
		sound = "supercookingpanic/effects/power_up_pickup.wav"
	})

	sound.Add({
		name = "scookp_power_up_spawn",
		channel = CHAN_ITEM,
		level = 66,
		sound = "supercookingpanic/effects/power_up_spawn.wav"
	})

	sound.Add({
		name = "scookp_power_up_use",
		channel = CHAN_ITEM,
		level = 66,
		sound = "supercookingpanic/effects/power_up_use.wav"
	})

	sound.Add({
		name = "scookp_reroll_bonus_ingredient",
		channel = CHAN_ITEM,
		level = 120,
		sound = "supercookingpanic/effects/reroll_super_ingredient.wav"
	})

	sound.Add({
		name = "scookp_cooking_pot_spawn",
		channel = CHAN_AUTO,
		level = 120,
		sound = "supercookingpanic/effects/cooking_pot_spawn.wav"
	})

end
