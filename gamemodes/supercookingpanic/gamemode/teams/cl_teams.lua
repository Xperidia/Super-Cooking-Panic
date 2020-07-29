--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_teams.lua")

--[[---------------------------------------------------------
	Name: gamemode:GetScoreMultiplier( number id )
	Desc: Gets the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:GetScoreMultiplier(id)

	return GetGlobalInt("scookp_team_" .. id .. "_score_multiplier", 1)

end

--[[---------------------------------------------------------
	Name: gamemode:GetComboTimer( number id )
	Desc: Called to know the endtime value of the team combo
-----------------------------------------------------------]]
function GM:GetComboTimer(id)

	return GetGlobalFloat("scookp_team_" .. id .. "_combo_timer", 0)

end

--[[---------------------------------------------------------
	Name: gamemode:GetComboTime( number id )
	Desc: Called to know the remaining time of the team combo
-----------------------------------------------------------]]
function GM:GetComboTime(id)

	return self:GetComboTimer(id) - CurTime()

end
