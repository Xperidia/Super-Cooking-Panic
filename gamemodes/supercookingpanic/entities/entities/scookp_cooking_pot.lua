--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Cooking Pot"
ENT.Author = "Xperidia"

local MODEL = Model("models/props_c17/metalPot001a.mdl")

--[[---------------------------------------------------------
	Name: entity:Initialize()
	Desc: Called immediately after spawning the entity
-----------------------------------------------------------]]
function ENT:Initialize()

	if not SERVER then
		return
	end

	self:SetModel(MODEL)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModelScale(4)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	self:Activate()

end

function ENT:SetupDataTables()

	self:NetworkVar("Int", 0, "Team")

end

--[[---------------------------------------------------------
	Name: entity:GetTeamColor()
	Desc: Gets the color of the entity's team
-----------------------------------------------------------]]
function ENT:GetTeamColor()
	return team.GetColor(self:GetTeam())
end

--[[---------------------------------------------------------
	Name: entity:Draw()
	Desc: Draws the entity on the screen
-----------------------------------------------------------]]
function ENT:Draw()
	self:DrawModel()
end
