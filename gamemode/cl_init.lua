--PirateShip Wars
--Originally made in Gmod 9 by EmpV
--Remade for Gmod 13 by VertisticINC

Msg("\nLoading client-side PirateShip Wars.\n")

include("shared.lua")
include("util.lua")
include("cl_menus.lua")
include("rtv/config.lua")
include("rtv/cl_rtv.lua")
include("cl_scoreboard.lua")
include("cl_dermaskin.lua")
include("cl_deathnotice.lua")
include("sh_points.lua")

---------------------------------
--Language additions
---------------------------------
language.Add( "func_physbox", "Ship" )
language.Add( "env_explosion", "Ship Explosion" )
language.Add( "func_breakable", "Ship" )
language.Add( "worldspawn", "Ship" )
language.Add( "trigger_hurt", "Davy Jones Locker" )

---------------------------------
--ClientConVar
---------------------------------
CreateClientConVar("psw_HUDEnabled", "0", true, true)
CreateClientConVar("psw_3rdperson", "0", true, true)
CreateClientConVar("psw_endroundmusic", "1", true, true)
CreateClientConVar("psw_displayroundinfo", "0", true, true)
CreateClientConVar("psw_displaylives", "0", true, true)

RunConsoleCommand( "cl_pred_optimize", "1");

PSW_CONTENT_ID = 124918666
function GM:PostDrawViewModel( vm, ply, weapon )
 
	if ( !IsValid( weapon ) ) then return false end
 
	if ( weapon.UseHands || !weapon:IsScripted() ) then
 
		local hands = ply:GetHands()
		if ( IsValid( hands ) ) then
			hands:DrawModel()
		end
 
	end
 
	if ( weapon.PostDrawViewModel == nil ) then return false end		
	return weapon:PostDrawViewModel( vm, weapon, ply )
	
end
---------------------------------
--HUD
---------------------------------
function pswhud()
ply = LocalPlayer()
local lives = ply:GetNWInt("lives")

