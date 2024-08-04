-- Configuration
local partNamePrefix = "MyPart" -- Change this to the prefix of the part names you want to find
local activationKey = Enum.KeyCode.E -- Change this to the key you want to press to activate the part

-- Function to find the next part
local function findNextPart()
    local parts = game.Workspace:GetDescendants()
    local matchingParts = {}
    for _, part in pairs(parts) do
        if part.Name:sub(1, #partNamePrefix) == partNamePrefix then
            table.insert(matchingParts, part)
        end
    end
    return matchingParts
end

-- Function to loop the script
local function loopScript()
    -- Find the next part
    local parts = findNextPart()
    if #parts == 0 then
        print("No more parts to find")
        return
    end

    -- Get the next part
    local part = parts[1]
    table.remove(parts, 1)

    -- Check if the part exists
    if not part or not part.Parent then
        warn("Part does not exist")
        return
    end

    -- Walk to the part
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then
        warn("Humanoid does not exist")
        return
    end
    humanoid:MoveTo(part.Position)
    humanoid.MoveToFinished:Wait()

    -- Press the activation key
    game:GetService("UserInputService"):SimulateInput(activationKey, true)
    wait(0.1) -- Hold the key for a bit
    game:GetService("UserInputService"):SimulateInput(activationKey, false)

    -- Wait 10 seconds
    local startTime = tick()
    while tick() - startTime < 10 do
        wait(0.1)
    end
end

-- Create the UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.StarterGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundTransparency = 0.5
Frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0.5, -50, 0.5, -25)
Button.Text = "Find Part"
Button.Font = Enum.Font.SourceSans
Button.FontSize = Enum.FontSize.Size24
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundTransparency = 0.5
Button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Button.Parent = Frame

-- Connect the button to the loopScript function
Button.MouseButton1Click:Connect(loopScript)
