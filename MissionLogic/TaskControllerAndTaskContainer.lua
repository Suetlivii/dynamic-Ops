--Contain all task controllers
--Task controller must have :StartTask() method
--Tasks can be main and additional

TasksManager = {}

function TasksManager:New()

    newObj = 
    {
        tasksList = {}
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function TasksManager:GetRandomTask()

    local tableCount = 0

    for i in pairs(self.tasksList) do
        if self.tasksList[i] ~= nil then
            tableCount = tableCount + 1
        end
    end

    if tableCount >= 1 then
        --math.randomseed(os.time())
        local randomTaskInt = math.random(1, tableCount)
        return self.tasksList[randomTaskInt]
    end
end

function TasksManager:AddTask(newTask)

    if newTask ~= nil then
        table.insert(self.tasksList, newTask)
    end

end

function TasksManager:RemoveTask(taskToBeRemoved)

    if taskToBeRemoved ~= nil then
        table.remove(self.tasksList, taskToBeRemoved)
    end

end

--Task Class for testing
TaskController = {}

function TaskController:New(_coalition)

    newObj = 
    {
        taskStatus,
        taskCoalition = _coalition,
        taskBrif
    }
    self.__index = self
    return setmetatable(newObj, self)

end

function TaskController:StartTask()

    print("Default Task Was Started")
    MESSAGE:NewType("Default Task Was Started", MESSAGE.Type.Information ):ToAll()

end


mainTasks = TasksManager:New()
additionalTasks = TasksManager:New()






