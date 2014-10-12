---------------------------------
--F1 Menu
---------------------------------
function GM:ShowHelp()
	local menu = vgui.Create("DLabel")
	menu:SetSize(ScrW()*0.25, ScrH()*0.27)
	menu:SetText("")
	menu:Center()
	menu.startTime = SysTime()
	menu.Paint = function()
		Derma_DrawBackgroundBlur(menu, menu.startTime)
	end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Help")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 0, 0, 12)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(TOP)
	button:SetDrawBackground(false)
	button.DoClick = function() RunConsoleCommand("Helpmenu") menu:Remove() end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Select Team")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 0, 0, 12)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(TOP)
	button:SetDrawBackground(false)
	button.DoClick = function() RunConsoleCommand("Teams") menu:Remove() end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Options")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 0, 0, 12)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(TOP)
	button:SetDrawBackground(false)
	button.DoClick = function() RunConsoleCommand("Options") menu:Remove() end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Credits")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 0, 0, 12)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(TOP)
	button:SetDrawBackground(false)
	button.DoClick = function() RunConsoleCommand("Credits") menu:Remove() end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Close")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 24, 0, 0)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(TOP)
	button:SetDrawBackground(false)
	button.DoClick = function() menu:Remove() end

	menu:MakePopup()
end

function helpmenu(ply)
	local menu = vgui.Create( "DFrame" )
	menu:SetSize(ScrW()*0.48, ScrH()*0.72)
	menu:Center()
	menu:SetTitle( "" )
	menu:SetVisible( true )
	menu:SetDraggable( false )
	menu:ShowCloseButton( true )
	menu:MakePopup()
	menu.Paint = function()
		Derma_DrawBackgroundBlur(menu, menu.startTime)
		draw.SimpleTextOutlined("Pirate Ship Wars 2", "psw", ScrW()*0.24, 36, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		draw.DrawText(GAMEMODE.HELP, "pswsize10", 10, 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	end
end
concommand.Add("Helpmenu",helpmenu)

function Credits(ply)
	local menu = vgui.Create( "DFrame" )
	menu:SetSize(ScrW()*0.48, ScrH()*0.72)
	menu:Center()
	menu:SetTitle( "" )
	menu:SetVisible( true )
	menu:SetDraggable( false )
	menu:ShowCloseButton( true )
	menu:MakePopup()
	menu.Paint = function()
		Derma_DrawBackgroundBlur(menu, menu.startTime)
		draw.SimpleTextOutlined("Pirate Ship Wars 2", "psw", 400, 36, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		draw.DrawText(GAMEMODE.Credits, "pswsize12", 10, 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	end
end
concommand.Add("Credits",Credits)

function teams(ply)
	local menu = vgui.Create("DLabel")
	menu:SetSize(ScrW()*0.48, ScrH()*0.72)
	menu:SetText("")
	menu:Center()
	menu.startTime = SysTime()
	menu.Paint = function()
		Derma_DrawBackgroundBlur(menu, menu.startTime)
	end

	PSWSB = vgui.Create("DImage", menu)
	PSWSB:SetImage('gui/teamselect')
	PSWSB:SizeToContents()
	PSWSB:SetSize(ScrW()*0.48, ScrH()*0.65)

	local icon = vgui.Create( "DModelPanel", menu )
	icon:SetModel( "models/player/sharpshooter/sharpshooter.mdl" )
	icon:SetSize(ScrW()*0.2149, ScrH()*0.492)
	icon:SetPos(ScrW()*0.0171, ScrH()*0.122)
	icon:SetFOV(50)
	icon:SetAnimated(true)
	icon.DoClick = function() 
		if ply:Team() == 1 then
			ply:ChatPrint( "You are already a Redcoat" )
		else
			RunConsoleCommand( "Team_1" )
			menu:Remove() 
		end
	end
	
	local icon2 = vgui.Create( "DModelPanel", menu )
	icon2:SetModel( "models/player/skirmisher/skirmisher.mdl" )
	icon2:SetSize(ScrW()*0.2149, ScrH()*0.492)
	icon2:SetPos(ScrW()*0.25, ScrH()*0.122)
	icon2:SetFOV(50)
	icon2.DoClick = function()
		if ply:Team() == 2 then
			ply:ChatPrint( "You are already a Pirate" )
		else
			RunConsoleCommand( "Team_2" )
			menu:Remove() 
		end
	end

	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Spectate")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 10, 0, 0)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(BOTTOM)
	button:SetDrawBackground(false)
	button.DoClick = function() 
		if ply:Team() == 4 then
			ply:ChatPrint( "You are already spectating" )
		else
			RunConsoleCommand( "TEAM_SPECTATOR" )
			menu:Remove() 
		end
	end
	
	local button = vgui.Create("DButton", menu)
	button:SetFont("psw")
	button:SetText("Close")
	button:SetTall(ScrW()*0.02)
	button:DockMargin(0, 10, 0, 0)
	button:DockPadding(0, 12, 0, 12)
	button:Dock(BOTTOM)
	button:SetDrawBackground(false)
	button.DoClick = function() menu:Remove() end
	
	menu:MakePopup()
end
concommand.Add("Teams",teams)

---------------------------------
--F2 Menu
---------------------------------
function set_team(ply)
--// Start of Main Frame
	local MainMenuFrame = vgui.Create( "DFrame" )
	MainMenuFrame:SetSize( 600, 600 )
	MainMenuFrame:SetTitle("Pirate Ship Wars V2")
	MainMenuFrame:Center()
	MainMenuFrame:SetVisible( true )
	MainMenuFrame:SetDraggable( false )
	MainMenuFrame:MakePopup()

	local MainMenuSheet = vgui.Create( "DPropertySheet", MainMenuFrame )
	MainMenuSheet:SetPos( 5, 27 )
	MainMenuSheet:SetSize( 590, 567 )
	MainMenuSheet.Paint = function()
		draw.RoundedBox( 8, 0, 0, MainMenuSheet:GetWide(), MainMenuSheet:GetTall(), Color( 0, 0, 0, 0 ) )
	end
--// End of Main Frame

--// Start of Team Tab
	local TabOne = vgui.Create( "DPanelList" )
	TabOne:SetPos( 0, 0 )
	TabOne:SetSize( MainMenuSheet:GetWide(), MainMenuSheet:GetTall() )
	TabOne:SetSpacing( 5 )
	TabOne:EnableHorizontal( false )
	TabOne:EnableVerticalScrollbar( true )
	
	local ChooseATeam = vgui.Create("DLabel", TabOne) -- We only have to parent it to the DPanelList now, and set it's position.
	ChooseATeam:SetPos(190,0)
	ChooseATeam:SetColor( Color( 255, 255, 255, 255 ) )
	ChooseATeam:SetFont("psw")
	ChooseATeam:SetText("Choose a Team:")
	ChooseATeam:SizeToContents()

	local RedcoatsSB = vgui.Create("DLabel", TabOne) -- We only have to parent it to the DPanelList now, and set it's position.
	RedcoatsSB:SetPos(93,280)
	RedcoatsSB:SetColor( Color(165, 42, 42, 255) )
	RedcoatsSB:SetFont("psw")
	RedcoatsSB:SetText("Redcoats")
	RedcoatsSB:SizeToContents()
	PlayerTeam1 = vgui.Create("DListView", TabOne)
	PlayerTeam1:SetPos(10, 320)
	PlayerTeam1:SetSize(270, 200)
	PlayerTeam1:SetMultiSelect(false)
	PlayerTeam1:AddColumn("Player") -- Add column
	PlayerTeam1:AddColumn("Kills")
	PlayerTeam1:AddColumn("Deaths")
	for k,v in pairs(team.GetPlayers(1)) do
		PlayerTeam1:AddLine(v:Nick(),v:Frags(),v:Deaths())
	end

	local PiratesSB = vgui.Create("DLabel", TabOne) -- We only have to parent it to the DPanelList now, and set it's position.
	PiratesSB:SetPos(390,280)
	PiratesSB:SetColor( Color(100, 149, 237, 255) )
	PiratesSB:SetFont("psw")
	PiratesSB:SetText("Pirates")
	PiratesSB:SizeToContents()
	PlayerTeam2 = vgui.Create("DListView", TabOne)
	PlayerTeam2:SetPos(295, 320)
	PlayerTeam2:SetSize(270, 200)
	PlayerTeam2:SetMultiSelect(false)
	PlayerTeam2:AddColumn("Player") -- Add column
	PlayerTeam2:AddColumn("Kills")
	PlayerTeam2:AddColumn("Deaths")
	for k,v in pairs(team.GetPlayers(2)) do
		PlayerTeam2:AddLine(v:Nick(),v:Frags(),v:Deaths())
	end

	SpectatorButton = vgui.Create('DButton')
	SpectatorButton:SetParent(TabOne)
	SpectatorButton:SetSize(310, 60)
	SpectatorButton:SetPos(130, 205)
	SpectatorButton:SetText('Spectator')
	SpectatorButton:SetFont("psw")
	SpectatorButton:SetColor( Color( 255, 255, 255, 255 ) )
	SpectatorButton:SetDrawBackground(false)
	SpectatorButton.DoClick = function() 
		if ply:Team() == 4 then
		ply:ChatPrint( "You are already spectating" )
		else
		RunConsoleCommand( "TEAM_SPECTATOR" )
		MainMenuFrame:Close()
		end
	end

	RedLabel = vgui.Create('DLabel')
	RedLabel:SetParent(TabOne)
	RedLabel:SetPos(155, 50)
	RedLabel:SetText('Redcoats')
	RedLabel:SetFont("psw")
	RedLabel:SetTextColor(Color(165, 42, 42, 255))	
	RedLabel:SizeToContents()

	BlueLabel = vgui.Create('DLabel')
	BlueLabel:SetParent(TabOne)
	BlueLabel:SetPos(335, 50)
	BlueLabel:SetText('Pirates')
	BlueLabel:SetFont("psw")
	BlueLabel:SetTextColor(Color(100, 149, 237, 255))
	BlueLabel:SizeToContents()

	ReDButton = vgui.Create('DImageButton')
	ReDButton:SetParent(TabOne)
	ReDButton:SetSize(128, 168)
	ReDButton:SetPos(145, 80)
	ReDButton:SetImage('VGUI/hud/Skull')
	ReDButton:SizeToContents()
	ReDButton.DoClick = function() 
		if ply:Team() == 1 then
		ply:ChatPrint( "You are already a Redcoat" )
		else
		RunConsoleCommand( "Team_1" )
		MainMenuFrame:Close()
		end
	end

	BlueButton = vgui.Create('DImageButton')
	BlueButton:SetParent(TabOne)
	BlueButton:SetSize(128, 168)
	BlueButton:SetPos(315, 80)
	BlueButton:SetImage('VGUI/hud/blueskull')
	BlueButton:SizeToContents()
	BlueButton.DoClick = function()
		if ply:Team() == 2 then
		ply:ChatPrint( "You are already a Pirate" )
		else
		RunConsoleCommand( "Team_2" )
		MainMenuFrame:Close()
		end
	end
	
	MainMenuSheet:AddSheet( "Team", TabOne, "icon16/group.png", false, false, "Select a team to be on." )
--// End of TabOne

--// Start of TabTwo
	local TabTwo = vgui.Create( "DPanelList" )
	TabTwo:SetPos( 0, 0 )
	TabTwo:SetSize( MainMenuSheet:GetWide(), MainMenuSheet:GetTall() )
	TabTwo:SetSpacing( 5 )
	TabTwo:EnableHorizontal( false )
	TabTwo:EnableVerticalScrollbar( true )
	
	local Content = vgui.Create("DLabel", TabTwo) -- We only have to parent it to the DPanelList now, and set it's position.
	Content:SetPos(100,5)
	Content:SetColor( Color( 255, 255, 255, 255 ) )
	Content:SetFont("psw")
	Content:SetText("Content for this gamemode.")
	Content:SizeToContents()

	OpenWorkshopButton = vgui.Create('DButton')
	OpenWorkshopButton:SetParent(TabTwo)
	OpenWorkshopButton:SetSize(306, 46)
	OpenWorkshopButton:SetPos(130, 80)
	OpenWorkshopButton:SetText('Install Content')
	OpenWorkshopButton:SetFont("psw")
	--OpenWorkshopButton:SetDrawBackground(false)
	OpenWorkshopButton.DoClick = function() steamworks.ViewFile(PSW_CONTENT_ID) end

	OpenWorkshopExtraMaps = vgui.Create('DButton')
	OpenWorkshopExtraMaps:SetParent(TabTwo)
	OpenWorkshopExtraMaps:SetSize(306, 46)
	OpenWorkshopExtraMaps:SetPos(130, 140)
	OpenWorkshopExtraMaps:SetText('Extra Maps')
	OpenWorkshopExtraMaps:SetFont("psw")
	OpenWorkshopExtraMaps.DoClick = function() steamworks.ViewFile(PSW_EXTRAMAPSCONTENT_ID) end
	
	MainMenuSheet:AddSheet( "Content", TabTwo, "icon16/page_edit.png", false, false, "Content for this gamemode." )
--// End of TabTwo
end
concommand.Add("chooseTeam",set_team)

---------------------------------
--F4 Menu
---------------------------------
function Options(ply)
	local DermaPanel = vgui.Create( "DFrame" )
	local wide = math.min(ScrW(), 500)
	local tall = math.min(ScrH(), 580)
	DermaPanel:SetSize(wide, tall)
	DermaPanel:Center()
	DermaPanel:SetTitle( "Pirate Ship Wars Options" )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( false )
	DermaPanel:ShowCloseButton( true )
	DermaPanel:MakePopup()
	--DermaPanel.Paint = function()
		--draw.RoundedBox( 8, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), Color( 0, 0, 0, 0 ) )
	--end
 
	local PropertySheet = vgui.Create( "DPropertySheet", DermaPanel )
	PropertySheet:SetPos( 5, 30 )
	PropertySheet:SetSize( 490, 545 )
	PropertySheet.Paint = function()
		draw.RoundedBox( 8, 0, 0, PropertySheet:GetWide(), PropertySheet:GetTall(), Color( 0, 0, 0, 0 ) )
	end

--//Tab One options
	local TabOne = vgui.Create( "DPanelList" )
	TabOne:SetPos( 0, 0 )
	TabOne:SetSize( PropertySheet:GetWide(), PropertySheet:GetTall() )
	TabOne:SetSpacing( 5 )
	TabOne:EnableHorizontal( false )
	TabOne:EnableVerticalScrollbar( true )
	
	local TestingForm = vgui.Create( "DForm", TabOne )
	--TestingForm:SetPos( 25, 50 )
	TestingForm:SetSize( 350, 50 )
	TestingForm:SetSpacing( 5 )
	TestingForm:SetName( "HUD Settings" )
	TestingForm.Paint = function()
		surface.SetDrawColor( 255, 51, 15, 255 )
	end
 	TabOne:AddItem( TestingForm )
	
    local CategoryContentOne = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentOne:SetPos(0,50)
    CategoryContentOne:SetText( "Enable Hud" )
    CategoryContentOne:SetConVar( "psw_HUDEnabled" )
	CategoryContentOne:SizeToContents()
	TestingForm:AddItem( CategoryContentOne )
	
	--[[local CategoryContentTwo = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentTwo:SetPos(0,70)
    CategoryContentTwo:SetText( "Display Round Info (WIP)" )
    CategoryContentTwo:SetConVar( "psw_displayroundinfo" )
    CategoryContentTwo:SizeToContents()
	TestingForm:AddItem( CategoryContentTwo )]]--
	
	--[[local CategoryContentThree = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentThree:SetPos(0,70)
    CategoryContentThree:SetText( "Display lives left (WIP Only Works If The Owner/Admin Has Enable Lives System)" )
    CategoryContentThree:SetConVar( "psw_displaylives" )
    CategoryContentThree:SizeToContents()
	TestingForm:AddItem( CategoryContentThree )]]--
	
	local TestingForm2 = vgui.Create( "DForm", TabOne )
	--TestingForm2:SetPos( 25, 50 )
	TestingForm2:SetSize( 350, 50 )
	TestingForm2:SetSpacing( 5 )
	TestingForm2:SetName( "Other Settings" )
	TestingForm2.Paint = function()
		surface.SetDrawColor( 255, 51, 15, 255 )
	end
 	TabOne:AddItem( TestingForm2 )
	
	local CategoryContentFour = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentFour:SetPos(0,70)
    CategoryContentFour:SetText( "Toggle 3rd Person Mode" )
    CategoryContentFour:SetConVar( "psw_3rdperson" )
    CategoryContentFour:SizeToContents()
	TestingForm2:AddItem( CategoryContentFour )
	
	local CategoryContentFive = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentFive:SetPos(0,90)
    CategoryContentFive:SetText( "Enable End Round Music" )
    CategoryContentFive:SetConVar( "psw_endroundmusic" )
    CategoryContentFive:SizeToContents()
	TestingForm2:AddItem( CategoryContentFive )
	
	local CategoryContentsix = vgui.Create( "DCheckBoxLabel", TabOne )
	--CategoryContentsix:SetPos(0,90)
    CategoryContentsix:SetText( "Disable Cannon Smoke" )
    CategoryContentsix:SetConVar( "psw_disablecannonsmoke" )
    CategoryContentsix:SizeToContents()
	TestingForm2:AddItem( CategoryContentsix )
	
	PropertySheet:AddSheet( "Client Options", TabOne, "icon16/page_edit.png", false, false, "Client Options" )
--//End of Tab One options

--//Tab Two options
	if (LocalPlayer():IsAdmin()) or (LocalPlayer():IsSuperAdmin()) then
	local TabTwo = vgui.Create( "DPanelList" )
	TabTwo:SetPos( 0, 0 )
	TabTwo:SetSize( PropertySheet:GetWide(), PropertySheet:GetTall() )
	TabTwo:SetSpacing( 5 )
	TabTwo:EnableHorizontal( false )
	TabTwo:EnableVerticalScrollbar( true )

--Server Settings
	local TestingForm = vgui.Create( "DForm", TabTwo )
	TestingForm:SetPos( 25, 50 )
	TestingForm:SetSize( 350, 50 )
	TestingForm:SetSpacing( 5 )
	TestingForm:SetName( "Server Settings" )
	TestingForm.Paint = function()
		surface.SetDrawColor( 255, 51, 15, 255 )
	end
 	TabTwo:AddItem( TestingForm )
	
	local CategoryContentOne = vgui.Create( "DCheckBoxLabel"  )
    CategoryContentOne:SetText( "Disable Ships Explosive Barrel (On Next Round)" )
	CategoryContentOne:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_nodoors") == 1 then
		CategoryContentOne:SetChecked( true )
	else
		CategoryContentOne:SetChecked( false )
	end
	function CategoryContentOne.OnChange()
		if GetConVarNumber("psw_nodoors") == 1 then
		net.Start("NoDoors")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("NoDoors")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentOne:SizeToContents()
	TestingForm:AddItem( CategoryContentOne )
 
	local CategoryContentTwo = vgui.Create( "DCheckBoxLabel"  )
    CategoryContentTwo:SetText( "Disable Friendly Fire" )
	CategoryContentTwo:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_friendlyfire") == 1 then
		CategoryContentTwo:SetChecked( true )
	else
		CategoryContentTwo:SetChecked( false )
	end
	function CategoryContentTwo.OnChange()
		if GetConVarNumber("psw_friendlyfire") == 1 then
		net.Start("friendlyfire")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("friendlyfire")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentTwo:SizeToContents()
	TestingForm:AddItem( CategoryContentTwo )
	
	local CategoryContentThree = vgui.Create( "DCheckBoxLabel"  )
    CategoryContentThree:SetText( "Disable Water Damage" )
	CategoryContentThree:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_nowaterdamage") == 1 then
		CategoryContentThree:SetChecked( true )
	else
		CategoryContentThree:SetChecked( false )
	end
	function CategoryContentThree.OnChange()
		if GetConVarNumber("psw_nowaterdamage") == 1 then
		net.Start("nowaterdamage")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("nowaterdamage")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentThree:SizeToContents()
	TestingForm:AddItem( CategoryContentThree )
 
	local CategoryContentFour = vgui.Create( "DCheckBoxLabel"  )
    CategoryContentFour:SetText( "Enable/Disable Auto Team Balance" )
	CategoryContentFour:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_autoteambalance") == 1 then
		CategoryContentFour:SetChecked( true )
	else
		CategoryContentFour:SetChecked( false )
	end
	function CategoryContentFour.OnChange()
		if GetConVarNumber("psw_autoteambalance") == 1 then
		net.Start("autoteambalance")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("autoteambalance")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentFour:SizeToContents()
	TestingForm:AddItem( CategoryContentFour )
	
	--[[local Enableplayerslives = vgui.Create( "DCheckBoxLabel"  )
    Enableplayerslives:SetText( "Enable Players Lives System (WIP)" )
	Enableplayerslives:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_enableplayerslives") == 1 then
		Enableplayerslives:SetChecked( true )
	else
		Enableplayerslives:SetChecked( false )
	end
	function Enableplayerslives.OnChange()
		if GetConVarNumber("psw_enableplayerslives") == 1 then
		net.Start("enableplayerslives")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("enableplayerslives")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    Enableplayerslives:SizeToContents()
	TestingForm:AddItem( Enableplayerslives )
	
	local CategoryContentFive = vgui.Create( "DNumSlider" )
    CategoryContentFive:SetText( "Players Lives (On Next Round)" )
	CategoryContentFive:SetMinMax( 1, 25 )
	CategoryContentFive:SetDecimals(0)
	CategoryContentFive:SetValue(GetConVarNumber("psw_playerslives"))
	CategoryContentFive.ValueChanged = function(Self, Value)
     	net.Start("Playerslives")
		net.WriteFloat(Value)
		net.SendToServer()
	end
    CategoryContentFive:SizeToContents()
	TestingForm:AddItem( CategoryContentFive )]]--
	
	local CategoryContentSix = vgui.Create( "DNumSlider" )
    CategoryContentSix:SetText( "Max Rounds" )
	CategoryContentSix:SetMinMax( 4, 12 )
	CategoryContentSix:SetDecimals(0)
	CategoryContentSix:SetValue(GetConVarNumber("psw_maxrounds"))
	CategoryContentSix.ValueChanged = function(Self, Value)
     	net.Start("MaxRounds")
		net.WriteFloat(Value)
		net.SendToServer()
	end
    CategoryContentSix:SizeToContents()
	TestingForm:AddItem( CategoryContentSix )

--Weapon Settings
	local TestingForm2 = vgui.Create( "DForm", DermaPanel )
	TestingForm2:SetPos( 25, 50 )
	TestingForm2:SetSize( 350, 50 )
	TestingForm2:SetSpacing( 5 )
	TestingForm2:SetName( "Weapon Settings" )
	TestingForm2.Paint = function()
		surface.SetDrawColor( 255, 51, 15, 255 )
	end
 	TabTwo:AddItem( TestingForm2 )
	
	local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )
    CategoryContentOne:SetText( "Enable Pistol" )
	CategoryContentOne:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_weaponPistol") == 1 then
		CategoryContentOne:SetChecked( true )
	else
		CategoryContentOne:SetChecked( false )
	end
	function CategoryContentOne.OnChange()
		if GetConVarNumber("psw_weaponPistol") == 1 then
		net.Start("DisablePistol")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("DisablePistol")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentOne:SizeToContents()
	TestingForm2:AddItem( CategoryContentOne )
	
	local CategoryContentTwo = vgui.Create( "DCheckBoxLabel" )
    CategoryContentTwo:SetText( "Enable Sabre" )
	CategoryContentTwo:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_weaponSabre") == 1 then
		CategoryContentTwo:SetChecked( true )
	else
		CategoryContentTwo:SetChecked( false )
	end
	function CategoryContentTwo.OnChange()
		if GetConVarNumber("psw_weaponSabre") == 1 then
		net.Start("DisableSaber")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("DisableSaber")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentTwo:SizeToContents()
	TestingForm2:AddItem( CategoryContentTwo )	
	
	local CategoryContentThree = vgui.Create( "DCheckBoxLabel" )
    CategoryContentThree:SetText( "Enable Musket" )
	CategoryContentThree:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_weaponMusket") == 1 then
		CategoryContentThree:SetChecked( true )
	else
		CategoryContentThree:SetChecked( false )
	end
	function CategoryContentThree.OnChange()
		if GetConVarNumber("psw_weaponMusket") == 1 then
		net.Start("DisableMusket")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("DisableMusket")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentThree:SizeToContents()
	TestingForm2:AddItem( CategoryContentThree )
 
	local CategoryContentFour = vgui.Create( "DCheckBoxLabel" )
    CategoryContentFour:SetText( "Enable Grenade" )
	CategoryContentFour:SetTextColor(Color(255,255,255))
	if GetConVarNumber("psw_weaponGrenade") == 1 then
		CategoryContentFour:SetChecked( true )
	else
		CategoryContentFour:SetChecked( false )
	end
	function CategoryContentFour.OnChange()
		if GetConVarNumber("psw_weaponGrenade") == 1 then
		net.Start("DisableGrenade")
		net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("DisableGrenade")
		net.WriteFloat(1)
		net.SendToServer()
		end
	end
    CategoryContentFour:SizeToContents()
	TestingForm2:AddItem( CategoryContentFour )

	PropertySheet:AddSheet( "Admin Options", TabTwo, "gui/silkicons/group", false, false, "Server Options" )
	end
--//End of Tab Two options
end
concommand.Add("Options",Options)