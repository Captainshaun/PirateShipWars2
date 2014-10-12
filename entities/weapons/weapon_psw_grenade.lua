AddCSLuaFile()

if CLIENT then
	SWEP.PrintName			= "Powder Keg"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 0
	SWEP.DrawCrosshair		= true
	
	killicon.Add("weapon_psw_grenade", "HUD/keg", Color(255,255,255,255))
	killicon.Add("psw_grenade", "HUD/keg", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/keg")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false
end

SWEP.ViewModel       	= "models/weapons/keg.mdl"
SWEP.WorldModel         = "models/weapons/w_keg/w_keg.mdl"
SWEP.Category 			= "Pirate Ship Wars 2"    					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true  
SWEP.AutoSwitchFrom		= true
SWEP.ViewModelFlip 		= false
SWEP.DrawCrosshair		= true                         		
SWEP.Spawnable 			= true                             
--list.Add("NPCUsableWeapons", {class = "weapon_psw_grenade", title = SWEP.PrintName or ""});

SWEP.HoldReady = "grenade"
SWEP.HoldNormal = "slam"

SWEP.Kind = WEAPON_NADE

--SWEP.Primary.Sound			= Sound("Default.PullPin_Grenade")--Got a fuse sound :D
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay = 1.0
SWEP.Primary.Ammo		= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.IsGrenade = true
SWEP.NoSights = true

SWEP.pin_pulled = false
SWEP.throw_time = 0

SWEP.was_thrown = false

SWEP.detonate_timer = 5

SWEP.DeploySpeed = 1.5

AccessorFunc( SWEP, "pin_pulled", "Pin")
AccessorFunc( SWEP, "throw_time", "ThrowTime")

AccessorFunc(SWEP, "det_time", "DetTime")

function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "pin_pulled")
   self:DTVar("Int", 0, "throw_time")
end


function SWEP:Deploy()

   if self.SetWeaponHoldType then
      self:SetWeaponHoldType(self.HoldNormal)
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
   return true
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   self:PullPin()
end

function SWEP:SecondaryAttack()
end

function SWEP:BlowInFace()
   local ply = self.Owner
   if not IsValid(ply) then return end

   if self.was_thrown then return end

   self.was_thrown = true

   -- drop the grenade so it can immediately explode

   local ang = ply:GetAngles()
   local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
   src = src + (ang:Right() * 10)

   self:CreateGrenade(src, Angle(0,0,0), Vector(0,0,1), Vector(0,0,1), ply)

   self:SetThrowTime(0)
   self:Remove()
   
end

function SWEP:StartThrow()
   self:SetThrowTime(CurTime() + 0.1)
end

function SWEP:Throw()
   if CLIENT then
      self:SetThrowTime(0)
   elseif SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.was_thrown then return end

      self.was_thrown = true

      local ang = ply:EyeAngles()

      -- don't even know what this bit is for, but SDK has it
      -- probably to make it throw upward a bit
      if ang.p < 90 then
         ang.p = -10 + ang.p * ((90 + 10) / 90)
      else
         ang.p = 360 - ang.p
         ang.p = -10 + ang.p * -((90 + 10) / 90)
      end

      local vel = math.min(800, (90 - ang.p) * 6)

      local vfw = ang:Forward()
      local vrt = ang:Right()
      --      local vup = ang:Up()

      local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
      src = src + (vfw * 8) + (vrt * 10)

      local thr = ( vfw * vel + ply:GetVelocity() ) * 1.4

      self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)

      self:SetThrowTime(0)
      self:Remove()
   end
end

function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
   local gren = ents.Create("psw_grenade")
   if not IsValid(gren) then return end

   gren:SetPos(src)
   gren:SetAngles(ang)

   --   gren:SetVelocity(vel)
   gren:SetOwner(ply)
   --gren:SetThrower(ply)

   gren:SetGravity(0.4)
   gren:SetFriction(0.2)
   gren:SetElasticity(0.45)

   gren:Spawn()

   gren:PhysWake()

   local phys = gren:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocity(vel)
      phys:AddAngleVelocity(angimp)
   end

   return gren
end

function SWEP:PullPin()
   if self:GetPin() then return end

   local ply = self.Owner
   if not IsValid(ply) then return end

   self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)

   if self.SetWeaponHoldType then
      self:SetWeaponHoldType(self.HoldReady)
   end

   self:SetPin(true)

   self:SetDetTime(CurTime() + self.detonate_timer)
end


function SWEP:Think()
   local ply = self.Owner
   if not IsValid(ply) then return end

   -- pin pulled and attack loose = throw
   if self:GetPin() then
      -- we will throw now
      if not ply:KeyDown(IN_ATTACK) then
         self:StartThrow()

         self:SetPin(false)
         self.Weapon:SendWeaponAnim(ACT_VM_THROW)

         if SERVER then
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
         end
      else
         -- still cooking it, see if our time is up
         if SERVER and self:GetDetTime() < CurTime() then
            self:BlowInFace()
         end
      end
   elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
      self:Throw()
   end
end

function SWEP:Holster()
   if self:GetPin() then
      return false -- no switching after pulling pin
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

function SWEP:PreDrop()
   -- if owner dies or drops us while the pin has been pulled, create the armed
   -- grenade anyway
   if self:GetPin() then
      self:BlowInFace()
   end
end

function SWEP:OnDrop()
	self.Weapon:Remove()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )	end

function SWEP:Initialize()
   if self.SetWeaponHoldType then
      self:SetWeaponHoldType(self.HoldNormal)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   self:SetDetTime(0)
   self:SetThrowTime(0)
   self:SetPin(false)

   self.was_thrown = false
end


function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()

   if ( self.Owner:WaterLevel() > 0 ) then
      return false
   end

   return true

end