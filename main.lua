-- FORSAKEN BY ELPRIMO228RB - RAYFIELD GUI (ОПТИМИЗИРОВАННАЯ ВЕРСИЯ)

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

-- ========== ТЕМЫ (БЕЗ ЦВЕТОВ) ==========
local Themes = {
    Default = {
        Background = Color3.fromRGB(25, 25, 30),
        Header = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Text2 = Color3.fromRGB(200, 200, 200),
    },
    Nya = {
        Background = Color3.fromRGB(45, 15, 45),
        Header = Color3.fromRGB(60, 20, 60),
        Accent = Color3.fromRGB(255, 100, 200),
        Text = Color3.fromRGB(255, 220, 240),
        Text2 = Color3.fromRGB(255, 180, 220),
    },
    Lava = {
        Background = Color3.fromRGB(25, 10, 5),
        Header = Color3.fromRGB(45, 20, 10),
        Accent = Color3.fromRGB(255, 120, 0),
        Text = Color3.fromRGB(255, 200, 100),
        Text2 = Color3.fromRGB(255, 160, 50),
    }
}

local currentTheme = "Default"

local function applyTheme(themeName)
    currentTheme = themeName
    local theme = Themes[themeName]
    if not theme then return end
    pcall(function()
        Rayfield:ModifyTheme(themeName)
    end)
end

-- ========== ИНИЦИАЛИЗАЦИЯ ОКНА ==========
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

-- ПЕРЕМЕННЫЕ ДЛЯ ПОДСВЕТКИ ПРЕДМЕТОВ (ОПТИМИЗИРОВАННЫЕ)
local itemsEspEnabled = false
local itemsEspThread = nil
local itemsHighlights = {}
local itemCache = {} -- кэш для отслеживания предметов

-- ПЕРЕМЕННЫЕ ДЛЯ ПОКАЗА ЗДОРОВЬЯ
local healthShowEnabled = false
local healthThread = nil
local healthBillboards = {}

-- ========== АВТО БЛОК ПЕРЕМЕННЫЕ (ИЗ ВТОРОГО СКРИПТА) ==========
local autoBlockOn = false
local autoBlockAudioOn = false
local autoblocktype = "Block"
local detectionRange = 18
local detectionRangeSq = detectionRange * detectionRange
local blockdelay = 0
local facingCheckEnabled = true
local doubleblocktech = false
local predictiveBlockOn = false
local edgeKillerDelay = 3
local antiFlickOn = false
local antiFlickParts = 4
local antiFlickDelay = 0
local predictionStrength = 1
local predictionTurnStrength = 1
local stagger = 0.02
local hitboxDraggingTech = false
local messageWhenAutoBlockOn = false
local messageWhenAutoBlock = ""
local customFacingDot = -0.3

-- ДОПОЛНИТЕЛЬНЫЕ ПЕРЕМЕННЫЕ ДЛЯ BD
local killerState = {}
local PRED_SECONDS_FORWARD = 0.25
local PRED_SECONDS_LATERAL = 0.18
local PRED_MAX_FORWARD = 6
local PRED_MAX_LATERAL = 4
local ANG_TURN_MULTIPLIER = 0.6
local SMOOTHING_LERP = 0.22
local blockPartsSizeMultiplier = 1
local antiFlickBaseOffset = 2.7
local antiFlickOffsetStep = 0
local autoAdjustDBTFBPS = false
local _savedManualAntiFlickDelay = 0

-- ДЛЯ AUDIO AUTO BLOCK
local soundHooks = {}
local soundBlockedUntil = {}
local AUDIO_PREDICT_DT = 0.08
local AUDIO_LOCAL_COOLDOWN = 0.35
local AUDIO_SOUND_THROTTLE = 1.0
local lastLocalBlockTime = 0

local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local testRemote = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Network") and ReplicatedStorage.Modules.Network:FindFirstChild("RemoteEvent")

-- ========== ФУНКЦИИ ДЛЯ РАБОТЫ С REMOTE ==========
local function fireRemoteBlock()
    if testRemote then
        local args = {"UseActorAbility", "Block"}
        testRemote:FireServer(unpack(args))
    end
end

local function fireRemotePunch()
    if testRemote then
        local args = {"UseActorAbility", "Punch"}
        testRemote:FireServer(unpack(args))
    end
end

local function fireRemoteCharge()
    if testRemote then
        local args = {"UseActorAbility", "Charge"}
        testRemote:FireServer(unpack(args))
    end
end

local function fireRemoteClone()
    if testRemote then
        local args = {"UseActorAbility", "Clone"}
        testRemote:FireServer(unpack(args))
    end
