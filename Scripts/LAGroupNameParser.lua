-----------
--Utility that parse dcs late activate groups full name and makes it easy to check groups parameters
--Dependencies: Nothing
-----------


--LAGroupNameParser
--s<>cl<>st<>gn<>nm<>
LAGroupNameParser = {}

function LAGroupNameParser:New()
    newObj = 
    {
        sectorNumber = 0,
        coalition = "no",
        spawnType = "no",
        groupName = "no",
        groupNumber = 0
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function LAGroupNameParser:Parse(laGroupFullName)
    self.sectorNumber = string.match(laGroupFullName, "s<(%d+)>")
    self.coalition = string.match(laGroupFullName, "cl<(%a+)>")
    self.spawnType = string.match(laGroupFullName, "st<(%a+)>")
    self.groupName = string.match(laGroupFullName, "gn<(%a+)>")
    self.groupNumber = string.match(laGroupFullName, "nm<(%d+)>")
end

function LAGroupNameParser:GetLAGroupFullPrefix()
    --s<SectorNumber>st<SpawnType>zp<ZonePrefix>gp<GroupPrefix>nm<ZoneNumber>
    local fullPrefix = string.format("s<%s>cl<%s>st<%s>gn<%s>", self.sectorNumber, self.coalition, self.spawnType, self.groupName)
    return fullPrefix
end

function LAGroupNameParser:GetLAGroupFullName()
    local fullName = string.format("s<%s>cl<%s>st<%s>gn<%s>nm<%s>", self.sectorNumber, self.coalition, self.spawnType, self.groupName, self.groupNumber)
    return fullName
end
--LAGroupNameParser end