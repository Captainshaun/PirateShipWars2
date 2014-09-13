
AddCSLuaFile()

ENT.Type 			= "anim"

if (CLIENT) then
	function ENT:Draw()
		self.Entity:DrawModel()
	end
end


function ENT:Initialize()

	self:SetModel( "models/props_c17/woodbarrel001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
		
	local phys = self:GetPhysicsObject()
		
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetElasticity( 1 )
	end

end