--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "#scookp_powerup"
ENT.Author = "Xperidia"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	if SERVER then

		self:SetTrigger(true)
		self:SetUseType(SIMPLE_USE)
		self:SetLePos(self:GetPos() + Vector(0, 0, 35.5))

	end

	self:SetModel("models/maxofs2d/hover_rings.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255, 128, 0, 200))
	self:SetMaterial("models/wireframe")
	self:SetPos(self:GetLePos())
	self:SetAngles(Angle(0, 0, 90))

	self.CTime = CurTime()

	if SERVER then

		if self.IsRespawn then

			self:EmitSound("scookp_power_up_spawn")

		elseif self.WasDropped then

			self:EmitSound("scookp_power_up_drop")

		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar("Vector", 0, "LePos")
	self:NetworkVar("Int", 0, "PowerUP")

	if SERVER then

		self:SetPowerUP(0)

	end

end

local unknown_sprite = Material("supercookingpanic/powerup/unknown")
function ENT:Draw()

	local sprite = unknown_sprite
	local color = color_white
	local power_up = GAMEMODE.PowerUPs[self:GetPowerUP()]

	if power_up and power_up.icon and not power_up.icon:IsError() then
		sprite = power_up.icon
	elseif power_up then
		color = GAMEMODE.ErrorColor
	end

	render.SetMaterial(sprite)

	local pos = self:GetPos() + Vector(0, 0, math.sin(CurTime() + self:EntIndex()) * 4)

	render.DrawSprite(pos, 32, 32, color)

end

function ENT:OnRemove()

	if CLIENT and IsValid(self.PU) then

		self.PU:Remove()

	end

end

function ENT:PickUP(ent)

	if IsValid(ent) and ent:IsPlayer() and ent:Alive() then

		if IsValid(self.WasDropped) and self.WasDropped == ent and self.CTime and self.CTime + 0.5 > CurTime() then return end

		local result = ent:PickPowerUP(self:GetPowerUP())

		if result or result == nil then

			ent:EmitSound("scookp_power_up_pickup")

			self:Remove()

		end

	end

end

function ENT:StartTouch(ent)
	self:PickUP(ent)
end

function ENT:Use(activator, caller)
	self:PickUP(caller)
end
