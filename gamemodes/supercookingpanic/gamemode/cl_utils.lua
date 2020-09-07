--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local bind_text = {
	MOUSE1 = "left_mouse_click",
	MOUSE2 = "right_mouse_click",
	MOUSE3 = "middle_mouse_click",
}

local bind_check = {
	["+attack"] = {
		name = "MOUSE1",
		code = MOUSE_LEFT,
	},
	["+attack2"] = {
		name = "MOUSE2",
		code = MOUSE_RIGHT,
	},
}

--[[----------------------------------------------------------------------------
	Name: GM:CheckForAltBind(cmd)
	Desc:	This function will enforce a more appropriate keybind,
			if a player has multiple weird keybinds for some reasons.
------------------------------------------------------------------------------]]
function GM:CheckForAltBind(cmd)

	local bind = bind_check[cmd]

	if not bind then return nil end
	if not bind.name then return nil end
	if not bind.code then return nil end

	if input.LookupKeyBinding(bind.code) then

		return bind_check[cmd].name

	end

	return nil

end

--[[----------------------------------------------------------------------------
	Name: GM:CheckBind(cmd)
	Desc: Returns a friendly translated bind input name from the cmd arg.
------------------------------------------------------------------------------]]
function GM:CheckBind(cmd)

	local bind = self:CheckForAltBind(cmd) or input.LookupBinding(cmd, true)

	if bind_text[bind] then

		return language.GetPhrase(bind_text[bind])

	end

	if bind then

		return string.upper(bind)

	end

	return "N/A"

end
