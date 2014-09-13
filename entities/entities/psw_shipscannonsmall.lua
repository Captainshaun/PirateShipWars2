AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Ships Cannon Small"
ENT.Author			= "Thomas Hansen"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.NextAttack = CurTime()
ENT.LastThink = CurTime()

if (SERVER) then
	function ENT:Initialize()
		self:SetModel( "models/Frigate01/cannon/cannonsmall.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self.nextUse=0
	end
	
	function ENT:Use(ply,caller)
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+0.5
		if ply:IsPlayer() then
			if !ply:KeyPressed(IN_USE) then return end
			ply:SetMoveType(0)
			ply:SetGravity(0)
			ply:DrawViewModel(false)
			--ply:StripWeapons()
			self.Entity:SetOwner(ply)
			self.weps = {}
			for k,v in pairs(ply:GetWeapons()) do
				table.insert(self.weps, v:GetClass());
			end
			ply:StripWeapons();
			self.owner = ply;
		end
	end
	
	function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsPlayer() then

		local ownerpos = owner:GetPos()
		local cannonpos = self:GetPos()

		if cannonpos:Distance(ownerpos) > 120 then
			self:SetOwner( self:GetParent() )
			owner:DrawViewModel(true)
			owner.Cannon = false
			for k,v in pairs(self.weps) do
				self.owner:Give(tostring(v));
			end
			self.owner = NULL;
			return 
		end

		if (self.Entity:GetOwner():KeyPressed(IN_USE)) then
			self.nextUse = CurTime()+0.5
			return
		end
		
		if self.Entity:GetOwner():KeyDown(IN_USE) then
			if self.nextUse<=CurTime() then
				self.nextUse = CurTime()+0.5
				self:SetOwner( self:GetParent() )
				owner:SetParent()
				owner:SetMoveType(2)
				owner:SetGravity(1)
				owner:DrawViewModel(true)
				owner = false
				for k,v in pairs(self.weps) do
					self.owner:Give(tostring(v));
				end
				self.owner = NULL;
				return 
			end
		end

		local ang = owner:GetAimVector( ):Angle()
		local bang = self:GetParent():GetAngles() + Angle(0,180,0)--Base Angle ;)
		--local bang = self:GetAngles()
		--local bang = self:GetLocalAngularVelocity( )
		
		local pang = math.AngleDifference( bang.p, ang.p )
		local yang = math.AngleDifference( bang.y, ang.y )
			
		if pang > 15 then
			ang.p = (bang - Angle(15,0,0)).p
		end
		if pang < (0 - 15) then
			ang.p = (bang + Angle(15,0,0)).p
		end
		if yang > 5 then
			ang.y = (bang - Angle(0,5,0)).y
		end
		if yang < (0 - 5) then
			ang.y = (bang + Angle(0,5,0)).y
		end

		self:SetAngles( ang )

		if (SERVER) then
			if self.NextAttack < CurTime() then
				if owner:KeyDown(IN_ATTACK) then
					self.NextAttack = CurTime() + 4
					self:EmitShootEffects()

					local ball = ents.Create("psw_cannonball")
					ball:SetPos( (self:GetPos() + self:GetForward() * 100) + Vector(0,0,0) )
					ball:SetAngles(self:GetAngles())
					ball:SetOwner( owner )
					ball:Spawn()
					ball:Activate()
					ball:GetPhysicsObject():SetVelocity(self:GetForward() * 8000)
				end
			end
		end
	end

	if self:GetAngles() != self:GetParent():GetAngles() then
		
	end

	self.LastThink = CurTime()
	
	end
end

if (CLIENT) then
	function ENT:Initialize()
		self.Color = Color(255,255,255,255)
	end

	function ENT:Draw()
		self:DrawModel()
	end
	
end

function ENT:EmitShootEffects() 
	local Effect = EffectData()
    Effect:SetOrigin(self:LocalToWorld(Vector(25, -0, 0)))
	Effect:SetStart(self:GetForward() * 850 * 1.4)
    util.Effect("cannon_muzzleblast", Effect, true, true)
	
    util.ScreenShake(self:GetPos(), 20, 4, math.Rand(0.3, 0.6), 320)
end