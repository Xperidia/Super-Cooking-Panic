--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Cooking Pot"

ENT.Spawnable = true

--[[---------------------------------------------------------
	Name: entity:Initialize()
	Desc: Called immediately after spawning the entity
-----------------------------------------------------------]]
function ENT:Initialize()
	self:SetModel("models/props_c17/metalPot001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
end

--[[---------------------------------------------------------
	Name: entity:SetupDataTables()
	Desc: Declares network variables for the entity
-----------------------------------------------------------]]
function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "TeamIndex")
end

--[[---------------------------------------------------------
	Name: entity:GetTeamColor()
	Desc: Gets the color of the entity's team
-----------------------------------------------------------]]
function ENT:GetTeamColor()
	return team.GetColor(self:GetTeamIndex())
end

--[[---------------------------------------------------------
	Name: entity:Draw()
	Desc: Draws the entity on the screen
-----------------------------------------------------------]]
function ENT:Draw()
	self:DrawModel()
end