--local EXP = LocalPlayer():GetEXP()
--local Level = LocalPlayer():GetLevel()

	if GetConVarNumber("psw_HUDEnabled")>=1 then
	
		if LocalPlayer():Alive() then
		
		--draw.SimpleText("Current XP: "..EXP, 'TargetID', 10, 10, Color(255,255,255))
		--draw.SimpleText("Level: "..Level, 'TargetID', 10, 30, Color(255,255,255))
		
			if GetConVarNumber( "psw_enableplayerslives" ) == 1 and GetConVarNumber( "psw_displaylives" ) == 1 then
				if ply:Team() == TEAM_BLUE || ply:Team() == TEAM_RED then
					draw.WordBox( 1, ScrW()*0.015, ScrH()*0.86, "lives: "..LocalPlayer():GetNWInt("lives"),"pswsize12",Color(200,0,0,0),Color(255,255,255,255))  
					draw.WordBox( 1, ScrW()*0.2, ScrH()*0.898, "Lives Left: "..lives,"pswsize12",Color(200,0,0,0),Color(255,255,255,255))
					draw.WordBox( 1, ScrW()*0.2, ScrH()*0.925, "Lives Next round: "..GetConVarNumber("psw_playerslives"),"pswsize12",Color(200,0,0,0),Color(255,255,255,255))
				end
			end
			
			--[[if GetConVarNumber( "psw_displayroundinfo" ) == 1 then
				if ply:Team() == TEAM_BLUE || ply:Team() == TEAM_RED then
					draw.WordBox( 1, ScrW()*0.41, ScrH()*0.02, "Redcoats","pswsize12",Color(200,0,0,0),Color(130, 30, 30, 255))
					draw.WordBox( 1, ScrW()*0.475, ScrH()*0.001, "Rounds","pswsize12",Color(200,0,0,0),Color(255,255,255,255))
					draw.WordBox( 1, ScrW()*0.526, ScrH()*0.02, "Pirates","pswsize12",Color(200,0,0,0),Color(30, 30, 130, 255))  
					
					draw.WordBox( 1, ScrW()*0.432, ScrH()*0.04, ""..GetGlobalInt("roundsDone"),"pswsize12",Color(200,0,0,0),Color(255,255,255,255))
					draw.WordBox( 1, ScrW()*0.49, ScrH()*0.02, ""..GetConVarNumber("psw_maxrounds"),"pswsize12",Color(200,0,0,0),Color(255,255,255,255))
					draw.WordBox( 1, ScrW()*0.542, ScrH()*0.04, ""..GetGlobalInt("roundsDone"),"pswsize12",Color(200,0,0,0),Color(255,255,255,255))  
				end
			end]]--
		
			if LocalPlayer():Team() == TEAM_RED then
				surface.SetDrawColor( 255, 255, 255, 255 )
				local tid = surface.GetTextureID( 'VGUI/hud/blood' )
				surface.SetTexture( tid )
				surface.DrawTexturedRect( ScrW()*0.01, ScrH()*0.88, ScrW()*0.187, ScrH()*0.12 )
				local tid2 = surface.GetTextureID( 'VGUI/hud/Skull' )
				surface.SetTexture( tid2 )
				surface.DrawTexturedRect( ScrW()*0.01, ScrH()*0.88, ScrW()*0.06, ScrH()*0.088 )
				if LocalPlayer():Health() > 10 then
					draw.RoundedBox( 10, ScrW()*0.0665, ScrH()*0.9, ( ScrW()*0.1255 * ( LocalPlayer():Health() / 100 ) ), ScrH()*0.029, Color( 130, 30, 30, 140 ) )
					draw.RoundedBox( 10, ScrW()*0.064, ScrH()*0.898, ScrW()*0.13, ScrH()*0.033, Color( 20, 20, 20, 150 ) )
					else --Added to prevent the bar from screwing
					surface.SetFont("psw") 
					surface.SetTextPos( ScrW()*0.07, ScrH()*0.895 )
					surface.SetTextColor( 170, 50, 50, 245 )
					surface.DrawText( "Aye ye hit" ) --Piratey
					draw.RoundedBox( 10, ScrW()*0.064, ScrH()*0.898, ScrW()*0.13, ScrH()*0.033, Color( 20, 20, 20, 150 ) )
				end
			end
			
			if LocalPlayer():Team() == TEAM_BLUE then
				surface.SetDrawColor( 255, 255, 255, 255 )
				local tid = surface.GetTextureID( 'VGUI/hud/blueblood' )
				surface.SetTexture( tid )
				surface.DrawTexturedRect( ScrW()*0.01, ScrH()*0.88, ScrW()*0.187, ScrH()*0.12 )
				local tid2 = surface.GetTextureID( 'VGUI/hud/blueskull' )
				surface.SetTexture( tid2 )
				surface.DrawTexturedRect( ScrW()*0.01, ScrH()*0.88, ScrW()*0.06, ScrH()*0.088 )
				if LocalPlayer():Health() > 10 then
					draw.RoundedBox( 10, ScrW()*0.0665, ScrH()*0.9, ( ScrW()*0.1255 * ( LocalPlayer():Health() / 100 ) ), ScrH()*0.029, Color( 130, 30, 30, 140 ) )
					draw.RoundedBox( 10, ScrW()*0.064, ScrH()*0.898, ScrW()*0.13, ScrH()*0.033, Color( 20, 20, 20, 150 ) )
					else --Added to prevent the bar from screwing
					surface.SetFont("psw") 
					surface.SetTextPos( ScrW()*0.07, ScrH()*0.895 )
					surface.SetTextColor( 170, 50, 50, 245 )
					surface.DrawText( "Aye ye hit" ) --Piratey
					draw.RoundedBox( 10, ScrW()*0.064, ScrH()*0.898, ScrW()*0.13, ScrH()*0.033, Color( 20, 20, 20, 150 ) )
				end
			end
			
			if LocalPlayer():Team() == TEAM_BLUE then
				surface.SetDrawColor( 255, 255, 255, 255 )
				local tid = surface.GetTextureID( 'VGUI/hud/blueblood' )
				surface.SetTexture( tid )
				surface.DrawTexturedRect( 20, ScrH() - 130, 312, 128 )
				local tid2 = surface.GetTextureID( 'VGUI/hud/blueskull' )
				surface.SetTexture( tid2 )
				surface.DrawTexturedRect( 20, ScrH() - 130, 99, 90 )
				if LocalPlayer():Health() > 10 then
					draw.RoundedBox( 10, 110, ScrH() - 105, ( 210 * ( LocalPlayer():Health() / 100 ) ), 30, Color( 30, 30, 130, 140 ) )
					draw.RoundedBox( 10, 105, ScrH() - 107.5, 220, 35, Color( 20, 20, 20, 150 ) )
					else --Added to prevent the bar from screwing
					surface.SetFont("psw") 
					surface.SetTextPos( 110, ScrH() - 107.5 )
					surface.SetTextColor( 170, 50, 50, 245 )
					surface.DrawText( "Aye ye hit" ) --Piratey
					draw.RoundedBox( 10, 105, ScrH() - 107.5, 220, 35, Color( 20, 20, 20, 150 ) )
				end
			end	
		end
			
			if LocalPlayer():Team() == TEAM_SPECTATE then
				return false 
			end
		end
		
		if table.Count(LocalPlayer():GetWeapons()) > 0 then
			curwep = LocalPlayer():GetActiveWeapon()
			if curwep and curwep ~= "nil" and curwep ~= nil and curwep:IsValid() then
				if curwep:GetPrimaryAmmoType() then
					ammotype = curwep:GetPrimaryAmmoType()
				else
					ammotype = false
				end
				if ammotype and ammotype ~= -1 then
					ammo = LocalPlayer():GetAmmoCount( ammotype )
					strammo = curwep:Clip1() .. " / " .. ammo
					if ammo == 0 and curwep:Clip1() == 0 then strammo = "0 / 0" 
				end
					
				surface.SetDrawColor( 255, 255, 255, 255 )
				local tid = surface.GetTextureID( 'VGUI/hud/gunhud' )
				surface.SetTexture( tid )
				surface.DrawTexturedRect( ScrW() - 354, ScrH() - 160, 356, 151 )

				surface.SetFont("psw") 
				surface.SetTextPos( ScrW() - 200, ScrH() - 100)
				surface.SetTextColor( 170, 50, 50, 245 )
				surface.DrawText( strammo ) --Piratey
			end
		end
	end
