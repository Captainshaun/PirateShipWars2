AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "Explosive Barrel"
ENT.Category 		= "Pirate Ship Wars 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

local MODEL = Model( "models/weapons/w_keg/w_keg.mdl" )

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
		self:SetModel( MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		--self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self.nextUse=0

		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	
	function ENT:OnTakeDamage( dmg )
		self:Explode()
	end
	
	function ENT:Use(ply,caller)
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+6
		if ply:IsPlayer() then
			if self.Entity:GetName() == "ship1explosive" or self.Entity:GetName() == "ship2explosive" then
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Player "..ply:GetName().." has set a fuse on the powder stores and will explode in 5 seconds" )
				end
				timer.Create("explosion", 5, 0, function() self:Explode() end)
			else
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Player "..ply:GetName().." has set a fuse on the powder stores and will explode in 5 seconds" )
				end	
				timer.Create("explosion", 5, 0, function() self:Explode() end)
			end
		end
	end
	
	function ENT:Explode()
		explosion = timer.Create("explosion", 0.01, 1, function()
			local explode = ents.Create( "env_explosion" ) -- creates the explosion
			explode:SetPos( self.Entity:GetPos() )
			explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
			explode:SetKeyValue( "iMagnitude", 2000 ) -- the magnitude
			explode:SetKeyValue( "iRadiusOverride", 400 )
			explode:Fire( "Explode", 0, 0 )	
			explode:Spawn() -- this actually spawns the explosion
			explode:Activate()
			self:Remove();
		end)
	end
end

if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end