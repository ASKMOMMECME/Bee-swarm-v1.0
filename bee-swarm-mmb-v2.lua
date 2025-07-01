-- Bee Swarm v1.0 MMB -- Compatible with PC and Mobile -

local UIS = game:GetService("UserInputService") local player = game.Players.LocalPlayer local ScreenGui = Instance.new("ScreenGui", game.CoreGui) local visible = true

-- Main GUI local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 350, 0, 450) MainFrame.Position = UDim2.new(0, 50, 0, 100) MainFrame.BackgroundTransparency = 1 MainFrame.Name = "BeeSwarmMMB" MainFrame.Parent = ScreenGui

-- Toggle Button local ToggleButton = Instance.new("TextButton") ToggleButton.Size = UDim2.new(0, 40, 0, 40) ToggleButton.Position = UDim2.new(1, -50, 0, 10) ToggleButton.Text = "⛶" ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) ToggleButton.TextColor3 = Color3.new(1, 1, 1) ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function() visible = not visible MainFrame.Visible = visible end)

UIS.InputBegan:Connect(function(input, gameProcessed) if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then visible = not visible MainFrame.Visible = visible end end)

-- Create Tab Function function createTab(name, position) local tab = Instance.new("Frame") tab.Name = name tab.Size = UDim2.new(0, 350, 0, 450) tab.Position = UDim2.new(0, position, 0, 100) tab.BackgroundTransparency = 1 tab.Visible = true tab.Parent = ScreenGui return tab end

-- Create Checkbox Function function createCheckbox(tab, text, posY, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 300, 0, 35) btn.Position = UDim2.new(0, 25, 0, posY) btn.Text = "☐ " .. text btn.BackgroundColor3 = Color3.fromRGB(80, 80, 100) btn.TextColor3 = Color3.new(1, 1, 1) btn.Parent = tab

local active = false
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = (active and "☑️ " or "☐ ") .. text
    callback(active)
end)

end

-- FARM TAB local tabFarm = createTab("FarmTab", 50) createCheckbox(tabFarm, "Auto Farm", 0.1, function(v) if v then spawn(function() while v do player.Character:MoveTo(Vector3.new(137, 4, 284)) wait(3) end end) end end) createCheckbox(tabFarm, "Auto Sell Honey", 0.2, function(v) if v then spawn(function() while v do local hive = workspace.Honeycombs:FindFirstChild(player.Name) if hive then player.Character:SetPrimaryPartCFrame(hive.CFrame + Vector3.new(0, 5, 0)) game.ReplicatedStorage.Events.PlayerHiveCommand:FireServer("StartMakingHoney") end wait(5) end end) end end) createCheckbox(tabFarm, "Auto Dig", 0.3, function(v) if v then spawn(function() while v do game.ReplicatedStorage.Events.ToolCollect:FireServer("CollectFromTool") wait(0.2) end end) end end) createCheckbox(tabFarm, "Auto Sprinkler", 0.4, function(v) if v then spawn(function() while v do game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer("Sprinkler", "Place") wait(10) end end) end end)

-- QUEST TAB local tabQuest = createTab("QuestTab", 420) local npcs = {"Black Bear", "Brown Bear", "Mother Bear", "Science Bear", "Panda Bear"} local enabledNPCs = {} for i, name in ipairs(npcs) do createCheckbox(tabQuest, name, 0.05 + (i * 0.1), function(v) enabledNPCs[name] = v end) end spawn(function() while true do for _, name in ipairs(npcs) do if enabledNPCs[name] and workspace.NPCs:FindFirstChild(name) then local part = workspace.NPCs[name]:FindFirstChild("Dialog") if part then fireclickdetector(part.ClickDetector) end end end wait(10) end end)

-- TITLES TAB local tabTitles = createTab("TitlesTab", 790) createCheckbox(tabTitles, "Auto Farm Titles", 0.1, function(v) if v then spawn(function() while v do player.Character:MoveTo(Vector3.new(100, 4, 270)) wait(5) end end) end end) createCheckbox(tabTitles, "Auto Claim Titles", 0.25, function(v) if v then spawn(function() while v do game.ReplicatedStorage.Events.BadgeEvent:FireServer("CollectBadges") wait(15) end end) end end)

