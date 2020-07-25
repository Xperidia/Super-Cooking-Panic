--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

include("sh_teams.lua")

AddCSLuaFile("cl_teams.lua")

-- Constants
local min_number_of_players = 1 -- Required on each team
local score_to_win = 10
local combo_time_length = 10 -- Seconds
--

--[[---------------------------------------------------------
	Name: gamemode:SetScoreMultiplier( number id )
	Desc: Sets the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:SetScoreMultiplier(id, val)

	if self:IsValidPlayingTeam(id) and val > 0 then

		SetGlobalInt("scookp_team_" .. id .. "_score_multiplier", val)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:IncrementScoreMultiplier( number id )
	Desc: Increments the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:IncrementScoreMultiplier(id)

	self:SetScoreMultiplier(id, self:GetScoreMultiplier(id) + 1)

end

--[[---------------------------------------------------------
	Name: gamemode:ResetScoreMultiplier( number id )
	Desc: Resets the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:ResetScoreMultiplier(id)

	self:SetScoreMultiplier(id, 1)

end

--[[---------------------------------------------------------
	Name: gamemode:ResetScoresMultiplier()
	Desc: Resets teams score multiplier back to zero
-----------------------------------------------------------]]
function GM:ResetScoreMultipliers()

	for k, _ in pairs(self.team_list) do
		self:ResetScoreMultiplier(k)
	end

end

--[[---------------------------------------------------------
	Name: gamemode:GetScoreMultiplier( number id )
	Desc: Gets the score multiplier of the given team id
-----------------------------------------------------------]]
function GM:GetScoreMultiplier(id)

	return GetGlobalInt("scookp_team_" .. id .. "_score_multiplier", 1)

end

--[[---------------------------------------------------------
	Name: gamemode:StartComboTimer( number id )
	Desc: Creates a new combo timer / Stores the value of its endtime
-----------------------------------------------------------]]
function GM:StartComboTimer(id)

	if self:IsValidPlayingTeam(id) then

		SetGlobalFloat("scookp_team_" .. id .. "_combo_timer", CurTime() + combo_time_length)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:GetComboTimer( number id )
	Desc: Called to know the endtime value of the team combo
-----------------------------------------------------------]]
function GM:GetComboTimer(id)

	return GetGlobalFloat("scookp_team_" .. id .. "_combo_timer", 0)

end

--[[---------------------------------------------------------
	Name: gamemode:IsComboTimerOver( number id )
	Desc: Checks if the team combo timer is over
-----------------------------------------------------------]]
function GM:IsComboTimerOver(id)

	return self:GetComboTimer(id) < CurTime()

end

--[[---------------------------------------------------------
	Name: gamemode:EndCombo( number id )
	Desc: Ends a team combo
-----------------------------------------------------------]]
function GM:EndCombo(id)

	if self:IsValidPlayingTeam(id) then

		SetGlobalFloat("scookp_team_" .. id .. "_combo_timer", 0)
		self:ResetScoreMultiplier(id)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:CheckToEndCombos()
	Desc: Checks necessary conditions to end teams combo
-----------------------------------------------------------]]
function GM:CheckToEndCombos()

	for k, _ in pairs(self.team_list) do

		if self:IsComboTimerOver(k) then
			self:EndCombo(k)
		end

	end

end

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

	local all_teams = self:GetPlayingTeams()

	for i, _ in pairs(all_teams) do

			local players_on_team = team.GetPlayers(i)

			if #players_on_team < min_number_of_players then
				return false
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
function GM:GetScoreToWin()
	return score_to_win
end

--[[---------------------------------------------------------
	Name: gamemode:ResetScores()
	Desc: Resets teams score back to zero
-----------------------------------------------------------]]
function GM:ResetScores()

	for k, _ in pairs(self.team_list) do
		team.SetScore(k, 0)
	end

end

--[[---------------------------------------------------------
	Name: gamemode.CheckTeamsScoreToWin()
	Desc: Checks if one of the teams has the required score to win
-----------------------------------------------------------]]
function GM:CheckTeamsScoreToWin()

	local all_teams = self:GetPlayingTeams()

	for i, _ in pairs(all_teams) do

		if team.GetScore(i) >= score_to_win then
			return true
		end

	end

	return false

end

--[[---------------------------------------------------------
	Name: gamemode:OnPlayerChangedTeam( ply, oldteam, newteam )
-----------------------------------------------------------]]
function GM:OnPlayerChangedTeam(ply, oldteam, newteam)

	ply.oldteam = oldteam

	self.BaseClass.OnPlayerChangedTeam(self, ply, oldteam, newteam)

end

--[[---------------------------------------------------------
	Name: gamemode.AutoTeam(Player)
	Desc: Try to make a player join the team with the least players
-----------------------------------------------------------]]
function GM:AutoTeam(ply)

	local select = team.BestAutoJoinTeam()

	if select then

		self:PlayerRequestTeam(ply, select)

		self:DebugLog(string.format("We choosed %s for %s", name, ply:GetName()))

	else

		self:Log(string.format("Couldn't find a team for %s", ply:GetName()))

	end

end

--[[---------------------------------------------------------
	Name: gamemode:TeamThink()
	Desc: Called every frame to handle teams logic
-----------------------------------------------------------]]
function GM:TeamThink()

	if self:GetRoundState() > RND_WAITING then
		self:CheckToEndCombos()
	end

end

concommand.Add("autoteam", function(ply)
	GAMEMODE:AutoTeam(ply)
end)
