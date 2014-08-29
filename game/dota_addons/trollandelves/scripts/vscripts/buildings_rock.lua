function BuildRock1( keys )
	local ownersHero = keys.caster
	local point = BuildingHelper:AddBuildingToGrid( keys.target_points[1], 4, ownersHero )
	if point == -1 then
		-- Refund the cost.
		ownersHero:SetGold(ownersHero:GetGold()+4, false)
		--Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
		return
	else
		local rock = CreateUnitByName( "building_rock_1", point, false, nil, nil, ownersHero:GetTeam() )
		BuildingHelper:AddBuilding( rock )
		rock:UpdateHealth( 1,true,.75 )--buildTime, gradual enlargement, scale
		rock:SetHullRadius( 157 )
		rock:SetOwner( ownersHero )
		rock:SetControllableByPlayer( ownersHero:GetPlayerID(), true )
		rock:FindAbilityByName( "build_rock_2" ):SetLevel( 1 )
		rock:FindAbilityByName( "buildings_destroy_4" ):SetLevel( 1 )
	end
end

function BuildRock2( keys )
	keys.caster:SetUnitName( "building_rock_2" )
	print ( "[t&e] hell yea " .. keys.caster:GetUnitName() )
	keys.caster:SetMaxHealth( 70 )
	keys.caster:SetHealth( keys.caster:GetHealth() + 20 )
	keys.caster:FindAbilityByName( "build_rock_2" ):SetLevel( 0 )
end

-- LOOK AT THIS