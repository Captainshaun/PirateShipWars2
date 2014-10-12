AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Ships Cannon"
ENT.Author			= "Thomas Hansen"
ENT.Model 			= "models/frigate01/cannon/cannonbase.mdl"
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
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		local physical = self:GetPhysicsObject()
		if (physical:IsValid()) then
			physical:Wake()
		end

		local cannon = ents.Create("psw_shipscannon")
		cannon:SetPos( self:GetPos() + Vector(0,0,12))
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
