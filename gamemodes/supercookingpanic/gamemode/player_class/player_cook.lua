--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName = "Player Cook Class"

PLAYER.TauntCam = TauntCamera()


function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables(self)

end

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	--self.Player:Give("weapon_physgun")

end

local pm_list = {
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

for _, v in pairs(pm_list) do
	util.PrecacheModel(v)
end

function PLAYER:SetModel()

	local playermodel = pm_list[math.random(1, #pm_list)]
	local model = player_manager.TranslatePlayerModel(playermodel)

	self.Player:SetModel(model)

	local nskin = self.Player:SkinCount()
	self.Player:SetSkin(math.random(0, nskin))

end

--Called serverside
function PLAYER:Spawn()

	BaseClass.Spawn(self)

	local color = team.GetColor(self.Player:Team())

	self.Player:SetPlayerColor(color:ToVector())

	self.Player:SetWeaponColor(color:ToVector())

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

	if self.TauntCam:ShouldDrawLocalPlayer(self.Player, self.Player:IsPlayingTaunt()) then
		return true
	end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove(cmd)

	if self.TauntCam:CreateMove(cmd, self.Player, self.Player:IsPlayingTaunt()) then
		return true
	end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView(view)

	if self.TauntCam:CalcView(view, self.Player, self.Player:IsPlayingTaunt()) then
		return true
	end

end

player_manager.RegisterClass("player_cook", PLAYER, "player_default")
