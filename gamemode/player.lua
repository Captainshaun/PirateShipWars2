---------------------------------
--Death Functions
---------------------------------
function GM:PlayerDeath( Victim, Inflictor, Attacker )

	--[[if GetConVarNumber( "psw_enableplayerslives" ) == 1 then
		if Victim.lives < 1 then
			Victim.canSpawn = false
			local teamAlive = false
			for k,v in pairs(team.GetPlayers(Victim:Team())) do
				if v.canSpawn then
					teamAlive = true
				end
			end
			if !teamAlive then
			winner(opposingTeam(Victim:Team()))
			end
		end
   
   	Victim.lives = Victim.lives - 1
	
	local killadd = Victim:GetNWInt("kills") + 1
	Victim:SetNWInt("lives",lives)
	end]]--
	
	-- Don't spawn for at least 4 seconds 
	Victim.NextSpawnTime = CurTime() + 4
	
	-- Convert the inflictor to the weapon that they're holding if we can. 
	-- This can be right or wrong with NPCs since combine can be holding a  
	-- pistol but kill you by hitting you with their arm. 
	
	if ( !Attacker:IsPlayer() ) && ( Attacker:GetOwner() ) then
		
		if Attacker:GetOwner():IsValid() then
			if Attacker:GetOwner():IsPlayer() then
				Attacker = Attacker:GetOwner()
			end
		end
		
	end
	
	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then 
	 
		Inflictor = Inflictor:GetActiveWeapon() 
		if ( Inflictor == NULL ) then Inflictor = Attacker end 
	 
	end 
	 
	if (Attacker == Victim) then 
	 
		umsg.Start( "PlayerKilledSelf" ) 
			umsg.Entity( Victim ) 
		umsg.End() 
		 
		MsgAll( Attacker:Nick() .. " suicided!\n" ) 

	return end 
   
	if ( Attacker:IsPlayer() ) then 
	 
		umsg.Start( "PlayerKilledByPlayer" ) 
		 
			umsg.Entity( Victim ) 
			umsg.String( Inflictor:GetClass() ) 
			umsg.Entity( Attacker ) 
		 
		umsg.End() 
		 
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" ) 
		
		--Attacker:AddEXP(5)
		
	return end 
	 
	umsg.Start( "PlayerKilled" ) 
	 
		umsg.Entity( Victim ) 
		umsg.String( Inflictor:GetClass() ) 
		umsg.String( Attacker:GetClass() ) 
	
	umsg.End() 
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" ) 
	
end 

--[[local function OnNPCKilled( victim, killer, weapon )
	killer:AddEXP(5)
end
hook.Add("OnNPCKilled", "Give5Points", OnNPCKilled)]]--
---------------------------------
--Spawning Functions
---------------------------------
function enableSpawning()
	GAMEMODE.round_state = ROUND_ACTIVE
	for k,v in pairs(player.GetAll()) do
		v.canSpawn = true
		--v.lives = GetConVarNumber("psw_playerslives")
		v:KillSilent( ) 
	end
end
timer.Simple(5, enableSpawning)

function GM:PlayerInitialSpawn( ply )

	--ply:LoadPts()
	--MsgN ( 'Points have been Loaded!')
	
	--ply:SetNWInt("lives",GetConVarNumber("psw_playerslives"))
	--ply.lives = GetConVarNumber("psw_playerslives")
	
  	if (GAMEMODE.round_state == ROUND_ACTIVE) then
  		ply.canSpawn = true
  	end
	
	ply:PrintMessage(HUD_PRINTTALK, "Change Team? Press F2")
	ply:SetTeam(TEAM_SPECTATE)
	ply:SetNoCollideWithTeammates(true)
	ply:SetCustomCollisionCheck(true)
	
	local bb = team.NumPlayers(TEAM_BLUE)
	local rr = team.NumPlayers(TEAM_RED)
	if ply:Team()== TEAM_SPECTATE then
		if bb==rr then
			ply:SetTeam(TEAM_RED)
		elseif bb>rr then
			ply:SetTeam(TEAM_RED)
		else
			ply:SetTeam(TEAM_BLUE)
		end
	end
	if bb > (rr + 1) then
		ply:SetTeam(TEAM_RED)
	elseif (rr > bb + 1) then
		ply:SetTeam(TEAM_BLUE)
	end
	
	ply.temp = 98.6
	ply.heal = false
	ply.lastpos = nil
	ply.kd = 0
	ply.lastspawn = nil
	ply.parented = false
	ply:Freeze(true)
	ply.UsingCannon = 0
	
end

function GM:PlayerSpawn( ply )
	if (GAMEMODE.round_state == ROUND_ACTIVE) then
		ply:UnSpectate()
		ply:Freeze(false)
		ply:GodDisable(false)
		ply:SprintDisable()
		ply.temp = 98.6
		pang = ply:GetAngles()
		ply:SetAngles(Angle(0, pang.y, 0))
		GAMEMODE:PlayerLoadout( ply )
		GAMEMODE:PlayerSetModel( ply )
		GAMEMODE:SetPlayerSpeed( ply, 250, 300 )	
		if ply:Team() == TEAM_SPECTATE then
			ply:Spectate(OBS_MODE_ROAMING)
			return
		end
	end
