AddCSLuaFile()

local BounceSound = Sound( "psw/impact1.wav" )

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
		self:PhysicsInitSphere( 6 )
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -6, -6, -6 ), Vector( 6, 6, 6 ) )
		phys:EnableGravity( false ) --We're going to make our own gravity below cause we're cool
		--self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)

		timer.Simple(5, function() if self:IsValid() then self:Remove() else return end end)
		
		local trail=util.SpriteTrail(self.Entity,0, Color(255, 255, 255, 30), false, 10, 0, 4, 1 / (5.38) * 0.5, "trails/smoke.vmt")

	end

	function ENT:PhysicsUpdate( phys )
		vel = Vector( 0, 0, ( ( -2 * phys:GetMass() ) * 2 ) )
		phys:ApplyForceCenter( vel )
	end

	function ENT:PhysicsCollide( data, physobj )
		if data.HitEntity then
			data.HitEntity:TakeDamage( 500, self.Owner )
		end
		if data.HitEntity:IsPlayer() || data.HitEntity:IsNPC() then
			local effectdata = EffectData()
			effectdata:SetStart( data.HitPos )
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 1 )
			util.Effect( "BloodImpact", effectdata )
			--self:Remove()
		end
		
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
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.4
		
		physobj:SetVelocity( TargetVelocity )
		
	end
end

if ( CLIENT ) then

	killicon.Add("psw_cannon", "killicons/sent_cball_killicon", Color(255,255,255,255))
	killicon.Add("psw_cannonball", "killicons/sent_cball_killicon", Color(255,255,255,255))

	local matBall = Material( "textures/Ship/cannonball" )

	/*---------------------------------------------------------
	   Name: Initialize
	---------------------------------------------------------*/
	function ENT:Initialize()

		self.Color = Color( 255, 150, 0, 255 )
		
		self.LightColor = Vector( 0, 0, 0 )

		self:DrawShadow( false )

		self:EmitSound("phx/explode0" .. math.random(1,6) .. ".wav", 511, math.random(50,150))
		
	end

	function ENT:Draw()
		
		self.Color = Color( 255, 150, 0, 255 )
		
		local pos = self:GetPos()
		local vel = self:GetVelocity()
			
		render.SetMaterial( matBall )
		
		render.DrawSprite( pos, 6, 6, Color( 58, 58, 58, 255 ) )
		
	end

end