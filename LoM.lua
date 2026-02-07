-- Library of Mysterious v0.7
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

-- Variável Global para o ToggleButton funcionar
local globalMainFrame = nil

-- Função auxiliar para animações
local function Tween(obj, info, goal)
    return TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad), goal):Play()
end

local CoreGui = game:GetService("CoreGui")
local ScreenNotif = Instance.new("ScreenGui")
ScreenNotif.Name = "MyLibNotifications"
ScreenNotif.Parent = CoreGui

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Parent = ScreenNotif
NotifHolder.Size = UDim2.new(0, 300, 1, 0)
NotifHolder.Position = UDim2.new(1, -310, 0, 10)
NotifHolder.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = NotifHolder
Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout.Padding = UDim.new(0, 5)

function Library:AddNotification(config)
    local Titulo = config.Title or "Aviso"
    local Desc = config.Description or ""
    local Tempo = config.Time or 5
    local Icone = config.Icon or "rbxassetid://0"

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 80)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifHolder
    NotifFrame.ClipsDescendants = true
    NotifFrame.Transparency = 1

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Titulo
    TitleLabel.Size = UDim2.new(1, -40, 0, 30)
    TitleLabel.Position = UDim2.new(0, 40, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = Desc
    DescLabel.Size = UDim2.new(1, -45, 0, 40)
    DescLabel.Position = UDim2.new(0, 40, 0, 30)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = NotifFrame

    local IconImg = Instance.new("ImageLabel")
    IconImg.Image = Icone
    IconImg.Size = UDim2.new(0, 25, 0, 25)
    IconImg.Position = UDim2.new(0, 7, 0, 7)
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = NotifFrame

    TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

    task.delay(Tempo, function()
        local TweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenOut:Play()
        TweenOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function Library:CreateToggleButton(imageId)
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "LibraryToggleButton"
    toggleGui.ResetOnSpawn = false
    toggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local button = Instance.new("ImageButton")
    button.Parent = toggleGui
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(0, 20, 0.5, -25)
    button.BackgroundColor3 = Theme.Main
    button.Image = imageId or ""
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", button).Color = Theme.Accent

    local opened = true
    button.MouseButton1Click:Connect(function()
        if globalMainFrame then
            opened = not opened
            globalMainFrame.Visible = opened
        end
    end)

    -- Drag do Botão de Toggle
    local dragging, dragStart, startPos
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function Library:CreateWindow(title)
    local Window = {}
    local gui = Instance.new("ScreenGui")
    gui.Name = "LibraryOfMysterious"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.fromScale(0.35, 0.45) 
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.BorderSizePixel = 0
    globalMainFrame = mainFrame

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Theme.Secondary
    stroke.Thickness = 1.5

    local sizeConstraint = Instance.new("UISizeConstraint", mainFrame)
    sizeConstraint.MinSize = Vector2.new(320, 280)
    sizeConstraint.MaxSize = Vector2.new(600, 500)

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

    -- Barra de Tabs (Com Scroll Lateral)
    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Name = "TabBar"
    tabBar.Parent = mainFrame
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.Size = UDim2.new(1, -20, 0, 35)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.ScrollBarThickness = 2
    tabBar.ScrollBarImageColor3 = Theme.Accent

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = mainFrame
    tabContainer.Position = UDim2.new(0, 10, 0, 80)
    tabContainer.Size = UDim2.new(1, -20, 1, -90)
    tabContainer.BackgroundTransparency = 1

    -- Drag da Window
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

function Window:AddTab(name)
    local Tab = {}
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabBar
    tabButton.Size = UDim2.new(0, 100, 1, -4)
    tabButton.BackgroundColor3 = Theme.Button
    tabButton.Text = name
    tabButton.TextColor3 = Theme.TextDark
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.TextSize = 13
    tabButton.AutoButtonColor = false
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    local container = Instance.new("ScrollingFrame")
    container.Name = name -- ADICIONADO: Nome para identificação
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
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    local function SelectTab()
        -- Esconde TODOS os containers de tabs
        for _, child in pairs(tabContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        -- Mostra o container atual
        container.Visible = true
        
        -- Remove seleção visual de TODOS os botões
        for _, btn in pairs(tabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                Tween(btn, 0.2, {BackgroundColor3 = Theme.Button})
                btn.TextColor3 = Theme.TextDark
            end
        end
        -- Seleciona o botão atual
        Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
        tabButton.TextColor3 = Theme.Text
    end

    tabButton.MouseButton1Click:Connect(SelectTab)
    
    -- CORRIGIDO: Se é a PRIMEIRA tab, seleciona automaticamente
    local tabCount = 0
    for _ in pairs(tabContainer:GetChildren()) do tabCount = tabCount + 1 end
    if tabCount == 1 then 
        SelectTab() 
    end

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

        function Tab:AddButton(text, callback)
            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, 0, 35)
            button.BackgroundColor3 = Theme.Button
            button.AutoButtonColor = false
            button.Text = text
            button.TextColor3 = Theme.Text
            button.Font = Enum.Font.GothamMedium
            button.TextSize = 13
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            button.MouseButton1Click:Connect(function()
                Tween(button, 0.1, {BackgroundColor3 = Theme.ButtonHover})
                task.delay(0.1, function() Tween(button, 0.1, {BackgroundColor3 = Theme.Button}) end)
                if callback then callback() end
            end)
        end

        function Tab:AddSlider(config)
            local Title = config.Title or "Slider"
            local Default = config.Default or 0
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Step = config.Step or 1
            local Callback = config.Callback or function() end
            local CurrentValue = Default

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = container
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            sliderFrame.BackgroundColor3 = Theme.Button
            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Parent = sliderFrame
            titleLabel.Size = UDim2.new(1, -80, 0, 18)
            titleLabel.Position = UDim2.new(0, 12, 0, 8)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = Title
            titleLabel.TextColor3 = Theme.Text
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 13
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.Size = UDim2.new(0, 60, 0, 18)
            valueLabel.Position = UDim2.new(1, -70, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(CurrentValue)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 13
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local sliderBar = Instance.new("Frame")
            sliderBar.Parent = sliderFrame
            sliderBar.Size = UDim2.new(1, -24, 0, 4)
            sliderBar.Position = UDim2.new(0, 12, 0, 32)
            sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 2)

            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBar
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 2)

            local handle = Instance.new("Frame")
            handle.Parent = sliderBar
            handle.Size = UDim2.new(0, 12, 0, 12)
            handle.Position = UDim2.new(0, 0, 0.5, 0)
            handle.AnchorPoint = Vector2.new(0.5, 0.5)
            handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

            local SliderObject = {}
            function SliderObject:SetValue(newValue)
                local snappedValue = math.floor(((newValue - Min) / Step) + 0.5) * Step + Min
                CurrentValue = math.clamp(snappedValue, Min, Max)
                local percentage = (CurrentValue - Min) / (Max - Min)
                TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                TweenService:Create(handle, TweenInfo.new(0.1), {Position = UDim2.new(percentage, 0, 0.5, 0)}):Play()
                valueLabel.Text = string.format("%.1f", CurrentValue):gsub("%.0$", "")
                if Callback then Callback(CurrentValue) end
            end

            local dragging = false
            local function updateFromInput(input)
                local barPos = sliderBar.AbsolutePosition.X
                local barSize = sliderBar.AbsoluteSize.X
                local mousePos = input.Position.X
                local relativePos = math.clamp(mousePos - barPos, 0, barSize)
                SliderObject:SetValue(Min + ((relativePos / barSize) * (Max - Min)))
            end

            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateFromInput(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateFromInput(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)

            SliderObject:SetValue(Default)
            return SliderObject
        end

        function Tab:AddDropdown(text, list, callback)
            local Dropdown = {Open = false, Options = list or {}}
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Parent = container
            dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            dropdownFrame.BackgroundColor3 = Theme.Button
            dropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)

            local mainBtn = Instance.new("TextButton")
            mainBtn.Size = UDim2.new(1, 0, 0, 35)
            mainBtn.BackgroundTransparency = 1
            mainBtn.Text = ""
            mainBtn.Parent = dropdownFrame

            local label = Instance.new("TextLabel")
            label.Parent = mainBtn
            label.Size = UDim2.new(1, -40, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = text .. " : ..."
            label.TextColor3 = Theme.TextDark
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1

            local arrow = Instance.new("ImageLabel")
            arrow.Parent = mainBtn
            arrow.Size = UDim2.new(0, 16, 0, 16)
            arrow.Position = UDim2.new(1, -25, 0.5, -8)
            arrow.Image = "rbxassetid://6034818372"
            arrow.BackgroundTransparency = 1
            arrow.ImageColor3 = Theme.TextDark

            local optionContainer = Instance.new("Frame")
            optionContainer.Parent = dropdownFrame
            optionContainer.Position = UDim2.new(0, 5, 0, 35)
            optionContainer.Size = UDim2.new(1, -10, 0, 0)
            optionContainer.BackgroundTransparency = 1
            local layout = Instance.new("UIListLayout", optionContainer)
            layout.Padding = UDim.new(0, 3)

            local function createOption(name)
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Theme.Secondary
                optBtn.Text = name
                optBtn.TextColor3 = Theme.TextDark
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 12
                optBtn.Parent = optionContainer
                optBtn.AutoButtonColor = false
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

                optBtn.MouseButton1Click:Connect(function()
                    label.Text = text .. " : " .. name
                    Dropdown.Open = false
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    if callback then callback(name) end
                end)
            end

            for _, v in pairs(Dropdown.Options) do createOption(v) end

            -- Exemplo para o Dropdown (Aplique lógica similar ao Color Picker)
mainBtn.MouseButton1Click:Connect(function()
    Dropdown.Open = not Dropdown.Open
    
    -- Se abrir, sobe a camada IMEDIATAMENTE
    if Dropdown.Open then
        dropdownFrame.ZIndex = 100
    else
        -- Se fechar, espera a animação acabar para baixar a camada
        task.delay(0.3, function()
            if not Dropdown.Open then dropdownFrame.ZIndex = 1 end
        end)
    end

    local listSize = layout.AbsoluteContentSize.Y + 10
    local targetSize = Dropdown.Open and UDim2.new(1, 0, 0, 35 + listSize) or UDim2.new(1, 0, 0, 35)

    TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = Dropdown.Open and 180 or 0}):Play()
end)
            return Dropdown
        end

        function Tab:AddColorPicker(text, default, callback)
            local ColorPicker = {
                Value = default or Color3.fromRGB(255, 255, 255),
                Open = false
            }

            local pickerFrame = Instance.new("Frame")
            pickerFrame.Parent = container
            pickerFrame.Size = UDim2.new(1, 0, 0, 35)
            pickerFrame.BackgroundColor3 = Theme.Button
            pickerFrame.ClipsDescendants = true
            Instance.new("UICorner", pickerFrame).CornerRadius = UDim.new(0, 6)

            local mainBtn = Instance.new("TextButton")
            mainBtn.Size = UDim2.new(1, 0, 0, 35)
            mainBtn.BackgroundTransparency = 1
            mainBtn.Text = ""
            mainBtn.Parent = pickerFrame

            local label = Instance.new("TextLabel")
            label.Parent = mainBtn
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = text
            label.TextColor3 = Theme.TextDark
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1

            local colorDisplay = Instance.new("Frame")
            colorDisplay.Parent = mainBtn
            colorDisplay.Size = UDim2.new(0, 24, 0, 16)
            colorDisplay.Position = UDim2.new(1, -35, 0.5, -8)
            colorDisplay.BackgroundColor3 = ColorPicker.Value
            Instance.new("UICorner", colorDisplay).CornerRadius = UDim.new(0, 4)
            Instance.new("UIStroke", colorDisplay).Color = Color3.fromRGB(80, 80, 80)

            -- Área do Seletor (Aparece ao expandir)
            local pickerArea = Instance.new("Frame")
            pickerArea.Parent = pickerFrame
            pickerArea.Position = UDim2.new(0, 10, 0, 40)
            pickerArea.Size = UDim2.new(1, -20, 0, 120)
            pickerArea.BackgroundTransparency = 1

            -- Rainbow Saturation/Value Box
            local svBox = Instance.new("ImageLabel")
            svBox.Parent = pickerArea
            svBox.Size = UDim2.new(1, -30, 1, 0)
            svBox.Image = "rbxassetid://4155801252" -- Textura de Saturation/Value
            svBox.BackgroundColor3 = Color3.fromHSV(0, 1, 1) -- Cor base (Matiz)

            local cursor = Instance.new("Frame")
            cursor.Parent = svBox
            cursor.Size = UDim2.new(0, 6, 0, 6)
            cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", cursor).CornerRadius = UDim.new(1, 0)
            Instance.new("UIStroke", cursor).Thickness = 1

            -- Barra de Matiz (Hue) lateral
            local hueBar = Instance.new("ImageLabel")
            hueBar.Parent = pickerArea
            hueBar.Position = UDim2.new(1, -20, 0, 0)
            hueBar.Size = UDim2.new(0, 15, 1, 0)
            hueBar.Image = "rbxassetid://3641079629" -- Barra arco-íris

            local hueCursor = Instance.new("Frame")
            hueCursor.Parent = hueBar
            hueCursor.Size = UDim2.new(1, 4, 0, 2)
            hueCursor.Position = UDim2.new(0.5, 0, 0, 0)
            hueCursor.AnchorPoint = Vector2.new(0.5, 0)
            hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

            local function updateColor()
                local h = 1 - (hueCursor.Position.Y.Scale)
                local s = cursor.Position.X.Scale
                local v = 1 - cursor.Position.Y.Scale

                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                ColorPicker.Value = Color3.fromHSV(h, s, v)
                colorDisplay.BackgroundColor3 = ColorPicker.Value

                if callback then callback(ColorPicker.Value) end
            end

            -- Lógica de Input
            local draggingSV = false
            svBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = true
                end
            end)

            local draggingHue = false
            hueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local relativeX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    local relativeY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    cursor.Position = UDim2.new(relativeX, 0, relativeY, 0)
                    updateColor()
                elseif draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local relativeY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                    hueCursor.Position = UDim2.new(0.5, 0, relativeY, 0)
                    updateColor()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = false
                    draggingHue = false
                end
            end)

            -- Abrir/Fechar
            -- Exemplo para o Dropdown (Aplique lógica similar ao Color Picker)
