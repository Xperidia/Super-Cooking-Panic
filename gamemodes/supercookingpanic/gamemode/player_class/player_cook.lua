--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.DisplayName = "Player Cook Class"

PLAYER.TauntCam = TauntCamera()

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400
PLAYER.DropWeaponOnDie		= true


function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables(self)

end

function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	self.Player:Give("weapon_fists")

end

function PLAYER:SetModel()

	local playermodel = GAMEMODE.pm_list[math.random(1, #GAMEMODE.pm_list)]
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
