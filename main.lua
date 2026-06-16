-- FORSAKEN BY ELPRIMO228RB - RAYFIELD GUI (С РАБОЧИМИ ТЕМАМИ)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ПЛАВАЮЩАЯ КНОПКА ДЛЯ ТЕЛЕФОНА
local floatingBtn = Instance.new("ImageButton")
floatingBtn.Size = UDim2.new(0, 60, 0, 60)
floatingBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
floatingBtn.BackgroundTransparency = 0.15
floatingBtn.Image = "rbxassetid://7641916668"
floatingBtn.ScaleType = Enum.ScaleType.Fit
floatingBtn.Parent = game:GetService("CoreGui")
floatingBtn.ZIndex = 1000

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

-- ПЕРЕТАСКИВАНИЕ ПЛАВАЮЩЕЙ КНОПКИ
local dragActive = false
local dragStart = Vector2.new()
local dragStartPos = UDim2.new()

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = true
        dragStart = input.Position
        dragStartPos = floatingBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragActive and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        local scrSize = game:GetService("CoreGui").AbsoluteSize
        local btnSize = floatingBtn.AbsoluteSize
        floatingBtn.Position = UDim2.new(0, math.clamp(dragStartPos.X.Offset + delta.X, 0, scrSize.X - btnSize.X), 0, math.clamp(dragStartPos.Y.Offset + delta.Y, 0, scrSize.Y - btnSize.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = false
    end
end)

-- ОТКРЫТИЕ/ЗАКРЫТИЕ ОКНА
local windowVisible = true

floatingBtn.MouseButton1Click:Connect(function()
    windowVisible = not windowVisible
    if windowVisible then
        Rayfield:ToggleVisibility(true)
    else
        Rayfield:ToggleVisibility(false)
    end
end)

-- ========== ТЕМЫ (РАБОЧИЕ) ==========
local function applyTheme(themeType)
    if themeType == "Nya" then
        -- РОЗОВАЯ ТЕМА
        pcall(function()
            -- Меняем стиль Rayfield
            Rayfield:ModifyTheme("Default")
            -- Меняем плавающую кнопку
            floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 180)
            floatingBtn.Image = "rbxassetid://7641916668"
            -- Меняем фон окна через стили (если есть)
            Rayfield:SetWindowName("🌸 NYA BY ELPRIMO228RB 🌸")
        end)
        Rayfield:Notify({
            Title = "🌸 ТЕМА СМЕНЕНА",
            Content = "НЯШНЫЙ РЕЖИМ АКТИВИРОВАН!",
            Duration = 2,
            Image = 0
        })
    elseif themeType == "Lava" then
        -- ЛАВОВАЯ ТЕМА (как в Bobby Hub)
        pcall(function()
            Rayfield:ModifyTheme("AmberGlow")
            floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            floatingBtn.Image = "rbxassetid://7641916668"
            Rayfield:SetWindowName("🔥 LAVA BY ELPRIMO228RB 🔥")
        end)
        Rayfield:Notify({
            Title = "🔥 ТЕМА СМЕНЕНА",
            Content = "ЛАВОВЫЙ РЕЖИМ АКТИВИРОВАН!",
            Duration = 2,
            Image = 0
        })
    else
        -- СТАНДАРТНАЯ ТЕМА
        pcall(function()
            Rayfield:ModifyTheme("Default")
            floatingBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            floatingBtn.Image = "rbxassetid://7641916668"
            Rayfield:SetWindowName("FORSAKEN BY ELPRIMO228RB")
        end)
        Rayfield:Notify({
            Title = "💠 ТЕМА СМЕНЕНА",
            Content = "СТАНДАРТНАЯ ТЕМА АКТИВИРОВАНА",
            Duration = 2,
            Image = 0
        })
    end
end

local Window = Rayfield:CreateWindow({
    Name = "FORSAKEN BY ELPRIMO228RB",
    LoadingTitle = "FORSAKEN ELPRIMO228RB",
    LoadingSubtitle = "by ELPRIMO228RB",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "ELPRIMO228RB_HUB",
       FileName = "Settings"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Key System",
       Subtitle = "Key System",
       Note = "No key required",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"key"}
    }
})

