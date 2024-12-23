local player = game:GetService("Players").LocalPlayer
local hotbarApp = player.PlayerGui:WaitForChild("FrostclawsRevengeHotbarApp")
local hotbar = hotbarApp:WaitForChild("Hotbar")

local function getButton(buttonName)
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
      print("notfound")
    end
end

-- Repeat loop to continuously trigger button events
repeat
    local joyBombButton = getButton("JoyBombButton")
    local swordSlashButton = getButton("SwordSlashButton")

    -- Trigger the events for each button
    triggerButton(joyBombButton)
    triggerButton(swordSlashButton)

    wait(0.1) -- Add a short delay to prevent excessive resource usage
until false -- Runs indefinitely; use a condition to exit if needed
