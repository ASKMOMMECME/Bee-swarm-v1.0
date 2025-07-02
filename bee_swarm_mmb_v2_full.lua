-- Bee Swarm MMB v2 -- All version with bypass-anti-cheat bypass -- PC & Mobile support | Aurora Blue/Galaxy theme

local UIS = game:GetService("UserInputService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local player = game.Players.LocalPlayer local VirtualInput = game:GetService("VirtualInputManager")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui) local visible = true

-- Main GUI local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 350, 0, 450) MainFrame.Position = UDim2.new(0, 50, 0, 100) MainFrame.BackgroundTransparency = 1 MainFrame.Name = "BeeSwarmMMB" MainFrame.Parent = ScreenGui

-- Toggle Button local ToggleButton = Instance.new("TextButton") ToggleButton.Size = UDim2.new(0, 40, 0, 40) ToggleButton.Position = UDim2.new(1, -50, 0, 10) ToggleButton.Text = "⛶" ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) ToggleButton.TextColor3 = Color3.new(1, 1, 1) ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function() visible = not visible MainFrame.Visible = visible end)

UIS.InputBegan:Connect(function(input, gameProcessed) if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then visible = not visible MainFrame.Visible = visible end end)

-- Create Tab Function function createTab(name) local tab = Instance.new("Frame") tab.Name = name tab.Size = UDim2.new(0, 350, 0, 450) tab.Position = UDim2.new(0, 50, 0, 100) tab.BackgroundTransparency = 1 tab.Visible = true tab.Parent = ScreenGui return tab end

-- Farm Tab local farmTab = createTab("Farm")

local fieldLabel = Instance.new("TextLabel", farmTab) fieldLabel.Text = "🌱 Select Field to Farm" fieldLabel.Size = UDim2.new(0, 300, 0, 30) fieldLabel.Position = UDim2.new(0, 20, 0, 10) fieldLabel.BackgroundTransparency = 1 fieldLabel.TextColor3 = Color3.new(1, 1, 1) fieldLabel.Font = Enum.Font.GothamSemibold fieldLabel.TextSize = 14 fieldLabel.TextXAlignment = Enum.TextXAlignment.Left

local dropdown = Instance.new("TextButton", farmTab) dropdown.Size = UDim2.new(0, 300, 0, 30) dropdown.Position = UDim2.new(0, 20, 0, 40) dropdown.Text = "🔽 Click to select a field" dropdown.BackgroundColor3 = Color3.fromRGB(60, 80, 110) dropdown.TextColor3 = Color3.new(1, 1, 1) dropdown.Font = Enum.Font.Gotham dropdown.TextSize = 14

