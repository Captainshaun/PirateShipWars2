--Moo
if (SERVER) then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true

--	SWEP.ViewModelFOV		= 82
	
	SWEP.Author				= "Metroid48"
	SWEP.PrintName			= "Grenade"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 1
		
	killicon.AddFont("weapon_psw_grenade2","CSKillIcons",SWEP.IconLetter,Color(255,80,0,255))
	--SWEP.WepSelectIcon = surface.GetTextureID("gmod/SWEP/pistol_select")--grenade
	SWEP.DrawWeaponInfoBox = false
	SWEP.BounceWeaponIcon = false 
end

SWEP.HoldType			= "grenade"
SWEP.ViewModel			= "models/powdergrenade/v_powdergrenade_blue.mdl"
SWEP.WorldModel			= "models/powdergrenade/w_powdergrenade.mdl"
SWEP.Category 			= "Pirate Ship Wars 2"  
SWEP.Spawnable 			= true               					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		       
--list.Add("NPCUsableWeapons", {class = "weapon_psw_grenade2", title = SWEP.PrintName or ""});

--SWEP.Primary.Sound			= Sound("Default.PullPin_Grenade")--Got a fuse sound :D
SWEP.Primary.Recoil			= 0
SWEP.Primary.Unrecoil		= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 1

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "grenade"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Next = CurTime()
SWEP.Primed = 0

function SWEP:Reload()
	return false
end

function SWEP:Holster()
	self.Next = CurTime()
	self.Primed = 0
	return true
end

function SWEP:Deploy()
	if self.Owner:Team()==TEAM_BLUE then
		self.Owner:GetViewModel():SetModel("models/powdergrenade/v_powdergrenade_blue.mdl")
	else
		self.Owner:GetViewModel():SetModel("models/powdergrenade/v_powdergrenade_red.mdl")
	end

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:Holster()
	self.Next = CurTime()
	self.Primed = 0
	return true
end

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		-- View model animation
	--self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation
end

function SWEP:PrimaryAttack()
	if self.Next < CurTime() and self.Primed == 0 and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Next = CurTime() + self.Primary.Delay
		
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
		--self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		--self.Weapon:EmitSound(Sound("sound/powdergrenade/fuse.wav"))
	end
end

function SWEP:Think()
	if self.Next < CurTime() then
		if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) then
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Primed = 2
			self.Next = CurTime() + .3
		elseif self.Primed == 2 then
			self.Primed = 0
			self.Next = CurTime() + self.Primary.Delay
			
			if SERVER then
				local ent = ents.Create("sent_pswgrenade")
				
				ent:SetPos(self.Owner:GetShootPos())
				ent:SetAngles(Angle(1,0,0))
				ent:Spawn()
				ent.eOwner = self.Owner
				ent:SetOwner(self.Owner)
				ent:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 7500)
				
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 1000)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
				
				self.Owner:RemoveAmmo(1,self.Primary.Ammo)
				
				if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
					self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	return false
end
