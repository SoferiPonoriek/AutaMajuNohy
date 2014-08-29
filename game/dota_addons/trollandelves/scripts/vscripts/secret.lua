-- Some cool variables
SECRET_THINK = 0.1

if Secret == nil then
    print( '[t&e] Creating Secret' )
    Secret = {}
    Secret.__index = Secret
end

function Secret:new( o )
    o = o or {}
    setmetatable( o, Secret )
    return o
end

function Secret:start()
    Secret = self
    self.Secret = {}

    local ent = Entities:CreateByClassname("info_target") -- Entities:FindByClassname(nil, 'CWorld')
    ent:SetThink("Think", self, "Secret", SECRET_THINK)
end

function Secret:Think()
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return
    end

    -- Track game time, since the dt passed in to think is actually wall-clock time not simulation time.
    local now = GameRules:GetGameTime()

    -- Process Secret
    for k,v in pairs(Secret.Secret) do
        local bUseGameTime = true
        if v.useGameTime ~= nil and v.useGameTime == false then
            bUseGameTime = false
        end

        local bOldStyle = false
        if v.useOldStyle ~= nil and v.useOldStyle == true then
            bOldStyle = true
        end

        local now = GameRules:GetGameTime()
        if not bUseGameTime then
            now = Time()
        end

        if v.endTime == nil then
            v.endTime = now
        end
        -- Check if the timer has finished
        if now >= v.endTime then
            -- Remove from Secret list
            Secret.Secret[k] = nil
      
            -- Run the callback
            local status, nextCall = pcall(v.callback, GameRules:GetGameModeEntity(), v)

            -- Make sure it worked
            if status then
                -- Check if it needs to loop
                if nextCall then
                    -- Change its end time
                    if bOldStyle then
                        v.endTime = v.endTime + nextCall - now
                    else
                        v.endTime = v.endTime + nextCall
                    end
                    Secret.Secret[k] = v
                end
                -- Update timer data
                --self:UpdateTimerData()
            else
            -- Nope, handle the error
                Secret:HandleEventError('Timer', k, nextCall)
            end
        end
    end

    return SECRET_THINK
end

function Secret:CreateTimer(name, args)
    if type(name) == "function" then
        args = {callback = name}
        name = DoUniqueString("timer")
    elseif type(name) == "table" then
        args = name
        name = DoUniqueString("timer")
    elseif type(name) == "number" then
        args = {endTime = name, callback = args}
        name = DoUniqueString("timer")
    end
    if not args.callback then
        print("Invalid timer created: "..name)
        return
    end


    local now = GameRules:GetGameTime()
    if args.useGameTime ~= nil and args.useGameTime == false then
        now = Time()
    end

    if args.endTime == nil then
        args.endTime = now
    elseif args.useOldStyle == nil or args.useOldStyle == false then
        args.endTime = now + args.endTime
    end

    Secret.Secret[name] = args
end

function Secret:RemoveTimer(name)
    Secret.Secret[name] = nil
end

function Secret:RemoveTimers(killAll)
    local Secret = {}

    if not killAll then
        for k,v in pairs(Secret.Secret) do
            if v.persist then
                Secret[k] = v
            end
        end
    end

    Secret.Secret = Secret
end

-- Error handler
function Secret:HandleEventError( name, event, err )
    print( err )

    name = tostring( name or 'unknown' )
    event = tostring( event or 'unknown' )
    err = tostring( err or 'unknown' )

    --Say( nil, name .. ' threw an error on event '..event, false )
    --Say( nil, err, false )

    -- Prevent loop arounds and store handled error
    if not self.errorHandled then
        self.errorHandled = true
    end
end

-- Pretty cool functions to print some messages into middle of the screen
function Secret:ShowCenterMessage( msg, dur )
    local msg = {
        message = msg,
        duration = dur
    }

    print( "--- Message: " .. msg .. "; Duration: " .. dur .. "; ---" )
    FireGameEvent("show_center_message",msg)
end

-- Function to destroy buildings on 1 tale
function Destroy4( keys )
    keys.caster:RemoveBuilding( 4, true )
end

-- Function to destroy buildings on 4 tales
function Destroy8( keys )
    keys.caster:RemoveBuilding( 8, true )
end

function Destroy8House( keys )
    Secret:RemoveTimer( "goldsFromHouse" .. keys.caster:GetPlayerOwnerID() )
    keys.caster:RemoveBuilding( 8, true )
end

function Destroy8House1( keys )
    Secret:RemoveTimer( "goldsFromHouse" .. keys.caster:GetPlayerOwnerID() )
    keys.caster:GetOwnerEntity():FindAbilityByName( "build_house_1" ):SetLevel( 1 )
    keys.caster:RemoveBuilding( 8, true )
end

-- Functions recting to custome console commands
function Secret:DisplayBuildingGrids()
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

function Secret:ShowSwag()
    Say(nil, "SWAG", false)
end

Secret:start()

--[[

  -- A timer running every second that starts immediately on the next frame, respects pauses
  Secret:CreateTimer(function()
      print ("Hello. I'm running immediately and then every second thereafter.")
      return 1.0
    end
  )

  -- A timer running every second that starts 5 seconds in the future, respects pauses
  Secret:CreateTimer(5, function()
      print ("Hello. I'm running 5 seconds after you called me and then every second thereafter.")
      return 1.0
    end
  )

  -- 10 second delayed, run once using gametime (respect pauses)
  Secret:CreateTimer({
    endTime = 10, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      print ("Hello. I'm running 10 seconds after when I was started.")
    end
  })

  -- 10 second delayed, run once regardless of pauses
  Secret:CreateTimer({
    useGameTime = false,
    endTime = 10, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      print ("Hello. I'm running 10 seconds after I was started even if someone paused the game.")
    end
  })


  -- A timer running every second that starts after 2 minutes regardless of pauses
  Secret:CreateTimer("uniqueTimerString3", {
    useGameTime = false,
    endTime = 120,
    callback = function()
      print ("Hello. I'm running after 2 minutes and then every second thereafter.")
      return 1
    end
  })


  -- A timer using the old style to repeat every second starting 5 seconds ahead
  Secret:CreateTimer("uniqueTimerString3", {
    useOldStyle = true,
    endTime = GameRules:GetGameTime() + 5,
    callback = function()
      print ("Hello. I'm running after 5 seconds and then every second thereafter.")
      return GameRules:GetGameTime() + 1
    end
  })

]]