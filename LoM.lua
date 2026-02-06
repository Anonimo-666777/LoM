-- Library of Mysterious v0.7 (Com Config System)
-- Desenvolvido por David
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- Necessário para JSON
local LocalPlayer = Players.LocalPlayer

local Library = {
    Config = {},
    Flags = {}, -- Onde guardamos os valores para salvar
    Theme = {
        Main = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(180, 180, 180),
        Button = Color3.fromRGB(45, 45, 45),
        ButtonHover = Color3.fromRGB(55, 55, 55)
    }
}
Library.__index = Library

-- Pastas para salvar os arquivos
local FOLDER_NAME = "MysteriousConfigs"
if not isfolder(FOLDER_NAME) then makefolder(FOLDER_NAME) end

-- Funções de Sistema de Arquivos
function Library:SaveConfig(name)
    local fileName = FOLDER_NAME .. "/" .. name .. ".json"
    local data = {}
    
    for flag, value in pairs(self.Flags) do
        if typeof(value) == "Color3" then
            data[flag] = {value.r, value.g, value.b} -- Converte cor para tabela
        elseif typeof(value) == "EnumItem" then
            data[flag] = tostring(value) -- Converte KeyCode para string
        else
            data[flag] = value
        end
    end
    
    writefile(fileName, HttpService:JSONEncode(data))
    self:AddNotification({Title = "Config", Description = "Configurações salvas!", Time = 3})
end

function Library:LoadConfig(name)
    local fileName = FOLDER_NAME .. "/" .. name .. ".json"
    if isfile(fileName) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
        if success then
            self.Flags = decoded
            self:AddNotification({Title = "Config", Description = "Configurações carregadas!", Time = 3})
            -- Nota: Para a UI atualizar visualmente, precisaríamos de uma lógica de Refresh
            return decoded
        end
    end
end

-- [As funções de Notificação e Tween continuam aqui igual à sua v0.6...]
-- (Vou pular para as mudanças nos widgets para o texto não ficar gigante)

function Library:CreateWindow(title)
    local Window = {}
    -- ... (Código do CreateWindow) ...

    function Window:AddToggle(text, flag, default, callback)
        -- Usamos 'flag' como a chave única para salvar essa config
        Library.Flags[flag] = default or false
        
        -- (Código da UI do Toggle...)
        
        -- No clique do Toggle:
        -- toggleFrame.MouseButton1Click:Connect(function()
        --     state = not state
        --     Library.Flags[flag] = state -- Salva o estado atual
        --     if callback then callback(state) end
        -- end)
    end

    function Window:AddSlider(text, flag, min, max, default, callback)
        Library.Flags[flag] = default or min
        
        -- No update do Slider:
        -- Library.Flags[flag] = value
        -- if callback then callback(value) end
    end

    return Window
end
