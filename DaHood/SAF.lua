local Player = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- Конфигурация
local SETTINGS = {
    ScriptURL = "https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua",
    CheckInterval = 0.2,
    MaxEmptyChecks = 10,
    RestartDelay = 3,
    HoverHeight = 3
}

-- Система логов
local function Log(message)
    print("[AUTO FARM]", message)
    if not game:IsLoaded() then return end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Farm",
            Text = message,
            Duration = 3
        })
    end)
end

-- Самопроверка работы
local function HealthCheck()
    if not Player or not Player.Character then
        Log("Ожидание персонажа...")
        Player.CharacterAdded:Wait()
    end
    return true
end

-- Основной сборщик
local function MoneyCollector()
    if not HealthCheck() then return false end
    
    local collected = false
    local character = Player.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not root then
        Log("Не найден HumanoidRootPart")
        return false
    end

    for _, drop in pairs(workspace.Ignored.Drop:GetChildren()) do
        if drop.Name == "MoneyDrop" then
            local clicker = drop:FindFirstChildOfClass("ClickDetector")
            if clicker then
                -- Оптимизированная телепортация
                root.CFrame = drop.CFrame + Vector3.new(0, SETTINGS.HoverHeight, 0)
                fireclickdetector(clicker)
                collected = true
                task.wait(0.05) -- Минимальная задержка между сборами
            end
        end
    end
    
    return collected
end

-- Система авторестарта
local function InitAutoRestart()
    Player.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then
            Log("Инициализация перезапуска...")
            local restartScript = string.format([[
                wait(%s)
                loadstring(game:HttpGet("%s", true))()
            ]], SETTINGS.RestartDelay, SETTINGS.ScriptURL)
            TeleportService:SetTeleportGui(restartScript)
        end
    end)
end

-- Главный цикл
local function MainLoop()
    Log("Система активирована")
    InitAutoRestart()
    
    local emptyChecks = 0
    local lastCollectionTime = os.time()
    
    while true do
        if MoneyCollector() then
            emptyChecks = 0
            lastCollectionTime = os.time()
        else
            emptyChecks = emptyChecks + 1
            if emptyChecks >= SETTINGS.MaxEmptyChecks then
                Log("Сервер пуст, перезагрузка...")
                TeleportService:Teleport(game.PlaceId, Player)
                break
            end
        end
        
        task.wait(SETTINGS.CheckInterval)
    end
end

-- Защищенный запуск
local function SafeStart()
    local success, err = pcall(MainLoop)
    if not success then
        Log("Критическая ошибка: "..tostring(err))
        task.wait(5)
        TeleportService:Teleport(game.PlaceId, Player)
    end
end

-- Первичная загрузка
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Попытка загрузить основной скрипт
local loadSuccess = pcall(function()
    loadstring(game:HttpGet(SETTINGS.ScriptURL, true))()
end)

-- Запуск системы в любом случае
task.spawn(SafeStart)
