--[[
		Garry's Mod 10 - Pirate Ship Wars 2.0
			Thomas 'g\mail termy58' Hansen
			CaptainShaun
				
		Garry's Mod 10 - Pirate Ship Wars
			EmpV
			Metroid48
			Thomas 'g\mail termy58' Hansen
					
		Gmod 9 Original - Pir
			EmpV

	Also thanks to the artists who have contributed various weapon models
	and also  Battlegrounds Source 1 mod for the original player model
]]--

include("shared.lua")
include("util.lua")
include("player.lua")
include("rounds.lua")
include("mapcycle.lua")
include("helm.lua")
include("explosion.lua")
include("rtv/config.lua")
include("rtv/sv_rtv.lua")
--include("sh_points.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("helm.lua")
AddCSLuaFile("explosion.lua")
AddCSLuaFile("rtv/config.lua")
AddCSLuaFile("rtv/cl_rtv.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_dermaskin.lua")
AddCSLuaFile("cl_deathnotice.lua")
--AddCSLuaFile("sh_points.lua")

--Var define
ships = false
PirateData = {}
canSpawn = false
exploded = {}
shipdata = {}
shipdata[TEAM_RED] = {}
shipdata[TEAM_RED].name = "Redcoats"
shipdata[TEAM_RED].n = 35
shipdata[TEAM_BLUE] = {}
shipdata[TEAM_BLUE].name = "Pirates"
shipdata[TEAM_BLUE].n = 35
pswThrusters = {}
pswThrusters[1] = {}
pswThrusters[2] = {}
cannonExplosive = nil
mastsBroken = {}

ROUND_INACTIVE = 0
ROUND_ACTIVE = 1

--resource.AddWorkshop( "229715888" )

function GM:Initialize()
	GAMEMODE.round_state = ROUND_INACTIVE
end

---------------------------------
--Menu
---------------------------------
function GM:ShowHelp(pl)
	pl:SendLua( "GAMEMODE:ShowHelp()" )
end

function GM:ShowTeam(ply)
	ply:ConCommand("ChooseTeam")
end

function GM:ShowSpare2(ply)
	ply:ConCommand("Options")
end

---------------------------------
--Teams
---------------------------------
function TEAM_SPECTATOR( ply )
    ply:SetTeam( 4 )
	ply:StripWeapons()
	ply:Spectate( OBS_MODE_ROAMING )
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint( "Player "..ply:GetName().." is spectating " )
		return
	end
end

function Team_1( ply )
    ply:SetTeam( 1 )
	ply:KillSilent()
	ply:Spawn()
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint( "Player "..ply:GetName().." Joined Team "..team.GetName( ply:Team() ).."" )
	end
end

function Team_2( ply )
    ply:SetTeam( 2 )
	ply:KillSilent()
	ply:Spawn()
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint( "Player "..ply:GetName().." Joined Team "..team.GetName( ply:Team() ).."" )
	end
end

concommand.Add( "TEAM_SPECTATOR", TEAM_SPECTATOR )
concommand.Add( "Team_1", Team_1 )
concommand.Add( "Team_2", Team_2 )

---------------------------------
--Main gamemode-related functions
---------------------------------
function GM:EntityKeyValue( ent, key, val )
	--[[if key == "team" then
		ent.team = tonumber( val )
		if string.find( ent:GetClass(), "psw_thruster_" ) then
			pswThrusters[ent.team][ string.sub(ent:GetClass(), 14) ] = ent
			print( string.sub(ent:GetClass(), 14) )
		end
		if ent:GetClass() == "psw_helm" then
			pswThrusters[ent.team]["helm"] = ent
		end
	end]]--

	--[[if key == "force" then
		if ent:GetClass() == "phys_thruster" then

			if string.find(ent:GetName(), "forward") then
				return "600"
			elseif string.find(ent:GetName(), "right") then
				return "200"
			elseif string.find(ent:GetName(), "left") then
				return "200"
			elseif string.find(ent:GetName(), "reverse") then
				return "250"
			end
		end
	end]]--
end

--[[concommand.Add( "psw_weaponSelect",function( ply, cmd, args )
    ply:SelectWeapon( args[1] )
end )]]--

--Spawns ships at map/round start
function GM:Think() --gamerulesThink()
	
	if !ships then
		spawnships()
		ships = true
	end
	
	lastthink = CurTime()
	
end

--SpawnShips
function spawnships()
	for k,v in pairs(ents.FindByName("spawnbutton")) do
		v:Fire("Press", "", 0)
	end
	
	shipdata[TEAM_RED].sinking = false
	shipdata[TEAM_BLUE].sinking = false
	shipdata[TEAM_RED].disabled = false
	shipdata[TEAM_BLUE].disabled = false
	starting=true

	for k,v in pairs(player.GetAll()) do
		v.kd = ( v.kd - 1 )
		if v.kd < 0 then
			v.kd = 0
		end
	end
	
	timer.Simple(4,getshipparts)
	timer.Simple(30,roundstart)
	
end

function roundstart()
	
	starting = false;
	
end

function findpartowner(ent, isstringbool)
	if isstringbool then
		entstring = ent
	else
		entstring = ent:GetName()
	end

	if string.find(entstring, "ship1") || string.find(entstring,"s1") then
		return 1
	end
	if string.find(entstring, "ship2") || string.find(entstring,"s2") then
		return 2
	end
end

function getshipparts() --GETS ENTITY ID'S FROM ALL SHIP PARTS AND SET MASSES.
	for v=1, 2 do
		pswThrusters[v] = { ["forward"] = { Ent = ents.FindByName( "ship"..v.."_thruster_forward" )[1],
											On = false},
							["reverse"] = { Ent = ents.FindByName( "ship"..v.."_thruster_reverse" )[1],
											On = false},
							["left"]    = { Ent = ents.FindByName( "ship"..v.."_thruster_left" )[1],
											On = false},
							["right"]   = { Ent = ents.FindByName( "ship"..v.."_thruster_right" )[1],
											On = false},
											}
		shipdata[v][3] = ents.GetByName("ship" .. v .. "keelbottom1");
		shipdata[v][4] = ents.GetByName("ship" .. v .. "keelbottom2");
		shipdata[v][5] = ents.GetByName("ship" .. v .. "keelbottom3");
		shipdata[v][6] = ents.GetByName("ship" .. v .. "keelbottom4");
		shipdata[v][8] = ents.GetByName("ship" .. v .. "keelbottom5");
		shipdata[v][9] = ents.GetByName("ship" .. v .. "keel2");
		shipdata[v][11] = ents.GetByName("ship" .. v .. "sinker");
		
		shipdata[v][16] = ents.GetByName("ship" .. v .. "door");
		shipdata[v][17] = ents.GetByName("ship" .. v .. "explosive");
		shipdata[v][18] = ents.GetByName("ship" .. v .. "keel");
		
		shipdata[v][3]:EnableDrag(false);
		shipdata[v][4]:EnableDrag(false);
		shipdata[v][5]:EnableDrag(false);
		shipdata[v][6]:EnableDrag(false);
		shipdata[v][8]:EnableDrag(false);
		shipdata[v][9]:EnableDrag(false);
		shipdata[v][11]:EnableDrag(false);
		
		shipdata[v][16]:EnableDrag(false);
		--shipdata[v][17]:EnableDrag(false);
		shipdata[v][18]:EnableDrag(false);
		
		shipdata[v][3]:SetMass(40000);
		shipdata[v][4]:SetMass(40000);
		shipdata[v][5]:SetMass(40000);
		shipdata[v][6]:SetMass(40000);
		shipdata[v][8]:SetMass(35000);
		mastsBroken["ship" .. v .. "mast1"] = false
		mastsBroken["ship" .. v .. "mast2"] = false
		mastsBroken["ship" .. v .. "mast3"] = false

		if GetConVarNumber("psw_noDoors")>=1 then
			ents.GetByName("ship" .. v .. "door", true):Remove()
			--ents.GetByName("ship" .. v .. "barrelexplode", true):Remove()
			ents.GetByName("ship" .. v .. "explosive", true):Remove()
			--ents.GetByName("s" .. v .. "smoke", true):Remove()
		end
	end
end

function sink(v) --Sink function, called when a piece of a ship breaks
	if !shipdata[v].sinking then
		if shipdata[v][8] ~= nil && shipdata[v][8]:GetMass() > 9000 then
			shipdata[v][8]:SetMass(shipdata[v][8]:GetMass()-1000)
			if shipdata[v][11]:GetMass() < 40000 then
				shipdata[v][11]:SetMass(shipdata[v][11]:GetMass()+2000)
			end
		end
		if shipdata[v][3] ~= nil && shipdata[v][3]:GetMass() > 2000 then
			shipdata[v][3]:SetMass(shipdata[v][3]:GetMass()-1000)
			shipdata[v][4]:SetMass(shipdata[v][4]:GetMass()-1000)
			shipdata[v][5]:SetMass(shipdata[v][5]:GetMass()-1000)
			shipdata[v][6]:SetMass(shipdata[v][6]:GetMass()-1000)
		else
			if shipdata[v][3] ~= nil && shipdata[v][3]:GetMass() > 14000 then
				shipdata[v][8]:SetMass(1000)
				shipdata[v][9]:SetMass(25000)
				shipdata[v][3]:SetMass(shipdata[v][3]:GetMass() - 1000)
				shipdata[v][4]:SetMass(shipdata[v][4]:GetMass() - 1000)
				shipdata[v][5]:SetMass(1000)
				shipdata[v][6]:SetMass(1000)
				shipdata[v][11]:SetMass(15000)
			else
				if !shipdata[opposingTeam(v)].sinking then
					shipdata[v].n = 35
					shipdata[v].sinking = true
					winner(opposingTeam(v))
				end
			end
		end
	end
end

function CountDown(v)
	if shipdata[v].n == 30 then
		canSpawn=false
	end
	if shipdata[v].n == 7 && shipdata[v].sinking then
		for k,v in pairs(player.GetAll()) do
			v:StripWeapons()
			v:Spectate(OBS_MODE_ROAMING)
		end
	end
	if shipdata[v].n == 5 && shipdata[v].sinking then	
		spawnships();
	end
	if shipdata[v].n == 1 then
		newRound()
	end	
	
	shipdata[v].n = shipdata[v].n - 1
	
	if ( shipdata[v].sinking ) then
		if shipdata[v][3]:GetMass() > 400 then
			shipdata[v][3]:SetMass( shipdata[v][3]:GetMass() - 200 )
			shipdata[v][4]:SetMass( shipdata[v][4]:GetMass() - 200 )
		end	
		
		shipdata[v][8]:SetMass(1000)
		
		if shipdata[v][11]:GetMass() <= 40000 then		
			shipdata[v][5]:SetMass(500);
			shipdata[v][6]:SetMass(500);
			shipdata[v][11]:SetMass( shipdata[v][11]:GetMass() + 1000 ); 
		end
		
		if shipdata[v][11]:GetMass() > 40000 then
			shipdata[v][5]:SetMass(1000)
			shipdata[v][6]:SetMass(1000)
			if shipdata[v][9]:GetMass() > 2000 then
				shipdata[v][9]:SetMass(shipdata[v][9]:GetMass()-1000)	
			end
		elseif shipdata[v][11]:GetMass() > 49000 then
			shipdata[v][10]:SetMass(35000)
			shipdata[v][9]:SetMass(2000)
			shipdata[v][3]:SetMass(1000)
			shipdata[v][4]:SetMass(1000)	
		end
	end
end

function GM:EntityTakeDamage( target, dmginfo )
	local caller = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()

	if (caller:GetClass() == "psw_ballbearing") || (caller:GetClass() == "psw_grenade") then
		if target:IsPlayer() then
			dmginfo:ScaleDamage(2)
			dmginfo:SetAttacker(caller:GetOwner())
			attacker = caller:GetOwner()
			Msg("\n\nZZZZZZZZZzzzz\n\n")
			return dmginfo
		else
			dmginfo:ScaleDamage(0)
			return dmginfo
		end
	end
	
	if attacker:IsPlayer() && string.find(target:GetName(), "ship") then
		if attacker:Team() == TEAM_RED && string.find(target:GetName(), "ship1") then return false end
		if attacker:Team() == TEAM_BLUE && string.find(target:GetName(), "ship2") then return false end
		if target:GetClass() != "prop_physics_multiplayer" && target:GetClass() != "func_breakable" then
			return false
		end
		if starting then
			return false
		end
	end
		
	local ent = target:GetPhysicsObject()
	owner = findpartowner(target)
	
	if owner then
		if caller:GetClass() == "psw_cannonball" then
			if caller:GetOwner():IsPlayer() then
				if owner == caller:GetOwner():Team() then
					dmginfo:ScaleDamage(0)
					return dmginfo
				end
			end
		else
			dmginfo:ScaleDamage(0)
			return dmginfo
		end
		
		if target:GetName() == "ship" .. owner .. "mast1" then 
			if (caller:GetClass() == "psw_cannonball") && ents.FindByName( "ship" .. owner .. "weldmast1" )[1] then
				ents.FindByName( "ship" .. owner .. "weldmast1" )[1]:Fire("Break", "", 1)
				--timer.Simple(40, function() masts(mastid, owner) end)
				--Msg ("ship" .. owner .. "mast1 hit")
			end
		end
		if target:GetName() == "ship" .. owner .. "mast2" then
			if (caller:GetClass() ==  "psw_cannonball") && ents.FindByName( "ship" .. owner .. "weldmast2" )[1] then
				ents.FindByName( "ship" .. owner .. "weldmast2" )[1]:Fire("Break", "", 1)
				--timer.Simple(40, function() masts(mastid, owner) end)
				--Msg ("ship" .. owner .. "mast2 hit")
			end
		end
		if target:GetName() == "ship" .. owner .. "mast3" then
			if (caller:GetClass() == "psw_cannonball") && ents.FindByName( "ship" .. owner .. "weldmast3" )[1] then
				ents.FindByName( "ship" .. owner .. "weldmast3" )[1]:Fire("Break", "", 1)
				--timer.Simple(40, function() masts(mastid, owner) end)
				--Msg ("ship" .. owner .. "mast3 hit")
			end
		end
	end
	
	if string.find(target:GetName(), "ship") then
		if ent && ent:GetMass()>amount+5 then
			ent:SetMass(ent:GetMass()-amount)
		else
			ent:SetMass(5)
		end
		sink(owner)
	end
end

--Anounce winner
function winner(t)
	GAMEMODE.round_state = ROUND_INACTIVE
	
	if shipdata[1].sinking == true then
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTCENTER, "The Pirates Win!")
		end
	end
	
	if shipdata[2].sinking == true then
		for k,v in pairs(player.GetAll()) do
			v:PrintMessage(HUD_PRINTCENTER, "The Redcoats Win!")
		end
	end
	
	if (shipdata[1].sinking == true) or (shipdata[2].sinking == true) then -- If the team wins by sinking the ship
		for k,v in pairs(player.GetAll()) do
			v:ConCommand("endroundmusic")
		end
		
		sinktimer = timer.Create("SinkTimer", 1, shipdata[t].n, function() CountDown(t) end)--timer.Simple(n1, CountDown)
		
		-- sets all players to spectate after 25 seconds of the ship sinking
		kill = timer.Create("kill", 25, 1, function()
			for k,v in pairs(player.GetAll()) do
				timer.Simple(0.1, function()
					v:StripWeapons()
					v:Spectate(OBS_MODE_ROAMING)
				end)	
			end
		end)
		
		-- Spawn the ships and new round after 30 seconds 
		NewRoundAndSpawn = timer.Create("NewRoundAndSpawn", 30, 1, function() 
			newRound()
			timer.Simple(0.1, function()
				spawnships();
			end)	
		end)
		
	else -- If the team win by kill the other team
	
		kill = timer.Create("kill", 5, 1, function()
			for k,v in pairs(player.GetAll()) do
				timer.Simple(0.1, function()
					v:StripWeapons()
					v:Spectate(OBS_MODE_ROAMING)
				end)	
			end
		end)

		-- Spawn the ships and new round after 10 seconds 
		NewRoundAndSpawn = timer.Create("NewRoundAndSpawn", 10, 1, function() 
			newRound()
			timer.Simple(0.1, function()
				spawnships();
			end)	
		end)
	end