end

function GM:PlayerSelectSpawn( ply ) --Returns correct spawn point for team
	if GetConVarNumber("psw_autoteambalance")>=1 then
		local bb = team.NumPlayers(TEAM_BLUE)
		local rr = team.NumPlayers(TEAM_RED)
		if bb > (rr + 1) then
			ply:SetTeam(TEAM_RED)
		elseif (rr > bb + 1) then
			ply:SetTeam(TEAM_BLUE)
		end
	end
	
	if ply:Team()==TEAM_BLUE then --Defines player spawns
		local spawns = ents.FindByClass( "psw_bluespawn" )
		local random_entry = math.random(#spawns)
		return spawns[random_entry]
	elseif ply:Team()==TEAM_RED then
		local spawns = ents.FindByClass( "psw_redspawn" )
		local random_entry = math.random(#spawns)
		return spawns[random_entry]
	elseif ply:Team()==TEAM_SPECTATE then
		local spawns = ents.FindByClass( "psw_redspawn" )
		local spawns = ents.FindByClass( "psw_bluespawn" )
		local random_entry = math.random(#spawns)
		return spawns[random_entry]
	end	
end

---------------------------------
--Players Loadout
---------------------------------
function GM:PlayerLoadout( ply )

	if ply:Team() == TEAM_SPECTATE then return end
	
	if ply:Team() == TEAM_BLUE || ply:Team() == TEAM_RED then
		if GetConVarNumber("psw_weaponSabre")>=1 then
			ply:Give("weapon_psw_sabre")
		end
		
		if GetConVarNumber("psw_weaponGrenade")>=1 then
			ply:Give("weapon_psw_grenade")
		end
		
		if GetConVarNumber("psw_weaponmusket")>=1 then
			ply:Give("weapon_psw_musket")
		end
		
		if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
			ply:Give("weapon_physgun")
		end
		
		ply:GiveAmmo(7,"pistol");
	end
	
	if ply:Team() == TEAM_RED then
		if GetConVarNumber("psw_weaponPistol")>=1 then
			ply:Give("weapon_psw_pistol")
		end
	end

	if ply:Team() == TEAM_BLUE then
		if GetConVarNumber("psw_weaponPistol")>=1 then
			ply:Give("weapon_psw_pistol2")
		end
	end
	
end

function GM:PlayerSetModel( ply )

	if ply:Team() == TEAM_SPECTATE then return end
	
	if ply:Team() == TEAM_BLUE then
		ply:SetModel( "models/player/skirmisher/skirmisher.mdl" )
	end
	if ply:Team() == TEAM_RED then
		ply:SetModel( "models/player/sharpshooter/sharpshooter.mdl" )
	end
 
end

---------------------------------
--Other
---------------------------------
function GM:PlayerConnect( ply )
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, ply:Name().. " 'ave joined the battle.")
	end
end

function GM:PlayerDisconnected( ply )

	--ply:SavePts()
	--MsgN ( 'Points have been saved!')
	
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTTALK, ply:Name().. " has fled the battle." )
	end
end

function GM:PlayerUse( ply, entity )
	if ply:Team()== TEAM_SPECTATE then 
		return false
	else 
		return true
	end
end

function GM:PlayerNoClip( ply )
	if ( ply:IsAdmin() or ply:IsSuperAdmin() ) then
		return true
	end
end

--Disable Water Damage
hook.Add("PlayerShouldTakeDamage", "No trigger_hurt", function(ply, attacker)
	if(attacker:GetName() == "pswwaterdamage" and GetConVarNumber( "psw_nowaterdamage" ) == 1) then
		return false;
	end
	
	--[[if(attacker:GetClass() == "trigger_hurt" and GetConVarNumber( "psw_nowaterdamage" ) == 1) then
		return false;
	end]]--
end);

function GM:PlayerShouldTakeDamage( victim, pl )
	if pl:IsPlayer() then -- check the attacker is player 	
		if( pl:Team() == victim:Team() and GetConVarNumber( "psw_friendlyfire" ) == 0 ) then -- check the teams are equal and that friendly fire is off.
				return false -- do not damage the player
			end
		end
	return true -- damage the player
end

--Extinguish Player on Fire and Breath Underwater in case of water damage disabled
hook.Add( "Think", "LimitedBreath", function(ply)
	for k, v in pairs( player.GetAll() ) do
		if v:Alive() then
			if v:WaterLevel() == 3 then
				if v:IsOnFire() then
				   v:Extinguish()
				end
				if v.NextHurt < CurTime() then
					v:TakeDamage( 5 )
					v.NextHurt = CurTime() + 1
				end
			else
				v.NextHurt = CurTime() + 10
			end
		end
	end
end )