-- Library of Mysterious v0.7.1 (FINAL FIX)
-- Desenvolvido por David

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    Button = Color3.fromRGB(40, 40, 40),
}

local ThemeObjects = { Accent = {} }

local function Tween(obj, time, goal)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

function Library:SetThemeColor(color)
    Theme.Accent = color
    for _, obj in pairs(ThemeObjects.Accent) do
        if obj:IsA("Frame") or obj:IsA("TextButton") then
            if obj.Name == "SliderFill" or obj.Name == "SwitchBg" or obj.Name == "TabButton" then
                Tween(obj, 0.3, {BackgroundColor3 = color})
            end
        elseif obj:IsA("UIStroke") then
            Tween(obj, 0.3, {Color = color})
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.Name == "ValueLabel" or obj.Name == "KeyLabel" or obj.Name == "SectionLabel" then
                Tween(obj, 0.3, {TextColor3 = color})
            end
        end
    end
end

function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MysteriousLib"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(450, 320)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.Parent = gui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.5
    table.insert(ThemeObjects.Accent, stroke)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 35)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Text = title or "Library of Mysterious"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame

    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Size = UDim2.new(1, -20, 0, 30)
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0,0,0,0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.Parent = mainFrame
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 1, -85)
    tabContainer.Position = UDim2.new(0, 10, 0, 75)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local Window = {}

    function Window:AddTab(name)
        local Tab = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = Theme.Button
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextDark
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabBar
        Instance.new("UICorner", tabButton)
        table.insert(ThemeObjects.Accent, tabButton)

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.ScrollBarThickness = 2
        container.ScrollBarImageColor3 = Theme.Accent
        container.Parent = tabContainer
        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 7)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)

        local function SelectTab()
            for _, c in pairs(tabContainer:GetChildren()) do if c:IsA("ScrollingFrame") then c.Visible = false end end
            for _, b in pairs(tabBar:GetChildren()) do if b:IsA("TextButton") then Tween(b, 0.2, {BackgroundColor3 = Theme.Button}) b.TextColor3 = Theme.TextDark end end
            container.Visible = true
            Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
            tabButton.TextColor3 = Theme.Text
        end
        tabButton.MouseButton1Click:Connect(SelectTab)
        if #tabBar:GetChildren() == 1 then SelectTab() end

        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = container
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = Theme.Button
            btn.Text = text
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(callback)
        end

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local tFrame = Instance.new("TextButton")
            tFrame.Parent = container
            tFrame.Size = UDim2.new(1, 0, 0, 35)
            tFrame.BackgroundColor3 = Theme.Button
            tFrame.Text = ""
            Instance.new("UICorner", tFrame)

            local label = Instance.new("TextLabel")
            label.Parent = tFrame
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = text
            label.TextColor3 = Theme.TextDark
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            local switch = Instance.new("Frame")
            switch.Name = "SwitchBg"
            switch.Parent = tFrame
            switch.Size = UDim2.new(0, 30, 0, 16)
            switch.Position = UDim2.new(1, -40, 0.5, -8)
            switch.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)
            table.insert(ThemeObjects.Accent, switch)

            tFrame.MouseButton1Click:Connect(function()
                state = not state
                Tween(switch, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)})
                callback(state)
            end)
        end

        function Tab:AddSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = container
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundColor3 = Theme.Button
            Instance.new("UICorner", sliderFrame)

            local label = Instance.new("TextLabel")
            label.Parent = sliderFrame
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 5)
            label.Text = text
            label.TextColor3 = Theme.Text
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            local valLabel = Instance.new("TextLabel")
            valLabel.Name = "ValueLabel"
            valLabel.Parent = sliderFrame
            valLabel.Size = UDim2.new(0, 40, 0, 20)
            valLabel.Position = UDim2.new(1, -50, 0, 5)
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = Theme.Accent
            valLabel.BackgroundTransparency = 1
            table.insert(ThemeObjects.Accent, valLabel)

            local bar = Instance.new("Frame")
            bar.Parent = sliderFrame
            bar.Size = UDim2.new(1, -24, 0, 4)
            bar.Position = UDim2.new(0, 12, 0, 32)
            bar.BackgroundColor3 = Theme.Secondary
            Instance.new("UICorner", bar)

            local fill = Instance.new("Frame")
            fill.Name = "SliderFill"
            fill.Parent = bar
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", fill)
            table.insert(ThemeObjects.Accent, fill)

            local dragging = false
            local function update()
                local percent = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                valLabel.Text = tostring(value)
                callback(value)
            end

            bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
        end

        return Tab
    end
    return Window
end

return Library