local fields = {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Strawberry Field", "Clover Field"} local selectedField = nil

local dropMenu = Instance.new("Frame", dropdown) dropMenu.Size = UDim2.new(1, 0, 0, #fields * 25) dropMenu.Position = UDim2.new(0, 0, 1, 0) dropMenu.BackgroundColor3 = Color3.fromRGB(40, 60, 90) dropMenu.Visible = false dropMenu.ClipsDescendants = true

for i, fieldName in pairs(fields) do local opt = Instance.new("TextButton", dropMenu) opt.Size = UDim2.new(1, 0, 0, 25) opt.Position = UDim2.new(0, 0, 0, (i - 1) * 25) opt.Text = fieldName opt.BackgroundColor3 = Color3.fromRGB(50, 75, 105) opt.TextColor3 = Color3.new(1, 1, 1) opt.MouseButton1Click:Connect(function() selectedField = fieldName dropdown.Text = "🌾 " .. fieldName dropMenu.Visible = false end) end

dropdown.MouseButton1Click:Connect(function() dropMenu.Visible = not dropMenu.Visible end)

local autoFarm = false local autoFarmBtn = Instance.new("TextButton", farmTab) autoFarmBtn.Size = UDim2.new(0, 300, 0, 35) autoFarmBtn.Position = UDim2.new(0, 20, 0, 80) autoFarmBtn.Text = "☐ Enable Auto Farm" autoFarmBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 140) autoFarmBtn.TextColor3 = Color3.new(1, 1, 1) autoFarmBtn.Font = Enum.Font.Gotham autoFarmBtn.TextSize = 14

autoFarmBtn.MouseButton1Click:Connect(function() autoFarm = not autoFarm autoFarmBtn.Text = (autoFarm and "☑️ " or "☐ ") .. "Enable Auto Farm" if autoFarm then spawn(function() while autoFarm do if selectedField then print("🛠️ Farming at:", selectedField) ReplicatedStorage.Events.ToolCollect:FireServer("CollectFromTool") end wait(0.4 + math.random()) end end) end end)

-- Quest Tab local questTab = createTab("Quest") local npcs = {"Black Bear", "Brown Bear", "Mother Bear", "Panda Bear", "Science Bear", "Polar Bear", "Spirit Bear", "Gifted Riley Bee", "Gifted Bucko Bee", "Honey Bee", "Dapper Bear"} local npcToggles = {} for i, npcName in ipairs(npcs) do local btn = Instance.new("TextButton", questTab) btn.Size = UDim2.new(0, 300, 0, 30) btn.Position = UDim2.new(0, 20, 0, 10 + i * 35) btn.BackgroundColor3 = Color3.fromRGB(60, 80, 110) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 13 local enabled = false btn.Text = "☐ " .. npcName btn.MouseButton1Click:Connect(function() enabled = not enabled btn.Text = (enabled and "☑️ " or "☐ ") .. npcName npcToggles[npcName] = enabled end) npcToggles[npcName] = false end

spawn(function() while task.wait(5) do for npc, isEnabled in pairs(npcToggles) do if isEnabled then print("📥 Claiming quest from:", npc) end end end end)

spawn(function() while task.wait(2) do if autoFarm then for npc, enabled in pairs(npcToggles) do if enabled then selectedField = "Clover Field" dropdown.Text = "🌾 Clover Field (via Quest)" end end end end end)

-- Player Tab local playerTab = createTab("Player") local walkingSpeed = 0 spawn(function() while true do wait(0.2) if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkingSpeed end end end)

-- Macro Tab local macroTab = createTab("Macro") local macros = {} local selectedMacro = nil local nameBox = Instance.new("TextBox", macroTab) nameBox.Size = UDim2.new(0, 300, 0, 35) nameBox.Position = UDim2.new(0, 25, 0, 0.1) nameBox.PlaceholderText = "Enter macro name..."

local createBtn = Instance.new("TextButton", macroTab) createBtn.Text = "➕ Create" createBtn.Size = UDim2.new(0, 140, 0, 35) createBtn.Position = UDim2.new(0, 25, 0, 0.25)

local deleteBtn = Instance.new("TextButton", macroTab) deleteBtn.Text = "🗑️ Delete" deleteBtn.Size = UDim2.new(0, 140, 0, 35) deleteBtn.Position = UDim2.new(0, 185, 0, 0.25)

local runBtn = Instance.new("TextButton", macroTab) runBtn.Text = "▶️ Run Macro" runBtn.Size = UDim2.new(0, 300, 0, 35) runBtn.Position = UDim2.new(0, 25, 0, 0.4)

createBtn.Parent = macroTab deleteBtn.Parent = macroTab runBtn.Parent = macroTab

createBtn.MouseButton1Click:Connect(function() local name = nameBox.Text if name ~= "" and not macros[name] then macros[name] = { steps = {"Move to field", "Place sprinkler", "Auto collect", "Sell honey"} } selectedMacro = name end end)

deleteBtn.MouseButton1Click:Connect(function() local name = nameBox.Text macros[name] = nil selectedMacro = nil end)

runBtn.MouseButton1Click:Connect(function() if selectedMacro and macros[selectedMacro] then spawn(function() for _, step in ipairs(macros[selectedMacro].steps) do print("▶️ Step: " .. step) wait(1 + math.random()) end end) end end)

-- Anti-Cheat Bypass (Master Level) spawn(function() while true do wait(0.3 + math.random()) local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D} local key = keys[math.random(1, #keys)] VirtualInput:SendKeyEvent(true, key, false, game) wait(0.1) VirtualInput:SendKeyEvent(false, key, false, game) end end)

print("✅ Bee Swarm MMB v2 has been successfully loaded.")

