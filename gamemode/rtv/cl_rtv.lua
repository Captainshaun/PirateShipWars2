if SERVER then return end

RTV.Voter = nil
RTV.Maps = {}
RTV.Keys = {}
local menuText = "Rock the Vote"

function RTV.CreatePanel()

	if (RTV.Voter and RTV.Voter:IsVisible()) then
		RTV.Voter:Remove()
	end

	if not GetGlobalBool( "In_Voting" ) then RTV.Keys = {} return end
	
	RTV.Voter = vgui.Create( "DFrame" )
	local pn = RTV.Voter -- It gets annoying typing that
	pn:SetSize( 300, 20 + (26*#RTV.Maps) )
	pn:SetPos( 5, ScrH() * 0.4 )
	pn:SetTitle( "" )
	pn:ShowCloseButton(false)
	pn:SetDraggable(false)
	pn.Paint = function( self, w, h )
		surface.SetDrawColor( Color( 13, 14, 15, 200) )
		surface.DrawOutlinedRect( 0, 0, w, h )

		surface.SetDrawColor( Color( 55, 55, 55, 170 ) )
		surface.DrawRect( 2, 2, w - 4, h - 4 )

		surface.SetTextColor( Color( 255, 255, 255, 255 ) )
		surface.SetFont( "pswsmall" )
		local w2, h2 = surface.GetTextSize( menuText )
		surface.SetTextPos( w/2 - w2/2, 5 )
		surface.DrawText( menuText )
	end

	local voted = false

	for k, v in ipairs( RTV.Maps ) do
		local text = vgui.Create( "DLabel", pn )
		text:SetFont( "pswsmall" )
		text:SetColor( Color( 255, 255, 255, 255 ) )
		text:SetText( tostring(k)..") "..v )
		text:SetPos( 5, (26 * k-1) )
		text:SizeToContents()
		RTV.Keys[k+1] = { text, v == "Extend Current Map" and "EXTEND" or k }
	end

	pn.Think = function( self )
		if not voted and GetGlobalBool( "In_Voting" ) and #RTV.Keys > 0 then
			for k, v in pairs( RTV.Keys ) do
				if input.IsKeyDown( k ) and v[1] then
					voted = true
					v[1]:SetColor( Color( 0, 255, 0, 255 ) )
					RunConsoleCommand( "rtv_vote", v[2] )
					surface.PlaySound( "garrysmod/save_load1.wav" )
				end
			end
		end
	end
end
concommand.Add( "rtv_cp", RTV.CreatePanel )

usermessage.Hook( "RTVoting", function()
	timer.Simple( 1, function()
		RTV.CreatePanel()
	end )
end )

net.Receive( "RTVMaps", function()
	RTV.Maps = net.ReadTable()
end )