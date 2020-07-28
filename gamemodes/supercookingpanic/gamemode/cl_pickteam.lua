--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Name: gamemode:ShowTeam()
	Desc: The team selection menu
-----------------------------------------------------------]]
function GM:ShowTeam()

	if IsValid(self.TeamSelectFrame) then return end

	-- Simple team selection box
	self.TeamSelectFrame = vgui.Create("DFrame")
	self.TeamSelectFrame:SetTitle("Pick Team")

	local AllTeams = team.GetAllTeams()
	local y = 30
	local ply = LocalPlayer()
	for ID, TeamInfo in pairs(AllTeams) do

		if ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED and ID ~= TEAM_INGREDIENT then

			local Team = vgui.Create("DButton", self.TeamSelectFrame)
			function Team.DoClick()
				self:HideTeam()
				RunConsoleCommand("changeteam", ID)
			end
			Team:SetPos(10, y)
			Team:SetSize(130, 20)
			Team:SetText(TeamInfo.Name)
			Team:SetDisabled(not TeamInfo.Joinable)

			if IsValid(ply) and ply:Team() == ID then
				Team:SetDisabled(true)
			end

			y = y + 30

		end

	end

	if GAMEMODE.AllowAutoTeam then

		local Team = vgui.Create("DButton", self.TeamSelectFrame)
		function Team.DoClick()
			self:HideTeam()
			RunConsoleCommand("autoteam")
		end
		Team:SetPos(10, y)
		Team:SetSize(130, 20)
		Team:SetText("Auto")
		y = y + 30

	end

	self.TeamSelectFrame:SetSize(150, y)
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetKeyboardInputEnabled(false)

end
