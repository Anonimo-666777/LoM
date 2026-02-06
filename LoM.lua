local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Library = {
    Theme = {
        Main = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Button = Color3.fromRGB(40, 40, 40)
    },
    ThemeObjects = {},
    Presets = {
        ["Default Blue"] = {Main = Color3.fromRGB(25, 25, 25), Accent = Color3.fromRGB(0, 162, 255)},
        ["Hacker Green"] = {Main = Color3.fromRGB(5, 15, 5), Accent = Color3.fromRGB(0, 255, 70)},
        ["Vampire Red"] = {Main = Color3.fromRGB(15, 5, 5), Accent = Color3.fromRGB(255, 0, 0)}
    }
}
Library.__index = Library

-- [SISTEMA DE TEMAS - O MOTOR]
function Library:Register(obj, property, themeKey)
    if not self.ThemeObjects[themeKey] then self.ThemeObjects[themeKey] = {} end
    table.insert(self.ThemeObjects[themeKey], {Object = obj, Property = property})
    obj[property] = self.Theme[themeKey]
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

-- [MAIN WINDOW]
function Library:CreateWindow(title)
    local Window = {}
    local gui = Instance.new("ScreenGui", (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")))
    gui.Name = "MysteriousLib"

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.fromOffset(450, 300)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    Library:Register(mainFrame, "BackgroundColor3", "Main")
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = 2
    Library:Register(stroke, "Color", "Accent")

    local titleLvl = Instance.new("TextLabel", mainFrame)
    titleLvl.Size = UDim2.new(1, -20, 0, 40)
    titleLvl.Position = UDim2.fromOffset(15, 0)
    titleLvl.Text = title
    titleLvl.BackgroundTransparency = 1
    titleLvl.Font = Enum.Font.GothamBold
    titleLvl.TextXAlignment = Enum.TextXAlignment.Left
    Library:Register(titleLvl, "TextColor3", "Text")

    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Position = UDim2.fromOffset(10, 45)
    tabBar.Size = UDim2.new(1, -20, 0, 30)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = "Horizontal"
    tabLayout.Padding = UDim.new(0, 5)

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Position = UDim2.fromOffset(10, 85)
    tabContainer.Size = UDim2.new(1, -20, 1, -95)
    tabContainer.BackgroundTransparency = 1

    -- [FUNÇÃO ADD TAB]
    function Window:AddTab(name)
        local Tab = {}
        local tabBtn = Instance.new("TextButton", tabBar)
        tabBtn.Size = UDim2.fromOffset(90, 25)
        tabBtn.Text = name
        tabBtn.Font = "Gotham"
        Library:Register(tabBtn, "BackgroundColor3", "Secondary")
        Library:Register(tabBtn, "TextColor3", "Text")
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 4)

        local container = Instance.new("ScrollingFrame", tabContainer)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.ScrollBarThickness = 0
        Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabContainer:GetChildren()) do v.Visible = false end
            container.Visible = true
        end)
        if #tabContainer:GetChildren() == 1 then container.Visible = true end

        -- [WIDGET: BUTTON]
        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1, -5, 0, 35)
            btn.Text = "  " .. text
            btn.TextXAlignment = "Left"
            Library:Register(btn, "BackgroundColor3", "Button")
            Library:Register(btn, "TextColor3", "Text")
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(callback)
        end

        -- [WIDGET: TOGGLE]
        function Tab:AddToggle(text, flag, default, callback)
            local state = default or false
            local btn = Instance.new("TextButton", container)
            btn.Size = UDim2.new(1, -5, 0, 35)
            btn.Text = "  " .. text .. " : " .. tostring(state)
            btn.TextXAlignment = "Left"
            Library:Register(btn, "BackgroundColor3", "Button")
            Library:Register(btn, "TextColor3", "Text")
            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = "  " .. text .. " : " .. tostring(state)
                callback(state)
            end)
        end

        return Tab
    end

    -- [CRIAÇÃO DA ABA AUTOMÁTICA]
    local Settings = Window:AddTab("⚙️ Settings")
    for themeName, themeData in pairs(Library.Presets) do
        Settings:AddButton("Theme: " .. themeName, function()
            Library:UpdateTheme(themeData)
        end)
    end

    return Window
end

return Library
