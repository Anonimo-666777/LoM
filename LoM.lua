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

            function Window:AddTab(name)
        local Tab = {}
        
        -- O Botão na barra superior
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton"
        tabButton.Parent = tabBar
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = Theme.Button
        tabButton.Text = name
        tabButton.TextColor3 = Theme.TextDark
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 12
        Instance.new("UICorner", tabButton)

        -- O Container que guarda os botões desta Tab
        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
        container.Parent = tabContainer -- IMPORTANTE: Deve estar dentro do tabContainer da Window
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false -- Começa invisível
        container.ScrollBarThickness = 2
        container.ScrollBarImageColor3 = Theme.Accent
        container.BorderSizePixel = 0
        
        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 7)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Padding para os botões não colarem na borda
        local padding = Instance.new("UIPadding", container)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        padding.PaddingTop = UDim.new(0, 5)

        -- Função para trocar de Tab
        local function SelectTab()
            -- Esconde todas as outras
            for _, child in pairs(tabContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, btn in pairs(tabBar:GetChildren()) do
                if btn:IsA("TextButton") then 
                    Tween(btn, 0.2, {BackgroundColor3 = Theme.Button})
                    btn.TextColor3 = Theme.TextDark
                end
            end
            -- Mostra esta
            container.Visible = true
            Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
            tabButton.TextColor3 = Theme.Text
        end

        tabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Se for a primeira tab, já deixa aberta
        if #tabBar:GetChildren() == 1 then
            task.spawn(SelectTab)
        end

        -- IMPORTANTE: Todas as funções (AddButton, etc) devem usar esse 'container'
        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = container -- AQUI ESTAVA O ERRO! Tinha que ser este container.
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = Theme.Button
            btn.Text = text
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 13
            Instance.new("UICorner", btn)
            
            btn.MouseButton1Click:Connect(function()
                Tween(btn, 0.1, {BackgroundColor3 = Theme.Secondary})
                task.delay(0.1, function() Tween(btn, 0.1, {BackgroundColor3 = Theme.Button}) end)
                callback()
            end)
        end
        
                -- SLIDER REVISADO
        function Tab:AddSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "Slider_" .. text
            sliderFrame.Parent = container -- ONDE A MÁGICA ACONTECE
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
            label.Font = Enum.Font.Gotham

            local valLabel = Instance.new("TextLabel")
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
                local mousePos = UserInputService:GetMouseLocation().X
                local percent = math.clamp((mousePos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                valLabel.Text = tostring(value)
                callback(value)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
            end)
        end

        -- DROPDOWN REVISADO
        function Tab:AddDropdown(text, options, callback)
            local dropFrame = Instance.new("Frame")
            dropFrame.Parent = container
            dropFrame.Size = UDim2.new(1, 0, 0, 32)
            dropFrame.BackgroundColor3 = Theme.Button
            dropFrame.ClipsDescendants = true
            Instance.new("UICorner", dropFrame)

            local btn = Instance.new("TextButton")
            btn.Parent = dropFrame
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundTransparency = 1
            btn.Text = text .. " : ..."
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.GothamMedium

            local optionHolder = Instance.new("Frame")
            optionHolder.Parent = dropFrame
            optionHolder.Size = UDim2.new(1, -10, 0, 0)
            optionHolder.Position = UDim2.new(0, 5, 0, 35)
            optionHolder.BackgroundTransparency = 1
            local layout = Instance.new("UIListLayout", optionHolder)
            layout.Padding = UDim.new(0, 3)

            local open = false
            btn.MouseButton1Click:Connect(function()
                open = not open
                local targetSize = open and (35 + layout.AbsoluteContentSize.Y + 5) or 32
                Tween(dropFrame, 0.3, {Size = UDim2.new(1, 0, 0, targetSize)})
            end)

            for _, opt in pairs(options) do
                local oBtn = Instance.new("TextButton")
                oBtn.Parent = optionHolder
                oBtn.Size = UDim2.new(1, 0, 0, 25)
                oBtn.BackgroundColor3 = Theme.Secondary
                oBtn.Text = opt
                oBtn.TextColor3 = Theme.TextDark
                Instance.new("UICorner", oBtn)
                oBtn.MouseButton1Click:Connect(function()
                    btn.Text = text .. " : " .. opt
                    open = false
                    Tween(dropFrame, 0.3, {Size = UDim2.new(1, 0, 0, 32)})
                    callback(opt)
                end)
            end
        end

        -- COLOR PICKER REVISADO
        function Tab:AddColorPicker(text, default, callback)
            local cpFrame = Instance.new("Frame")
            cpFrame.Parent = container
            cpFrame.Size = UDim2.new(1, 0, 0, 32)
            cpFrame.BackgroundColor3 = Theme.Button
            cpFrame.ClipsDescendants = true
            Instance.new("UICorner", cpFrame)

            local btn = Instance.new("TextButton")
            btn.Parent = cpFrame
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. text
            btn.TextColor3 = Theme.Text
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.GothamMedium

            local preview = Instance.new("Frame")
            preview.Parent = btn
            preview.Size = UDim2.new(0, 20, 0, 15)
            preview.Position = UDim2.new(1, -30, 0.5, -7)
            preview.BackgroundColor3 = default
            Instance.new("UICorner", preview)

            local pickerImage = Instance.new("ImageButton")
            pickerImage.Parent = cpFrame
            pickerImage.Size = UDim2.new(1, -20, 0, 80)
            pickerImage.Position = UDim2.new(0, 10, 0, 35)
            pickerImage.Image = "rbxassetid://4155801252"
            
            local open = false
            btn.MouseButton1Click:Connect(function()
                open = not open
                Tween(cpFrame, 0.3, {Size = UDim2.new(1, 0, 0, open and 125 or 32)})
            end)

            pickerImage.MouseButton1Click:Connect(function()
                -- Lógica básica de clique (pode ser expandida para movimento)
                local x = math.clamp((UserInputService:GetMouseLocation().X - pickerImage.AbsolutePosition.X) / pickerImage.AbsoluteSize.X, 0, 1)
                local color = Color3.fromHSV(x, 1, 1)
                preview.BackgroundColor3 = color
                callback(color)
            end)
        end

        
        return Tab
    end
        
    return Window
end

return Library