end

-- ========== ФУНКЦИИ АВТО БЛОКА (ИЗ ВТОРОГО СКРИПТА) ==========
local function getNearestKillerModel()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closest, closestDist = nil, math.huge
    if not KillersFolder then return nil end
    for _, k in ipairs(KillersFolder:GetChildren()) do
        if k and k:IsA("Model") then
            local hrp = k:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myRoot.Position).Magnitude
                if d < closestDist then
                    closest, closestDist = k, d
                end
            end
        end
    end
    return closest
end

local function isFacing(localRoot, targetRoot)
    if not facingCheckEnabled then return true end
    if not localRoot or not targetRoot then return true end
    
    local dx = localRoot.Position.X - targetRoot.Position.X
    local dy = localRoot.Position.Y - targetRoot.Position.Y
    local dz = localRoot.Position.Z - targetRoot.Position.Z
    local mag = math.sqrt(dx*dx + dy*dy + dz*dz)
    if mag == 0 then return true end
    local invMag = 1 / mag
    local ux, uy, uz = dx * invMag, dy * invMag, dz * invMag
    local lv = targetRoot.CFrame.LookVector
    local lx, ly, lz = lv.X, lv.Y, lv.Z
    local dot = lx * ux + ly * uy + lz * uz
    return dot > (customFacingDot or -0.3)
end

local function extractNumericSoundId(sound)
    if not sound then return nil end
    local sid = sound.SoundId
    if not sid then return nil end
    sid = (type(sid) == "string") and sid or tostring(sid)
    local num = string.match(sid, "rbxassetid://(%d+)") or string.match(sid, "://(%d+)") or string.match(sid, "^(%d+)$")
    if num and #num > 0 then return num end
    return nil
end

local function getSoundWorldPosition(sound)
    if not sound then return nil, nil end
    local parent = sound.Parent
    if parent then
        if parent:IsA("BasePart") then
            return parent.Position, parent
        end
        if parent:IsA("Attachment") then
            local gp = parent.Parent
            if gp and gp:IsA("BasePart") then
                return gp.Position, gp
            end
        end
    end
    if KillersFolder and sound:IsDescendantOf(KillersFolder) then
        local root = parent or sound
        local found = root:FindFirstChildWhichIsA("BasePart", true)
        if found then return found.Position, found end
    end
    return nil, nil
end

local function getCharacterFromDescendant(inst)
    if not inst then return nil end
    local model = inst:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return model
    end
    return nil
end

local function isPointInsidePart(part, point)
    if not (part and point) then return false end
    local rel = part.CFrame:PointToObjectSpace(point)
    local half = part.Size * 0.5
    return math.abs(rel.X) <= half.X + 0.001 and
           math.abs(rel.Y) <= half.Y + 0.001 and
           math.abs(rel.Z) <= half.Z + 0.001
end

local function attemptBlockForSound(sound)
    if not autoBlockAudioOn then return end
    if not sound or not sound:IsA("Sound") then return end
    if not sound.IsPlaying then return end
    
    local now = tick()
    local id = extractNumericSoundId(sound)
    if not id then return end
    
    if soundBlockedUntil[sound] and now < soundBlockedUntil[sound] then return end
    if now - lastLocalBlockTime < AUDIO_LOCAL_COOLDOWN then return end
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local soundPos, soundPart = getSoundWorldPosition(sound)
    if not soundPart then return end
    
    local char = getCharacterFromDescendant(soundPart)
    if not char then return end
    local plr = Players:GetPlayerFromCharacter(char)
    if not plr or plr == LocalPlayer then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- предсказание позиции
    local v = hrp.Velocity or Vector3.new()
    local predictedX = hrp.Position.X + v.X * AUDIO_PREDICT_DT
    local predictedY = hrp.Position.Y + v.Y * AUDIO_PREDICT_DT
    local predictedZ = hrp.Position.Z + v.Z * AUDIO_PREDICT_DT
    local dx = predictedX - myRoot.Position.X
    local dy = predictedY - myRoot.Position.Y
    local dz = predictedZ - myRoot.Position.Z
    local distSqPred = dx*dx + dy*dy + dz*dz
    
    if distSqPred > detectionRangeSq then
        local dx2 = hrp.Position.X - myRoot.Position.X
        local dy2 = hrp.Position.Y - myRoot.Position.Y
        local dz2 = hrp.Position.Z - myRoot.Position.Z
        local distSqNow = dx2*dx2 + dy2*dy2 + dz2*dz2
        if distSqNow > (detectionRange + 3) * (detectionRange + 3) then return end
    end
    
    if facingCheckEnabled and not isFacing(myRoot, hrp) then return end
    
    task.wait(blockdelay)
    
    if autoblocktype == "Block" then
        fireRemoteBlock()
        if doubleblocktech then fireRemotePunch() end
    elseif autoblocktype == "Charge" then
        fireRemoteCharge()
    elseif autoblocktype == "7n7 Clone" then
        fireRemoteClone()
    end
    
    lastLocalBlockTime = now
    soundBlockedUntil[sound] = now + AUDIO_SOUND_THROTTLE
