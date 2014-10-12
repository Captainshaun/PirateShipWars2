SWEP.Weight				= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.ViewModelFlip			= false
SWEP.Primary.ClipSize			= 1

function SWEP:CanPrimaryAttack()
	
	if ( self:Clip1() <= 0 ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		--self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:Reload()
		return false
		
	end

	if ( self.Owner:WaterLevel() > 0 ) then
		return false
	end

	return true

end

function SWEP:OnDrop()
	self.Weapon:Remove()
end