end
hook.Add("HUDPaint", "pswhud", pswhud);

function ThirdPersonHUDPaint()
	if GetConVarNumber("psw_3rdperson")>=1 then
		local player = LocalPlayer()

		// trace from muzzle to hit pos
		local t = {}
		t.start = player:GetShootPos()
		t.endpos = t.start + player:GetAimVector() * 9000
		t.filter = player
		local tr = util.TraceLine(t)
		local pos = tr.HitPos:ToScreen()
		local fraction = math.min((tr.HitPos - t.start):Length(), 1024) / 1024
		local size = 10 + 20 * (1.0 - fraction)
		local offset = size * 0.5
		local offset2 = offset - (size * 0.1)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawLine(pos.x - offset, pos.y, pos.x - offset2, pos.y)
		surface.DrawLine(pos.x + offset, pos.y, pos.x + offset2, pos.y)
		surface.DrawLine(pos.x, pos.y - offset, pos.x, pos.y - offset2)
		surface.DrawLine(pos.x, pos.y + offset, pos.x, pos.y + offset2)
		surface.DrawLine(pos.x - 1, pos.y, pos.x + 1, pos.y)
		surface.DrawLine(pos.x, pos.y - 1, pos.x, pos.y + 1)
	end
end
hook.Add("HUDPaint", "ThirdPersonHUDPaint", ThirdPersonHUDPaint)