end

function opposingTeam( teamnum )
	if 1 then return 2 else return 1 end
end

function ents.GetByName( name, returnent )
	if returnent then return ents.FindByName( name )[1] end
	physent = ents.FindByName( name )[1]:GetPhysicsObject()
    return physent;
end

--[[function ENT:Touch( hitEnt1, hitEnt2 )
	if ( hitEnt1:GetClass() != "func_physbox" and hitEnt2:GetClass() != "func_breakable" ) then
		hitEnt2:Fire("break","",0)
	end
end]]--

---------------------------------
--Server Commands
---------------------------------
util.AddNetworkString("enableplayerslives")
util.AddNetworkString("Playerslives")
util.AddNetworkString("MaxRounds")
util.AddNetworkString("NoDoors")
util.AddNetworkString("friendlyfire")
util.AddNetworkString("nowaterdamage")
util.AddNetworkString("autoteambalance")
util.AddNetworkString("DisablePistol")
util.AddNetworkString("DisableMusket")
util.AddNetworkString("DisableSaber")
util.AddNetworkString("DisableGrenade")

net.Receive("enableplayerslives", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_enableplayerslives",rnrf)
	end
end)

net.Receive("Playerslives", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_playerslives",rnrf)
	end
end)

net.Receive("MaxRounds", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_maxrounds",rnrf)
	end
end)

