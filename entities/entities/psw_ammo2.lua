AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pistol Ammo"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

if ( SERVER ) then

	ENT.CleanupPriority = 2

	function ENT:Initialize()
		self.m_Health = 50
		self:SetModel("models/items/boxsrounds.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetMaterial("material")
			phys:EnableMotion(true)
			phys:Wake()
		end

		--self:ItemCreated()
	end

	function ENT:SetAmmoType(ammotype)
		self:SetModel(GAMEMODE.AmmoModels[string.lower(ammotype)] or "models/Items/BoxMRounds.mdl")
		self.m_AmmoType = ammotype
	end

	function ENT:GetAmmoType()
		return self.m_AmmoType or "pistol"
	end

	function ENT:SetAmmo(ammo)
		self.m_Ammo = tonumber(ammo) or self:GetAmmo()
	end

	function ENT:GetAmmo()
		return self.m_Ammo or 0
	end

	function ENT:Use(activator, caller)
		if activator:IsPlayer() and activator:Alive() then
				local hasweapon = false
					for _, wep in pairs(activator:GetWeapons()) do
						if wep.Primary and wep.Primary.Ammo and string.lower(wep.Primary.Ammo) == string.lower(self:GetAmmoType())
						or wep.Secondary and wep.Secondary.Ammo and string.lower(wep.Secondary.Ammo) == string.lower(self:GetAmmoType()) then
							hasweapon = true
							break
						end
					end

					if not hasweapon then
						activator:SplitMessage("You don't have anything that uses this type of ammo.")
						return
					end

				activator:GiveAmmo(self:GetAmmo(), self:GetAmmoType())

				activator.AmmoPickups = (activator.AmmoPickups or 0) + 1
		end
	end
	
	function ENT:KeyValue(key, value)
		key = string.lower(key)
		if key == "ammotype" then
			self:SetAmmoType(value)
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)

		self.m_Health = self.m_Health - dmginfo:GetDamage()
		if self.m_Health <= 0 then
			self:RemoveNextFrame()
		end
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
