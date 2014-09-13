if (CLIENT) then
	SWEP.PrintName			= "SS Pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.DrawCrosshair		= true
	
	killicon.Add("weapon_psw_pistol2", "HUD/sspistol", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/sspistol")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false
end

SWEP.Base = "weapon_pswgunbase"
SWEP.HoldType				= "pistol" --maybe server-only
SWEP.ViewModel				= "models/weapons/sspistol.mdl"
SWEP.WorldModel				= "models/weapons/w_sspistol/w_sspistol.mdl"
SWEP.Category 			= "PSW Weapons"                					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		
SWEP.Spawnable 			= true                             
--list.Add("NPCUsableWeapons", {class = "weapon_psw_pistol2", title = SWEP.PrintName or ""});

SWEP.Primary.Sound = Sound("weapons/pistolshot.wav")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo			= "pistol"
SWEP.ReloadSound = Sound("weapons/cockpistol.wav")

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= 0
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"

function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound("weapons/pistolshot.wav")
	local rnda = self.Primary.Recoil * -10 
	local rndb = self.Primary.Recoil * math.random(-10, 10)
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	
 	if (SERVER) then
		local ball = ents.Create("psw_ballbearing")
		ball:SetPos( self.Owner:GetShootPos() )
		ball:SetAngles(self.Owner:GetAngles())
		ball:SetOwner( self.Owner )
		ball:Spawn()
		ball:Activate()
		ball:GetPhysicsObject():SetVelocity(self:GetForward() * 14000)
	end
	
	self:ShootEffects()
	self:TakePrimaryAmmo(1)
	
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self:DefaultReload( ACT_VM_RELOAD )
		--self.Weapon:EmitSound( "weapons/pistolreload.wav" )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        self.ReloadingTime = CurTime() + AnimationTime
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
	end
	
end

function SWEP:Reload()
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self:DefaultReload( ACT_VM_RELOAD )
		self.Weapon:EmitSound( "weapons/pistolreload.wav" )
        local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
        self.ReloadingTime = CurTime() + AnimationTime
        self:SetNextPrimaryFire(CurTime() + AnimationTime)
        self:SetNextSecondaryFire(CurTime() + AnimationTime)
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:EmitSound("weapons/flcock_draw.wav")
    return true
end

function SWEP:Holster()
	self.Weapon:EmitSound("weapons/flcock_draw.wav")
	return true
end

function SWEP:ShootEffects()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation
	local effectdata = EffectData()
		effectdata:SetOrigin(self.Owner:GetShootPos())
		effectdata:SetEntity(self)
		effectdata:SetStart(self.Owner:GetShootPos())
		effectdata:SetNormal(self.Owner:GetAimVector())
		effectdata:SetAttachment(1)

	util.Effect("muzzleblast", effectdata)	
end

function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false

	end

	return true

end