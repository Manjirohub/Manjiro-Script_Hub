--// Secret Code Prompt
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Code check UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Enter Secret Code"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0.4, 0)
TextBox.PlaceholderText = "Enter code..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local Submit = Instance.new("TextButton")
Submit.Size = UDim2.new(0.5, -15, 0, 40)
Submit.Position = UDim2.new(0, 10, 1, -50)
Submit.Text = "Unlock"
Submit.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
Submit.Font = Enum.Font.GothamBold
Submit.TextSize = 16
Submit.Parent = Frame

local Denied = Instance.new("TextLabel")
Denied.Size = UDim2.new(1, 0, 0, 20)
Denied.Position = UDim2.new(0, 0, 1, -20)
Denied.BackgroundTransparency = 1
Denied.Text = ""
Denied.TextColor3 = Color3.fromRGB(255, 0, 0)
Denied.Font = Enum.Font.Gotham
Denied.TextSize = 14
Denied.Parent = Frame

-- Unlock Function
local function UnlockHub()
    ScreenGui:Destroy()

    --// Load Fluent
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

    --// Window
    local Window = Fluent:CreateWindow({
        Title = "Yash Daddy Hub",
        SubTitle = "Dominate with Style 😎",
        Theme = "Dark",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
    })

    local Tabs = {
        ManagePositions = Window:AddTab({ Title = "Manage Positions", Icon = "map" }),
        Utilities = Window:AddTab({ Title = "Utilities", Icon = "cpu" }),
    }

    --// Minimize / Restore system
    local Minimized = false
    local CrownBtn = Instance.new("TextButton")
    CrownBtn.Text = "👑"
    CrownBtn.Size = UDim2.new(0,40,0,40)
    CrownBtn.Position = UDim2.new(1, -45, 0, 5)
    CrownBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    CrownBtn.TextScaled = true
    CrownBtn.Parent = Window.Main

    CrownBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        Window.Main.Visible = not Minimized
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.LeftAlt then
            Window.Main.Visible = true
            Minimized = false
        end
    end)

    --// Positions System
    local Positions = {}
    local PositionButtons = {}
    local positionName = nil

    local function SavePositionsToFile()
        writefile("YashDaddyHub_Positions.txt", HttpService:JSONEncode(Positions))
    end

    local function LoadPositionsFromFile()
        if isfile("YashDaddyHub_Positions.txt") then
            local data = HttpService:JSONDecode(readfile("YashDaddyHub_Positions.txt"))
            for name, pos in pairs(data) do
                Positions[name] = Vector3.new(pos.X, pos.Y, pos.Z)
            end
        end
    end

    LoadPositionsFromFile()

    local function RefreshPositionButtons(section)
        for _, btn in ipairs(PositionButtons) do
            btn:Destroy()
        end
        PositionButtons = {}

        for name, pos in pairs(Positions) do
            local button = section:AddButton({
                Title = "Teleport: " .. name,
                Callback = function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                        Fluent:Notify({
                            Title = "Teleported",
                            Content = "You teleported to: " .. name,
                            Duration = 5,
                            Image = "check"
                        })
                    end
                end
            })
            table.insert(PositionButtons, button)
        end
    end

    -- Manage Positions Tab
    do
        local ManageSection = Tabs.ManagePositions:AddSection("Save & Load")

        Tabs.ManagePositions:AddInput("PosName", {
            Title = "Position Name",
            Default = "",
            Placeholder = "Enter a position name...",
            Callback = function(value)
                positionName = value
            end
        })

        Tabs.ManagePositions:AddButton({
            Title = "Save Current Position",
            Callback = function()
                if not positionName or positionName == "" then
                    Fluent:Notify({ Title = "Error", Content = "Please enter a name!", Duration = 5, Image = "x" })
                    return
                end

                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    Positions[positionName] = char.HumanoidRootPart.Position
                    SavePositionsToFile()
                    RefreshPositionButtons(ManageSection)
                    Fluent:Notify({ Title = "Saved", Content = "Position: " .. positionName, Duration = 5, Image = "check" })
                end
            end
        })

        RefreshPositionButtons(ManageSection)
    end

    -- Utilities Tab
    do
        local UtilSection = Tabs.Utilities:AddSection("Tools")

        -- Noble Teleport
        UtilSection:AddButton({
            Title = "Teleport to Noble",
            Callback = function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1020.9, 346.7, -1322.6)
                    Fluent:Notify({ Title = "Teleported", Content = "You teleported to Noble!", Duration = 5, Image = "check" })
                end
            end
        })

        -- Food Stall Teleport
        UtilSection:AddButton({
            Title = "Teleport to Food Stall",
            Callback = function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(608.1, 165.6, -876.4)
                    Fluent:Notify({ Title = "Teleported", Content = "You teleported to Food Stall!", Duration = 5, Image = "check" })
                end
            end
        })

        -- Teleport to Rosaline
        UtilSection:AddButton({
            Title = "Teleport to Rosaline",
            Callback = function()
                local function findRosaline(parent)
                    for _, obj in ipairs(parent:GetChildren()) do
                        if obj.Name == "Rosaline" and obj:FindFirstChild("HumanoidRootPart") then
                            return obj
                        end
                        local found = findRosaline(obj)
                        if found then return found end
                    end
                    return nil
                end

                local rosaline = findRosaline(workspace)
                if rosaline then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = rosaline.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    Fluent:Notify({ Title = "Teleported", Content = "You teleported to Rosaline!", Duration = 5, Image = "check" })
                else
                    Fluent:Notify({ Title = "Error", Content = "Rosaline not found.", Duration = 5, Image = "x" })
                end
            end
        })

        -- Speed Slider
        UtilSection:AddSlider("WalkSpeed", {
            Title = "WalkSpeed",
            Description = "Set your speed",
            Default = 16,
            Min = 16,
            Max = 200,
            Rounding = 0,
            Callback = function(value)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
                end
            end
        })

        -- Auto Hold E
        local holdingE = false
        local connection

        UtilSection:AddToggle("AutoHoldE", {
            Title = "Auto Hold E",
            Default = false,
            Callback = function(state)
                holdingE = state
                if holdingE then
                    connection = game:GetService("RunService").Heartbeat:Connect(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                    end)
                else
                    if connection then connection:Disconnect() end
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                end
            end
        })
    end

    Fluent:Notify({
        Title = "Yash Daddy Hub",
        Content = "Hub loaded successfully!",
        Duration = 8,
        Image = "star"
    })
end

-- Unlock check
Submit.MouseButton1Click:Connect(function()
    if TextBox.Text == "yashismydaddy" then
        UnlockHub()
    else
        Denied.Text = "Access Denied!"
    end
end)
