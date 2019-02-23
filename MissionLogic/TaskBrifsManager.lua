--Contains all brifs, print all of them in DCS
--Task can be added with priority in list
MissionBrifManager = {}

function MissionBrifManager:New()

    newObj = 
    {
        BrifsListRU = {},
        BrifsListEN = {}
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function MissionBrifManager:AddNewBrif(newBrif, priority)

    if priority == nil then
        table.insert(self.BrifsListEN, newBrif)
    end

    if priority ~= nil and priority >= 0 then
        table.insert(self.BrifsListEN, priority, newBrif)
    end

end

function MissionBrifManager:PrintBrifsToDCS(coalition)

    for i in ipairs(self.BrifsListEN) do
        self.BrifsListEN[i]:PrintToCoalitionDCS(coalition)
    end

end
--------------------------------

--contains message and print it to DCS
TaskBrifController = {}

function TaskBrifController:New()

    newObj = 
    {
        brifText = "No text"
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function TaskBrifController:PrintToClientDCS(client)

    if self.brifText ~= nil and self.brifText ~= "" then
    MESSAGE:New( self.brifText, 60):ToClient(client)
    end

end

function TaskBrifController:PrintToCoalitionDCS( coalition )

    if self.brifText ~= nil and self.brifText ~= "" then
    MESSAGE:New( self.brifText, 60):ToCoalition( coalition )
    end

end
--------------------------------

local function TasksReportTest()

    testTask1 = TaskBrifController:New()
    testTask1.brifText = "Test task"
    missionBrifManager:AddNewBrif(testTask1)

    testTask2 = TaskBrifController:New()
    testTask2.brifText = "Test task2"
    missionBrifManager:AddNewBrif(testTask2)

end

missionBrifManager = MissionBrifManager:New()

local function PrintBrifs(coalition)

    missionBrifManager:PrintBrifsToDCS(coalition)

end

--TasksReportTest()

MenuTasks = MENU_COALITION:New( coalition.side.BLUE, "Tasks" )
MenuTasksShow = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Show Tasks", MenuTasks, PrintBrifs, coalition.side.BLUE)


