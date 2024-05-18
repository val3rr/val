local virtualuser = game:GetService("VirtualUser")
local runservice = game:GetService("RunService")

local replicatedstorage = game:GetService("ReplicatedStorage")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

local player = players.LocalPlayer
local character = player.Character
local humanoidrootpart = character:WaitForChild("HumanoidRootPart")

local selectedOre = ""

local GC = getconnections or get_signal_cons
if GC then
	for i,v in pairs(GC(players.LocalPlayer.Idled)) do
		if v["Disable"] then
			v["Disable"](v)
		elseif v["Disconnect"] then
			v["Disconnect"](v)
		end
	end
else
	players.LocalPlayer.Idled:Connect(function()
		virtualuser:CaptureController()
		virtualuser:ClickButton2(Vector2.new())
	end)
end


local function clearlighting()
	lighting.Brightness = 2
	lighting.ClockTime = 14
	lighting.FogEnd = 100000
	lighting.GlobalShadows = false
	lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	lighting.FogEnd = 100000
	for i,v in pairs(lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end

end

runservice.RenderStepped:Connect(clearlighting)

local function findpickaxe()
	local timeout = tick() + 5
	while true do
		if tick() > timeout then
			warn("unable to find pickaxe within time limit")
			return nil
		end
		local backpack = player:FindFirstChild("Backpack")
		if backpack then
			for _, item in pairs(backpack:GetChildren()) do
				if item.Name:find("Pickaxe") then return item end
			end
		end
		task.wait(.1)
	end
end

local function usepickaxe(pickaxeTool)
	if not pickaxeTool then
		print("you dont have a pickaxe equipped")
		return
	end
	player.Character.Humanoid:EquipTool(pickaxeTool)
	pickaxeTool:Activate()
	task.wait(.1)
	player.Character.Humanoid:UnequipTools()
end

local function teleporttoore(target, distance, rotation, lookAt)
	distance = distance or Vector3.new(0, 0, 0)
	rotation = rotation or CFrame.Angles(0, 0, 0)
	if player.Character then
		local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local targetPart = target:IsA("Model") and target:FindFirstChildWhichIsA("BasePart") or target:FindFirstChildWhichIsA("BasePart") or target
			if targetPart then
				local targetPosition = targetPart.Position + distance
				local lookAtPosition = lookAt or targetPart.Position
				humanoidRootPart.CFrame = CFrame.new(targetPosition, lookAtPosition) * rotation
			end
		end
	end
end

local function findnextore()
	local pickaxeTool = findpickaxe()
	if not pickaxeTool then return nil end

	local pickaxePower = pickaxeTool.Power.Value
	local ores = workspace.Map.Ores:GetChildren()
	local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

	if #ores > 0 and humanoidRootPart then
		local closestOre
		local minDistance = math.huge

		for _, ore in pairs(ores) do
			local properties = ore:FindFirstChild("Properties")
			if properties then
				local oreToughness = properties:FindFirstChild("Toughness") and properties.Toughness.Value or 0
				local hitpoint = properties:FindFirstChild("Hitpoint") and properties.Hitpoint.Value or 0
				local meshPart = ore:FindFirstChildOfClass("MeshPart")
				if hitpoint > 0 and pickaxePower >= oreToughness and meshPart then
					local base = ore:FindFirstChild("Base")
					if not base or (base and not (base.Rotation.X == 0 and base.Rotation.Y == 90 and base.Rotation.Z == 0)) then
						if selectedOre == "" or ore.Name:find(selectedOre) then
							local distance = (humanoidRootPart.Position - meshPart.Position).Magnitude
							if distance < minDistance then
								minDistance = distance
								closestOre = ore
							end
						end
					end
				end
			end
		end

		if closestOre then
			return closestOre
		end
	end
end

local function findcreepy()
	local creepy = workspace:FindFirstChild("Creepy")
	if creepy then
		return creepy
	end
end

local function clearcreepies()
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v.name == "Creepy" then
			local nowcfh = humanoidrootpart.CFrame
			humanoidrootpart.CFrame = (v.HumanoidRootPart.CFrame*CFrame.new(0,75,0))
			task.wait(.25)
		end
	end
	repeat task.wait() humanoidrootpart.CFrame = CFrame.new(0,50000,0) until not findcreepy()
end

local function mining()
	local pickaxe = findpickaxe()
	if pickaxe then
		usepickaxe(pickaxe)
	end

	local success, response
	while true do
		if not success and response then warn("error found! |: "..response) end
		success, response = pcall(function()
			local ore = findnextore()
			if findcreepy then print("ja creepy has been found!!!!!!!") clearcreepies() end
			if ore then
				local connection
				connection = runservice.Heartbeat:Connect(function()
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						teleporttoore(ore, Vector3.new(0, -6.5, 0), CFrame.Angles(math.rad(0), 0, math.rad(0)))
					else
						connection:Disconnect()
					end
				end)
	
				local pickaxeTool = findpickaxe()
				local power = pickaxeTool and pickaxeTool:FindFirstChild("Power") and pickaxeTool:FindFirstChild("Power").Value or 0
				local oreToughness = ore.Properties:FindFirstChild("Toughness") and ore.Properties:FindFirstChild("Toughness").Value or 0
	
				if power >= oreToughness then
					if pickaxeTool:FindFirstChild("RemoteFunction") then
						print("mining "..ore.Name.." with "..pickaxeTool.Name..", pickaxe power is "..power)
						while true and ore.Properties.Hitpoint.Value > 0 do
							if player.Character and player.Character:FindFirstChild("Torso") then
								pickaxeTool.RemoteFunction:InvokeServer("mine")
							else
								print("torso is unavaliable")
								task.wait(.1)
							end
							task.wait(.05)
						end
					else
						warn("pickaxe is gone from backpack")
					end
				else
					warn("your pickaxe needs an upgrade (power is too low, craft a better one)")
				end
	
				if connection then
					connection:Disconnect()
				end
	
				task.wait()
			end
			task.wait()
		end)
	end
end

mining()
