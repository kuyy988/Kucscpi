-- MobileFlyUI.lua
local SPEED = 100
local BASE_POSITION = Vector3.new(0, 5, 0)
local flySpeed = 5
local flying = false
local flyDir = Vector3.new(0,0,0)

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local bgFrame = Instance.new("Frame", ScreenGui)
bgFrame.Size = UDim2.new(0, 190, 0, 350)
bgFrame.Position = UDim2.new(0, 10, 0, 80)
bgFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
bgFrame.BorderSizePixel = 0

local function createRainbowButton(parent, text, pos, size, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size
    btn.Position = pos
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0

    spawn(function()
        local t = 0
        while wait(0.05) do
            t = t + 0.01
            local r = math.sin(t*2)*127+128
            local g = math.sin(t*2 + 2)*127+128
            local b = math.sin(t*2 + 4)*127+128
            btn.BackgroundColor3 = Color3.fromRGB(r, g, b)
        end
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function speedHack()
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = SPEED
    end
end

local function toggleFly()
    flying = not flying
    local player = game.Players.LocalPlayer
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if flying then
        local bg = Instance.new("BodyGyro", hrp)
        local bv = Instance.new("BodyVelocity", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.velocity = Vector3.new(0,0,0)

        spawn(function()
            while flying do
                game:GetService("RunService").RenderStepped:Wait()
                bv.velocity = flyDir * flySpeed
            end
            hrp:FindFirstChildOfClass("BodyGyro"):Destroy()
            hrp:FindFirstChildOfClass("BodyVelocity"):Destroy()
            flyDir = Vector3.new(0,0,0)
        end)
    else
        if hrp:FindFirstChildOfClass("BodyGyro") then hrp:FindFirstChildOfClass("BodyGyro"):Destroy() end
        if hrp:FindFirstChildOfClass("BodyVelocity") then hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end
        flyDir = Vector3.new(0,0,0)
    end
end

local function setBase()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        BASE_POSITION = hrp.Position
        print("✅ Base position set to:", BASE_POSITION)
    end
end

local function goBase()
    local player = game.Players.LocalPlayer
    player.Character:MoveTo(BASE_POSITION)
end

createRainbowButton(bgFrame, "🏃 Speed", UDim2.new(0, 20, 0, 20), UDim2.new(0, 150, 0, 40), speedHack)
createRainbowButton(bgFrame, "🕊 Fly", UDim2.new(0, 20, 0, 70), UDim2.new(0, 150, 0, 40), toggleFly)
createRainbowButton(bgFrame, "📍 Set Base", UDim2.new(0, 20, 0, 120), UDim2.new(0, 150, 0, 40), setBase)
createRainbowButton(bgFrame, "🏠 Back to Base", UDim2.new(0, 20, 0, 170), UDim2.new(0, 150, 0, 40), goBase)

local controlFrame = Instance.new("Frame", ScreenGui)
controlFrame.Size = UDim2.new(0, 200, 0, 200)
controlFrame.Position = UDim2.new(1, -220, 1, -240)
controlFrame.BackgroundTransparency = 1

local function createControlButton(symbol, pos, dir)
    local btn = createRainbowButton(controlFrame, symbol, pos, UDim2.new(0, 50, 0, 50), function() end)
    btn.MouseButton1Down:Connect(function()
        flyDir = dir
    end)
    btn.MouseButton1Up:Connect(function()
        flyDir = Vector3.new(0,0,0)
    end)
end

createControlButton("⬆", UDim2.new(0.5, -25, 0, 0), Vector3.new(0, 1, 0))
createControlButton("⬇", UDim2.new(0.5, -25, 1, -50), Vector3.new(0, -1, 0))
createControlButton("⬅", UDim2.new(0, 0, 0.5, -25), Vector3.new(-1, 0, 0))
createControlButton("➡", UDim2.new(1, -50, 0.5, -25), Vector3.new(1, 0, 0))
createControlButton("🔼", UDim2.new(0.5, -25, 0.5, -75), Vector3.new(0, 0, -1))
createControlButton("🔽", UDim2.new(0.5, -25, 0.5, 25), Vector3.new(0, 0, 1))

print("✅ MobileFlyUI Loaded")