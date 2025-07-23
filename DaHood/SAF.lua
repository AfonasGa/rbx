local player = game:GetService("Players").LocalPlayer
local teleportService = game:GetService("TeleportService")

-- Основная функция сбора денег
local function startMoneyFarm()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local function findNearestMoney()
        local closest = nil
        local minDist = math.huge
        local origin = humanoidRootPart.Position
        
        for _,v in ipairs(workspace.Ignored.Drop:GetChildren()) do
            if v.Name == "MoneyDrop" and v:FindFirstChildOfClass("ClickDetector") then
                local dist = (v.Position - origin).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = v
                end
            end
        end
        return closest
    end

    local emptyChecks = 0
    local connection

    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local money = findNearestMoney()
        
        if money then
            emptyChecks = 0
            humanoidRootPart.CFrame = CFrame.new(money.Position + Vector3.new(0, 3, 0))
            fireclickdetector(money:FindFirstChildOfClass("ClickDetector"))
        else
            emptyChecks = emptyChecks + 1
            if emptyChecks >= 10 then -- 10 проверок подряд без денег
                connection:Disconnect()
                teleportService:Teleport(game.PlaceId, player)
            end
        end
    end)
end

-- Автоперезапуск при смене сервера
player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        -- Сохраняем скрипт для авторестарта
        local script = [[
            wait(5) -- Даем время для загрузки
            loadstring(game:HttpGet("URL_ВАШЕГО_СКРИПТА"))()
        ]]
        teleportService:SetTeleportGui(script)
    end
end)

-- Первый запуск
startMoneyFarm()
