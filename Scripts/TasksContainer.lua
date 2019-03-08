--------------------------------
--TasksContainer - contains all tasks, start random task at mission start
--Dependencies: Nothing
--------------------------------

TasksContainer = {}

function TasksContainer:New()
    newObj = 
    {
        allTasks = {}
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function TasksContainer:StartRandomTask()
    
end

function TasksContainer:StartTaskByName(taskName)

end

function TasksContainer:AddNewTask(newTaskController)
    table.insert(self.allTasks, newTaskController)
end
----------------

mainTasksContainer = TasksContainer:New()