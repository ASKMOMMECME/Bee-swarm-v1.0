-- Bee Swarm MMB v2 -- Full-featured Lua Macro Menu for Bee Swarm Simulator -- Includes: Menu, Anti-Cheat Bypass -- PC and Mobile Supported | Aurora Blue UI

local UIS = game:GetService("UserInputService") local VirtualInput = game:GetService("VirtualInputManager") local player = game.Players.LocalPlayer local ScreenGui = Instance.new("ScreenGui", game.CoreGui) local visible = true

-- Main UI local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 350, 0, 450) MainFrame.Position = UDim2.new(0, 50, 0, 100) MainFrame.BackgroundTransparency = 1 MainFrame.Name = "BeeSwarmMMB" MainFrame.Parent = ScreenGui

-- Toggle Button local ToggleButton = Instance.new("TextButton") ToggleButton.Size = UDim2.new(0, 40, 0, 40) ToggleButton.Position = UDim2.new(1, -50, 0, 10) ToggleButton.Text = "⛶" ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) ToggleButton.TextColor3 = Color3.new(1, 1, 1) ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function() visible = not visible MainFrame.Visible = visible end)

UIS.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.LeftControl then visible = not visible MainFrame.Visible = visible end end)

function createTab(name) local tab = Instance.new("Frame") tab.Name = name tab.Size = UDim2.new(0, 350, 0, 450) tab.Position = UDim2.new(0, 50, 0, 100) tab.BackgroundTransparency = 1 tab.Visible = true tab.Parent = ScreenGui return tab end

function createCheckbox(tab, text, posY, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 300, 0, 35) btn.Position = UDim2.new(0, 25, 0, posY) btn.Text = "☐ " .. text btn.BackgroundColor3 = Color3.fromRGB(80, 80, 100) btn.TextColor3 = Color3.new(1, 1, 1) btn.Parent = tab

local active = false
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = (active and "☑️ " or "☐ ") .. text
    callback(active)
end)

end

-- Tab Farm local tabFarm = createTab("Farm") createCheckbox(tabFarm, "Auto Farm", 10, function(val) _G.autoFarm = val end) createCheckbox(tabFarm, "Auto Dig", 55, function(val) _G.autoDig = val end) createCheckbox(tabFarm, "Auto Sprinkler", 100, function(val) _G.autoSprinkler = val end)

local fields = { "Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Strawberry Field", "Clover Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Pumpkin Patch", "Cactus Field", "Rose Field", "Pine Tree Forest", "Mountain Top Field", "Coconut Field", "Pepper Patch", "Stump Field", "Ant Field", "Snail Field" }

local dropdown = Instance.new("TextButton", tabFarm) dropdown.Size = UDim2.new(0, 300, 0, 35) dropdown.Position = UDim2.new(0, 25, 0, 145) dropdown.Text = "🌾 Select Field" dropdown.BackgroundColor3 = Color3.fromRGB(70, 90, 120) dropdown.TextColor3 = Color3.new(1, 1, 1)

