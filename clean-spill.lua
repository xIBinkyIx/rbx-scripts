-- Import the ImGUI library
local ImGUI = require(script.ImGUI)

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

-- Function to draw the GUI
local function drawGUI()
    ImGUI.Begin("Part Finder")
    if ImGUI.Button("Find Part") then
        loopScript()
    end
    ImGUI.End()
end

-- Connect the GUI to the RenderStepped event
game:GetService("RunService").RenderStepped:Connect(drawGUI)
