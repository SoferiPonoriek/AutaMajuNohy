require('buildinghelper')

if CTrollAndElvesGameMode == nil then
	CTrollAndElvesGameMode = class({})
end

function Precache( context )
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
	GameRules.TrollAndElves = CTrollAndElvesGameMode()
	GameRules.TrollAndElves:InitGameMode()
end

function CTrollAndElvesGameMode:InitGameMode()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CTrollAndElvesGameMode, "OnNPCSpawned" ), self )
	Convars:RegisterCommand( "buildinghelper", Dynamic_Wrap(CTrollAndElvesGameMode, 'DisplayBuildingGrids'), "blah", 0 )
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime( 30 )
	GameRules:SetPreGameTime( 30 )
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end


function CTrollAndElvesGameMode:DisplayBuildingGrids()
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
  print( '*********************************************' )
end

-- Evaluate the state of the game
function CTrollAndElvesGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CTrollAndElvesGameMode:OnNPCSpawned( event )
local spawnedUnit = EntIndexToHScript( event.entindex )
if not spawnedUnit or spawnedUnit:IsPhantom() then
return
end

-- Attach client side hero effects on spawning players
if spawnedUnit:IsRealHero() then
print( "setting up abilities" )
spawnedUnit:FindAbilityByName("antimage_blink"):SetLevel(1)
spawnedUnit:FindAbilityByName("repair"):SetLevel(1)
spawnedUnit:FindAbilityByName("shield"):SetLevel(1)
spawnedUnit:FindAbilityByName("lone_druid_spirit_bear_entangle"):SetLevel(1)
spawnedUnit:FindAbilityByName("death_prophet_silence"):SetLevel(1)
spawnedUnit:FindAbilityByName("buildings"):SetLevel(1)

spawnedUnit:SetAbilityPoints(0)

-- self:_SpawnHeroClientEffects( spawnedUnit, nPlayerID )

end
end
