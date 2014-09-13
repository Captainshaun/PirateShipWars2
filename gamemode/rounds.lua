roundsDone = 0

function newRound()
	roundsDone = roundsDone+1
	if roundsDone == GetConVarNumber("psw_maxrounds") -1 then
		PrintMessage( HUD_PRINTTALK, "Last round before map restart!") -- Gives the message
	end
	if roundsDone >= GetConVarNumber("psw_maxrounds") then
		RunConsoleCommand( "rtv_start2" )
	end
	--Updates scores and respawbn players
	--team.AddScore(opposingTeam( v ),30)

	timer.Remove("SinkTimer")
	enableSpawning()
		
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals")
	end	
	
end