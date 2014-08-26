-- Require some cool files
require('buildings')

-- Create class/object
if TrollAndElves == nil then
	TrollAndElves = class({})
end

-- Load thingies to cache.
function Precache( context )
	PrecacheUnitByNameSync( "npc_dota_hero_invoker", context )
	PrecacheResource( "model", "models/props_rock/badside_rocks005.vmdl", context )
end

-- Create GameMode
function Activate()
	GameRules.TrollAndElves = TrollAndElves()
	GameRules.TrollAndElves:InitGameMode()
end

-- Init GameMode
function TrollAndElves:InitGameMode()

	print( "Initializing Troll and Elves." )
	GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCameraDistanceOverride( 1134 ) -- Default value is 1134
	GameMode:SetBuybackEnabled( false )

	-- Set up some rules and thinker
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetSameHeroSelectionEnabled( true )

	-- Start listening to events
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( TrollAndElves, "OnNPCSpawned" ), self )

	-- Logs
	InitLogFile( "logs/t&e.txt","" )

	-- BuildingHelper shit
	BuildingHelper:BlockGridNavSquares( 16384 )

	-- Commands
	Convars:RegisterCommand( "t&e_show_grid", Dynamic_Wrap(TrollAndElves, 'DisplayBuildingGrids'), "It will show grid around buildings.", 0 )
	Convars:RegisterCommand( "t&e_show_swag", Dynamic_Wrap(TrollAndElves, 'SWAG'), "SWAG", 0 )
	print( "Initialization done." )

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
	spawnedUnit:FindAbilityByName("antimage_blink"):SetLevel(1)
	spawnedUnit:FindAbilityByName("repair"):SetLevel(1)
	spawnedUnit:FindAbilityByName("shield"):SetLevel(1)
	spawnedUnit:FindAbilityByName("root"):SetLevel(1)
	spawnedUnit:FindAbilityByName("death_prophet_silence"):SetLevel(1)
	spawnedUnit:FindAbilityByName("buildings"):SetLevel(1)
	-- Set up it nil ability points cuz why not, right?
	spawnedUnit:SetAbilityPoints(0)
	-- Set unit HP to 1 and then be sad cuz it's not working
	spawnedUnit:SetMaxHealth(1)
	-- Print it out so you know it is working and error is somwhere else
	print( "--- Spawned unit hp = " .. spawnedUnit:GetMaxHealth() .. " ---" )
	end
end

-- Pretty cool functions to print some messages into middle of the screen
function TrollAndElves:ShowCenterMessage( msg, dur )
	local msg = {
		message = msg,
		duration = dur
	}

	print( "--- Message: " .. msg .. "; Duration: " .. dur .. "; ---" )
	FireGameEvent("show_center_message",msg)
end

-- Error handler
function TrollAndElves:HandleEventError( name, event, err, v )
	print( err )

	name = tostring( name or 'unknown' )
	event = tostring( event or 'unknown' )
	err = tostring( err or 'unknown' )

	Say( nil, name .. ' threw an error on event '..event, false )
	Say( nil, err, false )
	Say( nil, "HELL YEA", false )

	-- If there is errorcallback specified by the timer, call it
	if v.errorcallback then
		v.errorcallback()
	end

	-- Prevent loop arounds and store handled error
	if not self.errorHandled then
		self.errorHandled = true
	end
end

-- Functions recting to custome console commands
function TrollAndElves:DisplayBuildingGrids()
	print( "Show me some magic!" )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			for i,v in ipairs(BUILDING_SQUARES) do
				for i2,v2 in ipairs(v) do
					BuildingHelper:PrintSquareFromCenterPoint(v2)
				end
			end
		end
	end
end

function TrollAndElves:SWAG()
	Say(nil, "SWAG?", false)
end