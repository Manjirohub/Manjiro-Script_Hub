-- // Yash Daddy Hub
-- // GUI based on Manjiro Hub (Fluent UI)
-- // Features: Unlock code, Teleport, Speed, Auto Hold E, Instant E bypass

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Secret Code Prompt
local codeGui = Instance.new("ScreenGui", player.PlayerGui)
codeGui.ResetOnSpawn = false
local frame = Instance.new("Frame", codeGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0.3, 0)
textBox.Position = UDim2.new(0.1, 0, 0.25, 0)
textBox.PlaceholderText = "Enter Secret Code"
local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0.5, 0, 0.25, 0)
submit.Position = UDim2.new(0.25, 0, 0.65, 0)
submit.Text = "Unlock"

local function unlockHub()
    if textBox.Text == "yashismydaddy" then
        codeGui:Destroy()
        loadHub()
    else
        textBox.Text = "Access Denied"
    end
end
submit.MouseButton1Click:Connect(unlockHub)
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then unlockHub() end
end)

-- Actual Hub Loader
function loadHub()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Fluent/source.lua"))()

    local Window = Library:CreateWindow({
        Title = "Yash Daddy Hub",
        SubTitle = "Made Different",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftAlt
    })

    -- Tabs
    local mainTab = Window:AddTab({ Title = "Main", Icon = "home" })
    local posTab = Window:AddTab({ Title = "Set New Position", Icon = "map" })
    local miscTab = Window:AddTab({ Title = "Misc", Icon = "settings" })

    -- Teleport to Rosaline
    mainTab:AddButton({
        Title = "Teleport to Rosaline",
        Description = "Teleport to NPC Rosaline",
        Callback = function()
            local function findRosaline(obj)
                if obj:IsA("Model") and obj.Name == "Rosaline" and obj:FindFirstChild("HumanoidRootPart") then
                    return obj
                end
                for _, child in ipairs(obj:GetChildren()) do
                    local result = findRosaline(child)
                    if result then return result end
                end
                return nil
            end
            local rosaline = findRosaline(workspace)
            if rosaline then
                player.Character:PivotTo(rosaline.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            end
        end
    })

    -- WalkSpeed slider
    mainTab:AddSlider("WalkSpeed", {
        Title = "WalkSpeed",
        Default = 16,
        Min = 16,
        Max = 200,
        Callback = function(val)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = val
            end
        end
    })

    -- Auto Hold E toggle
    local autoE = false
    mainTab:AddToggle("AutoHoldE", {
        Title = "Auto Hold E",
        Default = false,
        Callback = function(state)
            autoE = state
            if state then
                task.spawn(function()
                    while autoE do
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                        task.wait(0.1)
                    end
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                end)
            end
        end
    })

    -- Instant E (ProximityPrompt bypass + auto trigger)
    local function setupPrompt(prompt)
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
            prompt.PromptShown:Connect(function()
                fireproximityprompt(prompt)
            end)
        end
    end
    for _, v in pairs(game:GetDescendants()) do
        setupPrompt(v)
    end
    game.DescendantAdded:Connect(setupPrompt)

    -- Set Position tab (empty template for future)
    posTab:AddParagraph({ Title = "Custom Save Positions", Content = "Save & load your own positions here!" })

    -- Notifications
    Library:Notify({
        Title = "Yash Daddy Hub",
        Content = "Welcome, Hub Loaded!",
        Duration = 5
    })
end
