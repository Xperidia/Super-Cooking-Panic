--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

function GM:CheckBind(cmd)
	if input.LookupBinding(cmd, true) then
		return string.upper(input.LookupBinding(cmd, true))
	end
	return "N/A"
end
