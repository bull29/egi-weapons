function EFFECT:Init( data )
	local pos = data:GetOrigin() -- not same as below
	local Pos = data:GetOrigin() -- not same as above
	local rVec = VectorRand()*5
	local pos = pos + 128*rVec
	local emitter = ParticleEmitter( pos )
		for i=1, math.ceil( 13 ) do		
			for j=1, 12 do
			local particle = emitter:Add( "particles/flamelet"..math.Rand( 1, 5 ), pos - rVec * 8 * j )
			particle:SetVelocity( rVec*math.Rand( 2, 3 ) )
			particle:SetDieTime( math.Rand( 2, 5 ) )
			particle:SetStartAlpha( math.Rand( 230, 250 ) )
			particle:SetStartSize( j*math.Rand( 2, 3 ) )
			particle:SetEndSize( j*math.Rand( 1, 3 ) )
			particle:SetRoll( math.Rand( 20, 90 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 100, math.Rand( 90, 134 ), math.Rand( 220, 255 ) )
			particle:VelocityDecay( true )
			
			local eparticle = emitter:Add( "particles/flamelet"..math.Rand( 1, 5 ), pos - rVec * 6 * j )
			eparticle:SetVelocity( rVec*math.Rand( 2, 3 ) )
			eparticle:SetDieTime( math.Rand( 2, 5 ) )
			eparticle:SetStartAlpha( math.Rand(230, 250) )
			eparticle:SetStartSize( j*math.Rand( 2, 3 ) )
			eparticle:SetEndSize( j*math.Rand( 1, 3 ) )
			eparticle:SetRoll( math.Rand( 20, 90 ) )
			eparticle:SetRollDelta( math.Rand( -1, 1 ) )
			eparticle:SetColor( 90, math.Rand( 64, 108 ), math.Rand( 130, 255 ) )
			eparticle:VelocityDecay( true )
			
		end
	end
			for i=1, 10 do
			local particle = emitter:Add( "particles/flamelet"..math.Rand( 1, 4 ), Pos + Vector( math.Rand( -70, 70 ), math.Rand( -70, 70 ), math.Rand( -70, 70 ) ) )
			particle:SetVelocity( Vector( math.Rand( -20, 30 ), math.Rand( -10, 30 ), math.Rand( -10, 0 ) ) )
			particle:SetDieTime( math.Rand( 3, 6 ) )
			particle:SetStartAlpha( math.Rand( 190, 225 ) )
			particle:SetStartSize( math.Rand( 80, 150 ) )
			particle:SetEndSize( math.Rand( 20, 60 ) )
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



