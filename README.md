# Library of Mysterious🐺

Simple Roblox UI Library made By davidgames3d. 

! [alt text](URL_da_Imagem)

---

## significado dos emojis

✅ = funcionado 100%

❓ = não se sabe ou não existe mais ou está com leve falhas/bugs

❌ = não funciona ou não existe com 100% de certeza

---

## 📦 Load✅

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Anonimo-666777/LoM/main/LoM.lua"))()
```

## Animation Intro

```lua
Library:ShowIntro({
    Name = "Título",
    Icon = "rbxassetid://seu-id-aqui",
    Duration = 4
})
```

## 🖼 window✅

```lua
local Window = Library:CreateWindow("Title")
```

## ⏺Open/Close Window✅

```lua
Library:CreateToggleButton("rbxassetid://YOUR-ID-HERE")
```

## 📂Tab✅

```lua
local MainTab = Window:AddTab("Main")
```

## 🔘Button✅

```lua
MainTab:AddButton("name", function()
    print("teste de função")
end)
```

## 🎛️Toggle✅

```lua
Tab1:AddToggle("Name", false, function()
    print("substitua pela sua função")
end)
```

## 🎚Slider✅

```lua
local Slider = Tab1:AddSlider({
    Title = "título",
    Description = "descrição",
    Min = 16,
    Max = 100,
    Default = 16,
    Step = 1,
    Callback = function(valor)
  
    end
})
```

## 📃DropDown❓

```lua
Tab1:AddDropdown("Título", {"opção 1", "opção 2", "opção 3"}, function(escolha)
    
end)
```

## 🎨Color Picker ❓

```lua
MinhaTab:AddColorPicker("Name", Color3.fromRGB(0, 162, 255), function(corSelecionada)
    print("A cor mudou para:", corSelecionada)
game.Workspace.Baseplate.BrickColor = BrickColor.new(:", corSelecionada)
end)
```

## 🔜KeyBind❓

```lua
Tab:AddKeybind("Name", Enum.KeyCode.G, function(teclaPressionada)
    print("O usuário definiu uma nova tecla: " .. teclaPressionada.Name)
    Library:AddNotification({
        Title = "Keybind Atualizado",
        Description = "nova tecla: " .. teclaPressionada.Name,
        Time = 3
    })
end)
```

## 🔔Notification✅

```lua
Library:AddNotification({
    Title = "Title",
    Description = "Description",
    Time = 5,
    Icon = "rbxassetid://YOUR-ID-HERE"
})
```