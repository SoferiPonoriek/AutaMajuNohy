function Destroy( keys )
	local farm = keys.caster
	DeepPrintTable(keys.caster)
	BuildingHelper:AddBuilding(farm)
	farm:RemoveBuilding(4, true)
end

function BuildRockLvl1(keys)
	local caster = keys.caster
	local point = BuildingHelper:AddBuildingToGrid(keys.target_points[1], 4, caster)
	if point == -1 then
		-- Refund the cost.
		caster:SetGold(caster:GetGold()+4, false)
		--Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
		return
	else
		--caster:SetGold(caster:GetGold()-4, false)
		local farm = CreateUnitByName("building_rock", point, false, nil, nil, caster:GetTeam())
		BuildingHelper:AddBuilding(farm)
		farm:UpdateHealth(1,true,.75)--buildTime, ,scale
		farm:SetHullRadius(157)
		farm:SetControllableByPlayer( caster:GetPlayerID(), true )
		farm:FindAbilityByName("buildings_destroy"):SetLevel(1)
		farm:FindAbilityByName("repair"):SetLevel(0)
	end
end