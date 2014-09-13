AddCSLuaFile()

ENT.Type 			= "anim"
ENT.SAIL = Model( "" )

if (SERVER) then
	function ENT:Initialize()
		self:SetModel( self.MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )

		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

if (CLIENT) then
	function ENT:Initialize()
		local c_Model = ClientsideModel( self.SAIL, RENDERGROUP_BOTH )
		c_Model:SetPos( self:GetPos() )
		c_Model:SetAngles( self:GetAngles() )
		c_Model:SetParent( self )
		c_Model:SetColor(Color(255,255,255,255))
		c_Model:Spawn()
	
		--timer.Simple(5, function() c_Model:Remove() end)
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
end