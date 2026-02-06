-- Library of Mysterious v0.7.2 (REFATORADA)
-- Fixes: Tab Selection, Input Management, Auto-Layout

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

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

-- Draggable Function (Adicionado para melhorar a UX)
local function MakeDraggable(gui, dragPart)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MysteriousLib"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 100
    gui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")) -- Tenta CoreGui primeiro para exploits

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.fromOffset(450, 320)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.Parent = gui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    
    MakeDraggable(mainFrame, mainFrame) -- Agora a janela é arrastável

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
    titleLabel.TextSize = 14
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

    local Window = { Tabs = 0 } -- Contador de abas

    function Window:AddTab(name)
        Window.Tabs = Window.Tabs + 1
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

        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
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
            for _, c in pairs(tabContainer:GetChildren()) do 
                if c:IsA("ScrollingFrame") then c.Visible = false end 
            end
            for _, b in pairs(tabBar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    Tween(b, 0.2, {BackgroundColor3 = Theme.Button}) 
                    b.TextColor3 = Theme.TextDark 
                end 
            end
            container.Visible = true
            Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
            tabButton.TextColor3 = Theme.Text
        end

        tabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Fix do Bug de Seleção:
        if Window.Tabs == 1 then
            SelectTab()
        end

        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = container
            btn.Size = UDim2.new(1, -10, 0, 32) -- Reduzi um pouco a largura para não bater na scrollbar
            btn.BackgroundColor3 = Theme.Button
            btn.Text = text
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", btn)
            
            btn.MouseButton1Click:Connect(function()
                Tween(btn, 0.1, {BackgroundColor3 = Theme.Secondary})
                wait(0.1)
                Tween(btn, 0.1, {BackgroundColor3 = Theme.Button})
                callback()
            end)
        end
        
        -- Aqui você continuaria com AddToggle, AddSlider etc...
        return Tab
    end
    return Window
end

return Library
