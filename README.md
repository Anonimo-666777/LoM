# Library of Mysterious

Simple Roblox UI Library made for learning and testing.

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

## Button

```lua
MainTab:AddButton("name", function()
    print("teste de função")
end)
```

## Toggle

```lua
MainTab:AddToggle("Name", false, function(state)
    print("Toggle:", state)
end)
```

## Tab

```lua
local MainTab = Window:AddTab("Main")
```