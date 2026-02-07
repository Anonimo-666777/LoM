-- [[ MYSTERIOUS LIBRARY v0.8 - FULL THEME ENGINE ]]
-- Desenvolvido por David

local Library = {
    Theme = {
        Main = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Button = Color3.fromRGB(40, 40, 40)
    },
    Registry = {}, -- Onde a mágica do rastreamento de cores acontece
    Presets = {
        ["Default Blue"] = {Main = Color3.fromRGB(25, 25, 25), Accent = Color3.fromRGB(0, 162, 255)},
        ["Matrix Green"] = {Main = Color3.fromRGB(5, 15, 5), Accent = Color3.fromRGB(0, 255, 70)},
        ["Blood Red"] = {Main = Color3.fromRGB(15, 5, 5), Accent = Color3.fromRGB(255, 0, 0)},
        ["Purple Night"] = {Main = Color3.fromRGB(15, 10, 25), Accent = Color3.fromRGB(180, 70, 255)},
        ["Light Mode"] = {Main = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 120, 215), Text = Color3.fromRGB(20, 20, 20), Button = Color3.fromRGB(200, 200, 200)}
    }
}
Library.__index = Library

local TweenService = game:GetService("TweenService")

-- [[ MOTOR DE TEMAS ]]
function Library:Register(obj, property, themeKey)
    if not self.Registry[themeKey] then self.Registry[themeKey] = {} end
    table.insert(self.Registry[themeKey], {Obj = obj, Prop = property})
    obj[property] = self.Theme[themeKey]
end

function Library:ApplyTheme(themeData)
    for key, color in pairs(themeData) do
        self.Theme[key] = color
        if self.Registry[key] then
            for _, item in pairs(self.Registry[key]) do
                if item.Obj and item.Obj.Parent then
                    TweenService:Create(item.Obj, TweenInfo.new(0.4), {[item.Prop] = color}):Play()
                end
            end
        end
    end
end

-- [[ INTERFACE PRINCIPAL ]]
function Library:CreateWindow(title)
    local Window = { Tabs = {} }
    
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "LoM_v0.8"

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.fromOffset(480, 320)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    Library:Register(mainFrame, "BackgroundColor3", "Main")
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = 1.5
    Library:Register(stroke, "Color", "Accent")

    -- Título
    local titleLvl = Instance.new("TextLabel", mainFrame)
    titleLvl.Size = UDim2.new(1, -20, 0, 40)
    titleLvl.Position = UDim2.fromOffset(15, 0)
    titleLvl.Text = title
    titleLvl.BackgroundTransparency = 1
    titleLvl.Font = Enum.Font.GothamBold
    titleLvl.TextSize = 16
    titleLvl.TextXAlignment = "Left"
    Library:Register(titleLvl, "TextColor3", "Text")

    -- Barra de Abas (Horizontal)
    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Position = UDim2.fromOffset(10, 45)
    tabBar.Size = UDim2.new(1, -20, 0, 30)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0,0,0,0)
    tabBar.AutomaticCanvasSize = "X"
    
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = "Horizontal"
    tabLayout.Padding = UDim.new(0, 5)

    -- Container onde as abas aparecem
    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Position = UDim2.fromOffset(10, 85)
    tabContainer.Size = UDim2.new(1, -20, 1, -95)
    tabContainer.BackgroundTransparency = 1

    -- [[ FUNÇÃO PARA ADICIONAR ABAS ]]
    function Window:AddTab(name)
        local Tab = {}
        
        local tabBtn = Instance.new("TextButton", tabBar)
        tabBtn.Size = UDim2.fromOffset(100, 25)
        tabBtn.Text = name
        tabBtn.Font = "GothamSemibold"
        tabBtn.TextSize = 12
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
        Library:Register(tabBtn, "BackgroundColor3", "Secondary")
        Library:Register(tabBtn, "TextColor3", "Text")

        local content = Instance.new("ScrollingFrame", tabContainer)
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.ScrollBarThickness = 2
        Library:Register(content, "ScrollBarImageColor3", "Accent")
        
        local contentLayout = Instance.new("UIListLayout", content)
        contentLayout.Padding = UDim.new(0, 6)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabContainer:GetChildren()) do v.Visible = false end
            content.Visible = true
        end)

        if #tabContainer:GetChildren() == 1 then content.Visible = true end

        -- [[ WIDGET: BOTÃO ]]
        function Tab:AddButton(txt, callback)
            local btn = Instance.new("TextButton", content)
            btn.Size = UDim2.new(1, -8, 0, 35)
            btn.Text = "  " .. txt
            btn.TextXAlignment = "Left"
            btn.Font = "Gotham"
            btn.TextSize = 13
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            Library:Register(btn, "BackgroundColor3", "Button")
            Library:Register(btn, "TextColor3", "Text")
            
            btn.MouseButton1Click:Connect(callback)
        end

        -- [[ WIDGET: TOGGLE ]]
        function Tab:AddToggle(txt, default, callback)
            local state = default or false
            local toggleBtn = Instance.new("TextButton", content)
            toggleBtn.Size = UDim2.new(1, -8, 0, 35)
            toggleBtn.Text = "  " .. txt .. (state and " : ON" or " : OFF")
            toggleBtn.TextXAlignment = "Left"
            toggleBtn.Font = "Gotham"
            toggleBtn.TextSize = 13
            Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
            Library:Register(toggleBtn, "BackgroundColor3", "Button")
            Library:Register(toggleBtn, "TextColor3", "Text")

            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                toggleBtn.Text = "  " .. txt .. (state and " : ON" or " : OFF")
                callback(state)
            end)
        end

        return Tab
    end

    -- [[ CRIAÇÃO AUTOMÁTICA DA ABA DE CONFIGURAÇÕES ]]
    local Settings = Window:AddTab("⚙️ Settings")
    
    Settings:AddButton("--- SELECIONE UM TEMA ---", function() print("Mysterious Lib") end)

    for themeName, themeData in pairs(Library.Presets) do
        Settings:AddButton("Tema: " .. themeName, function()
            Library:ApplyTheme(themeData)
        end)
    end

    return Window
end

--- TESTE DO USUÁRIO ---
-- local Win = Library:CreateWindow("Mysterious v0.8")
-- local MainTab = Win:AddTab("Principal")
-- MainTab:AddToggle("Auto Farm", false, function(v) print("Farm: ", v) end)
-- MainTab:AddButton("Destruir UI", function() game.CoreGui.LoM_v0.8:Destroy() end)

return Library
