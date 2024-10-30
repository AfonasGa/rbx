local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local backpack = player.Backpack



--infstamina = true


if infstamina then
    StarterGui:SetCore("SendNotification", {
        Title = "Enabled";
        Text = "Inf stamina enabled";
        Duration = 5;  
        Button1 = "OK"; 
    })
    print("Infinite stamina enabled")
game.Players.LocalPlayer.PlayerGui.stamina.LocalScript.energy.Value = inf
else
 print("Infinite stamina disabled")
end


--gummyflash = true

if gummyflash then
    StarterGui:SetCore("SendNotification", {
        Title = "Enabled";
        Text = "Free gummy flashlight has been enabled";
        Duration = 5;  
        Button1 = "OK"; 
    })
    print("Free gummyflash enabled")
    local flash = game.Lighting:FindFirstChild("Gummy Flashlight")

    if flash then
    flash.Parent = backpack
   end
end
