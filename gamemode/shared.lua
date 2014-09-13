GM.Name		= "Pirate Ship Wars 2"
GM.Author	= "Thomas Hansen"
GM.Email	= ""
GM.Website	= ""

--DeriveGamemode( "sandbox" )

--Team setup
TEAM_RED	= 1
TEAM_BLUE	= 2
TEAM_JOINING	= 3
TEAM_SPECTATE	= 4

team.SetUp(TEAM_RED, "Redcoats", Color(240,40,40,255) )
team.SetUp(TEAM_BLUE, "Pirates", Color(40,40,240,255) ) --RGBA
team.SetUp(TEAM_JOINING, "Joining", Color(75,75,75,100) )
team.SetUp(TEAM_SPECTATE, "Spectating", Color(50,50,50,255) )

resource.AddFile("resource/akbar.ttf")

CreateConVar("psw_nodoors",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Removes Ships Explosive Barrel")
CreateConVar("psw_friendlyfire",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Toggle Friendly Fire")
CreateConVar("psw_nowaterdamage",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Disable Water Damage")
CreateConVar("psw_autoteambalance",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Keeps Teams Balanced")
CreateConVar("psw_enableplayerslives",0,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Enables Players lives System")
CreateConVar("psw_playerslives",6,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Players lives")
CreateConVar("psw_maxrounds",4,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Rounds per map")
CreateConVar("psw_weaponMusket",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Disable Musket")
CreateConVar("psw_weaponGrenade",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Disable Grenade")
CreateConVar("psw_weaponPistol",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Disable Pistol")
CreateConVar("psw_weaponSabre",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Disable Sabre")

GM.HELP = [[
In this gamemode there are 2 teams, Pirates and Redcoats. The Objective of this Gamemode is 
to sink the Enemy ship or to board them and kill its crew.
 
Menus:
F1 - Main Menu
F2 - Change Teams 
F3 - Client and Admin options 
 
Chat Commands:
!RTV- Vote for the next map
!FirstPerson- Change to First Person View, this can also be toggled in the F2 menu
!ThirdPerson - Change to Third Person View, this can also be toggled in the F2 menu
]]

GM.Credits = [[
Garry's Mod 13 - Pirate Ship Wars 2.0
	Thomas 'g\mail termy58' Hansen
	CaptainShaun
 				
Garry's Mod 10 - Pirate Ship Wars
	EmpV
	Metroid48
	Thomas 'g\mail termy58' Hansen
 					
Gmod 9 Original - Pirate Ship Wars
	EmpV
  
Also thanks to the artists who have contributed various weapon models
and also Battlegrounds Source 1 mod for the original player model
]] 