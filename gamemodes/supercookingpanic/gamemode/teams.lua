--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Constants
local min_number_of_players = 1 -- Required on each team
local score_to_win = 10
--

--[[---------------------------------------------------------
	Name: gamemode.SetMinNumberOfPlayersPerTeam()
	Desc: Sets the minimum value of players on a team to start a round
-----------------------------------------------------------]]
function GM:SetMinNumberOfPlayersPerTeam(val)
	if val > 1 then
		min_number_of_players = val
	end
end

--[[---------------------------------------------------------
	Name: gamemode.GetMinNumberOfPlayersPerTeam()
	Desc: Gets the minimum value of players on a team to start a round
-----------------------------------------------------------]]
function GM:GetMinNumberOfPLayersPerTeam()
	return min_number_of_players
end

--[[---------------------------------------------------------
	Name: gamemode.AreTeamsPopulated()
	Desc: Checks if all the teams have the required number of players
			to start a round
-----------------------------------------------------------]]
function GM:AreTeamsPopulated()

	local all_teams = team.GetAllTeams()

	for i, _ in pairs(all_teams) do

		-- This is the range of all the custom teams
		if i > 0 and i < 1001 then

			local players_on_team = team.GetPlayers(i)

			if #players_on_team < min_number_of_players then
				return false
			end

		end

	end

	return true

end

--[[---------------------------------------------------------
	Name: gamemode.SetScoreToWin()
	Desc: Sets the winning condition score
-----------------------------------------------------------]]
function GM:SetScoreToWin(val)
	if val > 0 then
		score_to_win = val
	end
end

--[[---------------------------------------------------------
	Name: gamemode.GetScoreToWin()
	Desc: Checks the win condition score
-----------------------------------------------------------]]
function GM:GetScoreToWin(val)
	return score_to_win
end

--[[---------------------------------------------------------
	Name: gamemode.CheckTeamsScoreToWin()
	Desc: Checks if one of the teams has the required score to win
-----------------------------------------------------------]]
function GM:CheckTeamsScoreToWin()

	local all_teams = team.GetAllTeams()

	for i, _ in pairs(all_teams) do

		-- This is the range of all the custom teams
		if i > 0 and i < 1001 and team.GetScore(i) >= score_to_win then
			return true
		end

	end

	return false

end
