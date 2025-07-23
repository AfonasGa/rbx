local Player = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- Функция для вывода отладочной информации
local function DebugPrint(message)
    print("[DEBUG]", message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Money Farm",
        Text = message,
        Duration = 3
    })
end

-- Проверка подключения к GitHub
local function CheckGitHubConnection()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua", true)
    end)
    return success, response
end

-- Основной загрузчик с улучшенной обработкой ошибок
local function LoadMainScript()
    DebugPrint("Попытка загрузки скрипта...")
    
    local githubSuccess, githubResponse = CheckGitHubConnection()
    if not githubSuccess then
        DebugPrint("Ошибка подключения к GitHub: "..tostring(githubResponse))
        return false
    end
    
    local loadSuccess, loadError = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua", true)
        return loadstring(script)()
    end)
    
    if not loadSuccess then
        DebugPrint("Ошибка загрузки: "..tostring(loadError))
        return false
    end
    
    DebugPrint("Скрипт успешно загружен")
    return true
end

-- Альтернативный сборщик денег (если основной скрипт не работает)
local function EmergencyMoneyCollector()
    DebugPrint("Активация аварийного сборщика")
    
    while true do
        local Char = Player.Character
        if not Char then
            Player.CharacterAdded:Wait()
            Char = Player.Character
        end
        
        local Root = Char:FindFirstChild("HumanoidRootPart")
        if not Root then
            Char.ChildAdded:Wait()
            Root = Char:WaitForChild("HumanoidRootPart")
        end
        
        local MoneyDrops = workspace.Ignored.Drop:GetChildren()
        local collected = false
        
        for _, Drop in ipairs(MoneyDrops) do
            if Drop.Name == "MoneyDrop" then
                local Clicker = Drop:FindFirstChildOfClass("ClickDetector")
                if Clicker then
                    Root.CFrame = CFrame.new(Drop.Position + Vector3.new(0, 2.5, 0))
                    fireclickdetector(Clicker)
                    collected = true
                    task.wait(0.05)
                end
            end
        end
        
        if not collected then
            DebugPrint("Деньги не найдены, проверка через 5 сек...")
            task.wait(5)
        else
            task.wait(0.1)
        end
    end
end

-- Инициализация системы
DebugPrint("Запуск системы...")

-- Попытка загрузить основной скрипт
local mainScriptLoaded = LoadMainScript()

-- Если основной скрипт не загрузился, запускаем аварийный режим
if not mainScriptLoaded then
    DebugPrint("Переход в аварийный режим")
    task.spawn(EmergencyMoneyCollector)
end

-- Система авторестарта
Player.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        DebugPrint("Подготовка к переходу на новый сервер")
        local TeleportScript = [[
            wait(3)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua", true))()
        ]]
        TeleportService:SetTeleportGui(TeleportScript)
    end
end)

DebugPrint("Система активирована")
