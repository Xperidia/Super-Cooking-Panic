--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local function binds()
	return {
		{GAMEMODE:CheckBind("gm_showhelp"), "Open Help", "#scookp_menu_bind_gm_showhelp"},
		{GAMEMODE:CheckBind("gm_showteam"), "Open Team Menu", "#scookp_menu_change_team"},
		{GAMEMODE:CheckBind("+attack"), language.GetPhrase("#Valve_Primary_Attack"), "#scookp_menu_bind_grab"},
		{GAMEMODE:CheckBind("+attack2"), language.GetPhrase("#Valve_Secondary_Attack"), "#scookp_menu_bind_power_up"},
		{GAMEMODE:CheckBind("+reload"), language.GetPhrase("#Valve_Reload_Weapon"), "#scookp_menu_bind_drop"},
		{GAMEMODE:CheckBind("gmod_undo"), "Undo", "#scookp_menu_bind_drop_power_up"},
		{GAMEMODE:CheckBind("+use"), language.GetPhrase("#Valve_Use_Items")},
		{GAMEMODE:CheckBind("+forward"), language.GetPhrase("#Valve_Move_Forward")},
		{GAMEMODE:CheckBind("+moveleft"), language.GetPhrase("#Valve_Move_Left")},
		{GAMEMODE:CheckBind("+moveright"), language.GetPhrase("#Valve_Move_Right")},
		{GAMEMODE:CheckBind("+back"), language.GetPhrase("#Valve_Move_Back")},
		{GAMEMODE:CheckBind("+speed"), language.GetPhrase("#Valve_Sprint")},
		{GAMEMODE:CheckBind("+jump"), language.GetPhrase("#Valve_Jump")},
		{GAMEMODE:CheckBind("+duck"), language.GetPhrase("#Valve_Duck")},
	}
end

local function do_tab(name, icon, parent, noscroll)

	local DPanel = vgui.Create("DPanel", parent)
	parent:AddSheet(name, DPanel, icon)

	if noscroll then

		return DPanel

	end

	local DScrollPanel = vgui.Create("DScrollPanel", DPanel)
	DScrollPanel:Dock(FILL)

	return DScrollPanel

end

local function do_text(str, parent)

	local DLabel = vgui.Create("DLabel", parent)
	DLabel:Dock(TOP)
	DLabel:SetText(str)
	DLabel:SetDark(1)

	return DLabel

end

local function do_rich_text(parent)

	local richtext = vgui.Create("RichText", parent)
	richtext:Dock(FILL)

	return richtext

end

local function do_a_checkbox(str, cvar, parent)

	local checkbox = vgui.Create("DCheckBoxLabel", parent)
	checkbox:SetText(str)
	checkbox:Dock(TOP)
	checkbox:DockMargin(10, 10, 10, 10)
	checkbox:DockPadding(10, 10, 10, 10)
	checkbox:SetDark(1)
	checkbox:SetConVar(cvar)
	checkbox:SetValue(GetConVar(cvar):GetBool())
	checkbox:SizeToContents()

	return checkbox

end

local function do_a_bunch_of_checkboxes(table, parent)
	for _, v in pairs(table) do
		do_a_checkbox(language.GetPhrase(v), v, parent)
	end
end

local cl_cvars = {
	"scookp_cl_hide_tips",
}

local function btnMaximDoClick(btn)
	local frame = btn:GetParent()
	if frame.maxim then
		frame:SetPos(frame.lastpos_x, frame.lastpos_y)
		frame:SetSize(frame.lastsize_w, frame.lastsize_h)
		frame:SetKeyboardInputEnabled(false)
		frame:SetSizable(true)
		frame:SetDraggable(true)
		frame.maxim = false
	else
		frame.lastpos_x, frame.lastpos_y = frame:GetPos()
		frame.lastsize_w, frame.lastsize_h = frame:GetSize()
		frame:SetPos(0, 0)
		frame:SetSize(ScrW(), ScrH())
		frame:SetKeyboardInputEnabled(true)
		frame:SetSizable(false)
		frame:SetDraggable(false)
		frame.maxim = true
	end
end

local function make_team_btn(parent)

	parent.teamBtn = vgui.Create("DButton", parent)
	parent.teamBtn:SetText("#scookp_menu_change_team")
	parent.teamBtn:Dock(BOTTOM)
	parent.teamBtn.DoClick = function(btn)
		RunConsoleCommand("gm_showteam")
		parent:GoHide()
	end

