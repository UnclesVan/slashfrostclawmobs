-- Local script for the PlayerGui
local player = game:GetService("Players").LocalPlayer

-- Creating a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Creating a rounded Frame to hold the buttons and title
local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0, 300, 0, 220)  -- Increase height for the title
controlFrame.Position = UDim2.new(0, 10, 0, 10) -- Top left corner position
controlFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- Dark background color
controlFrame.BorderSizePixel = 0
controlFrame.Parent = screenGui

-- Adding rounded corners to the Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20) -- Rounded corners
uiCorner.Parent = controlFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 300, 0, 40) -- Fixed width for the title label
titleLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- Slightly lighter gray for the title background
titleLabel.Text = "slashfrostclawmobs WinterFestAdoptMe!" -- Title text
titleLabel.TextColor3 = Color3.new(1, 1, 1) -- White text color
titleLabel.Font = Enum.Font.SourceSansBold -- Bold font for emphasis
titleLabel.TextSize = 20 -- Font size for the title
titleLabel.Parent = controlFrame

-- Function to scroll the title text from left to right within the frame
local function scrollTitle()
    local frameWidth = controlFrame.Size.X.Offset
    local textWidth = titleLabel.Size.X.Offset
    
    -- Start the title off-screen to the left, adjacent to the frame
    local startPosition = -textWidth
    -- End position is off-screen to the right, past the frame
    local endPosition = frameWidth

    -- Set the initial position of the title label
    titleLabel.Position = UDim2.new(0, startPosition, 0, 5)

    while true do
        for x = startPosition, endPosition do
            titleLabel.Position = UDim2.new(0, x, 0, 5) -- Update position of title
            wait(0.01) -- Adjust the wait time for the speed of scrolling
        end
        -- Reset position after reaching the end position
        titleLabel.Position = UDim2.new(0, startPosition, 0, 5) -- Pin it back to the start
    end
end

-- Start scrolling the title text in a new thread
coroutine.wrap(scrollTitle)()

-- Creating the Close Button (Header)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50) -- Size for the close button
closeButton.Position = UDim2.new(1, -60, 0, 45) -- Adjust the position to move it down
closeButton.BackgroundColor3 = Color3.new(1, 0, 0) -- Red color
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1) -- White text
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 24
closeButton.Parent = controlFrame

-- Adding rounded corners to the Close Button
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Creating the Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.4, 0) -- Size adjusted for aesthetic
toggleButton.Position = UDim2.new(0.5, -120, 0.5, -10) -- Raise the toggle button up slightly
toggleButton.BackgroundColor3 = Color3.new(0, 0.7, 0) -- Green color
toggleButton.Text = "Start"
toggleButton.TextColor3 = Color3.new(1, 1, 1) -- White text
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.Parent = controlFrame

-- Adding rounded corners to the Toggle Button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- Functionality for the toggle button
local isActive = false -- To track if the script is running
local repeatTask -- To store the repeat loop's task

local function getButton(buttonName)
    local hotbarApp = player.PlayerGui:WaitForChild("FrostclawsRevengeHotbarApp")
    local hotbar = hotbarApp:WaitForChild("Hotbar")
    local buttonFrame = hotbar:FindFirstChild(buttonName)
    return buttonFrame and buttonFrame:FindFirstChild("Button")
end

local function triggerButton(button)
    if button then
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            connection:Fire()
        end
    else
        print("Button not found")
    end
end

local function toggleScript()
    isActive = not isActive -- Toggle state

    if isActive then
        toggleButton.Text = "Stop"
        toggleButton.BackgroundColor3 = Color3.new(0.7, 0, 0) -- Darker red when active
        
        -- Start the repeat loop
        repeatTask = game:GetService("RunService").Heartbeat:Connect(function()
            local joyBombButton = getButton("JoyBombButton")
            local swordSlashButton = getButton("SwordSlashButton")

            -- Trigger the events for each button
            triggerButton(joyBombButton)
            triggerButton(swordSlashButton)

            wait(0.1) -- Delay to avoid excessive resource usage
        end)
    else
        toggleButton.Text = "Start"
        toggleButton.BackgroundColor3 = Color3.new(0, 0.7, 0) -- Green color when inactive

        -- Stop the repeat loop
        if repeatTask then
            repeatTask:Disconnect()
            repeatTask = nil
        end
    end
end

-- Connect button click event for toggle
toggleButton.MouseButton1Click:Connect(toggleScript)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- Destroy the ScreenGui and remove it from PlayerGui
end)
