-- Library of Mysterious v0.8 (Theme Engine & Auto-Settings)
-- Desenvolvido por David
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Library = {
    Theme = {
        Main = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Button = Color3.fromRGB(45, 45, 45)
    },
    ThemeObjects = {}, -- Onde a mágica do rastreamento acontece
    Presets = {
        ["Default Blue"] = {Main = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(0, 162, 255)},
        ["Hacker Green"] = {Main = Color3.fromRGB(5, 15, 5), Accent = Color3.fromRGB(0, 255, 70)},
        ["Vampire Red"] = {Main = Color3.fromRGB(15, 5, 5), Accent = Color3.fromRGB(255, 0, 0)},
        ["Purple Night"] = {Main = Color3.fromRGB(15, 10, 25), Accent = Color3.fromRGB(180, 70, 255)},
        ["Discord"] = {Main = Color3.fromRGB(47, 49, 54), Accent = Color3.fromRGB(114, 137, 218)}
    }
}
Library.__index = Library

-- [SISTEMA DE TEMAS] --
function Library:Register(obj, property, themeKey)
    if not self.ThemeObjects[themeKey] then self.ThemeObjects[themeKey] = {} end
    table.insert(self.ThemeObjects[themeKey], {Object = obj, Property = property})
    obj[property] = self.Theme[themeKey] -- Aplica cor inicial
end

function Library:UpdateTheme(newTheme)
    for key, color in pairs(newTheme) do
        if self.Theme[key] then
            self.Theme[key] = color
            if self.ThemeObjects[key] then
                for _, data in pairs(self.ThemeObjects[key]) do
                    if data.Object and data.Object.Parent then
                        TweenService:Create(data.Object, TweenInfo.new(0.4), {[data.Property] = color}):Play()
                    end
                end
            end
        end
    end
end

-- [FUNÇÕES AUXILIARES] --
local function Tween(obj, info, goal)
    return TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad), goal):Play()
end

-- [WINDOW CREATION] --
function Library:CreateWindow(title)
    local Window = {}
    local gui = Instance.new("ScreenGui")
    gui.Name = "Mysterious_" .. math.random(100, 999)
    gui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.fromOffset(450, 300)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    Library:Register(mainFrame, "BackgroundColor3", "Main")
    
    local stroke = Instance.new("UIStroke", mainFrame)
    Library:Register(stroke, "Color", "Accent")
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    -- Barra de Título
    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundTransparency = 1

    local titleLvl = Instance.new("TextLabel", titleBar)
    titleLvl.Size = UDim2.new(1, -15, 1, 0)
    titleLvl.Position = UDim2.new(0, 15, 0, 0)
    titleLvl.Text = title
    titleLvl.BackgroundTransparency = 1
    titleLvl.Font = Enum.Font.GothamBold
    titleLvl.TextXAlignment = Enum.TextXAlignment.Left
    Library:Register(titleLvl, "TextColor3", "Text")

    -- Container de Tabs
    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.Size = UDim2.new(1, -20, 0, 30)
    tabBar.BackgroundTransparency = 1
    tabBar.CanvasSize = UDim2.new(0,0,0,0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollBarThickness = 0
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Position = UDim2.new(0, 10, 0, 75)
    tabContainer.Size = UDim2.new(1, -20, 1, -85)
    tabContainer.BackgroundTransparency = 1

    -- [FUNÇÃO ADD TAB] --
    function Window:AddTab(name)
        local Tab = {}
        local tabBtn = Instance.new("TextButton", tabBar)
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 12
        Library:Register(tabBtn, "BackgroundColor3", "Secondary")
        Library:Register(tabBtn, "TextColor3", "Text")
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local container = Instance.new("ScrollingFrame", tabContainer)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.ScrollBarThickness = 2
        Library:Register(container, "ScrollBarImageColor3", "Accent")
        
        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 5)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabContainer:GetChildren()) do v.Visible = false end
            container.Visible = true
        end)
        if #tabContainer:GetChildren() == 1 then container.Visible = true end

        -- Exemplo de Widget: Botão Registrado
        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1, -5, 0, 35)
            btn.Text = text
            Library:Register(btn, "BackgroundColor3", "Button")
            Library:Register(btn, "TextColor3", "Text")
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(callback)
        end
        
        -- Aqui você adicionaria os outros (Toggle, Slider) seguindo o Library:Register
        return Tab
    end

    -- [CRIAÇÃO AUTOMÁTICA DA ABA SETTINGS] --
    local SettingsTab = Window:AddTab("⚙️ Settings")
    
    SettingsTab:AddButton("Reset Theme", function()
        Library:UpdateTheme(Library.Presets["Default Blue"])
    end)

    -- Dropdown de Temas (Usando AddButton como exemplo rápido)
    for themeName, themeData in pairs(Library.Presets) do
        SettingsTab:AddButton("Theme: " .. themeName, function()
            Library:UpdateTheme(themeData)
        end)
    end

    SettingsTab:AddButton("Destroy UI", function() gui:Destroy() end)

    return Window
end

return Library