end

-- ОПТИМИЗИРОВАННАЯ ПОДСВЕТКА ПРЕДМЕТОВ (С КЭШЕМ)
local function clearItemsESP()
    for _, h in pairs(itemsHighlights) do
        pcall(function() h:Destroy() end)
    end
    itemsHighlights = {}
    itemCache = {}
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
    
    -- Используем кэш для отслеживания предметов
    local newItemCache = {}
    
    -- Поиск предметов (только один раз за цикл)
    local allItems = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj.Name == "BloxyCola" or obj.Name == "Medkit" or obj.Name == "SubspaceTripmine" then
                table.insert(allItems, obj)
            end
        end
    end
    
    -- Удаляем подсветку для предметов, которых больше нет
    for _, h in pairs(itemsHighlights) do
        if not h or not h.Parent or not h.Parent:IsA("Model") then
            pcall(function() h:Destroy() end)
        end
    end
    
    -- Создаем подсветку для новых предметов
    for _, obj in pairs(allItems) do
        -- Проверяем, есть ли уже подсветка
        local hasHighlight = false
        for _, h in pairs(itemsHighlights) do
            if h and h.Parent == obj then
                hasHighlight = true
                break
            end
        end
        
        if not hasHighlight then
            if obj.Name == "BloxyCola" then
                createItemHighlight(obj, Color3.fromRGB(204, 153, 0), Color3.fromRGB(204, 153, 0))
            elseif obj.Name == "Medkit" then
                createItemHighlight(obj, Color3.fromRGB(128, 0, 128), Color3.fromRGB(128, 0, 128))
            elseif obj.Name == "SubspaceTripmine" then
                local isSurvivorPlaced = false
                if KillersFolder then
                    local survivors = workspace.Players:FindFirstChild("Survivors")
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
    
    -- Удаляем подсветку для предметов, которых больше нет в игре
    local toRemove = {}
    for i, h in pairs(itemsHighlights) do
        if h and h.Parent then
            local found = false
            for _, obj in pairs(allItems) do
                if obj == h.Parent then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(toRemove, i)
            end
        else
            table.insert(toRemove, i)
        end
    end
    
    for _, i in pairs(toRemove) do
        pcall(function() 
            if itemsHighlights[i] then 
                itemsHighlights[i]:Destroy() 
            end 
        end)
        itemsHighlights[i] = nil
    end
end

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

-- ========== ПОДСВЕТКА ПРЕДМЕТОВ (ОПТИМИЗИРОВАННАЯ) ==========
local ItemsSection = VisualTab:CreateSection("ПОДСВЕТКА ПРЕДМЕТОВ")

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
                if itemsEspEnabled then 
                    updateItemsESP() 
                    task.wait(0.1) -- небольшая задержка для снижения нагрузки
                end
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

-- ========== НОВАЯ ВКЛАДКА: АВТО БЛОК ==========
local AutoBlockTab = Window:CreateTab("АВТО БЛОК")

-- Левая группа: основные настройки
local ABLeftGroup = AutoBlockTab:CreateSection("ОСНОВНЫЕ НАСТРОЙКИ")

local AutoBlockToggle = AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО АНИМАЦИИ)",
    CurrentValue = false,
    Flag = "AutoBlockToggle",
    Callback = function(Value)
        autoBlockOn = Value
    end
})

local AutoBlockAudioToggle = AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО ЗВУКУ)",
    CurrentValue = false,
    Flag = "AutoBlockAudioToggle",
    Callback = function(Value)
        autoBlockAudioOn = Value
        -- Активируем хуки для звуков при включении
        if Value and KillersFolder then
            for _, desc in ipairs(KillersFolder:GetDescendants()) do
                if desc:IsA("Sound") then
                    if not soundHooks[desc] then
                        soundHooks[desc] = { id = extractNumericSoundId(desc) }
                    end
                end
            end
        end
    end
})

