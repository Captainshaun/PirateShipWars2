include( "shared.lua" )

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw( assssss )
	self:DrawModel()
end

function ENT:DrawTranslucent( bDontDrawModel )

	self:Draw()

end