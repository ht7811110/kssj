local function getGuiParent()
    return (gethui and gethui()) or game.CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NAGN"
ScreenGui.Parent = getGuiParent()

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "http://www.roblox.com/asset/?id=95622155258132"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local TabHolder = Instance.new("Frame")
TabHolder.Parent = MainFrame
TabHolder.Size = UDim2.new(0, 500, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 0)
TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Tabs = {}
local tabNames = {"Items", "Main", "Visuals", "Miscellaneous"}
for i, name in ipairs(tabNames) do
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabHolder
    TabButton.Size = UDim2.new(0, 125, 0, 30)
    TabButton.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = MainFrame
    TabFrame.Size = UDim2.new(0, 500, 0, 270)
    TabFrame.Position = UDim2.new(0, 0, 0, 30)
    TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabFrame.Visible = false

    Tabs[name] = TabFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do tab.Visible = false end
        TabFrame.Visible = true
    end)
end

local function AddToggle(tabName, text, callback)
    if Tabs[tabName] then
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Parent = Tabs[tabName]
        ToggleFrame.Size = UDim2.new(0, 480, 0, 40)
        ToggleFrame.Position = UDim2.new(0, 10, 0, 10 + (#Tabs[tabName]:GetChildren() * 45))
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

        local ToggleText = Instance.new("TextLabel")
        ToggleText.Parent = ToggleFrame
        ToggleText.Size = UDim2.new(0, 400, 1, 0)
        ToggleText.Position = UDim2.new(0, 10, 0, 0)
        ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleText.Text = text
        ToggleText.TextXAlignment = Enum.TextXAlignment.Left
        ToggleText.BackgroundTransparency = 1

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = ToggleFrame
        ToggleButton.Size = UDim2.new(0, 30, 0, 30)
        ToggleButton.Position = UDim2.new(1, -40, 0.5, -15)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Trắng (OFF)
        ToggleButton.Text = ""
        ToggleButton.AutoButtonColor = false
        ToggleButton.ClipsDescendants = true
        ToggleButton.BorderSizePixel = 0
        ToggleButton.TextSize = 14
        ToggleButton.Font = Enum.Font.SourceSansBold
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextTransparency = 1
        ToggleButton.ZIndex = 2
        ToggleButton.CornerRadius = UDim.new(1, 0) -- Biến nút thành hình tròn

        local enabled = false
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255) -- Xanh = ON, Trắng = OFF
            callback(enabled)
        end)
    end
end

local function getMaxLevel()
    return 2450 -- Thay đổi tùy theo game
end

local function getCurrentLevel()
    return game.Players.LocalPlayer.Data.Level.Value
end

local function getHighestLevelMob()
    local mobs = {
        ["Mob A"] = 2300,
        ["Mob B"] = 2350,
        ["Mob C"] = 2400,
        ["Mob D"] = 2450
    }
    local maxMob = nil
    for mob, level in pairs(mobs) do
        if not maxMob or level > mobs[maxMob] then
            maxMob = mob
        end
    end
    return maxMob
end

local function autoFarmLevel(enabled)
    while enabled do
        if getCurrentLevel() >= getMaxLevel() then
            local highestMob = getHighestLevelMob()
            print("Đã max cấp, đánh quái: " .. highestMob)
        else
            print("Đang farm level...")
        end
        wait(1)
    end
end

AddToggle("Main", "Auto Farm Level", function(state)
    autoFarmLevel(state)
end)

AddToggle("Main", "Auto Attack Elite Hunter", function(state)
    print("Auto Attack Elite Hunter: " .. tostring(state))
end)

AddToggle("Main", "Auto Attack Hải Tặc", function(state)
    print("Auto Attack Hải Tặc: " .. tostring(state))
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

spawn(function()
    while wait(1) do
        if not ScreenGui.Parent then
            ScreenGui.Parent = getGuiParent()
        end
    end
end)