end

concommand.Add("scookp_cl_menu", function()
	GAMEMODE:Menu()
end, nil, "Open the gamemode's menu")

function GM:Menu()

	if engine.IsPlayingDemo() then
		return
	end

	if IsValid(self.MainMenuFrame) then
		self.MainMenuFrame:ToggleVisible()
		return
	end

	self.MainMenuFrame = vgui.Create("DFrame")

	local frame = self.MainMenuFrame

	local s_x, s_y = 640, 400
	frame:SetSize(s_x, s_y)
	frame:SetPos(ScrW() / 2 - (s_x / 2), ScrH() / 2 - (s_y / 2))

	frame:SetTitle(self.Name .. " menu")

	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:SetScreenLock(true)

	frame:SetSizable(true)
	frame:SetMinWidth(400)
	frame:SetMinHeight(200)

	frame:ShowCloseButton(true)

	frame.GoHide = function(smf)

		if LocalPlayer():Team() == TEAM_UNASSIGNED then

			RunConsoleCommand("autoteam")

			if IsValid(smf.joinBtn) then

				smf.joinBtn:Remove()
				make_team_btn(smf)

			end

		end

		smf:ToggleVisible()

	end

	frame.btnMaxim:SetDisabled(false)
	frame.btnMaxim.DoClick = function(btn) btnMaximDoClick(btn) end

	frame.btnMinim:SetDisabled(false)
	frame.btnMinim.DoClick = function(btn) frame:GoHide() end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	frame.sheet = vgui.Create("DPropertySheet", frame)
	local menu = frame.sheet
	menu:Dock(FILL)

	local welcome = do_tab("#scookp_menu_tab_welcome", "icon16/house.png", menu, true)

	local welcome_txt = do_rich_text(welcome)

	welcome_txt:InsertColorChange(16, 16, 16, 255)
	welcome_txt:AppendText(self:GetPhrase("#scookp_menu_intro"))

	local team = LocalPlayer():Team()

	if team == TEAM_UNASSIGNED or team == TEAM_CONNECTING then

		frame.joinBtn = vgui.Create("DButton", frame)
		frame.joinBtn:SetText("#scookp_menu_join_game")
		frame.joinBtn:Dock(BOTTOM)
		frame.joinBtn.DoClick = function(btn) frame:GoHide() end

	else

		make_team_btn(frame)

	end


	local guide = do_tab("#scookp_menu_tab_guide", "icon16/book.png", menu)

	do_text("WIP", guide)


	self:MenuControls(menu)


	self:MenuOptions(menu)


	local credits = do_tab("#scookp_menu_tab_credits", "icon16/group.png", menu)

	do_text("WIP", credits)

end

function GM:MenuControls(menu)

	local controls = do_tab("#scookp_menu_tab_controls", "icon16/keyboard.png", menu, true)

	local list = vgui.Create("DListView", controls)
	list:Dock(FILL)
	list:SetMultiSelect(false)
	local key = list:AddColumn("#scookp_menu_controls_key")
	key:SetMinWidth(40)
	key:SetMinWidth(60)
	local action = list:AddColumn("#scookp_menu_controls_bind_name")
	action:SetMinWidth(100)
	local bindname = list:AddColumn("#scookp_menu_controls_gamemode_action")
	bindname:SetMinWidth(100)

	for _, v in pairs(binds()) do
		list:AddLine(v[1], v[2], v[3] or v[2])
	end

end

function GM:MenuOptions(menu)

	local DScrollPanel = do_tab("#options", "icon16/cog.png", menu)

	do_a_bunch_of_checkboxes(cl_cvars, DScrollPanel)

	local vollbl = vgui.Create("DLabel", DScrollPanel)
	vollbl:SetText("#scookp_menu_options_music_volume")
	vollbl:Dock(TOP)
	vollbl:DockMargin(10, 10, 10, 0)
	vollbl:DockPadding(10, 10, 10, 0)
	vollbl:SetDark(1)
	vollbl:SizeToContents()

	local vol = GetConVar("scookp_cl_music_volume")
	local musivol = vgui.Create("Slider", DScrollPanel)
	musivol:Dock(TOP)
	musivol:DockMargin(0, 0, 0, 10)
	musivol:DockPadding(0, 0, 0, 10)
	musivol:SetValue(vol:GetFloat())
	musivol.OnValueChanged = function(panel, value)
		vol:SetFloat(value)
	end

end
