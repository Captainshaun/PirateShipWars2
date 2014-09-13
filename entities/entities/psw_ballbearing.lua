AddCSLuaFile()

local BounceSound = Sound( "phx/epicmetal_hard6.wav" )

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"


ENT.PrintName		= "Ball Bearing"
ENT.Author			= "Thomas Hansen"

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/

if ( SERVER ) then
	function ENT:Initialize()

		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( 1 )
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
		phys:EnableGravity( false ) --We're going to make our own gravity below cause we're cool
		
		timer.Simple(4, function() if self:IsValid() then self:Remove() else return end end)
		
		local trail=util.SpriteTrail(self.Entity,0, Color(255, 255, 255, 30), true, 2, 0, 3, 1 / (5.38) * 0.5, "trails/smoke.vmt")

	end

	function ENT:PhysicsUpdate( phys )
		vel = Vector( 0, 0, ( ( -9.81 * phys:GetMass() ) * 0.65 ) )
		phys:ApplyForceCenter( vel )
	end

	function ENT:PhysicsCollide( data, physobj, dmg )
		if data.HitEntity then
			data.HitEntity:TakeDamage( 100, self.Owner )
		end
		if data.HitEntity:IsPlayer() || data.HitEntity:IsNPC() then
			local effectdata = EffectData()
			effectdata:SetStart( data.HitPos )
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 1 )
			util.Effect( "BloodImpact", effectdata )
			self:Remove()
		end
		
--[[		
		-- Play sound on bounce
		if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then
			sound.Play( BounceSound, self:GetPos(), 75, math.random( 90, 120 ), math.Clamp( data.Speed / 150, 0, 1 ) )
		end
		
		-- Bounce like a crazy bitch
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity:Normalize()
		NewVelocity = NewVelocity / 2
		
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.9
		
		physobj:SetVelocity( TargetVelocity )
]]--		
	end

end

if ( CLIENT ) then

	local matBall = Material( "textures/Ship/cannonball" )

	function ENT:Initialize()
		self.Color = Color( 255, 150, 0, 255 )
		self.LightColor = Vector( 0, 0, 0 )
		self:DrawShadow( false )
	end

	function ENT:Draw()
		self.Color = Color( 255, 150, 0, 255 )
		
		local pos = self:GetPos()
		local vel = self:GetVelocity()
		render.SetMaterial( matBall )
		render.DrawSprite( pos, 1, 1, Color( 58, 58, 58, 255 ) )
	end

end