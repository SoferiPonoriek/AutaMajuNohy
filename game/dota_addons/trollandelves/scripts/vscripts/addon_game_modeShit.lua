if CAddonTemplateGameMode == nil then
    CAddonTemplateGameMode = class({})
end

function Precache( context )
    PrecacheUnitByNameSync("npc_dota_hero_crystal_maiden", context)
end

function Activate()
    GameRules.AddonTemplate = CAddonTemplateGameMode()
    GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
    GameRules:SetHeroSelectionTime( 0.0 )
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerConnectFull'), self)
end

function CAddonTemplateGameMode:OnThink()
    -- Reconnect heroes
    for _,hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_crystal_maiden")) do
        if hero:GetPlayerOwnerID() == -1 then
            local id = hero:GetPlayerOwner():GetPlayerID()
            if id ~= -1 then
                print("Reconnecting hero for player " .. id)
                hero:SetControllableByPlayer(id, true)
                hero:SetPlayerID(id)
            end
        end
    end

    -- (Rest of your code)

end

function CAddonTemplateGameMode:OnPlayerConnectFull(keys)
    local player = PlayerInstanceFromIndex(keys.index + 1)
    print("Creating hero.")
    local hero = CreateHeroForPlayer('npc_dota_hero_crystal_maiden', player)
end