bloody = false

if (CLIENT) then
	SWEP.PrintName = "Cutlass"
	SWEP.Author = "PirateShip Wars GM9 / Metroid48 / Termy58"
--	SWEP.Contact = "metroid48@gmail.com"
--	SWEP.Instructions = ""
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
	killicon.Add("weapon_psw_sabre", "deathnotify/sabre_kill", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("gmod/SWEP/sabre_select")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false

end

SWEP.HoldType = "melee"
SWEP.ViewModel = "models/sabre/v_sabre_a.mdl"
SWEP.WorldModel = "models/sabre/w_sabre.mdl"
SWEP.Category 			= "PSW Weapons"                					
SWEP.AdminSpawnable 	= true                          		
SWEP.UseHands			= true									
SWEP.AutoSwitchTo 		= true                           		
SWEP.Spawnable 			= true                             
--list.Add("NPCUsableWeapons", {class = "weapon_psw_sabre", title = SWEP.PrintName or ""});

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

--Do NOTHING when player hits reload. This is a sword, not a weapon :D
function SWEP:Reload()
--	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
	return false
end

/*function resetSwing()
	swung = false
end*/

function SWEP:Initialize()
	bloody = false
--	self:SetWeaponHoldType("melee")
--	justbloodied = false
end

--Only does stuff when you attack. May add some sort of spark effect if someone pistols/sabres you with your sword out.
--[[function SWEP:Think()
--Update view model
	if self.Owner:Team() == TEAM_BLUE then
		if bloody then
			self.Owner.GetViewModel():SetModel("models/sabre/v_sab2e.mdl")
		else
			self.Owner.GetViewModel():SetModel("models/sabre/v_sabre.mdl")
		end
	else
		if bloody then
			self.Owner.GetViewModel():SetModel("models/sabre/v_sab22.mdl")
		else
			self.Owner.GetViewModel():SetModel("models/sabre/v_sabr2.mdl")
		end
	end
end]]--

--Primary function, swing your sword like a pirate!
function SWEP:PrimaryAttack()
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
	if trace.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
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
		bullet.Damage = 75
		self.Owner:FireBullets(bullet)

	else --We missed :(
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)--misscenter
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

--[[function SWEP:Deploy()
		if self.Owner:Team() == TEAM_BLUE then
			self.Owner:GetViewModel():SetModel("models/sabre/v_sabr2.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		else
			self.Owner:GetViewModel():SetModel("models/sabre/v_sabre.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		end
	
--	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end]]--

/*function SWEP:Holster()
	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
	return true
end*/

--Should be for blocking attacks, but won't be yet
function SWEP:SecondaryAttack()
	return false
end

function SWEP:OnDrop()
	self.Weapon:Remove()
end
