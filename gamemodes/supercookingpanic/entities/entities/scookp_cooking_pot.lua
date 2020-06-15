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

	if SERVER then

		self:SetModel(MODEL)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetTrigger(true) -- Generates signal on touch
		self:SetModelScale(4)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
		end

		self:Activate()

	end

	if CLIENT then

		self:SetLOD(0)

	end

end

--[[---------------------------------------------------------
	Name: entity:SetupDataTables()
	Desc: Declares shared entity variables
-----------------------------------------------------------]]
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
	Name: entity:StartTouch( entity ent )
	Desc: Detects when an ingredient is brought to the cooking pot
-----------------------------------------------------------]]
function ENT:StartTouch(ent)

	if ent:IsIngredient() and not ent:IsPlayer() then
		team.AddScore(self:GetTeam(), ent:GetPoints())
		ent:Remove() --TODO: maybe do some anim
	end

end

--[[---------------------------------------------------------
	Name: entity:Draw()
	Desc: Draws the entity on the screen
-----------------------------------------------------------]]
function ENT:Draw()

	self:DrawModel()

end
