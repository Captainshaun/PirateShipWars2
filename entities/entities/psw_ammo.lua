AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pistol Ammo"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if ( SERVER ) then

	function ENT:Initialize()
		self.Entity:SetModel("models/items/boxsrounds.mdl")
	    self.Entity:SetSkin(0)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
	    self.Entity:SetUseType(SIMPLE_USE)
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then phys:Wake() end
		self.uses = 2 
	end

	function ENT:SpawnFunction(ply, tr)

		if not tr.Hit then return end

		local SpawnPos = tr.HitPos + tr.HitNormal*16 
		local ent = ents.Create("ammobox_Pistol")
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()
		return ent

	end

	function ENT:Use(activator, caller )
		
		if ( activator:IsPlayer() ) then 
			activator:GiveAmmo(6,"pistol")
			self.uses = (self.uses - 1)
		end
	  
		if (self.uses< 1) then
			self.Entity:Remove()
		end
	end

	function ENT:Think() 
	end
end

if (CLIENT) then
	function ENT:Initialize()
	end

	function ENT:Draw()
		self.Entity:DrawModel()
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end
