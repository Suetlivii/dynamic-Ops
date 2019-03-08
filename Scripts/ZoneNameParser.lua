-----------
--Utility that parse zone dcs full name and makes it easy to check zone parameters
--Dependencies: Nothing
-----------


--ZoneNameParser
ZoneNameParser = {}

function ZoneNameParser:New()
    newObj = 
    {
        sectorNumber = -1,
        spawnType = "",
        zonePrefix = "",
        groupPrefix = "",
        zoneNumber = -1
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function ZoneNameParser:Parse(zoneFullName)
    self.sectorNumber = string.match(zoneFullName, "s<(%d+)>")
    self.spawnType = string.match(zoneFullName, "st<(%a+)>")
    self.zonePrefix = string.match(zoneFullName, "zp<(%a+)>")
    self.groupPrefix = string.match(zoneFullName, "gp<(%a+)>")
    self.zoneNumber = string.match(zoneFullName, "nm<(%d+)>")
end

function ZoneNameParser:GetZoneFullPrefix()
    --s<SectorNumber>st<SpawnType>zp<ZonePrefix>gp<GroupPrefix>nm<ZoneNumber>
    local fullPrefix = string.format("s<%s>st<%s>zp<%s>gp<%s>", self.sectorNumber, self.spawnType, self.zonePrefix, self.groupPrefix)
    return fullPrefix
end

function ZoneNameParser:GetZoneFullName()
    local fullName = string.format("s<%s>st<%s>zp<%s>gp<%s>nm<%s>", self.sectorNumber, self.spawnType, self.zonePrefix, self.groupPrefix, self.zoneNumber)
    return fullName
end
--ZoneNameParser end

