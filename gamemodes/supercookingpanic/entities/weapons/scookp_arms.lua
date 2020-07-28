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

	if not SERVER then return end

	self:GrabIngredient()

end

function SWEP:SecondaryAttack()

	if SERVER then

		self:GetOwner():UsePowerUP()

	end

end

function SWEP:Reload()

	if not SERVER then return end

	self:DropIngredient()

end

if SERVER then

	function SWEP:GrabIngredient()

		local owner = self:GetOwner()

		local trace = util.TraceLine(util.GetPlayerTrace(owner))

		if not trace.Hit then return end

		if not trace.HitNonWorld then return end

		if not IsValid(trace.Entity) or trace.Entity:IsPlayer() then return end

		if trace.HitPos:Distance(trace.StartPos) < GAMEMODE.ConvDistance then

			if IsValid(owner:GetHeldIngredient())
			and trace.Entity:GetClass() == "scookp_cooking_pot" then

				trace.Entity:AbsorbEnt(owner:DropHeldIngredient())

				self:DropIngredientAnim(owner)

			elseif not trace.Entity:IsIngredient() then

				return

			elseif IsValid(owner:GetHeldIngredient())
			and trace.Entity:GetClass() == "scookp_cooking_pot" then

				trace.Entity:AbsorbEnt(owner:DropHeldIngredient())

			elseif IsValid(owner:GetHeldIngredient()) then

				owner:DropHeldIngredient(true)

			end

			owner:GrabIngredient(trace.Entity)

			self:EmitSound("scookp_ingredient_grab")

		end

	end

	function SWEP:DropIngredient()

		local owner = self:GetOwner()

		local usecooldown = owner.usecooldown or 0

		if CurTime() <= usecooldown then return end

		owner:DropHeldIngredient(true)

		self:DropIngredientAnim(owner)

		self:EmitSound("scookp_ingredient_release")

	end

	function SWEP:DropIngredientAnim(owner)

		net.Start("VManip_SimplePlay")
			net.WriteString("use")
		net.Send(owner)
		owner.usecooldown = CurTime() + 1

	end

end
