-- Library of Mysterious v0.2
-- Desenvolvido por David
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}
Library.__index = Library

-- Tabela de Cores (Centralizada)
local Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(180, 180, 180),
    Button = Color3.fromRGB(45, 45, 45),
    ButtonHover = Color3.fromRGB(55, 55, 55)
}

-- Função auxiliar para animações
local function Tween(obj, info, goal)
    return TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad), goal):Play()
end

function Library:CreateWindow(title)
    local Window = {}

    -- GUI Base
    local gui = Instance.new("ScreenGui")
    gui.Name = "LibraryOfMysterious"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame (Tamanho Responsivo)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.fromScale(0.35, 0.45) 
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.BorderSizePixel = 0

    -- Constraints para não quebrar em telas muito pequenas ou grandes
    local sizeConstraint = Instance.new("UISizeConstraint", mainFrame)
    sizeConstraint.MinSize = Vector2.new(320, 280)
    sizeConstraint.MaxSize = Vector2.new(600, 500)

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Theme.Secondary
    stroke.Thickness = 1.5

    -- Barra de Título (Draggable)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Library of Mysterious"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Barra de Tabs
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.Position = UDim2.new(0, 10, 0, 40)
tabBar.Size = UDim2.new(1, -20, 0, 32)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)

-- Container geral das tabs
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Position = UDim2.new(0, 10, 0, 80)
tabContainer.Size = UDim2.new(1, -20, 1, -90)
tabContainer.BackgroundTransparency = 1

    -- Lógica de Arrastar
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

        -- BOTÃO
        function Window:AddTab(name)
    local Tab = {}

    -- Botão da Tab
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabBar
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Theme.Button
    tabButton.Text = name
    tabButton.TextColor3 = Theme.TextDark
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.TextSize = 13
    tabButton.AutoButtonColor = false
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    -- Frame da Tab
    local container = Instance.new("ScrollingFrame")
    container.Parent = tabContainer
    container.Size = UDim2.new(1, 0, 1, 0)
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Theme.Accent
    container.Visible = false
    container.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 8)

    -- Função de ativar tab
    local function SelectTab()
        for _, t in pairs(tabContainer:GetChildren()) do
            if t:IsA("ScrollingFrame") then
                t.Visible = false
            end
        end
        container.Visible = true

        for _, b in pairs(tabBar:GetChildren()) do
            if b:IsA("TextButton") then
                Tween(b, 0.2, {BackgroundColor3 = Theme.Button})
                b.TextColor3 = Theme.TextDark
            end
        end

        Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
        tabButton.TextColor3 = Theme.Text
    end

    tabButton.MouseButton1Click:Connect(SelectTab)

    -- Primeira tab abre sozinha
    if #tabContainer:GetChildren() == 1 then
        SelectTab()
    end

        -- TOGGLE
        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local toggleFrame = Instance.new("TextButton")
            toggleFrame.Parent = container
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Theme.Button
            toggleFrame.AutoButtonColor = false
            toggleFrame.Text = ""
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 12, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = text
            toggleLabel.TextColor3 = state and Theme.Text or Theme.TextDark
            toggleLabel.Font = Enum.Font.GothamMedium
            toggleLabel.TextSize = 13
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local switchBg = Instance.new("Frame")
            switchBg.Parent = toggleFrame
            switchBg.Size = UDim2.new(0, 34, 0, 18)
            switchBg.Position = UDim2.new(1, -42, 0.5, -9)
            switchBg.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

            local dot = Instance.new("Frame")
            dot.Parent = switchBg
            dot.Size = UDim2.new(0, 12, 0, 12)
            dot.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

            toggleFrame.MouseButton1Click:Connect(function()
                state = not state
                Tween(switchBg, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 60)})
                Tween(dot, 0.2, {Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)})
                Tween(toggleLabel, 0.2, {TextColor3 = state and Theme.Text or Theme.TextDark})
                if callback then callback(state) end
            end)
        end

        -- SLIDER
        function Tab:AddSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = container
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundColor3 = Theme.Button
            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.Size = UDim2.new(1, -20, 0, 20)
            sliderLabel.Position = UDim2.new(0, 12, 0, 5)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = text
            sliderLabel.TextColor3 = Theme.TextDark
            sliderLabel.Font = Enum.Font.GothamMedium
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -60, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default or min)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local sliderBar = Instance.new("Frame")
            sliderBar.Parent = sliderFrame
            sliderBar.Size = UDim2.new(1, -24, 0, 4)
            sliderBar.Position = UDim2.new(0, 12, 0, 32)
            sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", sliderBar)

            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBar
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", sliderFill)

            local draggingSlider = false

            local function UpdateSlider()
                local percent = math.clamp((Mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)

                valueLabel.Text = tostring(value)
                Tween(sliderFill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)})
                if callback then callback(value) end
            end

            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider()
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library