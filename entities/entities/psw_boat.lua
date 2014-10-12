AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "Boat"
ENT.Category 		= "Pirate Ship Wars 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if (SERVER) then

	function ENT:SpawnFunction( ply, tr, ClassName )
		if (  !tr.Hit ) then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 16
		local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
		return ent
	end
	
	function ENT:Initialize()
		self:SetModel( "models/boat/boat1.mdl" )
	 
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
	 
		local physics = self:GetPhysicsObject()
	 
		if ( physics:IsValid() ) then
			physics:SetBuoyancyRatio( 0.025 )
			physics:Wake()
		end
	end
	
end

if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end