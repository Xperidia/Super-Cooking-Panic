--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Constants
local min_number_of_players = 1 -- Required on each team
--

--[[---------------------------------------------------------
	Name: gamemode.SetMinNumberOfPlayersPerTeam( number )
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
