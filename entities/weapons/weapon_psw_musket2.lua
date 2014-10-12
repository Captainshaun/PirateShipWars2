if (CLIENT) then
	SWEP.PrintName			= "Musket 2"
	SWEP.Author				= "UberMensch"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	
	killicon.Add("weapon_psw_musket2", "HUD/musket", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/musket")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false
end

SWEP.HoldType				= "shotgun" --maybe server-only
SWEP.ViewModel				= "models/brownbess/v_brownbess.mdl"
SWEP.WorldModel				= "models/brownbess/w_brownbess.mdl"
SWEP.Category 			= "Pirate Ship Wars 2"                					
SWEP.AdminSpawnable 	= true 
SWEP.Spawnable 			= false                         		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		   
SWEP.DrawCrosshair 		= true 
SWEP.Weight				= 5                         
--list.Add("NPCUsableWeapons", {class = "weapon_psw_musket2", title = SWEP.PrintName or ""});

SWEP.Primary.Sound			= Sound("Weapon_shotgun.double")
SWEP.Primary.Recoil			= 1.4
SWEP.Primary.Damage			= 150
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize			= 1
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Deploy()
		if self.Owner:Team() == TEAM_BLUE then
			self.Owner:GetViewModel():SetModel("models/charleville/v_charleville.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		else
			self.Owner:GetViewModel():SetModel("models/brownbess/v_brownbess.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		end
	return true
end

function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound("weapons/rifle/ssrifle_fire1.wav")
	local rnda = self.Primary.Recoil * -5 
	local rndb = self.Primary.Recoil * math.random(-5, 5)
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
	
	--self:ShootBullet()
	self:ShootEffects()
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire(CurTime() + 0.50)--75
	--Do nothing if you're dead
	if !self.Owner:Alive() then return end
	--Start trace function to find if there is anything within 100 units infront of you
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start +(self.Owner:GetAimVector()*100)
	tr.filter = self.Owner
	local trace = util.TraceLine(tr)
	--Make sure we hit something
	if trace.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		if trace.Entity:IsPlayer() || trace.Entity:IsNPC() then --Hit a person/npc >:D
			bloody = true
		end
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(3,5)..".wav")	

		bullet = {} --Credit here goes to Feihc for his primary fire script of his lightsaber swep
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 0
		bullet.Damage = 40

		self.Owner:FireBullets(bullet)

	else --We missed :(a
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)--misscenter
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	
	if self.Owner then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
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

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )	end