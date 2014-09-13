AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Forts Cannon base Small"
ENT.Author			= "Thomas Hansen"
ENT.Model 			= "models/frigate01/cannon/cannonbasesmall.mdl"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if (SERVER) then

	function ENT:Initialize()
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local physical = self:GetPhysicsObject()
		if (physical:IsValid()) then
			physical:Wake()
		end

		local cannon = ents.Create("psw_fortscannonsmall")
		cannon:SetPos( self:GetPos() + Vector(0,0,7))
		local cannonangle = self:GetAngles() + Angle(0,180,0)
		cannon:SetAngles( cannonangle )
		cannon:Spawn()
		cannon:SetParent( self )

	end

	function ENT:Use( ply, caller )
		return
	end

end

if (CLIENT) then

	function ENT:Initialize()
		self.Color = Color(255,255,255,255)
	end

	function ENT:Draw()
		self.Entity:DrawModel()
	end
	
end
