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
	["+attack"] = "MOUSE1",
	["+attack2"] = "MOUSE2",
}

function GM:CheckBind(cmd)

	local bind = input.LookupBinding(cmd, true)

	if bind_check[cmd] then

		bind = bind_check[cmd]

	end

	if bind_text[bind] then

		return language.GetPhrase(bind_text[bind])

	end

	if bind then

		return string.upper(bind)

	end

	return "N/A"

end