-- ========== ПЕРЕМЕННЫЕ ==========
local tpwalkActive = false
local tpwalkConn = nil
local tpwalkSpeed = 0.15

local espEnabled = false
local espThread = nil
local espHighlights = {}

local autoGenEnabled = false
local autoGenLoop = nil

local aimEnabled = false
local aimConn = nil
local aimRadius = 150

-- ПЕРЕМЕННЫЕ ДЛЯ ПОДСВЕТКИ ПРЕДМЕТОВ
local itemsEspEnabled = false
local itemsEspThread = nil
local itemsHighlights = {}

-- ПЕРЕМЕННЫЕ ДЛЯ ПОКАЗА ЗДОРОВЬЯ
local healthShowEnabled = false
local healthThread = nil
local healthBillboards = {}

-- ========== ВКЛАДКА ИГРОК ==========
local PlayerTab = Window:CreateTab("ИГРОК")

local PlayerSection = PlayerTab:CreateSection("TPWALK")

local TpwalkToggle = PlayerTab:CreateToggle({
    Name = "TPWALK",
    CurrentValue = false,
    Flag = "TpwalkToggle",
    Callback = function(Value)
        tpwalkActive = Value
        if tpwalkActive then
            if tpwalkConn then tpwalkConn:Disconnect() end
            tpwalkConn = RunService.RenderStepped:Connect(function()
                if not tpwalkActive then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                local dir = hum.MoveDirection
                if dir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (dir * tpwalkSpeed)
                end
            end)
        else
            if tpwalkConn then tpwalkConn:Disconnect() end
            tpwalkConn = nil
        end
    end
})

local TpwalkSlider = PlayerTab:CreateSlider({
    Name = "СКОРОСТЬ TPWALK",
    Range = {5, 35},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 15,
    Flag = "TpwalkSpeed",
    Callback = function(Value)
        tpwalkSpeed = Value / 100
    end
})

-- ========== ВКЛАДКА ВИЗУАЛ ==========
local VisualTab = Window:CreateTab("ВИЗУАЛ")

local VisualSection = VisualTab:CreateSection("ESP ИГРОКОВ")

local function clearESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
end

local function createHighlight(obj, outlineColor, fillColor)
    for _, h in pairs(obj:GetChildren()) do
        if h:IsA("Highlight") then h:Destroy() end
    end
    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.FillTransparency = 0.75
    h.FillColor = fillColor
    h.OutlineColor = outlineColor
    h.OutlineTransparency = 0
    table.insert(espHighlights, h)
    return h
end

