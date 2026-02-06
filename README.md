# Library of Mysterious

Simple Roblox UI Library made By davidgames3d. 

---

## 📦 Load

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Anonimo-666777/LoM/main/LoM.lua"
))()
```
## 🖼 window

```lua
local Window = Library:CreateWindow("Title")
```

## ⏺Open/Close Window

```lua
Library:CreateToggleButton("rbxassetid://YOUR-ID-HERE")
```

## 📂Tab

```lua
local MainTab = Window:AddTab("Main")
```

## 🔘Button

```lua
MainTab:AddButton("name", function()
    print("teste de função")
end)
```

## 🎛️Toggle

```lua
MainTab:AddToggle("Name", false, function(state)
    print("Toggle:", state)
end)
```

## 🔛Slider

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

## 🔔Notification

```lua
Library:AddNotification({
    Title = "Title",
    Description = "Description",
    Time = 5,
    Icon = "rbxassetid://YOUR-ID-HERE"
})
```