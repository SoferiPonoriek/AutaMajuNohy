require('buildings')

if TrollAndElves == nil then
	TrollAndElves = class({})
end

function Precache( context )
	PrecacheUnitByNameSync("npc_dota_hero_invoker", context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.TrollAndElves = TrollAndElves()
	GameRules.TrollAndElves:InitGameMode()
end

function TrollAndElves:InitGameMode()

	GameMode = GameRules:GetGameModeEntity()

	-- CUSTOM COMMANDS
	Convars:RegisterCommand( "t&e_show_grid", Dynamic_Wrap(TrollAndElves, 'DisplayBuildingGrids'), "It will show grid around buildings.", 0 )
	Convars:RegisterCommand( "t&e_show_swag", Dynamic_Wrap(TrollAndElves, 'SWAG'), "SWAG", 0 )

	BuildingHelper:BlockGridNavSquares(16384)

	-- Logs
	InitLogFile( "logs/t&e.txt","")

	--ListenToGameEvent('player_connect_full', Dynamic_Wrap(TrollAndElves, 'OnPlayerConnectFull'), self)
	--ListenToGameEvent("player_spawn", Dynamic_Wrap(TrollAndElves, 'PlayerUpdate'), self)
	--ListenToGameEvent( "dota_player_update_hero_selection", Dynamic_Wrap( TrollAndElves, "PlayerUpdate" ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( TrollAndElves, "OnNPCSpawned" ), self )
	print( "Template addon is loaded." )
	--Setting up game rules
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameMode:SetBuybackEnabled( false )
end

-- Evaluate the state of the game
function TrollAndElves:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
--[[
	for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_invoker")) do
        if hero:GetPlayerOwnerID() == -1 then
            local id = hero:GetPlayerOwner():GetPlayerID()
            if id ~= -1 then
                print("Reconnecting hero for player " .. id)
                hero:SetControllableByPlayer(id, true)
                hero:SetPlayerID(id)
                hero:SetMaxHealth(1)
            end
        end
    end]]

	return 1
end
--[[
function TrollAndElves:PlayerUpdate( forceupload )
	TrollAndElves:ShowCenterMessage("it works", 10)
	print("it works")
	--for all,hero in pairs( Entities:FindAllByName("npc_dota_hero_invoker")) do
	--	hero:SetMaxHealth(1)
	--end
end]]
--[[
function TrollAndElves:OnPlayerConnectFull( keys )
	--local truePlayer = EntIndexToHScript( keys.index + 1 )
	--truePlayer:SetGold(1, false)
    local player = PlayerInstanceFromIndex(keys.index + 1)
    --player:SetGold(0, true)
    print("Creating hero.")
    local hero = CreateHeroForPlayer('npc_dota_hero_invoker', player)
    print( "setting up abilities" )
		hero:FindAbilityByName("antimage_blink"):SetLevel(1)
		hero:FindAbilityByName("repair"):SetLevel(1)
		hero:FindAbilityByName("shield"):SetLevel(1)
		hero:FindAbilityByName("root"):SetLevel(1)
		hero:FindAbilityByName("death_prophet_silence"):SetLevel(1)
		hero:FindAbilityByName("buildings"):SetLevel(1)

		hero:SetAbilityPoints(0)

		hero:SetMaxHealth(1)
		print("agi = ".. hero:GetBaseAgility())
		print("hp = ".. hero:GetMaxHealth())
end
]]
function TrollAndElves:OnNPCSpawned( keys )
	local spawnedUnit = EntIndexToHScript( keys.entindex )

	-- Attach client side hero effects on spawning players
	if spawnedUnit and spawnedUnit:IsRealHero() and false == spawnedUnit:IsPhantom() then

		print( "setting up abilities" )
		spawnedUnit:FindAbilityByName("antimage_blink"):SetLevel(1)
		spawnedUnit:FindAbilityByName("repair"):SetLevel(1)
		spawnedUnit:FindAbilityByName("shield"):SetLevel(1)
		spawnedUnit:FindAbilityByName("root"):SetLevel(1)
		spawnedUnit:FindAbilityByName("death_prophet_silence"):SetLevel(1)
		spawnedUnit:FindAbilityByName("buildings"):SetLevel(1)

		spawnedUnit:SetAbilityPoints(0)

		spawnedUnit:SetMaxHealth(1)
		print("hp = ".. spawnedUnit:GetMaxHealth())
		--keys.caster:SetMaxHealth(1)
	-- self:_SpawnHeroClientEffects( spawnedUnit, nPlayerID )
	end
end

function TrollAndElves:ShowCenterMessage( msg, dur )
	local msg = {
		message = msg,
		duration = dur
	}
	print( "[TrollAndElves] Sending message to all clients." )
	FireGameEvent("show_center_message",msg)
end

function TrollAndElves:HandleEventError(name, event, err, v)
  -- This gets fired when an event throws an error

  -- Log to console
  print(err)

  -- Ensure we have data
  name = tostring(name or 'unknown')
  event = tostring(event or 'unknown')
  err = tostring(err or 'unknown')

  -- Tell everyone there was an error
  Say(nil, name .. ' threw an error on event '..event, false)
  Say(nil, err, false)

  if v.errorcallback then
    v.errorcallback() -- call the errorcallback specified by the timer
end

  -- Prevent loop arounds
  if not self.errorHandled then
    -- Store that we handled an error
    self.errorHandled = true
end
end

-- CUSTOM FUNCTIONS WORKING WITH COMMANDS FROM CONSOLE
function TrollAndElves:DisplayBuildingGrids()
  print( '******* Displaying Building Grids ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
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