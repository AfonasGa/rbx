local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart

workspace.FallenPartsDestroyHeight = -1000
local lastCFrame = hrp.CFrame

hrp.CFrame = CFrame.new(Vector3.new(0, -500, 0))

wait(0.7)

hrp.CFrame = lastCFrame
workspace.FallenPartsDestroyHeight = -500
