function EFFECT:Init( data )
	self.StartPos= data:GetOrigin()
	local Pos = self.StartPos
	local Normal = Vector(0,0,1)
	
	Pos = Pos + Normal * 2
	
	local emitter = ParticleEmitter( Pos )
		
		for i=1, 23 do
		
			local particle = emitter:Add( "particles/smokey", Pos + Vector(math.Rand(-50,50),math.Rand(-50,50),math.Rand(-14,30)))

			particle:SetVelocity( Vector(math.Rand(-30,30),math.Rand(-30,30),math.Rand(-30,30)) )
			particle:SetDieTime( math.Rand( 5, 8 ) )
			particle:SetStartAlpha( math.Rand( 80, 125 ) )
			particle:SetStartSize( math.Rand( 32, 82 ) )
			particle:SetEndSize( math.Rand( 162, 230 ) )
			particle:SetRoll( math.Rand( 480, 540 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 250, 250, 250 )
			particle:VelocityDecay( false )
			particle:SetAirResistance( 4000 )
			particle:SetGravity( Vector( 0, 0, 20 ) )
			
		end
	emitter:Finish()
			for i=1, 13 do
		
			local particle = emitter:Add( "particles/flamelet"..math.Rand(1,4), Pos + Vector(-80,math.Rand(-10,10),math.Rand(-24,10)))

			particle:SetVelocity( Vector(math.Rand(-20,30),math.Rand(-10,30),math.Rand(-10,0)) )
			particle:SetDieTime( math.Rand( 6.1,9.4 ) )
			particle:SetStartAlpha( math.Rand( 80, 125 ) )
			particle:SetStartSize( math.Rand( 30, 60 ) )
			particle:SetEndSize( math.Rand( 10, 20 ) )
			particle:SetRoll( math.Rand( 180, 240 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 230, 230, 230 )
			particle:VelocityDecay( false )
			particle:SetAirResistance( 40 )
			particle:SetGravity( Vector( 0, 0, 0 ) )
			
		end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end



