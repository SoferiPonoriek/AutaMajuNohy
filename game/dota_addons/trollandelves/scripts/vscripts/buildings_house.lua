GOLDS_PER_SEC = 1

function BuildHouse1( keys )
    local caster = keys.caster
    local point = BuildingHelper:AddBuildingToGrid( keys.target_points[1], 8, caster )
    if point == -1 then
        --Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
        return
    else
        local house = CreateUnitByName( "building_house_1", point, false, nil, nil, caster:GetTeam() )
        BuildingHelper:AddBuilding( house )
        house:UpdateHealth( 1, true, 8 )--buildTime, gradual enlargement, scale
        house:SetHullRadius( 390 )
        house:SetOwner( caster )
        house:SetControllableByPlayer( caster:GetPlayerID(), true )
        Secret:CreateTimer( "golds" .. caster:GetPlayerID() , {
            callback = function()
                caster:SetGold( caster:GetGold() + GOLDS_PER_SEC, false )
                return 1
            end
        })
        house:FindAbilityByName( "build_house_2" ):SetLevel( 1 )
        house:FindAbilityByName( "buildings_destroy_8" ):SetLevel( 1 )
        print ( "[t&e] hell yea house " .. house:GetUnitName() )
    end
end

function BuildHouse2( keys )
    -- potrebuje rock aby sa mohlo vykonať
    local caster = keys.caster
    GOLDS_PER_SEC = 2
    caster:SetUnitName( "building_house_2" )
    caster:SetMaxHealth( 20 )
    caster:SetHealth( caster:GetHealth() + 10 )
    keys.caster:FindAbilityByName( "build_house_2" ):SetLevel( 0 )
end