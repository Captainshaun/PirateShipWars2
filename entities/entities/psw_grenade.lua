AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "Powder Keg"
ENT.Category 		= "Pirate Ship Wars 2"

ENT.Spawnable			= false
ENT.AdminSpawnable		= true

if CLIENT then
	killicon.Add("psw_grenade", "HUD/keg", Color(255,255,255,255))
end

function ENT:PhysicsCollide(data,phys)
	if (CLIENT) then
		if data.Speed > 50 then
			self:EmitSound(Sound("HEGrenade.Bounce"))
		end
	end
	if (SERVER) then
		local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -.4) --.4 .6
		phys:ApplyForceCenter(impulse)
	end
end

function ENT:Initialize()

	if (SERVER) then
		self:SetModel("models/weapons/w_keg/w_keg.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
			
		-- Don't collide with the player
		--self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	
	self.timer = CurTime() + 3
end

function ENT:Think()
	if self.timer < CurTime() then
		if (SERVER) then
			local range = 512
			local damage = 0
			local pos = self:GetPos()
			
			self:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
			self:Remove()
			
			orgin_ents = ents.FindInSphere( pos, 150 )
			for a=1, #orgin_ents do
				if orgin_ents[a]:GetClass() == "player" then
					if ( orgin_ents[a]:Team() != self.Owner:Team() ) or ( orgin_ents[a] == self.Owner ) then
						expdmg = 150 - pos:Distance( orgin_ents[a]:GetPos() )
						orgin_ents[a]:TakeDamage( expdmg, self.Owner )
					end
				end
			end
			
			local explode = ents.Create( "env_explosion" ) -- creates the explosion
			explode:SetPos( self.Entity:GetPos() )
			explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
			explode:SetKeyValue( "iMagnitude", 120 ) -- the magnitude
			explode:SetKeyValue( "iRadiusOverride", 500 )
			explode:Fire( "Explode", 0, 0 )	
			explode:Spawn() -- this actually spawns the explosion
			explode:Activate()
		end
	end
end
