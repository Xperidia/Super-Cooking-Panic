--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

surface.CreateFont("scookp_scoreboard", {
	font		= "Verdana",
	size		= 22,
	antialias	= false,
	shadow		= true,
})

surface.CreateFont("scookp_scoreboardTitle", {
	font		= "Verdana",
	size		= 50,
	antialias	= false,
	shadow		= true,
})

-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = {
	Init = function(self)

		local font = "scookp_scoreboard"
		local color = color_white

		self.AvatarButton = self:Add("DButton")
		self.AvatarButton:Dock(LEFT)
		self.AvatarButton:SetSize(32, 32)
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create("AvatarImage", self.AvatarButton)
		self.Avatar:SetSize(32, 32)
		self.Avatar:SetMouseInputEnabled(false)

		self.FriendStatusI = vgui.Create("DImage", self)
		self.FriendStatusI:SetSize(16, 16)
		self.FriendStatusI:SetPos(28, 22)
		self.FriendStatusI:SetMouseInputEnabled(false)

		self.AdminStatusI = vgui.Create("DImage", self)
		self.AdminStatusI:SetSize(16, 16)
		self.AdminStatusI:SetPos(28, 0)
		self.AdminStatusI:SetMouseInputEnabled(false)

		self.Name = self:Add("DLabel")
		self.Name:Dock(FILL)
		self.Name:SetFont(font)
		self.Name:SetTextColor(color)
		self.Name:DockMargin(8, 0, 0, 0)

		self.Mute = self:Add("DImageButton")
		self.Mute:SetSize(32, 32)
		self.Mute:Dock(RIGHT)

		self.Ping = self:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(50)
		self.Ping:SetFont(font)
		self.Ping:SetTextColor(color)
		self.Ping:SetContentAlignment(5)

		self.Deaths = self:Add("DLabel")
		self.Deaths:Dock(RIGHT)
		self.Deaths:SetWidth(50)
		self.Deaths:SetFont(font)
		self.Deaths:SetTextColor(color)
		self.Deaths:SetContentAlignment(5)

		self:Dock(TOP)
		self:DockPadding(3, 3, 3, 3)
		self:SetHeight(32 + 3 * 2)
		self:DockMargin(2, 0, 2, 2)

	end,

	Setup = function(self, pl)

		self.Player = pl

		self.Avatar:SetPlayer(pl)

		self:Think(self)

	end,

	Think = function(self)

		if not IsValid(self.Player) then
			self:SetZPos(9999) -- Causes a rebuild
			self:Remove()
			return
		end

		if self.PName == nil or self.PName ~= self.Player:Nick() then
			self.PName = self.Player:Nick()
			self.Name:SetText(self.PName)
		end

		if self.NumDeaths == nil or self.NumDeaths ~= self.Player:Deaths() then
			self.NumDeaths = self.Player:Deaths()
			self.Deaths:SetText(self.NumDeaths)
		end

		if self.NumPing == nil or (
		self.NumPing ~= self.Player:Ping()
		and self.NumPing ~= "BOT"
		and self.NumPing ~= "HOST"
		) then
			if self.Player:IsBot() then
				self.NumPing = "BOT"
				self.Ping:SetText(self.NumPing)
			elseif self.Player:GetNWBool("IsListenServerHost", false) then
				self.NumPing = "HOST"
				self.Ping:SetText(self.NumPing)
			else
				self.NumPing = self.Player:Ping()
				self.Ping:SetText(self.NumPing)
			end
		end

		--
		-- Change the icon of the mute button based on state
		--
		if self.Muted == nil or self.Muted ~= self.Player:IsMuted() then

			self.Muted = self.Player:IsMuted()
			if self.Muted then
				self.Mute:SetImage("icon32/muted.png")
			else
				self.Mute:SetImage("icon32/unmuted.png")
			end

			self.Mute.DoClick = function() self.Player:SetMuted(not self.Muted) end
			self.Mute.OnMouseWheeled = function(s, delta)
				self.Player:SetVoiceVolumeScale(self.Player:GetVoiceVolumeScale() + (delta / 100 * 5))
				s.LastTick = CurTime()
			end

			self.Mute.PaintOver = function(s, w, h)
				if not IsValid(self.Player) then return end
				local a = 255 - math.Clamp(CurTime() - (s.LastTick or 0), 0, 3) * 255
				if a <= 0 then return end
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, a * 0.75))
				draw.SimpleText(math.ceil(self.Player:GetVoiceVolumeScale() * 100) .. "%", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

		end

		if IsValid(self.Player) and (self.FriendStatus == nil or self.FriendStatus ~= self.Player:GetFriendStatus()) then

			self.FriendStatus = self.Player:GetFriendStatus()
			if self.FriendStatus == "friend" then
				self.FriendStatusI:SetImageColor(Color(255,255,255,255))
				self.FriendStatusI:SetImage("icon16/group.png")
			elseif self.FriendStatus == "blocked" then
				self.FriendStatusI:SetImageColor(Color(255,255,255,255))
				self.FriendStatusI:SetImage("icon16/delete.png")
			elseif self.FriendStatus == "requested" then
				self.FriendStatusI:SetImageColor(Color(255,255,255,255))
				self.FriendStatusI:SetImage("icon16/group_add.png")
			else
				self.FriendStatusI:SetImageColor(Color(255,255,255,0))
			end

		end

		if IsValid(self.Player) and (self.AdminStatus == nil or self.AdminStatus ~= self.Player:IsAdmin()) then

			self.AdminStatus = self.Player:IsAdmin()
			if self.AdminStatus then
				self.AdminStatusI:SetImageColor(Color(255,255,255,255))
				self.AdminStatusI:SetImage("icon16/shield.png")
			else
				self.AdminStatusI:SetImageColor(Color(255,255,255,0))
			end

		end

		--
		-- Connecting players go at the very bottom
		--
		if self.Player:Team() == TEAM_CONNECTING then
			self:SetZPos(2000 + self.Player:EntIndex())
			return
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( self.Player:EntIndex() )

	end,

	Paint = function(self, w, h)

		if not IsValid(self.Player) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		local color = ColorAlpha(GAMEMODE:GetTeamColor(self.Player), 128)

		draw.RoundedBox( 4, 0, 0, w, h, color )

	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable(PLAYER_LINE, "DPanel")

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function(self)

		self.Header = self:Add("Panel")
		self.Header:Dock(TOP)
		self.Header:SetHeight(100)

		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont("scookp_scoreboardTitle")
		self.Name:SetTextColor( Color(255, 255, 255, 255) )
		self.Name:Dock(TOP)
		self.Name:SetHeight(50)
		self.Name:SetContentAlignment(5)
		self.Name:SetExpensiveShadow( 2, Color(0, 0, 0, 200) )

		self.Scores = self:Add("DScrollPanel")
		self.Scores:Dock(FILL)

	end,

	PerformLayout = function(self)

		self:SetSize(700, ScrH() - 200)
		self:SetPos(ScrW() / 2 - 350, 100)

	end,

	Paint = function(self, w, h)
	end,

	Think = function(self, w, h)

		self.Name:SetText(GetHostName())

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for _, pl in pairs(plyrs) do

			if IsValid(pl.ScoreEntry) then continue end

			pl.ScoreEntry = vgui.CreateFromTable(PLAYER_LINE, pl.ScoreEntry)
			pl.ScoreEntry:Setup(pl)

			self.Scores:AddItem(pl.ScoreEntry)

		end

	end
}

SCORE_BOARD = vgui.RegisterTable(SCORE_BOARD, "EditablePanel")

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if not IsValid(g_Scoreboard) then
		g_Scoreboard = vgui.CreateFromTable(SCORE_BOARD)
	end

	self.BaseClass.ScoreboardShow(self)

end
