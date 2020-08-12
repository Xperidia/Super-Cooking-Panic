--[[----------------------------------------------------------------------------
				Put back the default Garry's Mod loading screen...
------------------------------------------------------------------------------]]

local gm_ls = "https://assets.xperidia.com/garrysmod/loading.html#auto-scookp"

hook.Add("Initialize", "spb_loading_screen_cleaner", function()

	local cur_ls = GetConVar("sv_loadingurl"):GetString()

	if not GAMEMODE.IsSuperCookingPanicDerived and cur_ls == gm_ls then

		RunConsoleCommand("sv_loadingurl", "")

	end

end)
