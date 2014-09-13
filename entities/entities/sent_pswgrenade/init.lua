AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: OnTakeDamage
   Desc: Entity takes damage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
/*
	Msg( tostring(dmginfo) .. "\n" )
	Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
	Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
	Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
	Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
	Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
	Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
	Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" )	// ??
*/
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -.4) --.4 .6
	phys:ApplyForceCenter(impulse)
end

function ENT:Initialize()
	self.Entity:SetModel("models/powdergrenade/powdergrenade.mdl")
 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.timer = CurTime() + 3
end

function ENT:Think()
	if self.timer < CurTime() then
		if (SERVER) then	
			self.Entity:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
			self.Entity:Remove()
			
			local explode = ents.Create( "env_explosion" ) -- creates the explosion
			explode:SetPos( self.Entity:GetPos() )
			explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
			explode:SetKeyValue( "iMagnitude", 120 ) -- the magnitude
			explode:SetKeyValue( "iRadiusOverride", 500 )
			--explode:SetKeyValue( "iIgnoredClass", "func_breakable" )
			explode:Fire( "Explode", 0, 0 )	
			explode:Spawn() -- this actually spawns the explosion
			explode:Activate()
		end
	end
end

