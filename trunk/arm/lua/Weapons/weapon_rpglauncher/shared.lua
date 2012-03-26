if ( SERVER ) then
 
    AddCSLuaFile( "shared.lua" )
   
    SWEP.HoldType         = "RPG"
   
end
 
if ( CLIENT ) then
 
    SWEP.PrintName     		= "RPG-7"   
    SWEP.Author    			= "Seenie"
 
    SWEP.Slot           	= 4
    SWEP.SlotPos        	= 11
    SWEP.ViewModelFOV   	= 60
	SWEP.IconLetter			= ""
	SWEP.DrawAmmo			= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.DrawCrosshair 		= true
	SWEP.Category			= "Seenie";
	SWEP.WepSelectIcon = surface.GetTextureID("materials/weapons/rpgicon");
	killicon.AddFont( "weapon_antitank", "CSKillIcons", SWEP.IconLetter, Color( 0, 255, 0, 255 ) )
 
end

/* O hai. Dont mind me Iz be just written stuffz*/


-----------------------Main functions----------------------------
SWEP.Base				= "weapon_cs_base"
SWEP.IronSightsPos 		= Vector( -3.74, -5, 0.2 )
----------------------Some difinitions we need-----------------

SWEP.settings = {}
SWEP.settings.loaded = true
SWEP.settings.warhead = "sent_rpgrocket"
SWEP.Ironsights = false
SWEP.SetNextReload = 0
SWEP.reloadtimer = 2.3
SWEP.settings.warheads = {}
SWEP.settings.warheadnumber = 1
SWEP.Warheadsloaded = false
SWEP.settings.warheadchoosing = false
SWEP.settings.warheadpressed = false
SWEP.settings.warheadcount = 0


----------------------Difinitons end-------------------------------

function SWEP:Initialize()
for k,v in pairs(scripted_ents.GetList()) do 
if string.find(v.t.Classname, "sent_rpgrocket") then 
table.insert(self.settings.warheads,v) 
end
end
self.settings.warheadcount = table.Count(self.settings.warheads) 

	self.settings.loaded = true
	util.PrecacheSound( "weapons/rpg.wav" )
end
 
 










function SWEP:Rocket()
if ( !SERVER ) then return end
local warhead = self.settings.warhead
	local rocket = ents.Create( warhead )	
		rocket:SetOwner( self.Owner )
		
		if ( self.Ironsights == false ) then
			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() 
				v = v + self.Owner:GetRight() 
				v = v + self.Owner:GetUp() 
			rocket:SetPos( v )	
		else
			rocket:SetPos( self.Owner:GetShootPos() )
		end
		
		rocket:SetAngles( self.Owner:GetAngles() )
		rocket:Spawn()
		rocket:Activate()
		
	local physObj = rocket:GetPhysicsObject()
	--physObj:ApplyForceCenter( self.Owner:GetAimVector() * 100000 )
		
		
	self.Owner:ViewPunch( Vector( math.Rand( 0, -10 ), math.Rand( 0, 0 ), math.Rand( 0, 0 ) ) )	
	self.settings.loaded = false
end

function SWEP:Reload()
	
	self.Ironsights = false
	self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
	self.Weapon:SetNextPrimaryFire( CurTime() + 2.3 )
	self.settings.loaded = true
	self:SetIronsights( self.Ironsights )
	if ( CLIENT ) then
	
	 

end


end


function SWEP:PrimaryAttack()
	if self.settings.loaded and not self.warheadchoosing then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:Rocket( self.Owner:GetAimVector() )
		self.Weapon:SetNextPrimaryFire( CurTime() + 300 )
		self.Weapon:EmitSound( "weapons/rpg.wav" )
		if (SERVER) then
		self.Owner:SetFOV( 90, 2.3 )
		end
		
	
	end
end



function SWEP:SecondaryAttack()
if not self.warheadchoosing then
if ( SERVER ) then
	if ( self.Ironsights == false ) then
		self.Ironsights = true
		self.Owner:SetFOV( 60, 0.3 )
		self.Owner:CrosshairDisable()
	else
		self.Ironsights = false
		self.Owner:SetFOV( 90, 0.3 )
		self.Owner:CrosshairEnable()
	end
end
	self:SetIronsights( self.Ironsights )

end
end

-------------HOLSTER SETTINGS--------------------

function SWEP:Holster()
 
    if ( SERVER ) then
		self.Owner:SetFOV( 90, 0.3 )
		self.Owner:CrosshairEnable()
		
		self.Ironsights = false
		self:SetIronsights( false )
		return true
	end
	self:SetIronsights( self.Irionsights )
end 

------------HOLSTER SETTINGS END------------------


------------DEPLOY SETTINGS-----------------------

function SWEP:Deploy()
if not self.Warheadsloaded then
for k,v in pairs(scripted_ents.GetList()) do 
if string.find(v.t.Classname, "sent_rpgrocket") then 
table.insert(self.settings.warheads,v) 
end
end
self.settings.warheadcount = table.Count(self.settings.warheads) 
self.Warheadsloaded = true
end
	if ( SERVER ) then
		self.Owner:SetFOV( 90, 0.3 )
		self.Owner:CrosshairEnable()
		
		self.Ironsights = false
		self:SetIronsights( false )
		
	end	
	self.settings.loaded = true
	
	self:SetIronsights( self.Irionsights )

end 

------------DEPLOY SETTINGS END-------------------


-------------------------------------------------------------------
 
 
------------General Swep Info---------------
SWEP.Author   = "Seenie"
SWEP.Contact        = ""
SWEP.Purpose        = "TO PWN SUM NEWBS"
SWEP.Instructions   = "Aim and pray"
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

-----------------------------------------------
 
------------Models---------------------------
SWEP.ViewModelFlip	    = false
SWEP.ViewModel      = "models/weapons/v_RL7.mdl"
SWEP.WorldModel   = "models/weapons/w_RPG7/w_rpg7.mdl"
-----------------------------------------------
 
-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay      = 0.9     
SWEP.Primary.Recoil   = 0    
SWEP.Primary.Damage   = 0 
SWEP.Primary.NumShots      = 1        
SWEP.Primary.Cone         = 0    
SWEP.Primary.ClipSize      = -1   
SWEP.Primary.DefaultClip    = -1    
SWEP.Primary.Automatic      = false 
SWEP.Primary.Ammo           = "RPG"   
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay        = 0.9
SWEP.Secondary.Recoil      = 0
SWEP.Secondary.Damage      = 0
SWEP.Secondary.NumShots  = 3
SWEP.Secondary.Cone   = 0
SWEP.Secondary.ClipSize  = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes-------------------------------- 