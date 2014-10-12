bloody = false

if (CLIENT) then
	SWEP.PrintName		= "Sabre"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	killicon.Add("weapon_psw_sabre2", "HUD/cutlass", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/cutlass")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false

end

SWEP.HoldType = "melee"
SWEP.ViewModel = "models/weapons/cutlass2.mdl"
SWEP.WorldModel = "models/weapons/w_cutlass2/w_cutlass2.mdl"
SWEP.Category 			= "Pirate Ship Wars 2"                					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		
SWEP.Spawnable 			= true                             
--list.Add("NPCUsableWeapons", {class = "weapon_psw_sabre2", title = SWEP.PrintName or ""});

SWEP.Primary.Delay = 5
SWEP.Primary.Recoil = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

--Primary function, swing your sword like a pirate!
function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.50)--75
	--Do nothing if you're dead
	if !self.Owner:Alive() then return end
	--Start trace function to find if there is anything within 75 units infront of you
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start +(self.Owner:GetAimVector()*125)
	tr.filter = self.Owner
	local trace = util.TraceLine(tr)
	--Make sure we hit something
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if trace.Hit then
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(3,5)..".wav")	

		bullet = {} --Credit here goes to Feihc for his primary fire script of his lightsaber swep
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 0
		bullet.Damage = 75
		self.Owner:FireBullets(bullet)

	else --We missed :(
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	--self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:OnDrop()
	self.Weapon:Remove()
end

function SWEP:CanPrimaryAttack()

	if (SERVER) then
		if ( self.Owner.UsingCannon == 1 ) then
			return false
		end
	elseif (UsingCannon) then
		return false
	end

	return true

end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
      return true
end