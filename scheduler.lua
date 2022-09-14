
local schedulerFrame = CreateFrame("Frame");
local lastRun = GetTime();


exampleTask = {
    callback = function() print("example task") end;
    interval = 1; --seconds
    runNow = true;
    runTimes = 5;
};


Scheduler = {
    tasks = {};
};

Scheduler.onUpdate = function()
    local now = GetTime();
    for task in Scheduler.tasks do
        Scheduler.doTask(task);
    end
end;

Scheduler.addTask = function(task) 
    assert(type(task.callback) == "function");
    assert(type(task.interval) == "number");
    task.runTimes = task.runTimes or 1;
    task.runNow = task.runNow or false;
    task.lastRun = task.lastRun or GetTime();
    Scheduler.tasks[task] = task;
    if task.runNow == true then
        Scheduler.doTask(task);
    end
end;

Scheduler.removeTask = function(task)
    Scheduler.tasks[task] = nil;
end;

Scheduler.doTask = function(task)
    if task.runTimes <= 0 then
        Scheduler.removeTask(task);
        return;
    end
    local now = GetTime();
    if now - task.lastRun >= task.interval then
        task.lastRun = GetTime();
        task.callback();
        task.runTimes = task.runTimes - 1;
    end
end;



schedulerFrame:SetScript("OnUpdate", Scheduler.onUpdate);