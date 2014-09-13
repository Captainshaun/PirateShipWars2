local meta = FindMetaTable("Player")

---------------------------------
--EXP
---------------------------------
function meta:GetEXP()
	return self:GetNWInt('exp')
end

function meta:AddEXP( amt )
	self:SetNWInt( 'exp', self:GetEXP() + amt )
end

function meta:TakeEXP( amt )
	self:SetNWInt( 'exp', self:GetEXP() - amt )
end

function meta:ResetXPToZero()
	self:SetPData("exp",0)
	self:SetNWInt("exp",0)
end

function meta:levelingUp()
	if self:GetEXP() <= 10 then
		self:ResetXPToZero()
		self:AddLevel()
		return 
	end
end

---------------------------------
--Level
---------------------------------
function meta:GetLevel()
	--what you want to call the EXP
	return self:GetNWInt('Level')
end

function meta:AddLevel( amt )
	self:SetNWInt( 'Level', self:GetLevel() + 1 )
end

function meta:TakeLevel( amt )
	self:SetNWInt( 'Level', self:GetLevel() - 1 )
end

---------------------------------
--Save and Load
---------------------------------
function meta:SavePts()
	self:SetPData( 'EXP_saved', self:GetEXP() )
	self:SetPData( 'Level_saved', self:GetLevel() )
end

function meta:LoadPts()
	self:SetNWInt( 'exp', self:GetPData( 'EXP_saved' ) )
	self:SetNWInt( 'Level', self:GetPData( 'Level_saved' ) )
end


--[[
--init.lua

hook.Add( 'PlayerDisconnected', 'save my EXP, pls', function(ply)

	ply:SavePts()
	MsgN ( 'EXP have been saved!')
	
end )

hook.Add( 'PlayerSpawn', 'ewewgfw', function(ply)

	ply:LoadPts()
	MsgN ( 'EXP have been Loaded!')
	
end )

hook.Add( 'ShowSpare1', 'dddd', function(ply)

	ply:AddEXP(5)
	MsgN ( '5 EXP have been added')
	
end )

--cl_init.lua

draw.SimpleText(LocalPlayer():GetEXP(), 'TargetID', 10, 10, Color(255,255,255))
]]--