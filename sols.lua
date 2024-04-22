local virtualinputmanager = game:GetService('VirtualInputManager')
local pathfindingservice = game:GetService("PathfindingService")
local runservice = game:GetService("RunService")
local players = game:GetService("Players")

local map = workspace:FindFirstChild("Map")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded
local controls = require(player.PlayerScripts.PlayerModule):GetControls()
local humanoidrootpart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
humanoid.WalkSpeed = 17.5

local wpfolder = workspace:FindFirstChild("waypoints")
if not wpfolder then wpfolder = Instance.new("Folder",workspace) wpfolder.Name = "waypoints" end

local symbols = {"!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "=", "{", "}", "[", "]", ";", ":", "'", "\"", ",", "<", ">", ".", "/", "?", "`", "~"}
local letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

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

runservice.RenderStepped:Connect(function()
	for _, descendant in ipairs(workspace:FindFirstChild("DroppedItems"):GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			fireproximityprompt(descendant)
		end
	end

end)

local function generateCode() print("generating..")
	local code = ""
	for i = 1, math.random(7,15) do
		local randomIndex = math.random(1, 3)
		if randomIndex == 1 then
			code = code .. symbols[math.random(1, #symbols)]
		elseif randomIndex == 2 then
			code = code .. letters[math.random(1, #letters)]
		else
			code = code .. numbers[math.random(1, #numbers)]
		end
	end
print("generated!: "..code)
	return code
end

local function checkblessing()
	return map:FindFirstChild("BuffGivers")["Basic Blessing"].Attachment.Star.Enabled
end

local function path()
	local p
	if checkblessing() == true then
		p = map:FindFirstChild("BuffGivers")["Basic Blessing"].Position-Vector3.new(0,-3,0)
	elseif checkblessing() == false then
		repeat task.wait() until #workspace:FindFirstChild("DroppedItems"):GetDescendants() ~= 0
		for _,v in pairs(workspace:FindFirstChild("DroppedItems"):GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				p = v.Parent.Position
			end
		end
	end
	return p
end

local function walk()
	while true do task.wait()
		local des = path()
		if des then --print("yay path")
			local path = pathfindingservice:CreatePath({ WaypointSpacing = 8, AgentRadius = 0.6, AgentCanJump = true })
			path:ComputeAsync(humanoidrootpart.Position - Vector3.new(0,2.5,0), des)
			local waypoints = path:GetWaypoints()

			if path.Status ~= Enum.PathStatus.NoPath then
				controls:Disable()
				wpfolder:ClearAllChildren()
				for _, waypoint in pairs(waypoints) do
					local part = Instance.new("Part",wpfolder)
					part.Color = Color3.fromRGB(255,255,255)
					part.Size = Vector3.new(.5,.5,.5)
					part.Position = waypoint.Position
					part.Shape = "Ball"
					part.Material = "Neon"
					part.Anchored = true
					part.CanCollide = false
				end

				for _, waypoint in pairs(waypoints) do
					if humanoidrootpart.Anchored == true or (waypoint.Position - (humanoidrootpart.Position - Vector3.new(0,3,0))).magnitude > 35 then
						walk()
						break
					else
						--print("going")
						if waypoint.Action == Enum.PathWaypointAction.Jump then
							humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
						humanoid:MoveTo(waypoint.Position)
						humanoid.MoveToFinished:Wait(.1)
					end
				end
				controls:Enable()
				wpfolder:ClearAllChildren()
			end
		end
	end
end

local f = Instance.new("Folder",workspace) f.Name = generateCode()
local textures = {17091612253,17091608605,17091604236,17091602770,17091601498,17091599841,17091597128}

local inst1=Instance.new('Part',f);inst1.Transparency,inst1.Anchored,inst1.Name,inst1.Size,inst1.CFrame=.8,true,generateCode(),Vector3.new(32.96197509765625, 12.539999961853027, 8.01546859741211),CFrame.new(183.821594, 106.511017, 346.114105, 0.999315262, 0.0318961367, -0.0187551491, -0.0325456001, 0.998842895, -0.0354075208, 0.0176040884, 0.0359936804, 0.999196947);
local tex1=Instance.new('Texture',inst1);tex1.Name,tex1.StudsPerTileU,tex1.StudsPerTileV,tex1.Texture,tex1.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst2=Instance.new('Part',f);inst2.Transparency,inst2.Anchored,inst2.Name,inst2.Size,inst2.CFrame=.8,true,generateCode(),Vector3.new(11.46553897857666, 5.709825038909912, 22.79570770263672),CFrame.new(396.143738, 114.48774, 112.51619, -0.828353941, -0.423289865, 0.366954535, -0.0909902006, 0.747998834, 0.657433629, -0.552766383, 0.511198521, -0.658123016);
local tex2=Instance.new('Texture',inst2);tex2.Name,tex2.StudsPerTileU,tex2.StudsPerTileV,tex2.Texture,tex2.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst3=Instance.new('Part',f);inst3.Transparency,inst3.Anchored,inst3.Name,inst3.Size,inst3.CFrame=.8,true,generateCode(),Vector3.new(18.239999771118164, 12.539999961853027, 6.199254989624023),CFrame.new(220.695053, 103.573051, 231.884628, 0.391566843, 0.0800369158, 0.916662097, -0.108108394, 0.993312061, -0.040549241, -0.913776875, -0.0832211077, 0.397600472);
local tex3=Instance.new('Texture',inst3);tex3.Name,tex3.StudsPerTileU,tex3.StudsPerTileV,tex3.Texture,tex3.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst4=Instance.new('Part',f);inst4.Transparency,inst4.Anchored,inst4.Name,inst4.Size,inst4.CFrame=.8,true,generateCode(),Vector3.new(7.749802589416504, 4.5655670166015625, 15.0235595703125),CFrame.new(489.043427, 128.209793, 29.4178448, 0.0257214606, 0, 0.999669194, 0, 1, 0, -0.999669194, 0, 0.0257214606);
local tex4=Instance.new('Texture',inst4);tex4.Name,tex4.StudsPerTileU,tex4.StudsPerTileV,tex4.Texture,tex4.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst5=Instance.new('Part',f);inst5.Transparency,inst5.Anchored,inst5.Name,inst5.Size,inst5.CFrame=.8,true,generateCode(),Vector3.new(4.258349418640137, 1.8461227416992188, 16.064241409301758),CFrame.new(404.234192, 122.372322, 12.0189686, -0.756186306, 0, 0.65435642, 0, 1, 0, -0.65435642, 0, -0.756186306);
local tex5=Instance.new('Texture',inst5);tex5.Name,tex5.StudsPerTileU,tex5.StudsPerTileV,tex5.Texture,tex5.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst6=Instance.new('Part',f);inst6.Transparency,inst6.Anchored,inst6.Name,inst6.Size,inst6.CFrame=.8,true,generateCode(),Vector3.new(5.809301853179932, 1.8461227416992188, 16.064241409301758),CFrame.new(425.231476, 124.114861, -3.17884707, -0.401374847, 0, 0.91591382, 0, 1, 0, -0.91591382, 0, -0.401374847);
local tex6=Instance.new('Texture',inst6);tex6.Name,tex6.StudsPerTileU,tex6.StudsPerTileV,tex6.Texture,tex6.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst7=Instance.new('Part',f);inst7.Transparency,inst7.Anchored,inst7.Name,inst7.Size,inst7.CFrame=.8,true,generateCode(),Vector3.new(17.1751651763916, 12.279537200927734, 7.0764007568359375),CFrame.new(253.823715, 99.8378677, 212.237961, 0.445663601, 0.000951659225, 0.895199776, -0.00213537016, 0.999997735, 0, -0.895197749, -0.00191158336, 0.445664674);
local tex7=Instance.new('Texture',inst7);tex7.Name,tex7.StudsPerTileU,tex7.StudsPerTileV,tex7.Texture,tex7.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst8=Instance.new('Part',f);inst8.Transparency,inst8.Anchored,inst8.Name,inst8.Size,inst8.CFrame=.8,true,generateCode(),Vector3.new(16.077255249023438, 12.279537200927734, 8.019676208496094),CFrame.new(261.455536, 99.8399429, 204.275055, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex8=Instance.new('Texture',inst8);tex8.Name,tex8.StudsPerTileU,tex8.StudsPerTileV,tex8.Texture,tex8.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst9=Instance.new('Part',f);inst9.Transparency,inst9.Anchored,inst9.Name,inst9.Size,inst9.CFrame=.8,true,generateCode(),Vector3.new(17.354660034179688, 21.770000457763672, 5.948921203613281),CFrame.new(260.816833, 104.585175, 143.018829, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex9=Instance.new('Texture',inst9);tex9.Name,tex9.StudsPerTileU,tex9.StudsPerTileV,tex9.Texture,tex9.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst10=Instance.new('Part',f);inst10.Transparency,inst10.Anchored,inst10.Name,inst10.Size,inst10.CFrame=.8,true,generateCode(),Vector3.new(3.96736478805542, 4.5655670166015625, 15.0235595703125),CFrame.new(480.103271, 124.455627, 27.295969, 0.0257214606, 0, 0.999669194, 0, 1, 0, -0.999669194, 0, 0.0257214606);
local tex10=Instance.new('Texture',inst10);tex10.Name,tex10.StudsPerTileU,tex10.StudsPerTileV,tex10.Texture,tex10.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst11=Instance.new('Part',f);inst11.Transparency,inst11.Anchored,inst11.Name,inst11.Size,inst11.CFrame=.8,true,generateCode(),Vector3.new(18.43865966796875, 3.5150146484375, 6.145535469055176),CFrame.new(461.04007, 121.248375, 19.5783272, 0.0257214606, 0, 0.999669194, 0, 1, 0, -0.999669194, 0, 0.0257214606);
local tex11=Instance.new('Texture',inst11);tex11.Name,tex11.StudsPerTileU,tex11.StudsPerTileV,tex11.Texture,tex11.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst12=Instance.new('Part',f);inst12.Transparency,inst12.Anchored,inst12.Name,inst12.Size,inst12.CFrame=.8,true,generateCode(),Vector3.new(33.13334655761719, 3.6121597290039062, 50.491310119628906),CFrame.new(205.929428, 109.252174, 105.197853, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex12=Instance.new('Texture',inst12);tex12.Name,tex12.StudsPerTileU,tex12.StudsPerTileV,tex12.Texture,tex12.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst13=Instance.new('Part',f);inst13.Transparency,inst13.Anchored,inst13.Name,inst13.Size,inst13.CFrame=.8,true,generateCode(),Vector3.new(3.96736478805542, 4.5655670166015625, 15.0235595703125),CFrame.new(465.291504, 123.73204, 26.9257584, 0.0257214606, 0, 0.999669194, 0, 1, 0, -0.999669194, 0, 0.0257214606);
local tex13=Instance.new('Texture',inst13);tex13.Name,tex13.StudsPerTileU,tex13.StudsPerTileV,tex13.Texture,tex13.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst14=Instance.new('Part',f);inst14.Transparency,inst14.Anchored,inst14.Name,inst14.Size,inst14.CFrame=.8,true,generateCode(),Vector3.new(9.693283081054688, 0.797074019908905, 13.934783935546875),CFrame.new(452.524475, 127.013916, 6.39205217, -0.999998689, -0.00181100285, 0.00163538626, 0, 0.670204878, 0.74217689, -0.00244012824, 0.742174327, -0.670204163);
local tex14=Instance.new('Texture',inst14);tex14.Name,tex14.StudsPerTileU,tex14.StudsPerTileV,tex14.Texture,tex14.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst15=Instance.new('Part',f);inst15.Transparency,inst15.Anchored,inst15.Name,inst15.Size,inst15.CFrame=.8,true,generateCode(),Vector3.new(25.82735252380371, 12.539999961853027, 8.243170738220215),CFrame.new(216.319672, 105.469673, 252.213074, 0.0977857262, 0.108512372, 0.989275336, -0.0639837533, 0.992667437, -0.102560095, -0.993148685, -0.0532686487, 0.104011774);
local tex15=Instance.new('Texture',inst15);tex15.Name,tex15.StudsPerTileU,tex15.StudsPerTileV,tex15.Texture,tex15.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst16=Instance.new('Part',f);inst16.Transparency,inst16.Anchored,inst16.Name,inst16.Size,inst16.CFrame=.8,true,generateCode(),Vector3.new(8.093038558959961, 1.8461227416992188, 16.064241409301758),CFrame.new(435.64624, 129.669037, -7.85445023, -0.0244233403, -0.469658226, 0.882510543, 0, 0.882773757, 0.469798386, -0.999701738, 0.0114740431, -0.0215602815);
local tex16=Instance.new('Texture',inst16);tex16.Name,tex16.StudsPerTileU,tex16.StudsPerTileV,tex16.Texture,tex16.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst17=Instance.new('Part',f);inst17.Transparency,inst17.Anchored,inst17.Name,inst17.Size,inst17.CFrame=.8,true,generateCode(),Vector3.new(15.484987258911133, 11.767034530639648, 7.0764007568359375),CFrame.new(243.270538, 101.130981, 220.261154, 0.913471043, 0.240842015, 0.327972263, -0.255444735, 0.966822565, 0.00149372092, -0.316731185, -0.0851432532, 0.944686234);
local tex17=Instance.new('Texture',inst17);tex17.Name,tex17.StudsPerTileU,tex17.StudsPerTileV,tex17.Texture,tex17.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst18=Instance.new('Part',f);inst18.Transparency,inst18.Anchored,inst18.Name,inst18.Size,inst18.CFrame=.8,true,generateCode(),Vector3.new(3.96736478805542, 4.5655670166015625, 15.0235595703125),CFrame.new(462.001282, 154.644836, 28.8641796, 0.673735499, 0.388000429, 0.628916681, 0, 0.851068974, -0.525053918, -0.738972604, 0.353747427, 0.573395371);
local tex18=Instance.new('Texture',inst18);tex18.Name,tex18.StudsPerTileU,tex18.StudsPerTileV,tex18.Texture,tex18.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst19=Instance.new('Part',f);inst19.Transparency,inst19.Anchored,inst19.Name,inst19.Size,inst19.CFrame=.8,true,generateCode(),Vector3.new(25.987550735473633, 12.539999961853027, 8.191612243652344),CFrame.new(217.558273, 106.039856, 285.370148, -0.490152478, 0.10706459, 0.86503613, 0.0188952275, 0.993499279, -0.112257801, -0.871431887, -0.0386783704, -0.488989174);
local tex19=Instance.new('Texture',inst19);tex19.Name,tex19.StudsPerTileU,tex19.StudsPerTileV,tex19.Texture,tex19.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst20=Instance.new('Part',f);inst20.Transparency,inst20.Anchored,inst20.Name,inst20.Size,inst20.CFrame=.8,true,generateCode(),Vector3.new(25.428770065307617, 12.539999961853027, 6.639999866485596),CFrame.new(224.630829, 105.743599, 297.337738, -0.490152478, 0.10706459, 0.86503613, 0.0188952275, 0.993499279, -0.112257801, -0.871431887, -0.0386783704, -0.488989174);
local tex20=Instance.new('Texture',inst20);tex20.Name,tex20.StudsPerTileU,tex20.StudsPerTileV,tex20.Texture,tex20.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst21=Instance.new('Part',f);inst21.Transparency,inst21.Anchored,inst21.Name,inst21.Size,inst21.CFrame=.8,true,generateCode(),Vector3.new(19.889999389648438, 12.539999961853027, 8.01546859741211),CFrame.new(232.303543, 105.640106, 315.917938, -0.299331963, 0.107064471, 0.948122025, -0.0048884498, 0.993498087, -0.113731764, -0.954136729, -0.0386782661, -0.296862543);
local tex21=Instance.new('Texture',inst21);tex21.Name,tex21.StudsPerTileU,tex21.StudsPerTileV,tex21.Texture,tex21.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst22=Instance.new('Part',f);inst22.Transparency,inst22.Anchored,inst22.Name,inst22.Size,inst22.CFrame=.8,true,generateCode(),Vector3.new(19.889999389648438, 12.539999961853027, 8.01546859741211),CFrame.new(230.412308, 106.43821, 331.182983, 0.705239832, 0.10706491, 0.700838029, -0.103307091, 0.993499517, -0.0478179529, -0.701401711, -0.0386784226, 0.711715996);
local tex22=Instance.new('Texture',inst22);tex22.Name,tex22.StudsPerTileU,tex22.StudsPerTileV,tex22.Texture,tex22.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst23=Instance.new('Part',f);inst23.Transparency,inst23.Anchored,inst23.Name,inst23.Size,inst23.CFrame=.8,true,generateCode(),Vector3.new(29.80889892578125, 3.6121597290039062, 60.55663299560547),CFrame.new(191.96936, 114.693924, 112.812691, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex23=Instance.new('Texture',inst23);tex23.Name,tex23.StudsPerTileU,tex23.StudsPerTileV,tex23.Texture,tex23.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst24=Instance.new('Part',f);inst24.Transparency,inst24.Anchored,inst24.Name,inst24.Size,inst24.CFrame=.8,true,generateCode(),Vector3.new(19.889999389648438, 12.539999961853027, 8.01546859741211),CFrame.new(221.651306, 106.68074, 339.826416, 0.70842433, -0.0834376514, 0.700838566, 0.163366377, 0.985407054, -0.0478179753, -0.686620593, 0.148368791, 0.711716354);
local tex24=Instance.new('Texture',inst24);tex24.Name,tex24.StudsPerTileU,tex24.StudsPerTileV,tex24.Texture,tex24.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst25=Instance.new('Part',f);inst25.Transparency,inst25.Anchored,inst25.Name,inst25.Size,inst25.CFrame=.8,true,generateCode(),Vector3.new(19.28618049621582, 12.539999961853027, 8.01546859741211),CFrame.new(207.308807, 106.098717, 346.540283, 0.992283583, 0.12256173, -0.0187551528, -0.123165533, 0.991754532, -0.0354075506, 0.0142608946, 0.0374443084, 0.999196827);
local tex25=Instance.new('Texture',inst25);tex25.Name,tex25.StudsPerTileU,tex25.StudsPerTileV,tex25.Texture,tex25.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst26=Instance.new('Part',f);inst26.Transparency,inst26.Anchored,inst26.Name,inst26.Size,inst26.CFrame=.8,true,generateCode(),Vector3.new(15.484987258911133, 11.767034530639648, 7.0764007568359375),CFrame.new(229.482239, 102.759605, 225.045547, 0.940344155, 0.0225027967, 0.339480132, -0.0248737074, 0.999687374, 0.00263369596, -0.33931461, -0.010920709, 0.940609813);
local tex26=Instance.new('Texture',inst26);tex26.Name,tex26.StudsPerTileU,tex26.StudsPerTileV,tex26.Texture,tex26.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst27=Instance.new('Part',f);inst27.Transparency,inst27.Anchored,inst27.Name,inst27.Size,inst27.CFrame=.8,true,generateCode(),Vector3.new(32.817718505859375, 3.6121597290039062, 37.176780700683594),CFrame.new(219.729904, 103.132538, 111.510483, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex27=Instance.new('Texture',inst27);tex27.Name,tex27.StudsPerTileU,tex27.StudsPerTileV,tex27.Texture,tex27.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst28=Instance.new('Part',f);inst28.Transparency,inst28.Anchored,inst28.Name,inst28.Size,inst28.CFrame=.8,true,generateCode(),Vector3.new(5.679999828338623, 4.661665916442871, 15.922219276428223),CFrame.new(178.00322, 107.314392, 61.5141983, 0.964569807, 0.218210921, -0.148289248, 0, 0.56206584, 0.827092528, 0.263828993, -0.797788143, 0.54215169);
local tex28=Instance.new('Texture',inst28);tex28.Name,tex28.StudsPerTileU,tex28.StudsPerTileV,tex28.Texture,tex28.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst29=Instance.new('Part',f);inst29.Transparency,inst29.Anchored,inst29.Name,inst29.Size,inst29.CFrame=.8,true,generateCode(),Vector3.new(56.17995071411133, 75.24739074707031, 3.6358413696289062),CFrame.new(343.06665, 135.52417, 84.6725616, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex29=Instance.new('Texture',inst29);tex29.Name,tex29.StudsPerTileU,tex29.StudsPerTileV,tex29.Texture,tex29.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst30=Instance.new('Part',f);inst30.Transparency,inst30.Anchored,inst30.Name,inst30.Size,inst30.CFrame=.8,true,generateCode(),Vector3.new(27.106828689575195, 75.24287414550781, 3.6358413696289062),CFrame.new(362.345795, 135.521896, 99.0333252, -0.00915077887, 0, 0.999958158, 0, 0.99999994, 0, -0.999958158, 0, -0.00915077887);
local tex30=Instance.new('Texture',inst30);tex30.Name,tex30.StudsPerTileU,tex30.StudsPerTileV,tex30.Texture,tex30.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst31=Instance.new('Part',f);inst31.Transparency,inst31.Anchored,inst31.Name,inst31.Size,inst31.CFrame=.8,true,generateCode(),Vector3.new(17.847509384155273, 21.42536163330078, 5.473657608032227),CFrame.new(403.130951, 116.764618, 94.0302277, -0.00915077887, -0.836788535, 0.547449827, 0, 0.547472715, 0.836823642, -0.999958217, 0.0076575866, -0.00500980159);
local tex31=Instance.new('Texture',inst31);tex31.Name,tex31.StudsPerTileU,tex31.StudsPerTileV,tex31.Texture,tex31.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst32=Instance.new('Part',f);inst32.Transparency,inst32.Anchored,inst32.Name,inst32.Size,inst32.CFrame=.8,true,generateCode(),Vector3.new(10.653038024902344, 7.042899131774902, 10.467855453491211),CFrame.new(445.653137, 160.17067, 29.6218357, -0.722612739, 0.393867731, 0.568066299, -0.0415397882, 0.795563996, -0.604443967, -0.690003872, -0.460376203, -0.558523595);
local tex32=Instance.new('Texture',inst32);tex32.Name,tex32.StudsPerTileU,tex32.StudsPerTileV,tex32.Texture,tex32.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst33=Instance.new('Part',f);inst33.Transparency,inst33.Anchored,inst33.Name,inst33.Size,inst33.CFrame=.8,true,generateCode(),Vector3.new(2.741999864578247, 5.152999401092529, 7.3329997062683105),CFrame.new(287.971802, 111.229668, 122.590378, 0.866025329, 0, -0.500000179, 0, 1, 0, 0.500000179, 0, 0.866025329);
local tex33=Instance.new('Texture',inst33);tex33.Name,tex33.StudsPerTileU,tex33.StudsPerTileV,tex33.Texture,tex33.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst34=Instance.new('Part',f);inst34.Transparency,inst34.Anchored,inst34.Name,inst34.Size,inst34.CFrame=.8,true,generateCode(),Vector3.new(12.50200080871582, 19.364999771118164, 11.701998710632324),CFrame.new(314.325745, 115.796432, 141.727051, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex34=Instance.new('Texture',inst34);tex34.Name,tex34.StudsPerTileU,tex34.StudsPerTileV,tex34.Texture,tex33.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst35=Instance.new('Part',f);inst35.Transparency,inst35.Anchored,inst35.Name,inst35.Size,inst35.CFrame=.8,true,generateCode(),Vector3.new(10.733999252319336, 16.637001037597656, 13.208000183105469),CFrame.new(276.706512, 113.699432, 172.930756, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex35=Instance.new('Texture',inst35);tex35.Name,tex35.StudsPerTileU,tex35.StudsPerTileV,tex35.Texture,tex35.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst36=Instance.new('Part',f);inst36.Transparency,inst36.Anchored,inst36.Name,inst36.Size,inst36.CFrame=.8,true,generateCode(),Vector3.new(9.956000328063965, 8.566999435424805, 15.85300064086914),CFrame.new(181.888672, 123.971497, 95.9904022, 1, 0, 0, 0, 1, 0, 0, 0, 1);
local tex36=Instance.new('Texture',inst36);tex36.Name,tex36.StudsPerTileU,tex36.StudsPerTileV,tex36.Texture,tex36.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst37=Instance.new('Part',f);inst37.Transparency,inst37.Anchored,inst37.Name,inst37.Size,inst37.CFrame=.8,true,generateCode(),Vector3.new(4, 6.595000267028809, 8.747000694274902),CFrame.new(199.321945, 128.631699, 74.9451828, 0.866025388, 0, -0.5, 0, 1, 0, 0.5, 0, 0.866025388);
local tex37=Instance.new('Texture',inst37);tex37.Name,tex37.StudsPerTileU,tex37.StudsPerTileV,tex37.Texture,tex37.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
local inst38=Instance.new('Part',f);inst38.Transparency,inst38.Anchored,inst38.Name,inst38.Size,inst38.CFrame=.8,true,generateCode(),Vector3.new(5.961000442504883, 12.583000183105469, 7.430999755859375),CFrame.new(373.198578, 118.00631, 119.863083, 0.965925813, 0, -0.258819044, 0, 1, 0, 0.258819044, 0, 0.965925813);
local tex38=Instance.new('Texture',inst38);tex38.Name,tex38.StudsPerTileU,tex38.StudsPerTileV,tex38.Texture,tex38.Face=generateCode(),4,4,'http://www.roblox.com/asset/?id='..textures[math.random(1,#textures)],Enum.NormalId.Top
print("parts loaded")

walk()
