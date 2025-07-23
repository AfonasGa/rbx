local Player = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- Основной загрузчик
local function LoadScript()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua", true))()
end

-- Ультра-быстрый сборщик денег
local function InstantMoneyCollector()
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Root = Char:WaitForChild("HumanoidRootPart")
    
    local MoneyDrops = workspace.Ignored.Drop:GetChildren()
    local Collected = false
    
    for _, Drop in ipairs(MoneyDrops) do
        if Drop.Name == "MoneyDrop" then
            local Clicker = Drop:FindFirstChildOfClass("ClickDetector")
            if Clicker then
                -- Супер-быстрая телепортация и сбор
                Root.CFrame = CFrame.new(Drop.Position + Vector3.new(0, 2.5, 0))
                fireclickdetector(Clicker)
                Collected = true
            end
        end
    end
    
    return Collected
end

-- Система авторестарта
local function SetupAutoRestart()
    Player.OnTeleport:Connect(function(State)
        if State == Enum.TeleportState.Started then
            local TeleportScript = [[
                wait(2)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/AfonasGa/rbx/main/DaHood/SAF.lua", true))()
            ]]
            TeleportService:SetTeleportGui(TeleportScript)
        end
    end)
end

-- Главный контроллер
local function MainController()
    SetupAutoRestart()
    
    -- Запуск основного скрипта
    local LoadSuccess = pcall(LoadScript)
    
    -- Настройки
    local EmptyChecks = 0
    local MaxEmptyChecks = 5
    local CheckInterval = 0.1
    
    -- Основной цикл
    while true do
        local Collected = InstantMoneyCollector()
        
        if Collected then
            EmptyChecks = 0
        else
            EmptyChecks += 1
            if EmptyChecks >= MaxEmptyChecks then
                TeleportService:Teleport(game.PlaceId, Player)
                break
            end
        end
        
        task.wait(CheckInterval)
    end
end

-- Запуск системы
MainController()
