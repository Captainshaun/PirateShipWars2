function EFFECT:Init(data)
	self.EndSize1=24
	self.EndSize2=48
	self.EndTime=0.5
	
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()

	local vPos=data:GetOrigin()
	local vStartVel=data:GetStart()
	local vGravity=Vector(0,0,600)
	local emitter=ParticleEmitter(vPos);
	for i=1,16 do 
		local delay=0.014
		local t=delay*i
		local vParticle=vPos+vStartVel*t
		if GetConVarNumber("psw_disablecannonsmoke")==0 then
			local particle=emitter:Add("effects/smoke0" .. math.random(1,2),vParticle) 
			particle:SetLifeTime(t);
			particle:SetVelocity(Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)):GetNormal()*3)--SPREAD
			particle:SetDieTime(self.EndTime) 
			particle:SetStartAlpha(math.Rand(75,200)) 
			particle:SetStartSize(math.Rand(30,36)) 
			particle:SetEndSize(math.Rand(self.EndSize1,self.EndSize2)) 
			particle:SetRoll(math.Rand(-0.1,0.1))
			particle:SetRollDelta(math.Rand(-0.25,0.25));
			particle:SetColor(200,200,210) 
			self.EndSize1=self.EndSize1+14
			self.EndSize2=self.EndSize2+18
			self.EndTime=self.EndTime+0.23
		end
		
		local particle = emitter:Add("sprites/heatwave", vParticle)
		particle:SetVelocity(80*self.Forward + 20*VectorRand())
		particle:SetDieTime(math.Rand(0.15,0.2))
		particle:SetStartSize(math.random(220,250))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(160)

		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), vParticle)
		particle:SetDieTime(0.04)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(200)
		particle:SetStartSize(15)
		particle:SetEndSize(30)
		particle:SetRoll(180)
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,120,120)	
	end	
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 149
		dlight.b = 4
		dlight.Brightness = 6
		dlight.Size = 340
		dlight.Decay = 340 * 5
		dlight.DieTime = CurTime() + 0.5
	end
	
	emitter:Finish();
end 
	
function EFFECT:Think()
	return false;
end

function EFFECT:Render()
end
