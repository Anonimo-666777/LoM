-- Library of Mysterious
-- v0.1 - Simple UI Library
-- by David 

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

-- Configurações de Cores (Fácil de mudar depois)
local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(60, 60, 60)
}

local gui = Instance.new("ScreenGui")
gui.Name = "LibraryOfMysterious"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
-- Tamanho ajustado: 40% da largura e 50% da altura (mais equilibrado)
mainFrame.Size = UDim2.fromScale(0.4, 0.5) 
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Centraliza perfeitamente
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0

-- Limites de tamanho (Não deixa ficar nem gigante, nem nanico)
local sizeConstraint = Instance.new("UISizeConstraint", mainFrame)
sizeConstraint.MinSize = Vector2.new(350, 250)
sizeConstraint.MaxSize = Vector2.new(800, 600)

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Borda suave para profundidade
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Theme.Stroke
stroke.Thickness = 1.2
stroke.Transparency = 0.5

-- Barra de Título (TopBar)
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "  " .. (title or "Library of Mysterious") -- Espaço para não colar no canto
titleLabel.TextColor3 = Theme.Text
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Linha divisória entre título e conteúdo
local divider = Instance.new("Frame", mainFrame)
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 45)
divider.BackgroundColor3 = Theme.Stroke
divider.BorderSizePixel = 0
divider.BackgroundTransparency = 0.5

-- Container de conteúdo (Com Padding para os botões não colarem na borda)
local tabContainer = Instance.new("ScrollingFrame", mainFrame)
tabContainer.Name = "TabContainer"
tabContainer.Position = UDim2.new(0, 10, 0, 55)
tabContainer.Size = UDim2.new(1, -20, 1, -65)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Ajusta conforme adiciona itens
tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", tabContainer)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding interno para o layout
local listPadding = Instance.new("UIPadding", tabContainer)
listPadding.PaddingTop = UDim.new(0, 5)
listPadding.PaddingBottom = UDim.new(0, 5)

    -- =========================
    -- ADD TAB
    -- =========================
    function Window:AddTab(name)
        local Tab = {}

-- TAB / SECTION SYSTEM
local function createTab(name)
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name .. "Tab"
    tabFrame.Parent = tabContainer -- Aquele container que criamos na Window
    tabFrame.Size = UDim2.new(1, 0, 0, 0) -- Ocupa a largura total do container (menos o padding)
    tabFrame.AutomaticSize = Enum.AutomaticSize.Y
    tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Levemente mais claro que o fundo
    tabFrame.BorderSizePixel = 0

    local tabCorner = Instance.new("UICorner", tabFrame)
    tabCorner.CornerRadius = UDim.new(0, 6)

    -- Borda para destacar a categoria
    local tabStroke = Instance.new("UIStroke", tabFrame)
    tabStroke.Color = Color3.fromRGB(50, 50, 50)
    tabStroke.Thickness = 1
    tabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tabTitle = Instance.new("TextLabel")
    tabTitle.Parent = tabFrame
    tabTitle.Size = UDim2.new(1, -20, 0, 35) -- Altura um pouco maior para respiro
    tabTitle.Position = UDim2.new(0, 10, 0, 0)
    tabTitle.BackgroundTransparency = 1
    tabTitle.Text = name:upper() or "CATEGORY" -- Texto em Caps para parecer cabeçalho
    tabTitle.TextColor3 = Color3.fromRGB(180, 180, 180) -- Cor mais suave
    tabTitle.Font = Enum.Font.GothamBold
    tabTitle.TextSize = 12 -- Menor e Bold fica mais profissional
    tabTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Container de elementos (onde vão os botões e toggles)
    local elements = Instance.new("Frame")
    elements.Name = "ElementsContainer"
    elements.Parent = tabFrame
    elements.Position = UDim2.new(0, 10, 0, 35) -- Começa logo abaixo do título
    elements.Size = UDim2.new(1, -20, 0, 0)
    elements.AutomaticSize = Enum.AutomaticSize.Y
    elements.BackgroundTransparency = 1

    local elementsLayout = Instance.new("UIListLayout", elements)
    elementsLayout.Padding = UDim.new(0, 5)
    elementsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Padding extra no fundo para não colar na borda de baixo
    local bottomPadding = Instance.new("UIPadding", elements)
    bottomPadding.PaddingBottom = UDim.new(0, 10)

    return elements -- Retornamos o container para você dar Parent nos botões nele