local BlockTypeDropdown = AutoBlockTab:CreateDropdown({
    Name = "ТИП БЛОКА",
    Options = {"Block", "Charge", "7n7 Clone"},
    CurrentOption = "Block",
    Flag = "BlockType",
    Callback = function(Value)
        autoblocktype = Value
    end
})

local DetectionRangeInput = AutoBlockTab:CreateInput({
    Name = "РАДИУС ОБНАРУЖЕНИЯ",
    CurrentValue = "18",
    PlaceholderText = "18",
    Flag = "DetectionRange",
    Callback = function(Value)
        detectionRange = tonumber(Value) or 18
        detectionRangeSq = detectionRange * detectionRange
    end
})

local BlockDelayInput = AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПЕРЕД БЛОКОМ (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "BlockDelay",
    Callback = function(Value)
        blockdelay = tonumber(Value) or 0
    end
})

-- Правая группа: продвинутые настройки
local ABRightGroup = AutoBlockTab:CreateSection("ПРОДВИНУТЫЕ НАСТРОЙКИ")

local FacingCheckToggle = AutoBlockTab:CreateToggle({
    Name = "ПРОВЕРКА НАПРАВЛЕНИЯ (ФЕЙСИНГ)",
    CurrentValue = true,
    Flag = "FacingCheckToggle",
    Callback = function(Value)
        facingCheckEnabled = Value
    end
})

local FacingDotInput = AutoBlockTab:CreateInput({
    Name = "УГОЛ ФЕЙСИНГА (DOT, от -1 до 1)",
    CurrentValue = "-0.3",
    PlaceholderText = "-0.3",
    Flag = "FacingDot",
    Callback = function(Value)
        customFacingDot = tonumber(Value) or -0.3
    end
})

local DoubleBlockToggle = AutoBlockTab:CreateToggle({
    Name = "ДВОЙНОЙ ПАНЧ (БЛОК + ПАНЧ)",
    CurrentValue = false,
    Flag = "DoubleBlockToggle",
    Callback = function(Value)
        doubleblocktech = Value
    end
})

local PredictiveBlockToggle = AutoBlockTab:CreateToggle({
    Name = "ПРЕДИКТИВНЫЙ АВТО БЛОК",
    CurrentValue = false,
    Flag = "PredictiveBlockToggle",
    Callback = function(Value)
        predictiveBlockOn = Value
    end
})

local EdgeKillerInput = AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПРЕДИКТИВНОГО БЛОКА (сек)",
    CurrentValue = "3",
    PlaceholderText = "3",
    Flag = "EdgeKillerDelay",
    Callback = function(Value)
        edgeKillerDelay = tonumber(Value) or 3
    end
})

-- ========== BD (BETTER DETECTION) СЕКЦИЯ ==========
local BDSection = AutoBlockTab:CreateSection("УЛУЧШЕННОЕ ОБНАРУЖЕНИЕ (BD)")

local AntiFlickToggle = AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ BD",
    CurrentValue = false,
    Flag = "AntiFlickToggle",
    Callback = function(Value)
        antiFlickOn = Value
    end
})

local AntiFlickPartsInput = AutoBlockTab:CreateInput({
    Name = "КОЛИЧЕСТВО БЛОК-ЧАСТЕЙ",
    CurrentValue = "4",
    PlaceholderText = "4",
    Flag = "AntiFlickParts",
    Callback = function(Value)
        antiFlickParts = math.max(1, math.floor(tonumber(Value) or 4))
    end
})

local PartsSizeInput = AutoBlockTab:CreateInput({
    Name = "МНОЖИТЕЛЬ РАЗМЕРА ЧАСТЕЙ",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PartsSizeMultiplier",
    Callback = function(Value)
        blockPartsSizeMultiplier = tonumber(Value) or 1
    end
})

local PredictStrengthInput = AutoBlockTab:CreateInput({
    Name = "СИЛА ПРЕДСКАЗАНИЯ (ВПЕРЁД)",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PredictStrength",
    Callback = function(Value)
        predictionStrength = tonumber(Value) or 1
    end
})

local PredictTurnInput = AutoBlockTab:CreateInput({
    Name = "СИЛА ПРЕДСКАЗАНИЯ (ПОВОРОТ)",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PredictTurn",
    Callback = function(Value)
        predictionTurnStrength = tonumber(Value) or 1
    end
})

local AntiFlickDelayInput = AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПОЯВЛЕНИЯ ЧАСТЕЙ (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "AntiFlickDelay",
    Callback = function(Value)
        antiFlickDelay = math.max(0, tonumber(Value) or 0)
    end
})

