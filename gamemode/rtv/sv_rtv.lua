RTV.VTab = {}
for i = 1, 9 do
	RTV.VTab["MAP_"..i] = 0
end
RTV.VTab["MAP_EXTEND"] = 0

RTV.Limit = math.Clamp( RTV.Limit, 2, 8 )

RTV.Maps = {}

RTV.TotalVotes = 0

RTV._ActualWait = CurTime() + RTV.Wait

local get = 0

local files, dirs = file.Find( "maps/*.bsp", "GAME" )

if RTV.UsePrefixes then
	for k, v in RandomPairs( files ) do
		if get >= RTV.Limit then 
			RTV.Maps[#RTV.Maps+1] = "Extend Current Map"
			break 
		end
		if string.gsub(v, ".bsp", "") == game.GetMap() then continue end
		for _, prefix in pairs( RTV.Prefixes ) do
			prefix = string.lower(prefix)
			if string.sub( string.lower(v), 0, #prefix ) == prefix then
				RTV.Maps[#RTV.Maps+1] = string.gsub( v, ".bsp", "" )
				get = get + 1
			end
		end
	end
end

SetGlobalBool( "In_Voting", false )

util.AddNetworkString( "RTVMaps" )

function RTV.ShouldChange()
	return RTV.TotalVotes >= math.Round(#player.GetAll()*0.66)
end

function RTV.RemoveVote()
	RTV.TotalVotes = math.Clamp( RTV.TotalVotes - 1, 0, math.huge )
end

function RTV.Start()
	SetGlobalBool( "In_Voting", true )
	for k, v in pairs( player.GetAll() ) do
		net.Start( "RTVMaps" )
			net.WriteTable( RTV.Maps )
		net.Send( v )
		umsg.Start( "RTVoting", v )
		umsg.End()
	end
	timer.Simple( 30, function()
		RTV.Finish()
	end )
end

concommand.Add( "rtv_start2", RTV.Start )

function RTV.ChangeMap(map)
	if not map then return end
	RunConsoleCommand( "gamemode", GAMEMODE.FolderName )
	RunConsoleCommand( "changelevel", map )
end
concommand.Add( "rtv_changemap", RTV.ChangeMap )

concommand.Add( "rtv_vote", function( ply, cmd, args )
	if not (ply and ply:IsValid()) then return end
	if not GetGlobalBool( "In_Voting" ) then
		ply:PrintMessage( HUD_PRINTTALK, "There is no vote in progress, you are a dumbass." )
		return
	end
	if ply.MapVoted then
		ply:PrintMessage( HUD_PRINTTALK, "You have already voted!" )
		return
	end

	local vote = args[1]

	if not vote then
		ply:PrintMessage( HUD_PRINTTALK, "What are you doing?" )
		return
	end
	if not tonumber(vote) then
		if vote == "EXTEND" then
			RTV.VTab["MAP_EXTEND"] = RTV.VTab["MAP_EXTEND"] + 1
			ply.MapVoted = true
			ply:PrintMessage( HUD_PRINTTALK, "You have voted to extend the map!" )
			return
		end
		ply:PrintMessage( HUD_PRINTTALK, "What are you doing?" )
		return
	end

	vote = math.Clamp( tonumber(vote), 1, #RTV.Maps )

	RTV.VTab["MAP_"..vote] = RTV.VTab["MAP_"..vote] + 1
	ply.MapVoted = true
	ply:PrintMessage( HUD_PRINTTALK, "You have voted for "..RTV.Maps[vote].."!" )
end )

function RTV.Finish()
	SetGlobalBool( "In_Voting", false )
	RTV.TotalVotes = 0

	umsg.Start( "RTVoting" )
	umsg.End()

	for k, v in pairs( player.GetAll() ) do
		v.RTVoted = false
		v.MapVoted = false
	end

	local top = 0
	local winner = nil

	for k,v  in pairs( RTV.VTab ) do
		if v > top then
			top = v
			winner = k
		end
		RTV.VTab[k] = 0
	end

	if top <= 0 then
		PrintMessage( HUD_PRINTTALK, "Vote failed! No one voted." )
	elseif winner then

		winner = string.gsub( winner, "MAP_", "" )

		if winner == "EXTEND" then
			PrintMessage( HUD_PRINTTALK, "Rock the Vote has spoken! Extending the current map!" )
			RTV._ActualWait = RTV.Wait*2
			RTV.Maps = {}
			local get = 0
			local files, dirs = file.Find( "maps/*.bsp", "GAME" )
			if RTV.UsePrefixes then
				for k, v in RandomPairs( files ) do
					if get >= RTV.Limit then 
						RTV.Maps[#RTV.Maps+1] = "Extend Current Map"
						break 
					end
					if string.gsub(v, ".bsp", "") == game.GetMap() then continue end
					for _, prefix in pairs( RTV.Prefixes ) do
						prefix = string.lower(prefix)
						if string.sub( string.lower(v), 0, #prefix ) == prefix then
							RTV.Maps[#RTV.Maps+1] = string.gsub( v, ".bsp", "" )
							get = get + 1
						end
					end
				end
			end
		else
			winner = math.Clamp( tonumber(winner) or 1, 1, #RTV.Maps )
			PrintMessage( HUD_PRINTTALK, "The winning map is "..RTV.Maps[winner].."!" )
			RTV.ChangingMaps = true
			PrintMessage( HUD_PRINTTALK, "Changing the map to "..RTV.Maps[winner].." at the end of the round" )
			RTV.ChangeMap( RTV.Maps[winner] )
		end
	else
		PrintMessage( HUD_PRINTTALK, "Voting fucked up. RIP" )
	end
end

function RTV.AddVote( ply )
	if RTV.CanVote( ply ) then
		RTV.TotalVotes = RTV.TotalVotes + 1
		ply.RTVoted = true
		MsgN( ply:Nick().." has voted to Rock the Vote." )
		PrintMessage( HUD_PRINTTALK, ply:Nick().." has voted to Rock the Vote. ("..RTV.TotalVotes.."/"..math.Round(#player.GetAll()*0.66)..")" )
		if RTV.ShouldChange() then
			RTV.Start()
		end
	end
end

hook.Add( "PlayerDisconnected", "Remove RTV", function( ply )
	if ply.RTVoted then
		RTV.RemoveVote()
	end
	timer.Simple( 0.1, function()
		if RTV.ShouldChange() then
			RTV.Start()
		end
	end )
end )

function RTV.CanVote( ply )
	if RTV._ActualWait >= CurTime() then
		return false, "You must wait a bit before voting!"
	end
	if GetGlobalBool( "In_Voting" ) then
		return false, "There is currently a vote in progress!"
	end
	if ply.RTVoted then
		return false, "You have already voted to Rock the Vote!"
	end
	if RTV.ChangingMaps then
		return false, "There has already been a vote, the map is going to change!"
	end
	return true
end

function RTV.StartVote( ply )
	local can, err = RTV.CanVote(ply)
	if not can then
		ply:PrintMessage( HUD_PRINTTALK, err )
		return
	end
	RTV.AddVote( ply )
end

concommand.Add( "rtv_start", RTV.StartVote )

hook.Add( "PlayerSay", "RTV Chat Commands", function( ply, text )
	if table.HasValue( RTV.ChatCommands, string.lower(text) ) then
		RTV.StartVote( ply )
		return ""
	end
end )