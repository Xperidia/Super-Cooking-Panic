--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

SWEP.Base = "weapon_fists"
SWEP.PrintName = "#scookp_arms"
SWEP.Author = "Xperidia"
SWEP.Purpose = "Get ingredients"
SWEP.Spawnable = false
SWEP.BounceWeaponIcon = false
SWEP.DisableDuplicator = true
SWEP.m_bPlayPickupSound = false

SWEP.Primary.Automatic = false

SWEP.Secondary.Automatic = false

if CLIENT then
	SWEP.PrintName = language.GetPhrase("scookp_arms")
	SWEP.Instructions = GAMEMODE:CheckBind("+attack") .. " to grab ingredients\n" .. GAMEMODE:CheckBind("+attack2") .. " to use power-up\n" .. GAMEMODE:CheckBind("+reload") .. " to drop ingredient"
end

function SWEP:PrimaryAttack()

	self:GrabIngredient()

end

function SWEP:SecondaryAttack()

	local owner = self:GetOwner()

	owner:LagCompensation(true)

	if SERVER then

		owner:UsePowerUP()

	end

	owner:LagCompensation(false)

end

function SWEP:Reload()

	if not SERVER then return end

	self:DropIngredient()

end

function SWEP:GrabIngredient()

	local owner = self:GetOwner()

	owner:LagCompensation(true)

	local trace = GAMEMODE:GetConvPlayerTrace(owner)

	if trace.Hit and trace.HitNonWorld and IsValid(trace.Entity) and not trace.Entity:IsPlayer() then

		if IsValid(owner:GetHeldIngredient())
		and trace.Entity:GetClass() == "scookp_cooking_pot" and SERVER then

			trace.Entity:AbsorbEnt(owner:DropHeldIngredient())

			self:DropIngredientAnim(owner)

		elseif trace.Entity:IsIngredient() and not owner:IsHoldingIngredient() and SERVER then

			owner:GrabIngredient(trace.Entity)

		end

	end

	owner:LagCompensation(false)

end

if SERVER then

	function SWEP:DropIngredient()

		local owner = self:GetOwner()

		local usecooldown = owner.usecooldown or 0

		if CurTime() <= usecooldown then return end

		owner:DropHeldIngredient(true)

		self:DropIngredientAnim(owner)

	end

	function SWEP:DropIngredientAnim(owner)

		net.Start("VManip_SimplePlay")
			net.WriteString("use")
		net.Send(owner)
		owner.usecooldown = CurTime() + 1

	end

end