-- ANT FARM TAB local tabAnt = createTab("AntTab", 1160) createCheckbox(tabAnt, "Auto Ant Farm", 0.1, function(v) if v then spawn(function() while v do player.Character:MoveTo(Vector3.new(100, 4, -20)) wait(2) end end) end end) createCheckbox(tabAnt, "Auto Avoid Mobs", 0.25, function(v) if v then spawn(function() while v do for _, mob in pairs(workspace.Monsters:GetChildren()) do if (mob.Position - player.Character.PrimaryPart.Position).Magnitude < 15 then player.Character:MoveTo(player.Character.PrimaryPart.Position + Vector3.new(15, 0, 15)) wait(0.5) end end wait(0.2) end end) end end) createCheckbox(tabAnt, "Auto Snail Farm", 0.4, function(v) if v then spawn(function() while v do player.Character:MoveTo(Vector3.new(-300, 5, 450)) wait(2) end end) end end)

-- PLAYER TAB local tabPlayer = createTab("PlayerTab", 1530) local speedEnabled = false local currentSpeed = 50 createCheckbox(tabPlayer, "Fast Movement", 0.1, function(v) speedEnabled = v if v then player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed else player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end) local speedBox = Instance.new("TextBox") speedBox.Size = UDim2.new(0, 100, 0, 35) speedBox.Position = UDim2.new(0, 25, 0, 0.25) speedBox.Text = tostring(currentSpeed) speedBox.BackgroundColor3 = Color3.fromRGB(120, 120, 150) speedBox.TextColor3 = Color3.new(1, 1, 1) speedBox.PlaceholderText = "Speed (0–80)" speedBox.Parent = tabPlayer speedBox.FocusLost:Connect(function() local val = tonumber(speedBox.Text) if val and val >= 0 and val <= 80 then currentSpeed = val end end) spawn(function() while true do if speedEnabled and player.Character then local hum = player.Character:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = currentSpeed end end wait(0.2) end end)

-- MACRO TAB local tabMacro = createTab("MacroTab", 1900) local macros = {} local selectedMacro = nil local nameBox = Instance.new("TextBox") nameBox.Size = UDim2.new(0, 300, 0, 35) nameBox.Position = UDim2.new(0, 25, 0, 0.1) nameBox.PlaceholderText = "Enter macro name..." nameBox.Parent = tabMacro local createBtn = Instance.new("TextButton") createBtn.Size = UDim2.new(0, 140, 0, 35) createBtn.Position = UDim2.new(0, 25, 0, 0.25) createBtn.Text = "Create" createBtn.Parent = tabMacro local deleteBtn = Instance.new("TextButton") deleteBtn.Size = UDim2.new(0, 140, 0, 35) deleteBtn.Position = UDim2.new(0, 185, 0, 0.25) deleteBtn.Text = "Delete" deleteBtn.Parent = tabMacro local runBtn = Instance.new("TextButton") runBtn.Size = UDim2.new(0, 300, 0, 35) runBtn.Position = UDim2.new(0, 25, 0, 0.4) runBtn.Text = "Run Macro" runBtn.Parent = tabMacro createBtn.MouseButton1Click:Connect(function() local name = nameBox.Text if name ~= "" and not macros[name] then macros[name] = { steps = {"Move to field", "Place sprinkler", "Auto collect", "Sell honey"} } selectedMacro = name end end) deleteBtn.MouseButton1Click:Connect(function() local name = nameBox.Text macros[name] = nil selectedMacro = nil end) runBtn.MouseButton1Click:Connect(function() if selectedMacro and macros[selectedMacro] then spawn(function() for _, step in ipairs(macros[selectedMacro].steps) do print("Running step:", step) wait(1 + math.random()) end end) end end)

-- ANTI-CHEAT BYPASS spawn(function() while true do wait(0.2 + math.random()) local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D} local key = keys[math.random(1, #keys)] game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game) wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game) end end)

print("Bee Swarm v1.0 MMB loaded successfully.")

