local players = game:GetService("Players")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded
local humanoidrootpart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local controls = require(player.PlayerScripts.PlayerModule):GetControls()

local whitelist = {
	enabled = true;
	ores = {-- to whitelist do something like "moonstone", "forbidden crystal" dont forget the comma, its also names sensitive so be careful. you can leave it off if you want to generally mine everything.
		"forbidden crystal",
		"moonstone"
	}
}


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

local function checkpickaxe(a)
	for _,v in pairs(a:GetChildren()) do
		if v:IsA("Tool") and v.Name:match("Pickaxe") then
			return v
		end
	end
end

local function filter(a)
	for _,v in pairs(workspace.Map.Ores:GetChildren()) do
		if whitelist.enabled == false then return v end
		local n = v.Name:lower()
		if n == a.Name:lower() then
			if table.find(whitelist.ores,n) then
				return v
			end
		end
	end
end

local function getpickaxe()
	local p = checkpickaxe(player.Backpack)
	local pi = checkpickaxe(character)
	if p then
		p.Parent = character
		return p
	elseif pi then
		return pi
	end
end

while true do task.wait()
	for _,v in pairs(workspace.Map.Ores:GetChildren()) do
		if filter(v) and getpickaxe() then
			local cf = humanoidrootpart.CFrame
			humanoidrootpart.CFrame = v.CFrame*CFrame.new(-2,0,-1)
			repeat task.wait()
				getpickaxe():FindFirstChild("RemoteFunction"):InvokeServer("mine")
			until not v.Mineral or v
			humanoidrootpart.CFrame = cf
		end
	end
end