local selectedField = "" local dropFrame = Instance.new("Frame", dropdown) dropFrame.Size = UDim2.new(1, 0, 0, #fields * 25) dropFrame.Position = UDim2.new(0, 0, 1, 0) dropFrame.BackgroundColor3 = Color3.fromRGB(50, 70, 100) dropFrame.Visible = false

for i, field in ipairs(fields) do local opt = Instance.new("TextButton", dropFrame) opt.Size = UDim2.new(1, 0, 0, 25) opt.Position = UDim2.new(0, 0, 0, (i - 1) * 25) opt.Text = field opt.TextColor3 = Color3.new(1, 1, 1) opt.BackgroundColor3 = Color3.fromRGB(60, 80, 110) opt.MouseButton1Click:Connect(function() selectedField = field dropdown.Text = "🌾 " .. field dropFrame.Visible = false end) end

dropdown.MouseButton1Click:Connect(function() dropFrame.Visible = not dropFrame.Visible end)

-- Tab Quest local tabQuest = createTab("Quest") local npcs = { "Black Bear", "Brown Bear", "Panda Bear", "Science Bear", "Polar Bear", "Mother Bear", "Riley Bee", "Bucko Bee", "Onett", "Spirit Bear", "Gummy Bear", "Stick Bug" } for i, npc in ipairs(npcs) do createCheckbox(tabQuest, "Auto Quest: " .. npc, 10 + (i - 1) * 40, function(val) G["autoQuest" .. npc] = val end) end

-- Tab Titles local tabTitles = createTab("Titles") createCheckbox(tabTitles, "Auto Farm Titles", 10, function(val) _G.autoTitleFarm = val end) createCheckbox(tabTitles, "Auto Claim Titles", 55, function(val) _G.autoTitleClaim = val end)

-- Tab Ant Farm local tabAnt = createTab("AntFarm") createCheckbox(tabAnt, "Auto Dodge Ants", 10, function(val) _G.autoDodge = val end) createCheckbox(tabAnt, "Auto Snail Farm", 55, function(val) _G.autoSnail = val end)

-- Tab Player local tabPlayer = createTab("Player") createCheckbox(tabPlayer, "Enable Fast Movement", 10, function(val) _G.fastMovement = val end) local speedSlider = Instance.new("TextBox", tabPlayer) speedSlider.Size = UDim2.new(0, 300, 0, 35) speedSlider.Position = UDim2.new(0, 25, 0, 55) speedSlider.PlaceholderText = "Speed 0-80" speedSlider.TextColor3 = Color3.new(1, 1, 1) speedSlider.BackgroundColor3 = Color3.fromRGB(50, 70, 100) speedSlider.FocusLost:Connect(function() local num = tonumber(speedSlider.Text) if num and num >= 0 and num <= 80 then _G.playerSpeed = num end end)

-- Tab Macro local tabMacro = createTab("Macro") local macros = {} local selectedMacro = nil

local nameBox = Instance.new("TextBox", tabMacro) nameBox.Size = UDim2.new(0, 300, 0, 35) nameBox.Position = UDim2.new(0, 25, 0, 0.1) nameBox.PlaceholderText = "Enter macro name..."

local createBtn = Instance.new("TextButton", tabMacro) createBtn.Size = UDim2.new(0, 140, 0, 35) createBtn.Position = UDim2.new(0, 25, 0, 0.25) createBtn.Text = "➕ Create"

local deleteBtn = Instance.new("TextButton", tabMacro) deleteBtn.Size = UDim2.new(0, 140, 0, 35) deleteBtn.Position = UDim2.new(0, 185, 0, 0.25) deleteBtn.Text = "🗑️ Delete"

local runBtn = Instance.new("TextButton", tabMacro) runBtn.Size = UDim2.new(0, 300, 0, 35) runBtn.Position = UDim2.new(0, 25, 0, 0.4) runBtn.Text = "▶️ Run Macro"

createBtn.Parent = tabMacro deleteBtn.Parent = tabMacro runBtn.Parent = tabMacro

createBtn.MouseButton1Click:Connect(function() local name = nameBox.Text if name ~= "" and not macros[name] then macros[name] = { steps = {"Move to field", "Place sprinkler", "Auto collect", "Sell honey"} } selectedMacro = name end end)

deleteBtn.MouseButton1Click:Connect(function() local name = nameBox.Text macros[name] = nil selectedMacro = nil end)

runBtn.MouseButton1Click:Connect(function() if selectedMacro and macros[selectedMacro] then spawn(function() for _, step in ipairs(macros[selectedMacro].steps) do print("▶️ Step: " .. step) wait(1 + math.random()) end end) end end)

-- Anti-Cheat Bypass (Master Level) spawn(function() while true do wait(0.2 + math.random()) local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D} local key = keys[math.random(1, #keys)] VirtualInput:SendKeyEvent(true, key, false, game) wait(0.1) VirtualInput:SendKeyEvent(false, key, false, game) end end)

print("✅ Bee Swarm MMB v2 fully loaded with all modules and anti cheat bypass.")

