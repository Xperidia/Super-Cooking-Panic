--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

GM.MusicsChans = GM.MusicsChans or {}

local musics_location = "sound/supercookingpanic/music/"
local switch_time = 30 --TODO: remove if system change

--[[---------------------------------------------------------
	Name: gamemode:SetupMusics()
	Desc: Automatically setup musics
-----------------------------------------------------------]]
function GM:SetupMusics()

	if #self.MusicsChans > 0 then

		self:DebugLog("Some music channels are already registered. Cleaning up...")

		self:StopMusics()

		table.Empty(self.MusicsChans)

		self:DebugLog("Music channels cleared!")

	end

	self:Log("Setting up music channels...")

	local musics = file.Find(musics_location .. "*", "GAME")

	for _, v in pairs(musics) do

		self:SetupMusic(musics_location .. v)

	end

end

--[[---------------------------------------------------------
	Name: gamemode:SetupMusic(string path)
	Desc: Set up a new music
-----------------------------------------------------------]]
function GM:SetupMusic(src)

	sound.PlayFile(src, "noplay noblock", function(chan, errorID, errorNames)

		if IsValid(chan) then

			table.insert(self.MusicsChans, chan)

			chan:EnableLooping(true)
			chan:SetVolume(0)

			self:DebugLog("Music channel ready for \"" .. src .. "\"")

		elseif errorID or errorName then

			self:ErrorLog("Error while setting up music \"" .. src .. "\": " .. errorName .. " (" .. errorID .. ")")

		else

			self:ErrorLog("Unknown music state for \"" .. src .. "\"")

		end

	end)

end

--[[---------------------------------------------------------
	Name: gamemode:IsPlayingMusics()
	Desc: Return true is all music channels are playing
-----------------------------------------------------------]]
function GM:IsPlayingMusics()

	local res

	for _, v in pairs(self.MusicsChans) do

		res = v:GetState() == GMOD_CHANNEL_PLAYING

		if not res then
			return res
		end

	end

	return res

end

--[[---------------------------------------------------------
	Name: gamemode:StartMusics()
	Desc: Plays all music channels
-----------------------------------------------------------]]
function GM:StartMusics()

	for _, v in pairs(self.MusicsChans) do

		v:Play()

	end

end

--[[---------------------------------------------------------
	Name: gamemode:StopMusics()
	Desc: Stops all music channels
-----------------------------------------------------------]]
function GM:StopMusics()

	for _, v in pairs(self.MusicsChans) do

		v:Stop()

	end

end

--[[---------------------------------------------------------
	Name: gamemode:MusicThink()
	Desc: Music channel logic
-----------------------------------------------------------]]
function GM:MusicThink()

	if #self.MusicsChans == 0 then return end

	local rndstate = self:GetRoundState()

	if not self:IsPlayingMusics() and rndstate > RND_WAITING then
		self:StartMusics()
	end

	if rndstate < RND_PLAYING or rndstate >= RND_VOTEMAP then
		return
	end

	if not self.CurMusChan or not self.DeltaMusChan then
		self.CurMusChan = 1
		self.DeltaMusChan = SysTime()
	end

	local t = SysTime() - self.DeltaMusChan

	--TODO: maybe replace this system with an event based one ⬇

	if t > switch_time then

		local n = self.CurMusChan + 1

		if self.MusicsChans[n] then
			self.CurMusChan = n
		else
			self.CurMusChan = 1
		end

		self.DeltaMusChan = SysTime()

	end

	local user_vol = math.Round(self:ConVarGetFloat("music_volume") or 0.6, 6)
	local base_vol = math.Round(Lerp(t, 0, 1), 6)
	local vol = base_vol * user_vol
	local ivol = (-base_vol * 1 + 1) * user_vol
	local cur_vol = math.Round(self.MusicsChans[self.CurMusChan]:GetVolume(), 6)

	if cur_vol == vol then return end

	for k, v in pairs(self.MusicsChans) do

		if k == self.CurMusChan then

			v:SetVolume(vol)

		elseif v:GetVolume() >= ivol then

			v:SetVolume(ivol)

		end

	end

end
