-----------
--Utility that parse zone dcs full name and makes it easy to check zone parameters
-----------


--ZoneNameParser
ZoneNameParser = {}

function ZoneNameParser:New(zoneFullName)
    newObj = 
    {

    }
    self.__index = self
    return setmetatable(newObj, self)
end

function ZoneNameParser:GetZoneFullPrefix()

end

function ZoneNameParser:GetZoneFullName()

end
--ZoneNameParser end