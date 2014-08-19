--[[
	Some tips:
	Make sure you add your units first somewhere in your code before adding any buildings, or else the units won't be checked for collision:
	BuildingHelper:AddUnit(heroEntity)
	Put BuildingHelper:BlockGridNavSquares(nMapLength) in your InitGameMode function.
	If units are getting stuck put "BoundsHullName"   "DOTA_HULL_SIZE_TOWER" for buildings in npc_units_custom.txt
]]


BUILD_TIME=1.0

function getBuildingPoint(keys)
	local point = BuildingHelper:AddBuildingToGrid(keys.target_points[1], 2, keys.caster)
	if point ~= -1 then
		local farm = CreateUnitByName("npc_dota_creature_gnoll_assassin", point, false, nil, nil, keys.caster:GetTeam())
		BuildingHelper:AddBuilding(farm)
		farm:UpdateHealth(BUILD_TIME,true,.85)
		farm:SetHullRadius(64)
		farm:SetControllableByPlayer( keys.caster:GetPlayerID(), true )
	else
		--Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
	end
end

function getHardFarmPoint(keys)
	local caster = keys.caster
	local point = BuildingHelper:AddBuildingToGrid(keys.target_points[1], 4, caster)
	if point == -1 then
		-- Refund the cost.
		caster:SetGold(caster:GetGold()+5, false)
		--Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
		return
	else
		caster:SetGold(caster:GetGold()-5, false)
		local farm = CreateUnitByName("building_rock", point, false, nil, nil, caster:GetTeam())
		BuildingHelper:AddBuilding(farm)
		farm:UpdateHealth(BUILD_TIME,true,.75)
		farm:SetHullRadius(157)--64
		farm:SetControllableByPlayer( caster:GetPlayerID(), true )
	end
end

-- Constant placed up here so its easy to see
PLACED_BUILDING_RADIUS = 160;
function placeBuilding(keys)
    -- We need a few variables. They should be self-explanatory
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
    -- Hoooooly complicated! Basically, this line finds all entities within PLACED_BUILDING_RADIUS of where we want to put the tower
    -- The for loop then counts them
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        -- is this a valid blocker?
        if thing:GetClassname() == "npc_dota_creature" then
            blocking_counter = blocking_counter + 1
            print("blocking creature")
        end
    end
    print(blocking_counter .. " blockers")

    -- If there are any entities to block us placing the tower, don't place it, otherwise: do!
    if( blocking_counter < 1) then
        tower = CreateUnitByName("building_rock", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        -- Rotate it as we want
        tower:SetAngles(90.0,90.0,90.0)
    end
end 