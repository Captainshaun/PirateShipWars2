
do
	DEFINE_BASECLASS( "drive_base" )
	local DRIVE = {}
	
	function DRIVE:Init()
		self.LastMove = CurTime()
	end
	
	function DRIVE:CalcView()
		view = {}
		view.origin = self.Entity:GetPos() + Vector(0,0,200)
		view.angles = self.Entity:GetAngles()
		return view
	end
	
	function DRIVE:SetupControls()
	end
	
	function DRIVE:StartMove( md, cmd )
		--md:SetForwardSpeed( md:KeyDown( IN_FORWARD ) and 1 or ( md:KeyDown( IN_BACK ) and -1 or 0 ) )
		--md:SetSideSpeed( md:KeyDown( IN_MOVERIGHT ) and 1 or ( md:KeyDown( IN_MOVELEFT ) and -1 or 0 ) )
		--md:SetOrigin( self.Entity:GetNetworkOrigin() )
	end
	function DRIVE:Move( md )
	end
	
	function DRIVE:FinishMove( md )
	end
	drive.Register( "drive_helm", DRIVE )
end