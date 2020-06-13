--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

GM.cvars = GM.cvars or {}

local replicated_server_cvars = {
	dev_mode = {0, FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, "Enable dev mode and debug logs"},
	log_file = {0, FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, "Write gamemode logs to file"},
}

function GM:CreateConVars()
	for k, v in pairs(replicated_server_cvars) do
		if not self.cvars[k] then
			self.cvars[k] = CreateConVar(self.Prefix .. "_sv_" .. k, unpack(v))
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
