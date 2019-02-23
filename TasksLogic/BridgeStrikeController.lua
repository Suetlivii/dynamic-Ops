--Create east bridge strike mission

taskStrikeEastBidge = TaskController:New()

function taskStrikeEastBidge:StartTask()

    local spawnZones = SET_ZONE:New()
    spawnZones:FilterPrefixes( {"RedBridgeEast"} )
    spawnZones:FilterOnce()

    local targetStatic = SPAWNSTATIC:NewFromStatic( "targetStatic" )
    targetStatic:SpawnFromZone( spawnZones:GetRandomZone(), 0, "bridgeTargetStatic")

    local targetStaticUNIT = STATIC:FindByName( "bridgeTargetStatic" )
    targetStaticUNIT:HandleEvent( EVENTS.Dead )

    taskBrifStrikeEastBidge = TaskBrifController:New()
    missionBrifManager:AddNewBrif(taskBrifStrikeEastBidge)

    taskBrifStrikeEastBidge.brifText =
    "Destroy bridge"

    local bridgeCoord = targetStaticUNIT:GetCoordinate()
    local markID = bridgeCoord:MarkToCoalitionBlue( "STRIKE: Bridge" )

    function targetStaticUNIT:OnEventDead(EventData)

        MESSAGE:NewType("Bridge Destroyed!", MESSAGE.Type.Information ):ToAll()

        taskBrifStrikeEastBidge.brifText =
        "TASK: Strike\r" ..
        "\r" ..
        "Bridge is destroyed, task completed." 

    end

end

mainTasksContainer:AddTask(taskStrikeEastBidge)
