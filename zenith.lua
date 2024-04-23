local player = game:GetService("Players").LocalPlayer
local character = player.Character

local GC = getconnections or get_signal_cons
if GC then
        for i,v in pairs(GC(player.Idled)) do
                if v["Disable"] then
                        v["Disable"](v)
                elseif v["Disconnect"] then
                        v["Disconnect"](v)
                end
        end
end

game:GetService("RunService").RenderStepped:Connect(function()
  for _,v in pairs(workspace.Collectibles:GetDescendants()) do
    if v:IsA("ClickDetector") then
      fireclickdetector(v)
    end
  end
end)

local function collect()
  while true do task.wait()
    for _,v in pairs(workspace.Collectibles:GetDescendants()) do
      if v and v:IsA("ClickDetector") then print("collected")
        character:MoveTo(v.Parent.Position)
        task.wait(.5)
      end
    end
  end
end

collect()
