-- ServerScriptService / Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local function getOrCreate(name, className)
    local obj = ReplicatedStorage:FindFirstChild(name)
    if not obj then
        obj = Instance.new(className)
        obj.Name = name
        obj.Parent = ReplicatedStorage
    end
    return obj
end

-- Remote objects
local UnlockFunc = getOrCreate("JDH_RequestUnlock", "RemoteFunction")
local SavePosEvent = getOrCreate("JDH_SavePosition", "RemoteEvent")
local TeleportEvent = getOrCreate("JDH_TeleportToPosition", "RemoteEvent")
local GetPositionsFunc = getOrCreate("JDH_GetPositions", "RemoteFunction")

-- Settings
local PASSCODE = "yashismydaddy" -- your secret code
local positions = {} -- positions[player.UserId] = { name = Vector3 }

Players.PlayerRemoving:Connect(function(player)
    positions[player.UserId] = nil
end)

-- Check passcode
UnlockFunc.OnServerInvoke = function(player, code)
    return code == PASSCODE
end

-- Send saved positions to client
GetPositionsFunc.OnServerInvoke = function(player)
    local p = positions[player.UserId] or {}
    local out = {}
    for name, vec in pairs(p) do
        out[name] = { x = vec.X, y = vec.Y, z = vec.Z }
    end
    return out
end

-- Save current position
SavePosEvent.OnServerEvent:Connect(function(player, name)
    if not name or name == "" then return end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        positions[player.UserId] = positions[player.UserId] or {}
        positions[player.UserId][name] = char.HumanoidRootPart.Position
    end
end)

-- Teleport player
TeleportEvent.OnServerEvent:Connect(function(player, name)
    local p = positions[player.UserId]
    if not p or not p[name] then return end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(p[name])
    end
end)
