AddCSLuaFile()

ENT.Base = "base_psw_thruster"

if (SERVER) then
	function ENT:Think()
		//if pswThrusters[self.team]["helm"].Forward then
			//pswThrusters[self.team]["helm"]:GetPhysicsObject():SetVelocityInstantaneous(self.Entity:GetAngles():Forward() * 99999)
			self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetAngles():Forward() * 99999)
		//end
	end
end