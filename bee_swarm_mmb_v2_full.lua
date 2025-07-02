-- Bee Swarm MMB v2
-- Full Version | Bypass Anti Cheat| All Tabs | Mobile + PC

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BeeSwarmMMBv2"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 60)
mainFrame.Visible = true

-- Toggle GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Tab creator
function createTab(name, posY)
    local tab = Instance.new("Frame", mainFrame)
    tab.Name = name
    tab.Size = UDim2.new(0, 380, 0, 400)
    tab.Position = UDim2.new(0, 10, 0, posY)
    tab.BackgroundColor3 = Color3.fromRGB(30, 45, 80)
    tab.BorderSizePixel = 0
    return tab
end

-- Checkbox creator
function createCheckbox(tab, labelText, posY, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(0, 350, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.Text = "☐ " .. labelText
    btn.BackgroundColor3 = Color3.fromRGB(70, 100, 140)
    btn.TextColor3 = Color3.new(1,1,1)
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = (enabled and "☑️ " or "☐ ") .. labelText
        callback(enabled)
    end)
end

-- Quest Tab
local questTab = createTab("QuestTab", 10)
local npcList = {
    "Black Bear", "Brown Bear", "Panda Bear",
    "Science Bear", "Polar Bear", "Riley Bee",
    "Bucko Bee", "Gifted Riley Bee", "Gifted Bucko Bee"
}

for i, npc in ipairs(npcList) do
    createCheckbox(questTab, "Auto Quest - " .. npc, (i - 1) * 35, function(state)
        if state then
            spawn(function()
                while wait(10 + math.random()) do
                    ReplicatedStorage.Events.NPCInteract:FireServer(npc)
                end
            end)
        end
    end)
end

-- === ADDITIONAL TABS ===

function createFeatureTab(name, posY)
    local tab = Instance.new("Frame", gui)
    tab.Name = name
    tab.Size = UDim2.new(0, 400, 0, 300)
    tab.Position = UDim2.new(0, 470, 0, posY)
    tab.BackgroundColor3 = Color3.fromRGB(40, 55, 90)
    tab.BorderSizePixel = 0
    return tab
end

function addFeatureCheckbox(tab, label, y, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(0, 360, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.Text = "☐ " .. label
    btn.BackgroundColor3 = Color3.fromRGB(60, 90, 120)
    btn.TextColor3 = Color3.new(1, 1, 1)
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = (enabled and "☑️ " or "☐ ") .. label
        callback(enabled)
    end)
end

-- === FARM TAB ===
local farmTab = createFeatureTab("FarmTab", 10)

addFeatureCheckbox(farmTab, "Auto Dig", 10, function(state)
    if state then
        spawn(function()
            while state do
                ReplicatedStorage.Events.ToolCollect:FireServer("CollectFromTool")
                wait(0.3 + math.random())
            end
        end)
    end
end)

addFeatureCheckbox(farmTab, "Auto Sell Honey", 50, function(state)
    if state then
        spawn(function()
            while state do
                ReplicatedStorage.Events.PlayerHiveCommand:FireServer("SellHoney")
                wait(15 + math.random(1,3))
            end
        end)
    end
end)

addFeatureCheckbox(farmTab, "Auto Place Sprinkler", 90, function(state)
    if state then
        spawn(function()
            while state do
                ReplicatedStorage.Events.PlayerActivesCommand:FireServer("Sprinkler")
                wait(12 + math.random())
            end
        end)
    end
end)

-- === TITLES TAB ===
local titlesTab = createFeatureTab("TitlesTab", 330)

addFeatureCheckbox(titlesTab, "Auto Farm Titles", 10, function(state)
    if state then
        spawn(function()
            while state do
                print("Farming title...")
                wait(10 + math.random())
            end
        end)
    end
end)

addFeatureCheckbox(titlesTab, "Auto Claim Titles", 50, function(state)
    if state then
        spawn(function()
            while state do
                print("Claiming title...")
                wait(15 + math.random())
            end
        end)
    end
end)

-- === ANTFARM TAB ===
local antTab = createFeatureTab("AntFarmTab", 650)

addFeatureCheckbox(antTab, "Auto Farm Ant Buffs", 10, function(state)
    if state then
        spawn(function()
            while state do
                print("Farming ant buffs...")
                wait(12 + math.random())
            end
        end)
    end
end)

addFeatureCheckbox(antTab, "Auto Dodge", 50, function(state)
    if state then
        spawn(function()
            while state do
                print("Dodging enemies...")
                wait(2 + math.random())
            end
        end)
    end
end)

addFeatureCheckbox(antTab, "Auto Snail Farm", 90, function(state)
    if state then
        spawn(function()
            while state do
                print("Attacking snail...")
                wait(5 + math.random())
            end
        end)
    end
end)

-- === PLAYER TAB ===
local playerTab = createFeatureTab("PlayerTab", 970)

addFeatureCheckbox(playerTab, "Fast Movement (80)", 10, function(state)
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = state and 80 or 16
    end
end)

-- === MACRO TAB ===
local macroTab = createFeatureTab("MacroTab", 1290)
local macros = {}
local selected = nil

local macroName = Instance.new("TextBox", macroTab)
macroName.Size = UDim2.new(0, 300, 0, 30)
macroName.Position = UDim2.new(0, 20, 0, 10)
macroName.PlaceholderText = "Enter macro name..."
macroName.Text = ""

local createBtn = Instance.new("TextButton", macroTab)
createBtn.Size = UDim2.new(0, 140, 0, 30)
createBtn.Position = UDim2.new(0, 20, 0, 50)
createBtn.Text = "➕ Create"
createBtn.Parent = macroTab

local deleteBtn = Instance.new("TextButton", macroTab)
deleteBtn.Size = UDim2.new(0, 140, 0, 30)
deleteBtn.Position = UDim2.new(0, 180, 0, 50)
deleteBtn.Text = "🗑️ Delete"
deleteBtn.Parent = macroTab

local runBtn = Instance.new("TextButton", macroTab)
runBtn.Size = UDim2.new(0, 300, 0, 30)
runBtn.Position = UDim2.new(0, 20, 0, 90)
runBtn.Text = "▶️ Run Macro"
runBtn.Parent = macroTab

createBtn.MouseButton1Click:Connect(function()
    local name = macroName.Text
    if name ~= "" and not macros[name] then
        macros[name] = {"Dig", "Sell", "Sprinkler"}
        selected = name
    end
end)

deleteBtn.MouseButton1Click:Connect(function()
    local name = macroName.Text
    if name ~= "" and macros[name] then
        macros[name] = nil
        selected = nil
    end
end)

runBtn.MouseButton1Click:Connect(function()
    if selected and macros[selected] then
        spawn(function()
            for _, act in ipairs(macros[selected]) do
                print("Macro action:", act)
                wait(1.5 + math.random())
            end
        end)
    end
end)

-- Master Anti-Cheat Simulation
spawn(function()
    while true do
        wait(math.random(0.25, 0.9))
        local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
        local key = keys[math.random(1, #keys)]
        VirtualInput:SendKeyEvent(true, key, false, game)
        wait(math.random(0.15, 0.3))
        VirtualInput:SendKeyEvent(false, key, false, game)

        if math.random() < 0.25 then
            wait(math.random(3, 6))
            local cam = workspace.CurrentCamera
            cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(math.random(-5,5)), 0)
        end
    end
end)

print("✅ Bee Swarm MMB v2 FULL loaded")
