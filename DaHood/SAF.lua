local loadScript = loadstring(game:HttpGet("https://afonasga.github.io/rbx/DaHood/SAF.lua"))()

-- Оптимизированный скрипт для Da Hood с авторестартом
local player = game:GetService("Players").LocalPlayer
local teleportService = game:GetService("TeleportService")

-- Основная функция сбора денег
local function startMoneyFarm()
    -- Запускаем ваш скрипт
    loadScript()
    
    -- Дополнительная логика для авторестарта
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local emptyChecks = 0
    local connection

    connection = game:GetService("RunService").Heartbeat:Connect(function()
        -- Проверяем наличие денег (адаптируйте под ваш скрипт)
        local moneyFound = false
        for _,v in ipairs(workspace.Ignored.Drop:GetChildren()) do
            if v.Name == "MoneyDrop" and v:FindFirstChildOfClass("ClickDetector") then
                moneyFound = true
                break
            end
        end
        
        if moneyFound then
            emptyChecks = 0
        else
            emptyChecks = emptyChecks + 1
            if emptyChecks >= 15 then -- 15 проверок подряд без денег
                connection:Disconnect()
                teleportService:Teleport(game.PlaceId, player)
            end
        end
    end)
end

-- Автоперезапуск при смене сервера
player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        local teleportScript = [[
            wait(5)
            loadstring(game:HttpGet("https://afonasga.github.io/rbx/DaHood/SAF.lua"))()
        ]]
        teleportService:SetTeleportGui(teleportScript)
    end
end)

-- Первый запуск
startMoneyFarm()

-- Улучшенная версия вашего скрипта с быстрым сбором
local function enhanceMoneyCollection()
    local moneyParts = workspace.Ignored.Drop:GetChildren()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    for _,part in pairs(moneyParts) do
        if part.Name == "MoneyDrop" then
            local clickDetector = part:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                -- Мгновенная телепортация и сбор
                root.CFrame = part.CFrame + Vector3.new(0,3,0)
                fireclickdetector(clickDetector)
            end
        end
    end
end

-- Автоматический быстрый сбор каждые 0.5 сек
while wait(0.5) do
    pcall(enhanceMoneyCollection)
end