function MyCalcView(ply, pos, angles, fov)
	if GetConVarNumber("psw_3rdperson")>=1 then
		local view = {}
		view.origin = pos-(angles:Forward()*100) + ( angles:Right()* 15 )
		view.angles = angles
		view.fov = fov
		return view
	end
end
hook.Add("CalcView", "MyCalcView", MyCalcView)

function ThirdPersonHUDShouldDraw(name)
	if GetConVarNumber("psw_3rdperson")>=1 then 
		if name == "CHudCrosshair" then
			return false
		end
	end
end
hook.Add("HUDShouldDraw", "ThirdPersonHUDShouldDraw", ThirdPersonHUDShouldDraw)

hook.Add("ShouldDrawLocalPlayer", "ShouldDrawLocalPlayer", function(ply)
	if GetConVarNumber("psw_3rdperson")>=1 then return true	end
end)

/*---------------------------------------------------------
   Name: gamemode:HUDDrawTargetID( )
   Desc: Draw the target id (the name of the player youre currently looking at)
---------------------------------------------------------*/
function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	local text = "pswsmall"
	local font = "pswsmall"

	if (trace.Entity:IsPlayer()) then
		text = trace.Entity:Nick()
	else
		return
		--text = trace.Entity:GetClass()
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

	y = y + h + 5

	local text = trace.Entity:Health() .. "%"
	local font = "pswsmall"

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX  - w / 2

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
end

hook.Add("HUDShouldDraw","gamemode",function(n)
	if ({
		CHudHealth = true,
		CHudBattery = true,
		CHudSecondaryAmmo = true,
		CHudAmmo = true,
	})[n] then
		return false
	end
end)

function GM:CalcView( ply, origin, angles, fov ) 
	local plViewAngle = {}
	plViewAngle.origin = origin
	plViewAngle.fov = fov + 10
	plViewAngle.angles = Angle( angles.p, angles.y, 0 )
 	return plViewAngle;
end

---------------------------------
--Other Stuff
---------------------------------
function endroundmusic()
	if GetConVarNumber("psw_endroundmusic")==1 then
		surface.PlaySound( "psw/shipsinking.mp3" )
	end	
end
concommand.Add("endroundmusic",endroundmusic)

--pswWeapons = { "weapon_psw_sabre", "weapon_psw_musket", "weapon_psw_blunderbus", "weapon_psw_pistol", "weapon_psw_pistol2", "weapon_psw_grenade",}

--[[hook.Add("PlayerBindPress","gamemode",function(ply,bind,pressed)
	local a = bind:find("+use")
	if ply:Alive() then
		--if a then RunConsoleCommand( "psw_use" ); end
	end
end)]]--

--Chat Commands
function TPRecieve()
	chat.AddText( Color( 0, 0, 0 ), "[Console] ", Color( 75, 75, 255 ), "You are now in third person!")
	RunConsoleCommand ("psw_3rdperson", "1");
end
usermessage.Hook( "thirdperson", TPRecieve )

function FPRecieve()
	chat.AddText( Color( 0, 0, 0 ), "[Console] ", Color( 75, 75, 255 ), "You are now in first person!")
	RunConsoleCommand ("psw_3rdperson", "0");
end
usermessage.Hook( "firstperson", FPRecieve )

---------------------------------
--Fonts
---------------------------------
surface.CreateFont("pswsize4", {
	size = ScreenScale(4),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsize6", {
	size = ScreenScale(6),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsize8", {
	size = ScreenScale(8),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsize10", {
	size = ScreenScale(10),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsize12", {
	size = ScreenScale(12),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsize16", {
	size = ScreenScale(16),
	weight = 400,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("psw", {
	size = ScreenScale(16),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})
surface.CreateFont("pswsmall", {
	size = ScreenScale(8),
	weight = 200,
	antialias = true,
	additive = false,
	font = "akbar"
})