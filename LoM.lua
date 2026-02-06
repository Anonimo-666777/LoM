-- Library of Mysterious v0.6
-- Desenvolvido por David
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Correção: Adicionado o { que faltava
local Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(180, 180, 180),
    Button = Color3.fromRGB(45, 45, 45),
    ButtonHover = Color3.fromRGB(55, 55, 55)
}

local ThemeObjects = {
    Accent = {},
    Text = {},
    Buttons = {}
}

-- Função auxiliar de animação corrigida (referenciada como Tween globalmente)
local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quad), goal)
    tween:Play()
    return tween
end

function Library:SetThemeColor(color)
    Theme.Accent = color
    for _, obj in pairs(ThemeObjects.Accent) do
        if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ScrollingFrame") then
            if obj.Name == "SliderFill" or obj.Name == "Dot" or obj.Name == "SwitchBg" then
                 Tween(obj, 0.3, {BackgroundColor3 = color})
            end
        elseif obj:IsA("UIStroke") then
            Tween(obj, 0.3, {Color = color})
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
             if obj.Name == "ValueLabel" or obj.Name == "KeyLabel" or obj.Name == "SectionLabel" then
                Tween(obj, 0.3, {TextColor3 = color})
             end
        end
    end
end

local globalMainFrame = nil

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
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 80)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotifFrame.Parent = NotifHolder
    NotifFrame.BackgroundTransparency = 1
    
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Titulo
    TitleLabel.Size = UDim2.new(1, -10, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = NotifFrame
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    Tween(NotifFrame, 0.5, {BackgroundTransparency = 0})
    task.delay(Tempo, function()
        Tween(NotifFrame, 0.5, {BackgroundTransparency = 1}):Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function Library:CreateWindow(title)
    local Window = {}
    local gui = Instance.new("ScreenGui")
    gui.Name = "LibraryOfMysterious"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.fromScale(0.35, 0.45) 
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Theme.Main
    globalMainFrame = mainFrame

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Theme.Secondary
    stroke.Thickness = 1.5
    table.insert(ThemeObjects.Accent, stroke)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame

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

    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Parent = mainFrame
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.Size = UDim2.new(1, -20, 0, 35)
    tabBar.BackgroundTransparency = 1
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ScrollBarThickness = 0

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)

    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = mainFrame
    tabContainer.Position = UDim2.new(0, 10, 0, 80)
    tabContainer.Size = UDim2.new(1, -20, 1, -90)
    tabContainer.BackgroundTransparency = 1

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
        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

        local container = Instance.new("ScrollingFrame")
        container.Parent = tabContainer
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.ScrollBarThickness = 2
        container.ScrollBarImageColor3 = Theme.Accent
        
        local layout = Instance.new("UIListLayout", container)
        layout.Padding = UDim.new(0, 8)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        end)

        local function SelectTab()
            for _, t in pairs(tabContainer:GetChildren()) do if t:IsA("ScrollingFrame") then t.Visible = false end end
            container.Visible = true
            for _, b in pairs(tabBar:GetChildren()) do if b:IsA("TextButton") then Tween(b, 0.2, {BackgroundColor3 = Theme.Button}) b.TextColor3 = Theme.TextDark end end
            Tween(tabButton, 0.2, {BackgroundColor3 = Theme.Accent})
            tabButton.TextColor3 = Theme.Text
        end
        tabButton.MouseButton1Click:Connect(SelectTab)
        if #tabContainer:GetChildren() == 1 then SelectTab() end

        function Tab:AddSection(text)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Parent = container
            sectionFrame.Size = UDim2.new(1, 0, 0, 25)
            sectionFrame.BackgroundTransparency = 1

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Parent = sectionFrame
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = text:upper()
            sectionLabel.TextColor3 = Theme.Accent
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 11
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            sectionLabel.Name = "SectionLabel"
            table.insert(ThemeObjects.Accent, sectionLabel)
        end

        function Tab:AddToggle(text, default, callback)
            local state = default or false
            local toggleFrame = Instance.new("TextButton")
            toggleFrame.Parent = container
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Theme.Button
            toggleFrame.Text = ""
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 12, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = text
            toggleLabel.TextColor3 = Theme.TextDark
            toggleLabel.Font = Enum.Font.GothamMedium
            toggleLabel.TextSize = 13
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local switchBg = Instance.new("Frame")
            switchBg.Name = "SwitchBg"
            switchBg.Parent = toggleFrame
            switchBg.Size = UDim2.new(0, 34, 0, 18)
            switchBg.Position = UDim2.new(1, -42, 0.5, -9)
            switchBg.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
            table.insert(ThemeObjects.Accent, switchBg)

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
                if callback then callback(state) end
            end)
        end

        function Tab:AddSlider(config)
            local Title = config.Title or "Slider"
            local Min, Max, Default = config.Min or 0, config.Max or 100, config.Default or 0
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = container
            sliderFrame.Size = UDim2.new(1, 0, 0, 45)
            sliderFrame.BackgroundColor3 = Theme.Button
            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "ValueLabel"
            valueLabel.Parent = sliderFrame
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -60, 0, 5)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(Default)
            table.insert(ThemeObjects.Accent, valueLabel)

            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new(Default/Max, 0, 0, 4)
            sliderFill.Position = UDim2.new(0, 12, 0, 30)
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.Parent = sliderFrame
            table.insert(ThemeObjects.Accent, sliderFill)
            
            -- Lógica simplificada de arraste do slider aqui...
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
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            local optionContainer = Instance.new("Frame")
            optionContainer.Parent = dropdownFrame
            optionContainer.Position = UDim2.new(0, 5, 0, 35)
            optionContainer.Size = UDim2.new(1, -10, 0, #list * 32)
            optionContainer.BackgroundTransparency = 1
            Instance.new("UIListLayout", optionContainer).Padding = UDim.new(0, 3)

            mainBtn.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                local targetSize = Dropdown.Open and UDim2.new(1, 0, 0, 40 + optionContainer.Size.Y.Offset) or UDim2.new(1, 0, 0, 35)
                Tween(dropdownFrame, 0.3, {Size = targetSize})
                dropdownFrame.ZIndex = Dropdown.Open and 10 or 1
            end)
            
            for _, v in pairs(list) do
                local opt = Instance.new("TextButton")
                opt.Size = UDim2.new(1, 0, 0, 30)
                opt.BackgroundColor3 = Theme.Secondary
                opt.Text = v
                opt.TextColor3 = Theme.TextDark
                opt.Parent = optionContainer
                opt.MouseButton1Click:Connect(function()
                    label.Text = text .. " : " .. v
                    Dropdown.Open = false
                    Tween(dropdownFrame, 0.3, {Size = UDim2.new(1, 0, 0, 35)})
                    callback(v)
                end)
            end
        end

        function Tab:AddColorPicker(text, default, callback)
            local ColorPicker = {Value = default or Color3.fromRGB(255,255,255), Open = false}
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
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left

            mainBtn.MouseButton1Click:Connect(function()
                ColorPicker.Open = not ColorPicker.Open
                local targetSize = ColorPicker.Open and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 35)
                Tween(pickerFrame, 0.3, {Size = targetSize})
                pickerFrame.ZIndex = ColorPicker.Open and 10 or 1
            end)
            return ColorPicker
        end

        function Tab:AddKeybind(text, default, callback)
            local Keybind = {Value = default or Enum.KeyCode.F, Binding = false}
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Parent = container
            keybindFrame.Size = UDim2.new(1, 0, 0, 35)
            keybindFrame.BackgroundColor3 = Theme.Button
            Instance.new("UICorner", keybindFrame).CornerRadius = UDim.new(0, 6)

            local keyLabel = Instance.new("TextButton")
            keyLabel.Name = "KeyLabel"
            keyLabel.Parent = keybindFrame
            keyLabel.Size = UDim2.new(0, 80, 0, 24)
            keyLabel.Position = UDim2.new(1, -90, 0.5, -12)
            keyLabel.BackgroundColor3 = Theme.Secondary
            keyLabel.Text = Keybind.Value.Name
            keyLabel.TextColor3 = Theme.Accent
            table.insert(ThemeObjects.Accent, keyLabel)

            keyLabel.MouseButton1Click:Connect(function()
                Keybind.Binding = true
                keyLabel.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if Keybind.Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind.Value = input.KeyCode
                    Keybind.Binding = false
                    keyLabel.Text = input.KeyCode.Name
                    if callback then callback(input.KeyCode) end
                end
            end)
        end

        return Tab
    end
    return Window
end

return Library
