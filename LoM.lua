-- Library of Mysterious v0.5 alpha
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

local CoreGui = game:GetService("CoreGui") -- Ou PlayerGui
local TweenService = game:GetService("TweenService")

-- Criando o "suporte" das notificações no canto da tela
local ScreenNotif = Instance.new("ScreenGui")
ScreenNotif.Name = "MyLibNotifications"
ScreenNotif.Parent = CoreGui

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Parent = ScreenNotif
NotifHolder.Size = UDim2.new(0, 300, 1, 0)
NotifHolder.Position = UDim2.new(1, -310, 0, 10) -- Canto direito
NotifHolder.BackgroundTransparency = 1

-- O segredo: UIListLayout faz elas não ficarem uma em cima da outra
local Layout = Instance.new("UIListLayout")
Layout.Parent = NotifHolder
Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout.Padding = UDim.new(0, 5)

function Library:AddNotification(config)
    local Titulo = config.Title or "Aviso"
    local Desc = config.Description or ""
    local Tempo = config.Time or 5
    local Icone = config.Icon or "rbxassetid://0"

    -- Criando o Frame da Notificação
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 80)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifHolder
    NotifFrame.ClipsDescendants = true
    NotifFrame.Transparency = 1 -- Começa invisível para o Tween

    -- Arredondar cantos
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifFrame

    -- Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Titulo
    TitleLabel.Size = UDim2.new(1, -40, 0, 30)
    TitleLabel.Position = UDim2.new(0, 40, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    -- Descrição
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

    -- Ícone (se houver)
    local IconImg = Instance.new("ImageLabel")
    IconImg.Image = Icone
    IconImg.Size = UDim2.new(0, 25, 0, 25)
    IconImg.Position = UDim2.new(0, 7, 0, 7)
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = NotifFrame

    -- Som (Opcional)
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://93152995777202" -- Som de notificação padrão
    Sound.Parent = NotifFrame
    Sound:Play()

    -- Animação de Entrada
    TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

    -- Timer para Sumir
    task.delay(Tempo, function()
        local TweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        TweenOut:Play()
        TweenOut.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
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

    -- Abrir / Fechar Window
    local opened = true
    button.MouseButton1Click:Connect(function()
        opened = not opened
        mainFrame.Visible = opened
    end)

    -- Drag
    local dragging, dragStart, startPos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

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

-- BUTTON
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
        task.delay(0.1, function()
            Tween(button, 0.1, {BackgroundColor3 = Theme.Button})
        end)

        if callback then
            callback()
        end
    end)
end

-- SLIDER (ADICIONAR AQUI) 👇
function Tab:AddSlider(config)
    local Title = config.Title or "Slider"
    local Description = config.Description or ""
    local Default = config.Default or 0
    local Min = config.Min or 0
    local Max = config.Max or 100
    local Callback = config.Callback or function() end
    
    local CurrentValue = Default
    
    -- Frame principal do slider
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = container
    sliderFrame.Size = UDim2.new(1, 0, 0, Description ~= "" and 70 or 55)
    sliderFrame.BackgroundColor3 = Theme.Button
    sliderFrame.BorderSizePixel = 0
    
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
    
    -- Título
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
    
    -- Valor atual (no canto direito)
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
    
    -- Descrição (se houver)
    local yOffset = 28
    if Description ~= "" then
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = sliderFrame
        descLabel.Size = UDim2.new(1, -24, 0, 14)
        descLabel.Position = UDim2.new(0, 12, 0, 26)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = Description
        descLabel.TextColor3 = Theme.TextDark
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        yOffset = 43
    end
    
    -- Barra do slider (background)
    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = sliderFrame
    sliderBar.Size = UDim2.new(1, -24, 0, 4)
    sliderBar.Position = UDim2.new(0, 12, 0, yOffset)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBar.BorderSizePixel = 0
    
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 2)
    
    -- Preenchimento (parte colorida)
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBar
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 2)
    
    -- Bolinha (handle)
    local handle = Instance.new("Frame")
    handle.Parent = sliderBar
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.Position = UDim2.new(0, 0, 0.5, -6)
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
    
    -- Objeto retornado
    local SliderObject = {}
    
    -- Função para atualizar o valor
    function SliderObject:SetValue(newValue)
        CurrentValue = math.clamp(newValue, Min, Max)
        
        local percentage = (CurrentValue - Min) / (Max - Min)
        
        -- Atualizar visual
        Tween(sliderFill, 0.15, {Size = UDim2.new(percentage, 0, 1, 0)})
        Tween(handle, 0.15, {Position = UDim2.new(percentage, 0, 0.5, -6)})
        valueLabel.Text = tostring(math.floor(CurrentValue + 0.5))
        
        -- Callback
        if Callback then
            Callback(CurrentValue)
        end
        
        return CurrentValue
    end
    
    -- Função para pegar valor
    function SliderObject:GetValue()
        return CurrentValue
    end
    
    -- Lógica de arrastar
    local dragging = false
    
    local function updateFromInput(input)
        local barPos = sliderBar.AbsolutePosition.X
        local barSize = sliderBar.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local relativePos = math.clamp(mousePos - barPos, 0, barSize)
        local percentage = relativePos / barSize
        
        local newValue = Min + (percentage * (Max - Min))
        SliderObject:SetValue(newValue)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Setar valor inicial
    SliderObject:SetValue(Default)
    
    return SliderObject
end

        return Tab
    end

    return Window
end

return Library