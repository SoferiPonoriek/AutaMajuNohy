function BuildHouse1( keys )
    local caster = keys.caster
    local point = BuildingHelper:AddBuildingToGrid( keys.target_points[1], 8, caster )
    if point == -1 then
        --Fire a game event here and use Actionscript to let the player know he can't place a building at this spot.
        return
    else
        caster:FindAbilityByName( "build_house_1" ):SetLevel( 0 )
        local house = CreateUnitByName( "building_house_1", point, false, nil, nil, caster:GetTeam() )
        BuildingHelper:AddBuilding( house )
        house:UpdateHealth( 1, true, 8 )--buildTime, gradual enlargement, scale
        house:SetHullRadius( 390 )
        house:SetOwner( caster )
        house:SetControllableByPlayer( caster:GetPlayerID(), true )
        Secret:CreateTimer( "goldsFromHouse" .. caster:GetPlayerID() , {
            callback = function()
                caster:SetGold( caster:GetGold() + 1, false )
                return 1
            end
        })
        house:FindAbilityByName( "build_house_2" ):SetLevel( 1 )
        house:FindAbilityByName( "buildings_destroy_8_house" ):SetLevel( 1 )
        print ( "[t&e] hell yea house " .. house:GetUnitName() )
    end
end

function BuildHouse2( keys )
    -- potrebuje rock aby sa mohlo vykonať
    local hero = keys.caster:GetOwnerEntity()
    local house = keys.caster
    print( "id = " .. hero:GetPlayerID() )
    Secret:RemoveTimer( "goldsFromHouse" .. hero:GetPlayerID() )
    Secret:CreateTimer( "goldsFromHouse" .. hero:GetPlayerID() , {
            callback = function()
                hero:SetGold( hero:GetGold() + 2, false )
                return 1
            end
        })

    house:SetUnitName( "building_house_2" )
    print ( "[t&e] hell yea " .. house:GetUnitName() )
    house:SetMaxHealth( 20 )
    house:SetHealth( house:GetHealth() + 10 )
    house:FindAbilityByName( "build_house_2" ):SetLevel( 0 )
end