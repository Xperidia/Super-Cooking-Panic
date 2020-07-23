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
	SWEP.Instructions = GAMEMODE:CheckBind("+attack") .. " to release ingredients\n" .. GAMEMODE:CheckBind("+attack2") .. " to grab ingredient\n" .. GAMEMODE:CheckBind("+reload") .. " to use power up"
end

function SWEP:PrimaryAttack()

	if not SERVER then return end

	self:GetOwner():DropHeldIngredient(true)

end

function SWEP:SecondaryAttack()

	if not SERVER then return end

	local owner = self:GetOwner()

	local trace = util.TraceLine(util.GetPlayerTrace(owner))

	if not trace.Hit then return end

	if not trace.HitNonWorld then return end

	if not IsValid(trace.Entity) or trace.Entity:IsPlayer() then return end

	if trace.HitPos:Distance(trace.StartPos) < 160 then

		if IsValid(owner:GetHeldIngredient()) then

			self:GetOwner():DropHeldIngredient(true)

		end

		owner:GrabIngredient(trace.Entity)

	end


end

function SWEP:Reload()
end
