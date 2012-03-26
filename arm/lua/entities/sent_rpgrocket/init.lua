AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local RocketSpeed 		= 2000 
local PingRadius 		= 2800 
local PingRate 			= 0.2
local WobbleScale 		= 0.03 
local TargetAffinity	= 0 
local GraceTime 		= 1 
local Damage			= 125 

local sndThrustLoop = Sound("Missile.Accelerate")
local sndStop = Sound("ambient/_period.wav")


function ENT:PingTargets()

local curtarg = NULL
local curdist = PingRadius

	for _,ent in pairs(ents.FindInSphere(self.Position,PingRadius)) do
	
		if ent:IsValid() and 
		(ent:IsNPC() or ent:IsPlayer()) and
		ent ~= self.Entity and
		ent ~= self.Child then
			local entpos = ent:LocalToWorld(ent:OBBCenter())
			local dist = (entpos - self.Position):Length()
			if (dist < curdist or curtarg == self.Owner) and self:LOS(ent,entpos)  then
				curtarg = ent
				curdist = dist
			end
		end

	end

self.Target = curtarg

end


function ENT:LOS(ent,entpos)

	local trace = {}
	trace.start = self.Position
	trace.endpos = entpos
	local traceRes = util.TraceLine(trace)

return (traceRes.Entity == ent)

end


function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/rocket/rocket.mdl" )

	self.Entity:PhysicsInit(SOLID_BBOX)
	self.Entity:SetMoveType(MOVETYPE_FLY)	
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	
	self.Position = self.Entity:GetPos()
	self.Owner = self.Owner or self.Entity
	self.Weapon = self.Weapon or self.Owner
	self.Target = NULL	
	self.Child = self.Child or NULL

	self.EmittingSound = false
	self.NextPing = CurTime() + GraceTime

	self.LastWobble = self.Entity:GetForward()
   	
end



function ENT:Touch(hitEnt)

if hitEnt == self.Owner and self.Target ~= self.Owner then return end --we need to do this so the player doesn't collide with his rockets when he fires them

local RocketAng = self.Entity:GetForward()

	if self.Child:IsValid() then
		self.Child:SetParent(nil)
		self.Child:SetPos(self.Position - RocketAng*72)
		if self.Child:IsPlayer() then
			self.Child:SetMoveType(MOVETYPE_WALK)
			self.Child:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			self.Child:TakeDamage(999,self.Owner)
		else
			self.Child:SetHealth(1)
			self.Child:Fire("kill","",0.2)
		end
	end
	
	if not self.Weapon:IsValid() then self.Weapon = self.Entity end --just in case

	util.BlastDamage(self.Weapon, 
	self.Owner, 
	self.Position + RocketAng*32, 
	Damage*3, 
	Damage)
	
util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 200, 500 )
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
--	util.Effect( "Explosion", effectdata )			 
	util.Effect( "HelicopterMegaBomb", effectdata )	 
	util.Effect( "Rocket_Explosion", effectdata )	 
	
	local explo = ents.Create( "env_explosion" )
		explo:SetOwner( self.Owner )
		explo:SetPos( self.Entity:GetPos() )
		explo:SetKeyValue( "iMagnitude", "50" )
//		explo:SetKeyValue( "iRadiusOverride", "400" )
		explo:Spawn()
		explo:Activate()
		explo:Fire( "Explode", "", 0 )
	
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.Owner )
		shake:SetPos( self.Entity:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )	-- Power of the shake
		shake:SetKeyValue( "radius", "900" )	-- Radius of the shake
		shake:SetKeyValue( "duration", "5" )	-- Time of shake
		shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
		shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )
		
	
	local physExplo = ents.Create( "env_physexplosion" )
	    physExplo:SetOwner( self.Owner )
        physExplo:SetPos( self.Entity:GetPos() )
        physExplo:SetKeyValue( "Magnitude", "1000" )	-- Power of the Physicsexplosion
        physExplo:SetKeyValue( "radius", "1000" )	-- Radius of the explosion
        physExplo:SetKeyValue( "spawnflags", "19" )
        physExplo:Spawn()
        physExplo:Fire( "Explode", "", 0.02 )
		
	local ar2Explo = ents.Create( "env_ar2explosion" )
		ar2Explo:SetOwner( self.Owner )
		ar2Explo:SetPos( self.Entity:GetPos() )
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire( "Explode", "", 0 )
		
	for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 350 ) ) do
		if v:IsValid() and v:IsPlayer() then return end
		v:Ignite( 10, 0 )
	end
	

	self.Entity:EmitSound( "explode_4" )
	self:StopSounds()	
	self.Entity:Remove()

end


function ENT:OnTakeDamage(dmginfo)

	self.Entity:TakePhysicsDamage(dmginfo)
	
end


function ENT:Use( activator, caller )

end


function ENT:Think()

	if self.NextPing < CurTime() then
		self:PingTargets()
		self.NextPing = CurTime() + PingRate
	end

	self.Position = self.Entity:GetPos()
	

	
	--calculate wobblyness
	local Wobble = (VectorRand() + self.LastWobble):GetNormalized()
	local RocketAng = self.Entity:GetForward()
	local NewAng = Wobble*WobbleScale + RocketAng
	
	if self.Target:IsValid() then
		local Displacement = (self.Target:LocalToWorld(self.Target:OBBCenter()) - self.Position)
		NewAng = NewAng*(Displacement:Length()/PingRadius) + Displacement:GetNormalized()*TargetAffinity 
	end
	NewAng = NewAng:GetNormalized()

	self.Entity:SetAngles(NewAng:Angle())
	self.Entity:SetLocalVelocity(NewAng*RocketSpeed)

	self:StartSounds()	
	self.LastWobble = Wobble

end



function ENT:OnRemove()
	self:StopSounds()
end

function ENT:StartSounds()	
	if not self.EmittingSound then
		self.Entity:EmitSound(sndThrustLoop)
		self.EmittingSound = true
	end
end

function ENT:StopSounds()
	if self.EmittingSound then
		self.Entity:StopSound(sndThrustLoop)
		self.Entity:EmitSound(sndStop)
		self.EmittingSound = false
	end	
end

