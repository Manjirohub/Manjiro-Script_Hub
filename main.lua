--// Secret Code Prompt
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

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

    -- Coordinates Display (Top Left)
    local coordGui = Instance.new("ScreenGui", CoreGui)
    coordGui.Name = "CoordGui"
    local coordLabel = Instance.new("TextLabel", coordGui)
    coordLabel.Size = UDim2.new(0, 280, 0, 30)
    coordLabel.Position = UDim2.new(0, 10, 0, 10)
    coordLabel.BackgroundTransparency = 0.3
    coordLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    coordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordLabel.Font = Enum.Font.Code
    coordLabel.TextSize = 16
    coordLabel.Text = "Coordinates: (0, 0, 0)"

    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            coordLabel.Text = string.format("Coordinates: (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
        end
    end)

    -- Minimize + Crown reopen
    local minimized = false
    local crownBtn = Instance.new("TextButton", coordGui)
    crownBtn.Size = UDim2.new(0, 40, 0, 40)
    crownBtn.Position = UDim2.new(0, 10, 0, 50)
    crownBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    crownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    crownBtn.Font = Enum.Font.GothamBold
    crownBtn.TextSize = 20
    crownBtn.Text = "👑"
    crownBtn.Visible = false

    Window:MinimizeButton(function()
        minimized = true
        crownBtn.Visible = true
        coordLabel.Visible = false
    end)

    crownBtn.MouseButton1Click:Connect(function()
        minimized = false
        crownBtn.Visible = false
        coordLabel.Visible = true
        Window:Toggle(true)
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.LeftAlt then
            if minimized then
                minimized = false
                crownBtn.Visible = false
                coordLabel.Visible = true
                Window:Toggle(true)
            else
                minimized = true
                crownBtn.Visible = true
                coordLabel.Visible = false
                Window:Toggle(false)
            end
        end
    end)

    -- Manage Positions Tab
    local ManageSection = Tabs.ManagePositions:AddSection("Save & Load")

    Tabs.ManagePositions:AddButton({
        Title = "Teleport to Noble",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1020.9, 346.7, -1322.6)
                Fluent:Notify({ Title = "Teleported", Content = "You teleported to Noble!", Duration = 5, Image = "check" })
            end
        end
    })

    Tabs.ManagePositions:AddButton({
        Title = "Teleport to Food Stall",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(608.1, 165.6, -876.4)
                Fluent:Notify({ Title = "Teleported", Content = "You teleported to Food Stall!", Duration = 5, Image = "check" })
            end
        end
    })

    -- Utilities Tab
    local UtilSection = Tabs.Utilities:AddSection("Tools")

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

    Fluent:Notify({
        Title = "Yash Daddy Hub",
        Content = "Hub loaded successfully!",
        Duration = 8,
        Image = "star"
    })
end

Submit.MouseButton1Click:Connect(function()
    if TextBox.Text == "yashismydaddy" then
        UnlockHub()
    else
        Denied.Text = "Access Denied!"
    end
end)
