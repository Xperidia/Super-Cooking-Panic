--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

-- Function to log important stuff
function GM:Log(str)
	Msg("[Super Cooking Panic] " .. (str or "This was a log message, but something went wrong") .. "\n")
	if dev_mode then
		self:LogToFile(" [LOG] " .. str)
	end
end

-- Function to log errors
function GM:ErrorLog(str)
	ErrorNoHalt("[Super Cooking Panic] " .. (str or "This was an error message, but something went wrong") .. "\n")
	if dev_mode then
		self:LogToFile(" [ERROR] " .. str)
	end
end

-- Debug log that would be only show in dev mode
function GM:DebugLog(str)
	if dev_mode then
		Msg("[Super Cooking Panic] " .. (str or "This was a debug message, but something went wrong") .. "\n")
		self:LogToFile("\t[DEBUG]\t" .. str)
	end
end

function GM:LogToFile(str)
	file.Append("supercookingpanic/log.txt", SysTime() .. str .. "\n")
end

function GM:FormatTime(t)
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

	--[[	This library/function does not seems exist on SERVER
					so here is this check if it ever does			]]
	if not language or not language.GetPhrase then
		return str
	end

	return language.GetPhrase(str)

end
