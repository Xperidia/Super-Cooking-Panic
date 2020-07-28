--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "Spawn point for Power-UPs"
ENT.Author = "Xperidia"
ENT.RenderGroup = RENDERGROUP_OTHER

function ENT:Initialize()

	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetRenderMode(RENDERMODE_NONE)

end

function ENT:KeyValue(k, v)

	if string.Left(k, 2) == "On" then

		self:StoreOutput(k, v)

	elseif k == "PowerUP" then

		self:SetPowerUP(GAMEMODE:GetPowerUPByKey(v) or 0)

	elseif k == "RespawnTime" then

		self.RespawnTime = v

	end

end

function ENT:SetupDataTables()

	self:NetworkVar("Int", 0, "PowerUP")

	if SERVER then

		self:SetPowerUP(0)

	end

end

function ENT:Think()

	if not SERVER or self.Disabled then return end

	if not self.SpawnedPowerUP then

		self.SpawnedPowerUP = GAMEMODE:CreatePowerUP(self, self:GetPowerUP())

	elseif not IsValid(self.SpawnedPowerUP) and not self.Wait then

		self.Wait = CurTime() + (self.RespawnTime or 30)
		self:TriggerOutput("OnPickup")

	elseif self.Wait and self.Wait < CurTime() then

		self.SpawnedPowerUP = GAMEMODE:CreatePowerUP(self, self:GetPowerUP(), true)
		self.Wait = nil

	end
end

function ENT:AcceptInput(name, activator, caller, data)

	if name == "ForceRespawn" and not IsValid(self.SpawnedPowerUP) then

		self.Wait = 0

		return true

	elseif name == "Enable" then

		self.Disabled = false

		return true

	elseif name == "Disable" then

		self.Disabled = true

		return true

	end

	return false

end