local StaggerInput = AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА МЕЖДУ ЧАСТЯМИ (сек)",
    CurrentValue = "0.02",
    PlaceholderText = "0.02",
    Flag = "StaggerDelay",
    Callback = function(Value)
        stagger = math.max(0, tonumber(Value) or 0.02)
    end
})

local BaseOffsetInput = AutoBlockTab:CreateInput({
    Name = "ДИСТАНЦИЯ СПАВНА ЧАСТЕЙ (студи)",
    CurrentValue = "2.7",
    PlaceholderText = "2.7",
    Flag = "BaseOffset",
    Callback = function(Value)
        antiFlickBaseOffset = math.max(0, tonumber(Value) or 2.7)
    end
})

-- ========== ХИТБОКС ДРАГГИНГ ==========
local HDSection = AutoBlockTab:CreateSection("ХИТБОКС ДРАГГИНГ (HDT)")

local HDToggle = AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ HDT",
    CurrentValue = false,
    Flag = "HDToggle",
    Callback = function(Value)
        hitboxDraggingTech = Value
    end
})

local HDSpeedInput = AutoBlockTab:CreateInput({
    Name = "СКОРОСТЬ HDT",
    CurrentValue = "5.6",
    PlaceholderText = "5.6",
    Flag = "HDSpeed",
    Callback = function(Value)
        Dspeed = tonumber(Value) or 5.6
    end
})

local HDDelayInput = AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА HDT (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "HDDelay",
    Callback = function(Value)
        Ddelay = tonumber(Value) or 0
    end
})

-- ========== СООБЩЕНИЯ В ЧАТ ==========
local ChatSection = AutoBlockTab:CreateSection("СООБЩЕНИЯ В ЧАТ")

local ChatBlockToggle = AutoBlockTab:CreateToggle({
    Name = "ОТПРАВЛЯТЬ СООБЩЕНИЕ ПРИ БЛОКЕ",
    CurrentValue = false,
    Flag = "ChatBlockToggle",
    Callback = function(Value)
        messageWhenAutoBlockOn = Value
    end
})

