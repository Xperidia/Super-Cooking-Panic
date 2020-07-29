--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

-- Function to log important stuff
function GM:Log(str)
	Msg("[" .. self.Name .. "] " .. (str or "This was a log message, but something went wrong") .. "\n")
	self:LogFile("\t[LOG]\t" .. str)
end

-- Function to log errors
function GM:ErrorLog(str)
	ErrorNoHalt("[" .. self.Name .. "] " .. (str or "This was an error message, but something went wrong") .. "\n")
	self:LogFile("\t[ERROR]\t" .. str)
end

-- Debug log that would be only show in dev mode
function GM:DebugLog(str)
	if not self:ConVarGetBool("dev_mode") then
		return
	end
	Msg("[" .. self.Name .. "] " .. (str or "This was a debug message, but something went wrong") .. "\n")
	self:LogFile("\t[DEBUG]\t" .. str)
end

function GM:LogFile(str)
	if not self:ConVarGetBool("log_file") then
		return
	end
	file.Append(GAMEMODE_NAME .. "/" .. Either(SERVER, "sv_", "cl_") .. "log.txt", SysTime() .. str .. "\n")
end

function GM:FormatTime(t)
	if t < 0 then
		return "00:00"
	end
	t = string.FormattedTime(t)
	if t.h >= 999 then
		return "∞"
	elseif t.h >= 1 then
		return string.format("%02i:%02i", t.h, t.m)
	elseif t.m >= 1 then
		return string.format("%02i:%02i", t.m, t.s)
	else
		return string.format("%02i.%02i", t.s, math.Clamp(t.ms, 0, 99))
	end
end

function GM:FormatTimeTri(t)
	if t.h > 0 then
		return string.format("%02i:%02i:%02i", t.h, t.m, t.s)
	end
	return string.format("%02i:%02i", t.m, t.s)
end

-- This should probably only be called clientside.
function GM:FormatLangPhrase(phrase, ...)

	local args = {...}

	for k, v in pairs(args) do

		if isstring(v) then

			args[k] = self:GetPhrase(v)

		end

	end

	return string.format(self:GetPhrase(phrase), unpack(args))

end

function GM:GetPhrase(str)

	if not isstring(str) or #str < 1 or str[1] ~= "$" then
		return str
	end

	str = string.Right(str, #str - 1)

	--[[	This library/function does not seems exist on SERVER
					so here is this check if it ever does			]]
	if not language or not language.GetPhrase then
		return str
	end

	return language.GetPhrase(str)

end

--[[---------------------------------------------------------
	Name: gamemode:RainbowColor(float speed, min_val, max_val)
	Desc: Returns a cyclic color
-----------------------------------------------------------]]
function GM:RainbowColor(speed, min_val, max_val)

	local time = CurTime() * (speed or 1)

	local r = 0.5 * (math.sin(time - 2) + 1)
	local g = 0.5 * (math.sin(time) + 1)
	local b = 0.5 * (math.sin(time + 2) + 1)
	r = math.Remap(r, 0, 1, min_val or 0, max_val or 255)
	g = math.Remap(g, 0, 1, min_val or 0, max_val or 255)
	b = math.Remap(b, 0, 1, min_val or 0, max_val or 255)

	return Color(r, g, b)

end
