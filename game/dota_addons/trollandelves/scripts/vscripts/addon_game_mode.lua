-- Require some cool files
require( 'buildings' )
require( 'secret' )

-- Define some (one) thinkerino times
BASE_THINK = 2

-- Create class/object
if TrollAndElves == nil then
    TrollAndElves = class({})
end

-- Load thingies to cache.
function Precache( context )
    PrecacheUnitByNameSync( "npc_dota_hero_invoker", context )
    PrecacheResource( "model", "models/props_rock/badside_rocks005.vmdl", context )
    PrecacheResource( "model", "models/props_debris/shop_set_seat001.vmdl", context )
end

-- Create GameMode
function Activate()
	GameRules.TrollAndElves = TrollAndElves()
	GameRules.TrollAndElves:InitGameMode()
end

-- Init GameMode
function TrollAndElves:InitGameMode()

    print( "[t&e] Initializing Troll and Elves." )
    GameMode = GameRules:GetGameModeEntity()

    GameMode:SetCameraDistanceOverride( 1134 ) -- Default value is 1134
    GameMode:SetBuybackEnabled( false )

    -- Set up some rules and thinker
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", BASE_THINK )
    GameRules:SetSameHeroSelectionEnabled( true )

    -- Start listening to events
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( TrollAndElves, "OnNPCSpawned" ), self )

    -- Logs
    InitLogFile( "logs/t&e.txt","" )

    -- BuildingHelper shit
    BuildingHelper:BlockGridNavSquares( 16384 )

    -- Commands
    Convars:RegisterCommand( "t&e_show_grid", Dynamic_Wrap( Secret, 'DisplayBuildingGrids' ), "It will show grid around buildings.", 0 )
    Convars:RegisterCommand( "t&e_show_swag", Dynamic_Wrap( Secret, 'ShowSwag' ), "SWAG", 0 )
    print( "[t&e] Initialization done." )

end

-- Evaluate the state of the game
function TrollAndElves:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        -- If game is in progress check if game is not ended
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    -- If game is not ended continue
    return 1
end

-- Do some sexi stuff when something is spawned
function TrollAndElves:OnNPCSpawned( keys )
    -- Find it and check if it is real hero
    local spawnedUnit = EntIndexToHScript( keys.entindex )
    if spawnedUnit and spawnedUnit:IsRealHero() and false == spawnedUnit:IsPhantom() then
    -- Set up it some cool abilities
    if spawnedUnit:GetGold() == 230 then
        spawnedUnit:SetGold(30, false)
    end
    spawnedUnit:FindAbilityByName( "antimage_blink" ):SetLevel( 1 )
    spawnedUnit:FindAbilityByName( "repair" ):SetLevel( 1 )
    spawnedUnit:FindAbilityByName( "shield" ):SetLevel( 1 )
    spawnedUnit:FindAbilityByName( "root" ):SetLevel( 1 )
    spawnedUnit:FindAbilityByName( "death_prophet_silence" ):SetLevel( 1 )
    spawnedUnit:FindAbilityByName( "buildings" ):SetLevel( 1 )
    -- Set up it nil ability points cuz why not, right?
    spawnedUnit:SetAbilityPoints( 0 )
    end
end