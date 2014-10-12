if (CLIENT) then
	SWEP.PrintName			= "Pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 0
	SWEP.DrawCrosshair		= true
	
	--killicon.Add("weapon_psw_pistol", "killicons/pistol_kill", Color(255,255,255,255))
	killicon.Add("weapon_psw_pistol", "HUD/pistol", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/pistol")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false
end

--SWEP.Base = "weapon_pswgunbase"
SWEP.HoldType			= "pistol" --maybe server-only
SWEP.ViewModel			= "models/weapons/pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol/w_pistol.mdl"
SWEP.Category 			= "Pirate Ship Wars 2"                					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		
SWEP.Spawnable 			= true                             
--list.Add("NPCUsableWeapons", {class = "weapon_psw_pistol", title = SWEP.PrintName or ""});

SWEP.Primary.Sound = Sound("weapons/pistolshot.wav")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.Delay			= 0.3
SWEP.Primary.ClipSize			= 1
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
	ScopeLevel = 0
	self.Owner:SetFOV( 0, 0 )
	self.Weapon:SetNetworkedBool( "Ironsights", false )

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Weapon:EmitSound("weapons/flcock_draw.wav")
		self.Owner:ViewPunch( Angle( 1, 0, -1 ) )
    return true
end

function SWEP:Holster()
	ScopeLevel = 0
	self.Owner:SetFOV( 0, 0 )
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	
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

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		if (!bIron) then Mul = 1 - Mul end
	end

	local Offset = self.IronSightsPos
	
	if ( self.IronSightsAng ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:SetIronsights( b )
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
	if(ScopeLevel == 0) then
		if(SERVER) then
			self.Owner:SetFOV( 55, 0.3 )
		end
 		ScopeLevel = 1
	else
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.3 )
		end
		ScopeLevel = 0
	end

end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

SWEP.Primary.Cone = 0.02

SWEP.IronSightsPos = Vector (-8.5, 6, 1.5)
SWEP.IronSightsAng = Vector (-2, -11.8, -3)

--SWEP.IronSightsPos = Vector (-8.5, 6, 1.5)
--SWEP.IronSightsAng = Vector (-1, -11.8, -3)

--SWEP.IronSightsPos = Vector (-8.1, 6, 1.5)
--SWEP.IronSightsAng = Vector (-1, -11, -2)