local function getGuiParent()
    return (gethui and gethui()) or game.CoreGui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NAGN"
ScreenGui.Parent = getGuiParent()

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Logo = Instance.new("ImageLabel")
Logo.Parent = MainFrame
Logo.Size = UDim2.new(0, 100, 0, 100)
Logo.Position = UDim2.new(0.5, -50, 0, 10)
Logo.Image = "http://www.roblox.com/asset/?id=95622155258132"

local TabHolder = Instance.new("Frame")
TabHolder.Parent = MainFrame
TabHolder.Size = UDim2.new(0, 500, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 120)
TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Tabs = {}
local tabNames = {"Items", "Combat", "Visuals", "Miscellaneous"}
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
    TabFrame.Size = UDim2.new(0, 500, 0, 150)
    TabFrame.Position = UDim2.new(0, 0, 0, 150)
    TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabFrame.Visible = false

    Tabs[name] = TabFrame

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do tab.Visible = false end
        TabFrame.Visible = true
    end)
end

local function AddButton(tabName, text, callback)
    if Tabs[tabName] then
        local Button = Instance.new("TextButton")
        Button.Parent = Tabs[tabName]
        Button.Size = UDim2.new(0, 480, 0, 30)
        Button.Position = UDim2.new(0, 10, 0, 10 + (#Tabs[tabName]:GetChildren() * 35))
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Text = text
        Button.MouseButton1Click:Connect(callback)
    end
end

AddButton("Combat", "Auto Farm Level", function()
    print("Auto Farm Level Activated")
end)

AddButton("Combat", "Auto Attack Elite Hunter", function()
    print("Auto Attack Elite Hunter Activated")
end)

AddButton("Combat", "Auto Attack Hải Tặc", function()
    print("Auto Attack Hải Tặc Activated")
end)

spawn(function()
    while wait(1) do
        if not ScreenGui.Parent then
            ScreenGui.Parent = getGuiParent()
        end
    end
end)