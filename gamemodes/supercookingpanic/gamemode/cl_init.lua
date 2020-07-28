--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("shared.lua")
include("cl_utils.lua")
include("cl_music.lua")
include("cl_hud.lua")
include("player/cl_player.lua")
include("teams/cl_teams.lua")
include("rounds/cl_rounds.lua")
include("entities/cl_entities.lua")
include("powerups/cl_powerups.lua")
include("cl_render.lua")
include("cl_targetid.lua")
include("cl_pickteam.lua")

function GM:Initialize()

	self:SharedInitialize()

	self:SetupMusics()

end

--[[---------------------------------------------------------
	Name: gamemode:Think()
	Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think()
end

local entity_looked_at = nil

--[[---------------------------------------------------------
	Name: gamemode:EntityLookedAt( )
	Desc: Refers the current entity looked by the player
-----------------------------------------------------------]]
function GM:EntityLookedAt()
	return entity_looked_at
end

--[[---------------------------------------------------------
	Name: gamemode:SetLookedAtEntity( )
	Desc: Sets the looked at entity
-----------------------------------------------------------]]
function GM:SetLookedAtEntity()

	if not self._c_loaded then
		return
	end

	local tr = util.GetPlayerTrace(LocalPlayer())
	local trace = util.TraceLine(tr)

	if not trace.Hit or not trace.HitNonWorld then
		entity_looked_at = nil
	end

	if trace.HitPos:Distance(trace.StartPos) < self.ConvDistance then

		entity_looked_at = trace.Entity

	end

end

--[[---------------------------------------------------------
	Name: gamemode:Tick()
	Desc: Like Think except called every tick on both client and server
-----------------------------------------------------------]]
function GM:Tick()

	self:SetLookedAtEntity()

	self:MusicThink()

end

--[[---------------------------------------------------------
	Name: gamemode:GetTeamColor( ent )
	Desc: Return the color for this ent's team
		This is for chat and deathnotice text
-----------------------------------------------------------]]
function GM:GetTeamColor(ent)

	if ent:IsBonusIngredient() then

		local time = CurTime() * 6
		local r = 0.5 * (math.sin(time - 1) + 1)
		local g = 0.5 * (math.sin(time) + 1)
		local b = 0.5 * (math.sin(time + 1) + 1)

		return Color(r * 255, g * 255, b * 255)

	end

	return self.BaseClass.GetTeamColor(self, ent)

end
