AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Category 			= "PSW Weapons"  
local MODEL = Model( "models/weapons/w_keg/w_keg.mdl" )

if (SERVER) then
	function ENT:Initialize()
		self:SetModel( MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self.nextUse=0

		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	
	function ENT:OnTakeDamage( dmg )
		local explode = ents.Create( "env_explosion" ) -- creates the explosion
			explode:SetPos( self.Entity:GetPos() )
			explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
			explode:SetKeyValue( "iMagnitude", 120 ) -- the magnitude
			explode:SetKeyValue( "iRadiusOverride", 200 )
			explode:Fire( "Explode", 0, 0 )	
			explode:Spawn() -- this actually spawns the explosion
			explode:Activate()
		self:Remove();
	end
	
	function ENT:Use(ply,caller)
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+0.5
		if ply:IsPlayer() then
			if self.Entity:GetName() == "ship1explosive" then
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Player "..ply:GetName().." has set a fuse on the powder stores and will explode in 5 seconds" )
				end
			end
			if self.Entity:GetName() == "ship2explosive" then
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Player "..ply:GetName().." has set a fuse on the powder stores and will explode in 5 seconds" )
				end
			end
			explosion = timer.Create("explosion", 5, 1, function()
				local explode = ents.Create( "env_explosion" ) -- creates the explosion
				explode:SetPos( self.Entity:GetPos() )
				explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
				explode:SetKeyValue( "iMagnitude", 120 ) -- the magnitude
				explode:SetKeyValue( "iRadiusOverride", 200 )
				explode:Fire( "Explode", 0, 0 )	
				explode:Spawn() -- this actually spawns the explosion
				explode:Activate()
				self:Remove();
			end)
		end
	end
end

if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end