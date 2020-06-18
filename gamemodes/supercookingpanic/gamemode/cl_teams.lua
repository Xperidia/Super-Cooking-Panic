--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:GetScoreMultiplier( number id )
	Desc: Gets the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:GetScoreMultiplier(id)

	return GetGlobalInt("scookp_team_" .. id .. "_score_multiplier", 1)

end
