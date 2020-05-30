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

--Called serverside
function PLAYER:Spawn()

	BaseClass.Spawn(self)

	local color = team.GetColor(self.player:Team())

	self.Player:SetPlayerColor(color)

	self.Player:SetWeaponColor(color)

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
