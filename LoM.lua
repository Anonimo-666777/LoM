-- Library of Mysterious
-- v0.1 - Simple UI Library
-- by David 😈

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- =========================
-- CREATE WINDOW
-- =========================
function Library:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}

    -- GUI base
    local gui = Instance.new("ScreenGui")
    gui.Name = "LibraryOfMysterious"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.fromScale(0.35, 0.4)
    mainFrame.Position = UDim2.fromScale(0.325, 0.3)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Library of Mysterious"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18

    -- Container de tabs
    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = mainFrame
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.Size = UDim2.new(1, 0, 1, -45)
    tabContainer.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", tabContainer)
    layout.Padding = UDim.new(0, 6)

    -- =========================
    -- ADD TAB
    -- =========================
    function Window:AddTab(name)
        local Tab = {}

        local tabFrame = Instance.new("Frame")
        tabFrame.Parent = tabContainer
        tabFrame.Size = UDim2.new(1, -12, 0, 0)
        tabFrame.AutomaticSize = Enum.AutomaticSize.Y
        tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabFrame.BorderSizePixel = 0

        local tabCorner = Instance.new("UICorner", tabFrame)
        tabCorner.CornerRadius = UDim.new(0, 8)

        local tabTitle = Instance.new("TextLabel")
        tabTitle.Parent = tabFrame
        tabTitle.Size = UDim2.new(1, -10, 0, 30)
        tabTitle.Position = UDim2.new(0, 5, 0, 5)
        tabTitle.BackgroundTransparency = 1
        tabTitle.Text = name or "Tab"
        tabTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabTitle.Font = Enum.Font.GothamBold
        tabTitle.TextSize = 14
        tabTitle.TextXAlignment = Left

        local elements = Instance.new("Frame")
        elements.Parent = tabFrame
        elements.Position = UDim2.new(0, 5, 0, 40)
        elements.Size = UDim2.new(1, -10, 0, 0)
        elements.AutomaticSize = Enum.AutomaticSize.Y
        elements.BackgroundTransparency = 1

        local elementsLayout = Instance.new("UIListLayout", elements)
        elementsLayout.Padding = UDim.new(0, 6)

        -- =========================
        -- ADD BUTTON
        -- =========================
        function Tab:AddButton(text, callback)
            local button = Instance.new("TextButton")
            button.Parent = elements
            button.Size = UDim2.new(1, 0, 0, 30)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Text = text or "Button"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.Gotham
            button.TextSize = 13
            button.AutoButtonColor = true

            local bCorner = Instance.new("UICorner", button)
            bCorner.CornerRadius = UDim.new(0, 6)

            button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        end

        -- =========================
        -- ADD TOGGLE
        -- =========================
        function Tab:AddToggle(text, default, callback)
            local state = default or false

            local toggle = Instance.new("TextButton")
            toggle.Parent = elements
            toggle.Size = UDim2.new(1, 0, 0, 30)
            toggle.BackgroundColor3 = state and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(50, 50, 50)
            toggle.Text = text .. " : " .. (state and "ON" or "OFF")
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 13

            local tCorner = Instance.new("UICorner", toggle)
            tCorner.CornerRadius = UDim.new(0, 6)

            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text .. " : " .. (state and "ON" or "OFF")
                toggle.BackgroundColor3 = state and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(50, 50, 50)

                if callback then
                    callback(state)
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library