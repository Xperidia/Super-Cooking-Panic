--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

AddCSLuaFile()

GM.cvars = GM.cvars or {}

local shared_cvars = {
	dev_mode = {0, FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, "Enable dev mode and debug logs"},
	log_file = {0, FCVAR_NONE, "Write gamemode logs to file"},
}

local client_cvars = {
	music_volume = {0.6, FCVAR_ARCHIVE + FCVAR_CLIENTCMD_CAN_EXECUTE, "Set the music volume", 0},
	hide_tips = {0, FCVAR_ARCHIVE + FCVAR_CLIENTCMD_CAN_EXECUTE, "Hide all tips"},
}

local server_cvars = {
}

function GM:CreateConVars()

	for k, v in pairs(shared_cvars) do
		if not self.cvars[k] then
			self.cvars[k] = CreateConVar(self.Prefix .. "_" .. k, unpack(v))
		end
	end

	if CLIENT then

		for k, v in pairs(client_cvars) do
			if not self.cvars[k] then
				self.cvars[k] = CreateConVar(self.Prefix .. "_cl_" .. k, unpack(v))
			end
		end

	elseif SERVER then

		for k, v in pairs(server_cvars) do
			if not self.cvars[k] then
				self.cvars[k] = CreateConVar(self.Prefix .. "_sv_" .. k, unpack(v))
			end
		end

	end

end

function GM:ConVarGetBool(cvar_name)
	if self.cvars[cvar_name] then
		return self.cvars[cvar_name]:GetBool()
	end
	return nil
end

function GM:ConVarGetInt(cvar_name)
	if self.cvars[cvar_name] then
		return self.cvars[cvar_name]:GetInt()
	end
	return nil
end

function GM:ConVarGetFloat(cvar_name)
	if self.cvars[cvar_name] then
		return self.cvars[cvar_name]:GetFloat()
	end
	return nil
end

function GM:ConVarGetString(cvar_name)
	if self.cvars[cvar_name] then
		return self.cvars[cvar_name]:GetString()
	end
	return nil
end