local function updateESP()
    if not espEnabled then
        clearESP()
        return
    end
    
    clearESP()
    
    local playersFolder = workspace:FindFirstChild("Players")
    if playersFolder then
        local killers = playersFolder:FindFirstChild("Killers")
        if killers then
            for _, obj in pairs(killers:GetChildren()) do
                if obj:IsA("Model") then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and obj:FindFirstChild("HumanoidRootPart") and hum.Health > 0 then
                        local hasHighlight = false
                        for _, h in pairs(obj:GetChildren()) do
                            if h:IsA("Highlight") then hasHighlight = true end
                        end
                        if not hasHighlight then
                            createHighlight(obj, Color3.new(1, 0, 0), Color3.new(1, 0.5, 0.5))
                        end
                    end
                end
            end
        end
        
        local survivors = playersFolder:FindFirstChild("Survivors")
        if survivors then
            for _, obj in pairs(survivors:GetChildren()) do
                if obj:IsA("Model") then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and obj:FindFirstChild("HumanoidRootPart") and hum.Health > 0 then
                        local hasHighlight = false
                        for _, h in pairs(obj:GetChildren()) do
                            if h:IsA("Highlight") then hasHighlight = true end
                        end
                        if not hasHighlight then
                            createHighlight(obj, Color3.new(0, 1, 0), Color3.new(0.5, 1, 0.5))
                        end
                    end
                end
            end
        end
    end
    
    local map = workspace:FindFirstChild("Map")
    if map then
        local ingame = map:FindFirstChild("Ingame")
        if ingame then
            local m = ingame:FindFirstChild("Map")
            if m then
                for _, obj in pairs(m:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == "Generator" then
                        local hasHighlight = false
                        for _, h in pairs(obj:GetChildren()) do
                            if h:IsA("Highlight") then hasHighlight = true end
                        end
                        if not hasHighlight then
                            createHighlight(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
                        end
                    end
                end
            end
        end
    end
end

local EspToggle = VisualTab:CreateToggle({
    Name = "ESP ИГРОКОВ",
    CurrentValue = false,
    Flag = "EspToggle",
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            updateESP()
            if espThread then espThread:Disconnect() end
            espThread = RunService.Heartbeat:Connect(function()
                if espEnabled then updateESP() end
            end)
        else
            if espThread then espThread:Disconnect() end
            clearESP()
        end
    end
})

-- ========== ПОДСВЕТКА ПРЕДМЕТОВ ==========
local ItemsSection = VisualTab:CreateSection("ПОДСВЕТКА ПРЕДМЕТОВ")

local function clearItemsESP()
    for _, h in pairs(itemsHighlights) do
        pcall(function() h:Destroy() end)
    end
    itemsHighlights = {}
end

local function createItemHighlight(obj, outlineColor, fillColor)
    for _, h in pairs(obj:GetChildren()) do
        if h:IsA("Highlight") then h:Destroy() end
    end
    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.FillTransparency = 0.75
    h.FillColor = fillColor
    h.OutlineColor = outlineColor
    h.OutlineTransparency = 0
    table.insert(itemsHighlights, h)
    return h
end

local function updateItemsESP()
    if not itemsEspEnabled then
        clearItemsESP()
        return
    end
    
    clearItemsESP()
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj.Name == "BloxyCola" then
                createItemHighlight(obj, Color3.fromRGB(204, 153, 0), Color3.fromRGB(204, 153, 0))
            elseif obj.Name == "Medkit" then
                createItemHighlight(obj, Color3.fromRGB(128, 0, 128), Color3.fromRGB(128, 0, 128))
            elseif obj.Name == "SubspaceTripmine" then
                local wp = workspace:FindFirstChild("Players")
                local isSurvivorPlaced = false
                if wp then
                    local survivors = wp:FindFirstChild("Survivors")
                    if survivors and obj:IsDescendantOf(survivors) then
                        isSurvivorPlaced = true
                    end
                end
                if not isSurvivorPlaced then
                    createItemHighlight(obj, Color3.fromRGB(0, 191, 255), Color3.fromRGB(0, 191, 255))
                end
            end
        end
    end
end

local ItemsEspToggle = VisualTab:CreateToggle({
    Name = "ПОДСВЕТКА ПРЕДМЕТОВ",
    CurrentValue = false,
    Flag = "ItemsEspToggle",
    Callback = function(Value)
        itemsEspEnabled = Value
        if itemsEspEnabled then
            updateItemsESP()
            if itemsEspThread then itemsEspThread:Disconnect() end
            itemsEspThread = RunService.Heartbeat:Connect(function()
                if itemsEspEnabled then updateItemsESP() end
            end)
        else
            if itemsEspThread then itemsEspThread:Disconnect() end
            clearItemsESP()
        end
    end
})

-- ========== ПОКАЗ ЗДОРОВЬЯ ==========
local HealthSection = VisualTab:CreateSection("ПОКАЗ ЗДОРОВЬЯ")

local function clearHealthBillboards()
    for _, billboard in pairs(healthBillboards) do
        pcall(function() billboard:Destroy() end)
    end
    healthBillboards = {}
end

local function createHealthBillboard(player)
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    for _, b in pairs(healthBillboards) do
        if b and b.Parent == head then
            return b
        end
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HealthESP"
    billboard.Size = UDim2.new(0, 100, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = math.huge
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = head
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Antique
    healthLabel.Text = ""
    healthLabel.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Antique
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Parent = billboard
    
    table.insert(healthBillboards, billboard)
    return billboard
end

local function updateHealthBillboards()
    if not healthShowEnabled then
        clearHealthBillboards()
        return
    end
    
    local toRemove = {}
    for i, billboard in pairs(healthBillboards) do
        if not billboard or not billboard.Parent then
            table.insert(toRemove, i)
        end
    end
    for i = #toRemove, 1, -1 do
        local idx = toRemove[i]
        pcall(function() healthBillboards[idx]:Destroy() end)
        table.remove(healthBillboards, idx)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            if hum and head then
                local billboard = createHealthBillboard(player)
                if billboard then
                    local healthLabel = billboard:FindFirstChild("HealthLabel")
                    if healthLabel then
                        local health = math.floor(hum.Health)
                        local maxHealth = math.floor(hum.MaxHealth)
                        healthLabel.Text = health .. "/" .. maxHealth
                        local percent = hum.Health / hum.MaxHealth
                        if percent > 0.5 then
                            healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif percent > 0.25 then
                            healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                    local nameLabel = billboard:FindFirstChild("NameLabel")
                    if nameLabel then
                        local wp = workspace:FindFirstChild("Players")
                        if wp then
                            if wp:FindFirstChild("Killers") and char:IsDescendantOf(wp.Killers) then
                                nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            elseif wp:FindFirstChild("Survivors") and char:IsDescendantOf(wp.Survivors) then
                                nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            else
                                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            end
                        end
                    end
                end
            end
        end
    end
end

local HealthToggle = VisualTab:CreateToggle({
    Name = "ПОКАЗ ЗДОРОВЬЯ",
    CurrentValue = false,
    Flag = "HealthToggle",
    Callback = function(Value)
        healthShowEnabled = Value
        if healthShowEnabled then
            updateHealthBillboards()
            if healthThread then healthThread:Disconnect() end
            healthThread = RunService.Heartbeat:Connect(function()
                if healthShowEnabled then updateHealthBillboards() end
            end)
        else
            if healthThread then healthThread:Disconnect() end
            clearHealthBillboards()
        end
    end
})

-- ========== ВКЛАДКА ГЕНЕРАТОРЫ ==========
local GenTab = Window:CreateTab("ГЕНЕРАТОРЫ")

local GenSection = GenTab:CreateSection("АВТО-ЧИНКА")

local function fixGens()
    pcall(function()
        local map = workspace:FindFirstChild("Map")
        if map then
            local ingame = map:FindFirstChild("Ingame")
            if ingame then
                local m = ingame:FindFirstChild("Map")
                if m then
                    for _, obj in pairs(m:GetChildren()) do
                        if obj:IsA("Model") and obj.Name == "Generator" then
                            local remotes = obj:FindFirstChild("Remotes")
                            if remotes then
                                local re = remotes:FindFirstChild("RE")
                                if re then
                                    re:FireServer()
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local AutoGenToggle = GenTab:CreateToggle({
    Name = "АВТО-ЧИНКА ГЕНЕРАТОРОВ",
    CurrentValue = false,
    Flag = "AutoGenToggle",
    Callback = function(Value)
        autoGenEnabled = Value
        if autoGenEnabled then
            if autoGenLoop then task.cancel(autoGenLoop) end
            autoGenLoop = spawn(function()
                while autoGenEnabled do
                    fixGens()
                    wait(2.5)
                end
            end)
        else
            if autoGenLoop then task.cancel(autoGenLoop) end
            autoGenLoop = nil
        end
    end
})

-- ========== ВКЛАДКА АИМБОТ ==========
local AimTab = Window:CreateTab("АИМБОТ")

local AimSection = AimTab:CreateSection("АИМБОТ")

local function getMyTeam()
    local wp = workspace:FindFirstChild("Players")
    if wp then
        if LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(wp:FindFirstChild("Killers")) then
            return "Killer"
        elseif LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(wp:FindFirstChild("Survivors")) then
            return "Survivor"
        end
    end
    return nil
end

local function getTargets()
    local targets = {}
    local myTeam = getMyTeam()
    local wp = workspace:FindFirstChild("Players")
    if not wp then return targets end
    
    local targetGroup = nil
    if myTeam == "Killer" then
        targetGroup = wp:FindFirstChild("Survivors")
    elseif myTeam == "Survivor" then
        targetGroup = wp:FindFirstChild("Killers")
    end
    
    if targetGroup then
        for _, obj in pairs(targetGroup:GetChildren()) do
            if obj:IsA("Model") then
                local hum = obj:FindFirstChild("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    table.insert(targets, obj)
                end
            end
        end
    end
    return targets
end

local function getClosestTarget()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local targets = getTargets()
    local closest = nil
    local bestDist = aimRadius
    
    for _, target in pairs(targets) do
        local hrp = target:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (root.Position - hrp.Position).Magnitude
            if dist < bestDist then
                local ray = Ray.new(root.Position, (hrp.Position - root.Position).Unit * dist)
                local hit = workspace:FindPartOnRay(ray, char)
                if not hit or hit:IsDescendantOf(target) then
                    bestDist = dist
                    closest = target
                end
            end
        end
    end
    return closest
end

local function aimFunc()
    if not aimEnabled then return end
    local target = getClosestTarget()
    if target then
        local hrp = target:FindFirstChild("HumanoidRootPart")
        if hrp then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position)
        end
    end
end

local AimToggle = AimTab:CreateToggle({
    Name = "АИМБОТ",
    CurrentValue = false,
    Flag = "AimToggle",
    Callback = function(Value)
        aimEnabled = Value
        if aimEnabled then
            if aimConn then aimConn:Disconnect() end
            aimConn = RunService.RenderStepped:Connect(aimFunc)
        else
            if aimConn then aimConn:Disconnect() end
            aimConn = nil
        end
    end
})

local AimSlider = AimTab:CreateSlider({
    Name = "РАДИУС НАВОДКИ",
    Range = {50, 300},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 150,
    Flag = "AimRadius",
    Callback = function(Value)
        aimRadius = Value
    end
})

-- ========== ВКЛАДКА РАЗВЛЕЧЕНИЯ ==========
local FunTab = Window:CreateTab("РАЗВЛЕЧЕНИЯ")

local FunSection = FunTab:CreateSection("СВЕТ")

local FullbrightBtn = FunTab:CreateButton({
    Name = "ПОЛНАЯ ОСВЕЩЁННОСТЬ",
    Callback = function()
        pcall(function()
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.Brightness = 1
            game.Lighting.FogEnd = 1e10
            game.Lighting.FogStart = 100000
            game.Lighting.TimeOfDay = "12:00:00"
            game.Lighting.Technology = Enum.Technology.Future
        end)
    end
})

local FogBtn = FunTab:CreateButton({
    Name = "УБРАТЬ ТУМАН",
    Callback = function()
        game.Lighting.FogStart = math.huge
        game.Lighting.FogEnd = math.huge
    end
})

-- ========== ВКЛАДКА НАСТРОЙКИ С ТЕМАМИ ==========
local SettingsTab = Window:CreateTab("НАСТРОЙКИ")

local ThemeSection = SettingsTab:CreateSection("ТЕМЫ")

local ThemeNya = SettingsTab:CreateButton({
    Name = "🌸 НЯШНЫЙ (РОЗОВАЯ ТЕМА)",
    Callback = function()
        applyTheme("Nya")
    end
})

local ThemeLava = SettingsTab:CreateButton({
    Name = "🔥 ЛАВОВЫЙ (LAVA THEME)",
    Callback = function()
        applyTheme("Lava")
    end
})

local ThemeDefault = SettingsTab:CreateButton({
    Name = "💠 СТАНДАРТНАЯ ТЕМА",
    Callback = function()
        applyTheme("Default")
    end
})

local SettingsSection2 = SettingsTab:CreateSection("УПРАВЛЕНИЕ")

local UnloadBtn = SettingsTab:CreateButton({
    Name = "ВЫГРУЗИТЬ GUI",
    Callback = function()
        Rayfield:Destroy()
        floatingBtn:Destroy()
    end
})

-- ПОКАЗЫВАЕМ ОКНО ПРИ ЗАПУСКЕ
Rayfield:ToggleVisibility(true)
print("FORSAKEN BY ELPRIMO228RB - RAYFIELD GUI С РАБОЧИМИ ТЕМАМИ")
