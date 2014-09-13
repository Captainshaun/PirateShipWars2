local SKIN = {}
SKIN.fontFrame = "pswsmall"

function GM:ForceDermaSkin()
	return "pswskin"
end
derma.DefineSkin("pswskin", "Derma skin for Pirate Ship Wars", SKIN, "Default")

function SKIN:DrawGenericBackground(x, y, w, h, color)
	draw.RoundedBox(8, x, y, w, h, color)
end

local black_alpha220 = Color(0, 0, 0, 220)
function SKIN:PaintFrame(panel)
	local pw, pt = panel:GetSize()
	draw.RoundedBox(6, 0, 0, pw, pt, black_alpha220)
	
	if panel.m_DrawStylishBackground then
		DrawStylishBackground(panel)
	end
end

function SKIN:PaintTab( panel )
	// This adds a little shadow to the right which helps define the tab shape..
	draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall() + 8, self.colTabShadow )
	
	if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
		draw.RoundedBox( 4, 1, 0, panel:GetWide()-2, panel:GetTall() + 8, self.colTab )
	end
end

SKIN.fontTab					= "pswsmall"
SKIN.colPropertySheet 			= Color( 0, 0, 0, 0 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabInactive				= Color( 0, 0, 0, 0 )
SKIN.colTabShadow				= Color( 0, 0, 0, 0 )
SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
SKIN.colTabTextInactive			= Color( 0, 0, 0, 155 )