end

        -- =========================
        -- ADD BUTTON
        -- =========================
local TweenService = game:GetService("TweenService")

function Tab:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Parent = elements
    button.Size = UDim2.new(1, 0, 0, 32) -- Um pouco mais alto para facilitar o clique
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = "" -- Deixamos vazio para usar uma Label separada (melhor controle)
    button.AutoButtonColor = false -- Desativamos o padrão para usar nossas animações
    button.BorderSizePixel = 0
    button.ClipsDescendants = true -- Garante que efeitos não saiam do botão

    local bCorner = Instance.new("UICorner", button)
    bCorner.CornerRadius = UDim.new(0, 6)
    
    -- Stroke sutil para o botão
    local bStroke = Instance.new("UIStroke", button)
    bStroke.Color = Color3.fromRGB(60, 60, 60)
    bStroke.Thickness = 1
    bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Texto do botão (usando Label para melhor alinhamento)
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Parent = button
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = text or "Button"
    btnLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    btnLabel.Font = Enum.Font.GothamMedium
    btnLabel.TextSize = 13

    -- Animações (Tweens)
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local hoverIn = TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
    local hoverOut = TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    local clickDown = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 30)})
    local clickUp = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 32)})

    -- Eventos
    button.MouseEnter:Connect(function()
        hoverIn:Play()
        TweenService:Create(btnLabel, info, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    button.MouseLeave:Connect(function()
        hoverOut:Play()
        TweenService:Create(btnLabel, info, {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
    end)

    button.MouseButton1Down:Connect(function()
        clickDown:Play()
    end)

    button.MouseButton1Up:Connect(function()
        clickUp:Play()
        if callback then
            -- Usamos task.spawn para o callback não travar a UI se for pesado
            task.spawn(callback)
        end
    end)
end

        -- =========================
        -- ADD TOGGLE
        -- =========================
        local TweenService = game:GetService("TweenService")

function Tab:AddToggle(text, default, callback)
    local state = default or false
    
    -- Container do Toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = text .. "Toggle"
    toggleBtn.Parent = elements
    toggleBtn.Size = UDim2.new(1, 0, 0, 32)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    
    local tCorner = Instance.new("UICorner", toggleBtn)
    tCorner.CornerRadius = UDim.new(0, 6)
    
    local tStroke = Instance.new("UIStroke", toggleBtn)
    tStroke.Color = Color3.fromRGB(60, 60, 60)
    tStroke.Thickness = 1
    tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Nome do Toggle
    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = toggleBtn
    tLabel.Size = UDim2.new(1, -50, 1, 0)
    tLabel.Position = UDim2.new(0, 10, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = text or "Toggle"
    tLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- O "Switch" (A caixinha do interruptor)
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Parent = toggleBtn
    switch.Size = UDim2.new(0, 34, 0, 18)
    switch.Position = UDim2.new(1, -44, 0.5, 0)
    switch.AnchorPoint = Vector2.new(0, 0.5)
    switch.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(80, 80, 80)
    
    local sCorner = Instance.new("UICorner", switch)
    sCorner.CornerRadius = UDim.new(1, 0) -- Deixa totalmente redondo (pílula)

    -- A Bolinha que desliza
    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Parent = switch
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local dCorner = Instance.new("UICorner", dot)
    dCorner.CornerRadius = UDim.new(1, 0)

    -- Lógica de Animação
    local function updateVisuals()
        local targetPos = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(80, 80, 80)
        
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        local textColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        TweenService:Create(tLabel, TweenInfo.new(0.2), {TextColor3 = textColor}):Play()
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        if callback then
            task.spawn(callback, state)
        end
    end)
    
    -- Efeito de Hover no botão todo
    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(tStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 100)}):Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(tStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
    end)
end

        return Tab
    end

    return Window
end

return Library