mainBtn.MouseButton1Click:Connect(function()
    Dropdown.Open = not Dropdown.Open
    
    -- Se abrir, sobe a camada IMEDIATAMENTE
    if Dropdown.Open then
        dropdownFrame.ZIndex = 100
    else
        -- Se fechar, espera a animação acabar para baixar a camada
        task.delay(0.3, function()
            if not Dropdown.Open then dropdownFrame.ZIndex = 1 end
        end)
    end

    local listSize = layout.AbsoluteContentSize.Y + 10
    local targetSize = Dropdown.Open and UDim2.new(1, 0, 0, 35 + listSize) or UDim2.new(1, 0, 0, 35)

    TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = Dropdown.Open and 180 or 0}):Play()
end)

            return ColorPicker
        end

function Tab:AddKeybind(text, default, callback)
    local Keybind = {
        Value = default or Enum.KeyCode.F,
        Binding = false
    }

    local keybindFrame = Instance.new("Frame")
    keybindFrame.Parent = container
    keybindFrame.Size = UDim2.new(1, 0, 0, 35)
    keybindFrame.BackgroundColor3 = Theme.Button
    Instance.new("UICorner", keybindFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = keybindFrame
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = text
    label.TextColor3 = Theme.TextDark
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local keyLabel = Instance.new("TextButton")
    keyLabel.Parent = keybindFrame
    keyLabel.Size = UDim2.new(0, 60, 0, 24)
    keyLabel.Position = UDim2.new(1, -70, 0.5, -12)
    keyLabel.BackgroundColor3 = Theme.Secondary
    keyLabel.Text = Keybind.Value.Name
    keyLabel.TextColor3 = Theme.Accent
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 12
    Instance.new("UICorner", keyLabel).CornerRadius = UDim.new(0, 4)

    keyLabel.MouseButton1Click:Connect(function()
        Keybind.Binding = true
        keyLabel.Text = "..."
        keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    UserInputService.InputBegan:Connect(function(input)
        if Keybind.Binding and input.UserInputType == Enum.UserInputType.Keyboard then
            Keybind.Value = input.KeyCode
            Keybind.Binding = false
            keyLabel.Text = Keybind.Value.Name
            keyLabel.TextColor3 = Theme.Accent
            if callback then callback(Keybind.Value) end
        end
    end)

    return Keybind
end

        return Tab
    end
    return Window
end

return Library