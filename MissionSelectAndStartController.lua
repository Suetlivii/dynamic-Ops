--Contain all task controllers
--Task controller must have :StartTask() method
--Tasks can be main and additional

TasksContainer = {}

function TasksContainer:New()

    newObj = 
    {
        tasksList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function TasksContainer:GetRandomTask()

    local tableCount = 0

    for i in pairs(self.tasksList) do
        if self.tasksList[i] ~= nil then
            tableCount = tableCount + 1
        end
    end

    if tableCount >= 1 then
        math.randomseed(os.time())
        local randomTaskInt = math.random(1, tableCount)
        return self.tasksList[randomTaskInt]
    end
end

function TasksContainer:AddTask(newTask)

    if newTask ~= nil then
        table.insert(self.tasksList, newTask)
    end

end

function TasksContainer:RemoveTask(taskToBeRemoved)

    if taskToBeRemoved ~= nil then
        table.remove(self.tasksList, taskToBeRemoved)
    end

end

--Task Class for testing
TestTaskDummy = {}

function TestTaskDummy:New()

    newObj = 
    {
        dummyText = nil
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function TestTaskDummy:StartTask()

    print(tostring(self.dummyText))

end

local function TestTasks()

    testTask1 = TestTaskDummy:New()
    testTask1.dummyText = "test text 1"
    mainTasksContainer:AddTask(testTask1)

    testTask2 = TestTaskDummy:New()
    testTask2.dummyText = "test text 2"
    mainTasksContainer:AddTask(testTask2)

    testTask3 = TestTaskDummy:New()
    testTask3.dummyText = "test text 3"
    mainTasksContainer:AddTask(testTask3)

    mainTasksContainer:GetRandomTask():StartTask()

end

mainTasksContainer = TasksContainer:New()
additionalTasksContainer = TasksContainer:New()

--TestTasks()