net.Receive("NoDoors", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_nodoors",rnrf)
	end
end)

net.Receive("friendlyfire", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_friendlyfire",rnrf)
	end
end)

net.Receive("nowaterdamage", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_nowaterdamage",rnrf)
	end
end)

net.Receive("autoteambalance", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_autoteambalance",rnrf)
	end
end)
--Weapon Settings
net.Receive("DisablePistol", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_weaponPistol",rnrf)
	end
end)

net.Receive("DisableMusket", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_weaponMusket",rnrf)
	end
end)

net.Receive("DisableSaber", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_weaponSabre",rnrf)
	end
end)

net.Receive("DisableGrenade", function(len,ply)
	if ply:IsSuperAdmin() then
	local nrf = net.ReadFloat()
	local rnrf = (math.Round(nrf))
	RunConsoleCommand("psw_weaponGrenade",rnrf)
	end
end)

--Chat Commands
hook.Add( "PlayerSay", "thirdperson", function( ply, text )
	if( string.sub( text, 1, 12) == "!thirdperson" ) then
		umsg.Start( "thirdperson", ply )
		umsg.End()
		function SODVM()
			self.Owner:DrawViewModel( false )
		end
	end
end)

hook.Add( "PlayerSay", "firstperson", function( ply, text )
	if( string.sub( text, 1, 12) == "!firstperson" ) then
		umsg.Start( "firstperson", ply )
		umsg.End()
		function SODVM()
			self.Owner:DrawViewModel( true )
		end
	end
end)