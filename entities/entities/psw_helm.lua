AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pirate Ship Helm"
ENT.Author			= "Thomas Hansen"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Think()
	local owner = self:GetOwner()
	if owner:IsPlayer() then
	
		self.Turning = false
		for k,v in pairs(player.GetAll()) do
			if self.Owner:KeyDown( IN_MOVELEFT ) then
				self.Turning = 1
			end
			if self.Owner:KeyDown( IN_MOVERIGHT ) then
				self.Turning = 2
			end
		end
	end
end

if ( SERVER ) then

	function ENT:Initialize()
		self:SetModel( "models/frigate01/helm/helm.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self.nextUse=0
	end
	
	function ENT:Use(ply,caller)
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+0.5
		if ply:IsPlayer() then
			if !ply:KeyPressed(IN_USE) then return end
			ply:SetMoveType(0)
			ply:SetGravity(0)
			ply:DrawViewModel(false)
			self.Entity:SetOwner(ply)
			self.weps = {}
			for k,v in pairs(ply:GetWeapons()) do
				table.insert(self.weps, v:GetClass());
			end
			ply:StripWeapons();
			self.owner = ply;
		end
	end
	
	function ENT:OnRemove()
		self:Deactivate()
	end
	
	function ENT:Deactivate()
		local owner = self:GetOwner()
		if owner:IsPlayer() then
			self:SetOwner( self:GetParent() )
			owner:SetParent()
			owner:SetMoveType(2)
			owner:SetGravity(1)
			owner:DrawViewModel(true)
			owner = false
			for k,v in pairs(self.weps) do
				self.owner:Give(tostring(v));
			end
			self.owner = NULL;
			
			if self.Entity:GetName() == "ship1helm" then
				ents.FindByName( "ship1_thruster_forward" )[1]:Fire("Deactivate")
				ents.FindByName( "ship1_thruster_reverse" )[1]:Fire("Deactivate")
				ents.FindByName( "ship1_thruster_left" )[1]:Fire("Deactivate")
				ents.FindByName( "ship1_thruster_right" )[1]:Fire("Deactivate")
			end
			if self.Entity:GetName() == "ship2helm" then
				ents.FindByName( "ship2_thruster_forward" )[1]:Fire("Deactivate")
				ents.FindByName( "ship2_thruster_reverse" )[1]:Fire("Deactivate")
				ents.FindByName( "ship2_thruster_left" )[1]:Fire("Deactivate")
				ents.FindByName( "ship2_thruster_right" )[1]:Fire("Deactivate")
			end
		end
	end
	
	function ENT:Think()
	local owner = self:GetOwner()
		if owner:IsPlayer() && owner:Alive() then
			local ownerpos = owner:GetPos()
			local Helmpos = self:GetPos()

			if Helmpos:Distance(ownerpos) > 120 then
				self:Deactivate()
				return
			end
				
			if (self.Entity:GetOwner():KeyPressed(IN_USE)) then
				self.nextUse = CurTime()+0.5
				return
			end
			
			if self.Entity:GetOwner():KeyDown(IN_USE) then
				if self.nextUse<=CurTime() then
					self.nextUse = CurTime()+0.5
					self:Deactivate()
					return 
				end
			end
			
			if self.Entity:GetName() == "ship1helm" then
				if self.Entity:GetOwner():KeyDown( IN_FORWARD ) then
					ents.FindByName( "ship1_thruster_forward" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship1_thruster_forward" )[1]:Fire("Deactivate")
				end

				if (self.Entity:GetOwner():KeyDown( IN_BACK )) then
					ents.FindByName( "ship1_thruster_reverse" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship1_thruster_reverse" )[1]:Fire("Deactivate")
				end
				
				if self.Entity:GetOwner():KeyDown( IN_MOVELEFT ) then
					ents.FindByName( "ship1_thruster_left" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship1_thruster_left" )[1]:Fire("Deactivate")
				end

				if self.Entity:GetOwner():KeyDown( IN_MOVERIGHT ) then
					ents.FindByName( "ship1_thruster_right" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship1_thruster_right" )[1]:Fire("Deactivate")
				end
			end
				
			if self.Entity:GetName() == "ship2helm" then
				if self.Entity:GetOwner():KeyDown( IN_FORWARD ) then
					ents.FindByName( "ship2_thruster_forward" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship2_thruster_forward" )[1]:Fire("Deactivate")
				end
				
				if (self.Entity:GetOwner():KeyDown( IN_BACK )) then
					ents.FindByName( "ship2_thruster_reverse" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship2_thruster_reverse" )[1]:Fire("Deactivate")
				end
				
				if self.Entity:GetOwner():KeyDown( IN_MOVELEFT ) then
					ents.FindByName( "ship2_thruster_left" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship2_thruster_left" )[1]:Fire("Deactivate")
				end
				
				if self.Entity:GetOwner():KeyDown( IN_MOVERIGHT ) then
					ents.FindByName( "ship2_thruster_right" )[1]:Fire("Activate")
				else
					ents.FindByName( "ship2_thruster_right" )[1]:Fire("Deactivate")
				end
			end
		else
			self:Deactivate()
		end
	end
end

if (CLIENT) then
	ENT.Turning = 0

	function ENT:Initialize()
		self.Color = Color(255,255,255,255)
	end

	ENT.LastDraw = CurTime()

	function ENT:Draw()
		for k,v in pairs(player.GetAll()) do
			if self.Turning then
				local deltaTime = CurTime() - self.LastDraw
				if self.Turning == 1 then --left
					self.Entity:SetAngles( self.Entity:GetAngles() + Angle(0,0,(100 * deltaTime )   ) )
				end
				if self.Turning == 2 then
					self.Entity:SetAngles( self.Entity:GetAngles() - Angle(0,0,(100 * deltaTime )   ) )
				end
				self.Turning = false
			end
			self.Entity:DrawModel()
			self.LastDraw = CurTime()
		end
	end
end
