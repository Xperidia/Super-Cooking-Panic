--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local function binds()
	return {
		{GAMEMODE:CheckBind("gm_showhelp"), "Open Help", "Gamemode menu"},
		{GAMEMODE:CheckBind("gm_showteam"), "Open Team Menu", "Change team"},
		{GAMEMODE:CheckBind("+attack"), language.GetPhrase("#Valve_Primary_Attack"), "Grab ingredient"},
		{GAMEMODE:CheckBind("+attack2"), language.GetPhrase("#Valve_Secondary_Attack"), "Use Power-UP"},
		{GAMEMODE:CheckBind("+reload"), language.GetPhrase("#Valve_Reload_Weapon"), "Drop ingredient"},
		{GAMEMODE:CheckBind("gmod_undo"), "Undo", "Drop Power-UP"},
		{GAMEMODE:CheckBind("+forward"), language.GetPhrase("#Valve_Move_Forward")},
		{GAMEMODE:CheckBind("+moveleft"), language.GetPhrase("#Valve_Move_Left")},
		{GAMEMODE:CheckBind("+moveright"), language.GetPhrase("#Valve_Move_Right")},
		{GAMEMODE:CheckBind("+back"), language.GetPhrase("#Valve_Move_Back")},
		{GAMEMODE:CheckBind("+speed"), language.GetPhrase("#Valve_Sprint")},
		{GAMEMODE:CheckBind("+jump"), language.GetPhrase("#Valve_Jump")},
		{GAMEMODE:CheckBind("+duck"), language.GetPhrase("#Valve_Duck")},
		{GAMEMODE:CheckBind("+use"), language.GetPhrase("#Valve_Use_Items")},
	}
end

local function do_tab(name, icon, parent)

	local DPanel = vgui.Create("DPanel", parent)
	parent:AddSheet(name, DPanel, icon)

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
	for k, v in pairs(table) do
		do_a_checkbox(v, k, parent)
	end
end

local cl_cvars = {
	scookp_cl_hide_tips = "Hide all tips",
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
	local s_x, s_y = 640, 480
	frame:SetSize(s_x, s_y)
	frame:SetPos(ScrW() / 2 - (s_x / 2), ScrH() / 2 - (s_y / 2))
	frame:SetTitle(self.Name .. " menu")
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:SetScreenLock(true)
	frame:SetSizable(true)
	frame:SetMinWidth(400)
	frame:SetMinHeight(200)
	frame.btnMaxim:SetDisabled(false)
	frame.btnMaxim.DoClick = function(btn) btnMaximDoClick(btn) end
	frame.btnMinim:SetDisabled(false)
	frame.btnMinim.DoClick = function(btn) frame:ToggleVisible() end
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	frame.sheet = vgui.Create("DPropertySheet", frame)
	local menu = frame.sheet
	menu:Dock(FILL)

	local welcome = do_tab("Welcome", "icon16/house.png", menu)

	do_text("", welcome)


	local guide = do_tab("Guide", "icon16/book.png", menu)

	do_text("", guide)


	self:MenuControls(menu)


	self:MenuOptions(menu)

end

function GM:MenuControls(menu)

	local controls = vgui.Create("DPanel", menu)
	menu:AddSheet("Controls", controls, "icon16/keyboard.png")

	local list = vgui.Create("DListView", controls)
	list:Dock(FILL)
	list:SetMultiSelect(false)
	local key = list:AddColumn("Key")
	key:SetMinWidth(40)
	key:SetMinWidth(60)
	local action = list:AddColumn("Options bind name")
	action:SetMinWidth(100)
	local bindname = list:AddColumn("Action in the gamemode")
	bindname:SetMinWidth(100)

	for _, v in pairs(binds()) do
		list:AddLine(v[1], v[2], v[3] or v[2])
	end

end

function GM:MenuOptions(menu)

	local DScrollPanel = do_tab("#options", "icon16/cog.png", menu)

	do_a_bunch_of_checkboxes(cl_cvars, DScrollPanel)

	local vollbl = vgui.Create("DLabel", DScrollPanel)
	vollbl:SetText("Music volume")
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
