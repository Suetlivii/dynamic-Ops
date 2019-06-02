-----------------------------------------------------------------------------------------------------------------------------------------------
-- Debuger used for debug
-- 
-----------------------------------------------------------------------------------------------------------------------------------------------
Debuger = {}

function Debuger:New(_isDebugMode)
    newObj = 
    {
        isDebugMode = _isDebugMode
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function Debuger:Log(msgString)
    if self.isDebugMode == true then
        newDebugMessage = MESSAGE:New(tostring(msgString .. "\n"), 10, "DEBUG", false):ToAll()
        BASE:E(tostring(msgString))
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------------------------------
-- MapMark
--
------------------------------------------------------------------------------------------------------------------------------------------------
MapMark = {}

function MapMark:New()
    newObj = 
    {
        markCoalition = nil,
        markID = nil,
        destroyGroup = nil
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function MapMark:CreateMark(_coalition, _textString, _vec2Coords)
    if _coalition ~= nil and _textString ~= nil and _vec2Coords ~= nil then

        if _coalition == coalition.side.RED then 
            local markID = _vec2Coords:MarkToCoalitionRed( _textString, true)
            self.markID = markID
        end

        if _coalition == coalition.side.BLUE then 
            local markID = _vec2Coords:MarkToCoalitionBlue( _textString, true)
            self.markID = markID
        end

    end
end

function MapMark:Destroy()
    if self.markID ~= nil then 
        COORDINATE:RemoveMark(self.markID)
    end
end

function MapMark:SetDestroyGroup(_group)
    _group:HandleEvent(EVENTS.Dead)
    function _group:OnEventDead( EventData )
        self:Destroy()
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------------------------
-- MarkCommandController
--
-----------------------------------------------------------------------------------------------------------------------------------------------

MarkCommandController = {}

function MarkCommandController:New()
    newObj = 
    {
        
    }
    self.__index = self
    return setmetatable(newObj, self)   
end

function MarkCommandController:SetExplosion()
    MarkRemovedEventHandler = EVENTHANDLER:New()
    MarkRemovedEventHandler:HandleEvent(EVENTS.MarkRemoved)
    function MarkRemovedEventHandler:OnEventMarkRemoved(EventData)
        if EventData.text:lower():find("-exp") then
            local markText = string.match(EventData.text, "-exp<(%d+)>")
            local vec3 = {y=EventData.pos.y, x=EventData.pos.z, z=EventData.pos.x}
            local coord = COORDINATE:NewFromVec3(vec3):Explosion(tonumber(markText))
        end 
    end
end

function MarkCommandController:SetSpawn()
    MarkRemovedEventHandler = EVENTHANDLER:New()
    MarkRemovedEventHandler:HandleEvent(EVENTS.MarkRemoved)
    function MarkRemovedEventHandler:OnEventMarkRemoved(EventData)
        if EventData.text:lower():find("-spawn") then
            local markText = string.match(EventData.text, "-spawn<(%a+)>")
            local vec3 = {y=EventData.pos.y, x=EventData.pos.z, z=EventData.pos.x}
            local coord = COORDINATE:NewFromVec3(vec3)
            local spawn = SPAWN:New(markText):SpawnFromVec2(coord:GetVec2())
        end 
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------
