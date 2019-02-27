rawText = "s<1>st<OnStart>zn<GudautaSam>gn<samSiteLong>nm<2>"
sector, spawnType, zoneName, groupName, number = string.match(rawText, "s<(%d+)>st<(%a+)>zn<(%a+)>gn<(%a+)>nm<(%d+)>")
print(sector, spawnType, zoneName, groupName, number)
