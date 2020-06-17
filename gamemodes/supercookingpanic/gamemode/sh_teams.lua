--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Default teams
GM.team_list = {
	{
		name = "Blue Team",
		color = Color(52, 152, 219),
	},
	{
		name = "Orange Team",
		color = Color(230, 126, 34),
	},
}

--[[---------------------------------------------------------
	Name: gamemode:IsValidPlayingTeam( number id )
	Desc: Checks if the team is playable
-----------------------------------------------------------]]
function GM:IsValidPlayingTeam(id)
	return	id ~= TEAM_SPECTATOR
		and id ~= TEAM_UNASSIGNED
		and id ~= TEAM_CONNECTING
		and team.Joinable(id)
end

--[[---------------------------------------------------------
	Name: gamemode:RemoveTeam( number index )
	Desc: Removes a team at the given index
-----------------------------------------------------------]]
function GM:RemoveTeam(index)
	table.remove(self.team_list, index)
	table.remove(team:GetAllTeams(), index)
end

--[[---------------------------------------------------------
	Name: gamemode:AddTeam( string name , table color )
	Desc: Creates a new team and sets it up
-----------------------------------------------------------]]
function GM:AddTeam(name, color)
	table.insert(self.team_list, #self.team_list + 1, {
		name = name,
		color = color,
	})
	team.SetUp(#self.team_list, name, color)
	team.SetSpawnPoint(#self.team_list, "info_player_start")
	team.SetClass(#self.team_list, {"player_cook"})
end

--[[---------------------------------------------------------
	Name: gamemode:CreateTeams()
	Desc: Creates and sets up teams parameters
-----------------------------------------------------------]]
function GM:CreateTeams()
	for k, v in pairs(self.team_list) do
		team.SetUp(k, v.name, v.color)
		team.SetSpawnPoint(k, "info_player_start")
		team.SetClass(k, {"player_cook"})
	end
end

--[[---------------------------------------------------------
	Name: gamemode.GetPlayingTeams()
	Desc: Return playing teams table
-----------------------------------------------------------]]
function GM:GetPlayingTeams()

	local p_teams = {}

	for i, tm in pairs(team.GetAllTeams()) do

		if self:IsValidPlayingTeam(i) then
			p_teams[i] = tm
		end

	end

	return p_teams

end
