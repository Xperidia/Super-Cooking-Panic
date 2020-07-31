--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "#scookp_trap"
ENT.Author = "Xperidia"

function ENT:Initialize()

	self._ingredient = true

	if SERVER then

		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)

	end

end

--[[---------------------------------------------------------
	Name: entity:SetupDataTables()
	Desc: Declares shared entity variables
-----------------------------------------------------------]]
function ENT:SetupDataTables()

	self:NetworkVar("Int", 0, "Team")
	self:NetworkVar("Entity", 0, "TheOwner")

end

--[[---------------------------------------------------------
	Name: entity:Team()
	Desc: Gets the entity's team ID
-----------------------------------------------------------]]
function ENT:Team()

	return self:GetTeam()

end

function ENT:Draw()

	self:DrawModel()

end

function ENT:DoTheTrap(ent)

	if not IsValid(ent) then return false end
	if not ent:IsPlayer() then return false end
	if not ent:IsValidPlayingState() then return false end
	if ent:Team() == self:Team() then return false end

	util.BlastDamage(self, self:GetTheOwner() or self, ent:GetPos(), 75, 2147483647)

	self:Remove()

	return true

end

function ENT:StartTouch(ent)

	self:DoTheTrap(ent)

end

function ENT:Use(activator)

	self:DoTheTrap(activator)

end
