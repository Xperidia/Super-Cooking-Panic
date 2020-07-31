--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("shared.lua")
include("cl_utils.lua")
include("cl_music.lua")
include("cl_scale.lua")
include("cl_fonts.lua")
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

	killicon.Add("scookp_arms", "supercookingpanic/powerup/cannibalism", color_white)
	killicon.Add("scookp_trap", "supercookingpanic/powerup/fake", color_white)

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

	local trace = self:GetConvPlayerTrace(LocalPlayer())

	if not trace.Hit or not trace.HitNonWorld then

		entity_looked_at = nil

	end

	if trace.HitPos:Distance(trace.StartPos) < self.ConvDistance then

		entity_looked_at = trace.Entity

	else

		entity_looked_at = nil

	end

end

--[[---------------------------------------------------------
	Name: gamemode:Tick()
	Desc: Like Think except called every tick on both client and server
-----------------------------------------------------------]]
function GM:Tick()

	self:SetLookedAtEntity()

	self:MusicThink()

	self:SoundThink()

end

local end_remind_sound = Sound("supercookingpanic/effects/time_running_up.wav")
local end_sound = Sound("supercookingpanic/effects/time_up.wav")
--[[---------------------------------------------------------
	Name: gamemode:SoundThink()
	Desc: Check to play special sounds
-----------------------------------------------------------]]
function GM:SoundThink()

	local state = self:GetRoundState()

	--[[if state == RND_PLAYING and not self._played_playing_sound then

		surface.PlaySound(start_sound)

		self._played_playing_sound = true

	elseif state ~= RND_PLAYING and self._played_playing_sound then

		self._played_playing_sound = nil

	end]]

	if state == RND_PLAYING and self:GetRoundTime() < 30 and not self._played_remind_sound then

		surface.PlaySound(end_remind_sound)

		self._played_remind_sound = true

	elseif state ~= RND_PLAYING and self._played_remind_sound then

		self._played_remind_sound = nil

	end

	if state == RND_ENDING and not self._played_end_sound then

		surface.PlaySound(end_sound)

		self._played_end_sound = true

	elseif state ~= RND_ENDING and self._played_end_sound then

		self._played_end_sound = nil


	end

end

--[[---------------------------------------------------------
	Name: gamemode:GetTeamColor( ent )
	Desc: Return the color for this ent's team
		This is for chat and deathnotice text
-----------------------------------------------------------]]
function GM:GetTeamColor(ent)

	if ent:IsBonusIngredient() then

		return self:RainbowColor(6, 128)

	end

	return self.BaseClass.GetTeamColor(self, ent)

end
