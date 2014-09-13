AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pirate Ship Helm"
ENT.Author			= "Thomas Hansen"
ENT.Model  			= "models/frigate01/shipsother/lantern01.mdl"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if ( SERVER ) then

	function ENT:Initialize()

		self:SetModel( self.Model )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local physical = self:GetPhysicsObject()
		if (physical:IsValid()) then
			physical:Wake()
		end

		Msg( self.team )

	end

	function ENT:Use( ply, caller )
		return
	end

end

if (CLIENT) then

	function ENT:Initialize()
		self.Color = Color(255,255,255,0)
	end

	function ENT:Draw()
		self.Entity:DrawModel()
	end

end