local ChatBlockInput = AutoBlockTab:CreateInput({
    Name = "ТЕКСТ СООБЩЕНИЯ",
    CurrentValue = "",
    PlaceholderText = "Я блокирую!",
    Flag = "ChatBlockText",
    Callback = function(Value)
        messageWhenAutoBlock = Value
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

-- ========== ВКЛАДКА НАСТРОЙКИ ==========
local SettingsTab = Window:CreateTab("НАСТРОЙКИ")

-- ТЕМЫ (БЕЗ ЦВЕТОВ)
local ThemeSection = SettingsTab:CreateSection("ТЕМЫ")

local ThemeNya = SettingsTab:CreateButton({
    Name = "НЯШНЫЙ (РОЗОВАЯ ТЕМА)",
    Callback = function()
        applyTheme("Nya")
        pcall(function()
            floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
            Rayfield:SetWindowName("FORSAKEN BY ELPRIMO228RB")
        end)
        Rayfield:Notify({
            Title = "ТЕМА СМЕНЕНА",
            Content = "НЯШНЫЙ РЕЖИМ АКТИВИРОВАН!",
            Duration = 3,
            Image = 0
        })
    end
})

local ThemeLava = SettingsTab:CreateButton({
    Name = "ЛАВОВЫЙ (LAVA THEME)",
    Callback = function()
        applyTheme("Lava")
        pcall(function()
            floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            Rayfield:SetWindowName("FORSAKEN BY ELPRIMO228RB")
        end)
        Rayfield:Notify({
            Title = "ТЕМА СМЕНЕНА",
            Content = "ЛАВОВЫЙ РЕЖИМ АКТИВИРОВАН!",
            Duration = 3,
            Image = 0
        })
    end
})

local ThemeDefault = SettingsTab:CreateButton({
    Name = "СТАНДАРТНАЯ ТЕМА",
    Callback = function()
        applyTheme("Default")
        pcall(function()
            floatingBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Rayfield:SetWindowName("FORSAKEN BY ELPRIMO228RB")
        end)
        Rayfield:Notify({
            Title = "ТЕМА СМЕНЕНА",
            Content = "СТАНДАРТНАЯ ТЕМА АКТИВИРОВАНА",
            Duration = 3,
            Image = 0
        })
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

-- ========== ЦИКЛ АВТО БЛОКА ПО АНИМАЦИИ ==========
RunService.RenderStepped:Connect(function()
    if not autoBlockOn then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    if not KillersFolder then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then continue end
            
            local dist = (hrp.Position - myRoot.Position).Magnitude
            if dist > detectionRange then continue end
            
            if facingCheckEnabled and not isFacing(myRoot, hrp) then continue end
            
            local animator = hum:FindFirstChildOfClass("Animator")
            if not animator then continue end
            
            local tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
            if not tracks then continue end
            
            for _, track in ipairs(tracks) do
                local animId = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                if animId then
                    -- Список анимаций блока из второго скрипта
                    local blockAnims = {
                        "126830014841198", "126355327951215", "121086746534252", "18885909645",
                        "98456918873918", "105458270463374", "83829782357897", "125403313786645",
                        "118298475669935", "82113744478546", "70371667919898", "99135633258223",
                        "97167027849946", "109230267448394", "139835501033932", "126896426760253",
                        "109667959938617", "126681776859538", "129976080405072", "121293883585738",
                        "81639435858902", "137314737492715", "92173139187970", "122709416391", "879895330952"
                    }
                    if table.find(blockAnims, animId) then
                        task.wait(blockdelay)
                        if autoblocktype == "Block" then
                            fireRemoteBlock()
                            if doubleblocktech then fireRemotePunch() end
                        elseif autoblocktype == "Charge" then
                            fireRemoteCharge()
                        elseif autoblocktype == "7n7 Clone" then
                            fireRemoteClone()
                        end
                        
                        -- Отправка сообщения в чат
                        if messageWhenAutoBlockOn and messageWhenAutoBlock ~= "" then
                            local TextChatService = game:GetService("TextChatService")
                            local channel = TextChatService.TextChannels.RBXGeneral
                            pcall(function() channel:SendAsync(messageWhenAutoBlock) end)
                        end
                        break
                    end
                end
            end
        end
    end
end)

-- ========== ПРЕДИКТИВНЫЙ АВТО БЛОК ==========
local killerInRangeSince = nil
local predictiveCooldown = 0

RunService.Heartbeat:Connect(function()
    if not predictiveBlockOn then return end
    if tick() < predictiveCooldown then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    
    if not KillersFolder then return end
    
    local killerInRange = false
    for _, killer in ipairs(KillersFolder:GetChildren()) do
        local hrp = killer:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (myHRP.Position - hrp.Position).Magnitude
            if dist <= detectionRange then
                killerInRange = true
                break
            end
        end
    end
    
    if killerInRange then
        if not killerInRangeSince then
            killerInRangeSince = tick()
        elseif tick() - killerInRangeSince >= edgeKillerDelay then
            fireRemoteBlock()
            predictiveCooldown = tick() + 2
            killerInRangeSince = nil
        end
    else
        killerInRangeSince = nil
    end
end)

-- ========== BD (BETTER DETECTION) ПО ЗВУКУ ==========
local function attemptBDParts(sound)
    if not antiFlickOn then return end
    if not sound or not sound:IsA("Sound") then return end
    if not sound.IsPlaying then return end
    
    local id = extractNumericSoundId(sound)
    if not id then return end
    
    local now = tick()
    if soundBlockedUntil[sound] and now < soundBlockedUntil[sound] then return end
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local soundPos, soundPart = getSoundWorldPosition(sound)
    if not soundPart then return end
    
    local char = getCharacterFromDescendant(soundPart)
    if not char then return end
    local plr = Players:GetPlayerFromCharacter(char)
    if not plr or plr == LocalPlayer then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local Debris = game:GetService("Debris")
    
    local basePartSize = Vector3.new(5.5, 7.5, 8.5)
    local partSize = basePartSize * (blockPartsSizeMultiplier or 1)
    local count = math.max(1, antiFlickParts or 4)
    local base = antiFlickBaseOffset or 2.7
    local step = antiFlickOffsetStep or 0.2
    local lifeTime = 0.2
    
    task.spawn(function()
        local blocked = false
        task.wait(antiFlickDelay or 0)
        for i = 1, count do
            if not hrp or not myRoot then break end
            
            local dist = base + (i - 1) * step
            local st = killerState[char] or { vel = hrp.Velocity or Vector3.new(), angVel = 0 }
            local vel = st.vel or hrp.Velocity or Vector3.new()
            
            local forwardSpeed = vel:Dot(hrp.CFrame.LookVector)
            local lateralSpeed = vel:Dot(hrp.CFrame.RightVector)
            local pStrength = (type(predictionStrength) == "number" and predictionStrength) or 1
            local pTurn = (type(predictionTurnStrength) == "number" and predictionTurnStrength) or 1
            
            local forwardPredictRaw = forwardSpeed * PRED_SECONDS_FORWARD * pStrength
            local lateralPredictRaw = lateralSpeed * PRED_SECONDS_LATERAL * pStrength
            local turnLateralRaw = st.angVel * ANG_TURN_MULTIPLIER * pTurn
            
            local forwardClamp = PRED_MAX_FORWARD * pStrength
            local lateralClamp = PRED_MAX_LATERAL * pStrength
            local turnClamp = PRED_MAX_LATERAL * pTurn
            
            local forwardPredict = math.clamp(forwardPredictRaw, -forwardClamp, forwardClamp)
            local lateralPredict = math.clamp(lateralPredictRaw, -lateralClamp, lateralClamp)
            local turnLateral = math.clamp(turnLateralRaw, -turnClamp, turnClamp)
            
            local forwardDist = dist + forwardPredict
            
            local spawnPos = hrp.Position
                            + hrp.CFrame.LookVector * forwardDist
                            + hrp.CFrame.RightVector * (lateralPredict + turnLateral)
            
            local part = Instance.new("Part")
            part.Name = "AntiFlickZone"
            part.Size = partSize
            part.Transparency = 0.45
            part.Anchored = true
            part.CanCollide = false
            part.CFrame = CFrame.new(spawnPos, hrp.Position)
            part.BrickColor = BrickColor.new("Bright blue")
            part.Parent = workspace
            
            Debris:AddItem(part, lifeTime)
            
            if isPointInsidePart(part, myRoot.Position) then
                blocked = true
            else
                local touching = {}
                pcall(function() touching = myRoot:GetTouchingParts() end)
                for _, p in ipairs(touching) do
                    if p == part then
                        blocked = true
                        break
                    end
                end
            end
            
            if blocked then
                if not (facingCheckEnabled and not isFacing(myRoot, hrp)) then
                    if autoblocktype == "Block" then
                        fireRemoteBlock()
                    elseif autoblocktype == "Charge" then
                        fireRemoteCharge()
                    elseif autoblocktype == "7n7 Clone" then
                        fireRemoteClone()
                    end
                    soundBlockedUntil[sound] = tick() + 1.2
                end
                break
            end
            
            if stagger and stagger > 0 then
                task.wait(stagger)
            else
                task.wait(0)
            end
        end
    end)
end

-- Хуки для звуков (включаются при включении Audio Auto Block)
local function hookSound(sound)
    if not sound or not sound:IsA("Sound") then return end
    if soundHooks[sound] then return end
    
    local preId = extractNumericSoundId(sound)
    soundHooks[sound] = { id = preId, hrp = nil, char = nil }
    
    local function handleAttempt(snd)
        if not autoBlockAudioOn then return end
        if antiFlickOn then
            attemptBDParts(snd)
        else
            attemptBlockForSound(snd)
        end
    end
    
    local playedConn = sound.Played:Connect(function()
        handleAttempt(sound)
    end)
    
    local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if sound.IsPlaying then
            handleAttempt(sound)
        end
    end)
    
    local destroyConn
    destroyConn = sound.Destroying:Connect(function()
        if playedConn and playedConn.Connected then playedConn:Disconnect() end
        if propConn and propConn.Connected then propConn:Disconnect() end
        if destroyConn and destroyConn.Connected then destroyConn:Disconnect() end
        soundHooks[sound] = nil
        soundBlockedUntil[sound] = nil
    end)
    
    soundHooks[sound].playedConn = playedConn
    soundHooks[sound].propConn = propConn
    soundHooks[sound].destroyConn = destroyConn
    
    if sound.IsPlaying then
        handleAttempt(sound)
    end
end

-- Подключаем хуки для существующих звуков в KillersFolder
task.spawn(function()
    while not KillersFolder do
        task.wait(0.5)
        KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    end
    
    for _, desc in ipairs(KillersFolder:GetDescendants()) do
        if desc:IsA("Sound") then
            hookSound(desc)
        end
    end
    
    KillersFolder.DescendantAdded:Connect(function(desc)
        if desc:IsA("Sound") then
            hookSound(desc)
        end
    end)
end)

-- Обновление состояния киллеров для BD
RunService.RenderStepped:Connect(function(dt)
    if not antiFlickOn then return end
    if dt <= 0 then return end
    
    if not KillersFolder then return end
    
    for _, killer in ipairs(KillersFolder:GetChildren()) do
        if killer and killer.Parent then
            local hrp = killer:FindFirstChild("HumanoidRootPart")
            if hrp then
                local st = killerState[killer] or { prevPos = hrp.Position, prevLook = hrp.CFrame.LookVector, vel = Vector3.new(), angVel = 0 }
                local newVel = (hrp.Position - st.prevPos) / math.max(dt, 1e-6)
                st.vel = st.vel and st.vel:Lerp(newVel, SMOOTHING_LERP) or newVel
                
                local prevLook = st.prevLook or hrp.CFrame.LookVector
                local look = hrp.CFrame.LookVector
                local dot = math.clamp(prevLook:Dot(look), -1, 1)
                local angle = math.acos(dot)
                local crossY = prevLook:Cross(look).Y
                local angSign = (crossY >= 0) and 1 or -1
                local newAngVel = (angle / math.max(dt, 1e-6)) * angSign
                st.angVel = (st.angVel * (1 - SMOOTHING_LERP)) + (newAngVel * SMOOTHING_LERP)
                
                st.prevPos = hrp.Position
                st.prevLook = look
                killerState[killer] = st
            end
        end
    end
end)

-- ========== ХИТБОКС ДРАГГИНГ ==========
local _hitboxDraggingDebounce = false
local Dspeed = 5.6
local Ddelay = 0
local HITBOX_DETECT_RADIUS = 6
local HITBOX_DRAG_DURATION = 1.4

local function getKillerHRP(killerModel)
    if not killerModel then return nil end
    if killerModel:FindFirstChild("HumanoidRootPart") then
        return killerModel:FindFirstChild("HumanoidRootPart")
    end
    if killerModel.PrimaryPart then
        return killerModel.PrimaryPart
    end
    return killerModel:FindFirstChildWhichIsA("BasePart", true)
end

local function beginDragIntoKiller(killerModel)
    if _hitboxDraggingDebounce then return end
    if not killerModel or not killerModel.Parent then return end
    local char = LocalPlayer and LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    
    local targetHRP = getKillerHRP(killerModel)
    if not targetHRP then return end
    
    _hitboxDraggingDebounce = true
    
    local oldWalk = humanoid.WalkSpeed
    local oldJump = humanoid.JumpPower
    local oldPlatformStand = humanoid.PlatformStand
    
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.PlatformStand = false
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 0, 1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp
    
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not hitboxDraggingTech or not _hitboxDraggingDebounce then
            conn:Disconnect()
            if bv and bv.Parent then pcall(function() bv:Destroy() end) end
            humanoid.WalkSpeed = oldWalk
            humanoid.JumpPower = oldJump
            humanoid.PlatformStand = oldPlatformStand
            return
        end
        
        if not (char and char.Parent) or not (killerModel and killerModel.Parent) then
            _hitboxDraggingDebounce = false
            return
        end
        
        targetHRP = getKillerHRP(killerModel)
        if not targetHRP then
            _hitboxDraggingDebounce = false
            return
        end
        
        local toTarget = (targetHRP.Position - hrp.Position)
        local dist = toTarget.Magnitude
        local horiz = Vector3.new(toTarget.X, 0, toTarget.Z)
        if horiz.Magnitude > 0.01 then
            local dir = horiz.Unit
            bv.Velocity = Vector3.new(dir.X * Dspeed, bv.Velocity.Y, dir.Z * Dspeed)
        else
            bv.Velocity = Vector3.new(0, bv.Velocity.Y, 0)
        end
        
        if dist <= 2.0 then
            _hitboxDraggingDebounce = false
        end
    end)
    
    task.delay(0.4, function()
        if _hitboxDraggingDebounce then
            _hitboxDraggingDebounce = false
        end
    end)
end

-- Активация HDT при блоке
RunService.RenderStepped:Connect(function()
    if not hitboxDraggingTech then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    local blockAnims = {
        "72722244508749", "96959123077498", "95802026624883"
    }
    
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local ok, animId = pcall(function()
            local a = track.Animation
            return a and tostring(a.AnimationId):match("%d+")
        end)
        if ok and animId and table.find(blockAnims, animId) then
            local timePos = 0
            pcall(function() timePos = track.TimePosition or 0 end)
            if timePos <= 0.12 then
                local nearest = getNearestKillerModel()
                if nearest then
                    task.wait(Ddelay)
                    task.spawn(function() beginDragIntoKiller(nearest) end)
                end
            end
        end
    end
end)

-- ПОКАЗЫВАЕМ ОКНО ПРИ ЗАПУСКЕ
Rayfield:ToggleVisibility(true)
print("FORSAKEN BY ELPRIMO228RB - RAYFIELD GUI С АВТО БЛОКОМ")
print("ВКЛАДКИ: ИГРОК | ВИЗУАЛ | ГЕНЕРАТОРЫ | АИМБОТ | АВТО БЛОК | РАЗВЛЕЧЕНИЯ | НАСТРОЙКИ")
