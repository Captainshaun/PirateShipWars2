AddCSLuaFile()
function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)

	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Up = self.Angle:Up()

	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	local emitter = ParticleEmitter(self.Position)
		
	local particle = emitter:Add("sprites/heatwave", self.Position)
		particle:SetVelocity(80*self.Forward + 20*VectorRand())
		particle:SetDieTime(math.Rand(0.15,0.2))
		particle:SetStartSize(math.random(22,25))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(160)

	local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position)
		particle:SetDieTime(0.04)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(200)
		particle:SetStartSize(14)
		particle:SetEndSize(15)
		particle:SetRoll(180)
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,120,120)	

	local particle = emitter:Add("particle/particle_smokegrenade", self.Position)
		particle:SetVelocity(100 * self.Forward + 8 * VectorRand())
		particle:SetAirResistance(400)
		particle:SetGravity(Vector(0, 0, math.Rand(25, 100)))
		particle:SetDieTime(math.Rand(4, 5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(6, 12))
		particle:SetEndSize(math.Rand(15, 25))
		particle:SetRoll(math.Rand(-25, 25))
		particle:SetRollDelta(math.Rand(-0.25, 0.35))
		particle:SetColor(255, 255, 255)

	local emitter = ParticleEmitter(self.Position)
	local dlight = DynamicLight(self:EntIndex())
		if (dlight) then
			dlight.Pos 		= self.Position
			dlight.r 		= 160
			dlight.g 		= 50
			dlight.b 		= 0
			dlight.Brightness = 0.2
			dlight.size 	= 200
			dlight.DieTime 	= CurTime() + 0.1
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end