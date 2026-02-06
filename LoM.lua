-- Library of Mysterious v0.7
-- Desenvolvido por David

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- TABELA DE TEMAS (Corrigida)
local Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(170, 170, 170),
    Button = Color3.fromRGB(40, 40, 40),
}

local ThemeObjects = {
    Accent = {},
}

-- FUNÇÃO TWEEN CENTRALIZADA
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
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
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
    mainFrame.Name = "MainFrame"
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
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = Theme.Button
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextDark
        tabButton.Font = Enum.Font.GothamMedium
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
        layout.Padding = UDim.new(0, 5)

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        end)

        local function SelectTab()
            for _, c in pairs(tabContainer:GetChildren()) do c.Visible = false end
            for _, b in pairs(tabBar:GetChildren()) do 
                if b:IsA("TextButton") then Tween(b, 0.2, {BackgroundColor3 = Theme.Button}) end 
            end
            container.Visible = true
            Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
        end
        tabButton.MouseButton1Click:Connect(SelectTab)
        if #tabContainer:GetChildren() == 1 then SelectTab() end

        local Tab = {}

        -- ELEMENTOS AQUI (Botões, Toggles, etc...)
        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = Theme.Button
            btn.Text = text
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.GothamMedium
            btn.Parent = container
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(callback)
        end

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local tFrame = Instance.new("TextButton")
            tFrame.Size = UDim2.new(1, 0, 0, 35)
            tFrame.BackgroundColor3 = Theme.Button
            tFrame.Text = ""
            tFrame.Parent = container
            Instance.new("UICorner", tFrame)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = text
            label.TextColor3 = Theme.TextDark
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tFrame

            local switch = Instance.new("Frame")
            switch.Name = "SwitchBg"
            switch.Size = UDim2.new(0, 30, 0, 16)
            switch.Position = UDim2.new(1, -40, 0.5, -8)
            switch.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)
            switch.Parent = tFrame
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)
            table.insert(ThemeObjects.Accent, switch)

            tFrame.MouseButton1Click:Connect(function()
                state = not state
                Tween(switch, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)})
                callback(state)
            end)
        end
        
        -- ADICIONE AS OUTRAS FUNÇÕES (AddSlider, AddTextBox) SEGUINDO ESTE PADRÃO
        
        return Tab
    end
    return Window
end

return Library
