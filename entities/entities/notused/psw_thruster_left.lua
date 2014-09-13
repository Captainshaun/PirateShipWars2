AddCSLuaFile()

ENT.Base = "base_psw_thruster"

if (SERVER) then
	function ENT:Think()
		if pswThrusters[self.team]["helm"].Forward then
			self:SetVelocity(self:GetAngles():Forward() * 99999)
		end
	end
end