-- FORSAKEN BY ELPRIMO228RB - С ПРОКРУТКОЙ

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local screenSize = workspace.CurrentCamera.ViewportSize
local buttonHeight = 38
local fontSize = 13
local titleHeight = 50
local tabHeight = 45
local spacing = 4

local gui = Instance.new("ScreenGui")
gui.Name = "FORSAKEN_ELPRIMO228RB"
gui.ResetOnSpawn = false

pcall(function()
    if syn then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    else
        gui.Parent = game:GetService("CoreGui")
    end
end)
if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ПЛАВАЮЩАЯ КНОПКА
local floatingButton = Instance.new("ImageButton")
floatingButton.Size = UDim2.new(0, 55, 0, 55)
floatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
floatingButton.BackgroundTransparency = 0.15
floatingButton.Image = "rbxassetid://7641916668"
floatingButton.ScaleType = Enum.ScaleType.Fit
floatingButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = floatingButton

local dragActive = false
local dragStart = Vector2.new()
local dragStartPos = UDim2.new()
floatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = true
        dragStart = input.Position
        dragStartPos = floatingButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragActive and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        local scrSize = gui.AbsoluteSize
        local btnSize = floatingButton.AbsoluteSize
        floatingButton.Position = UDim2.new(0, math.clamp(dragStartPos.X.Offset + delta.X, 0, scrSize.X - btnSize.X), 0, math.clamp(dragStartPos.Y.Offset + delta.Y, 0, scrSize.Y - btnSize.Y))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = false
    end
end)

-- ОСНОВНОЕ ОКНО
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.BackgroundTransparency = 0.05
frame.ClipsDescendants = true
frame.Visible = true
frame.Parent = gui

-- ЗАГОЛОВОК
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, titleHeight)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
titleBar.BackgroundTransparency = 0.15
titleBar.Parent = frame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "FORSAKEN BY ELPRIMO228RB"
titleText.TextColor3 = Color3.fromRGB(0, 162, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 42, 0, 42)
closeBtn.Position = UDim2.new(1, -52, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

floatingButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ПАНЕЛЬ ВКЛАДОК
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, tabHeight)
tabsFrame.Position = UDim2.new(0, 0, 0, titleHeight)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = frame

local function createTabButton(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.166, 0, 1, 0)
    btn.Position = UDim2.new(position, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(210, 210, 250)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = tabsFrame
    return btn
end

local btnPlayer = createTabButton("ИГРОК", 0)
local btnVisual = createTabButton("ВИЗУАЛ", 0.166)
local btnGenerators = createTabButton("ГЕНЕРАТ.", 0.332)
local btnAimbot = createTabButton("АИМБОТ", 0.498)
local btnFun = createTabButton("РАЗВЛЕЧ.", 0.664)
local btnSettings = createTabButton("НАСТРОЙКИ", 0.83)

-- ФУНКЦИЯ ПРОКРУЧИВАЕМОЙ ВКЛАДКИ (СКРОЛЛ)
local function createScrollableTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -(titleHeight + tabHeight + 5))
    container.Position = UDim2.new(0, 0, 0, titleHeight + tabHeight + 5)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.Parent = frame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarImageTransparency = 0.5
    scrollingFrame.Parent = container
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = scrollingFrame
    
    return container, scrollingFrame, content
end

local function createButton(parent, text, yOffset, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, screenSize.X - 40, 0, buttonHeight)
    btn.Position = UDim2.new(0.5, -(screenSize.X - 40) / 2, 0, yOffset)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 58)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = fontSize
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.Parent = parent
    return btn
end

local function createSlider(parent, yOffset, labelText, minValue, maxValue, defaultValue, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, screenSize.X - 40, 0, 22)
    label.Position = UDim2.new(0.5, -(screenSize.X - 40) / 2, 0, yOffset)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. tostring(defaultValue)
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.TextSize = fontSize - 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = parent
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, screenSize.X - 40, 0, 5)
    track.Position = UDim2.new(0.5, -(screenSize.X - 40) / 2, 0, yOffset + 22)
    track.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    track.Parent = parent
    
    local fill = Instance.new("Frame")
    local perc = (defaultValue - minValue) / (maxValue - minValue)
    fill.Size = UDim2.new(perc, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.Parent = track
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(perc, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    knob.Parent = track
    
    local dragging = false
    local function updateValue(inputPos)
        local tPos = track.AbsolutePosition.X
        local tWid = track.AbsoluteSize.X
        if tWid <= 0 then return end
        local p = math.clamp((inputPos - tPos) / tWid, 0, 1)
        local val = math.floor(minValue + p * (maxValue - minValue))
        label.Text = labelText .. ": " .. tostring(val)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -8, 0.5, -8)
        callback(val)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateValue(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ========== TPWALK ==========
local tpwalkActive = false
local tpwalkConn = nil
local tpwalkSpeed = 0.15

local function startTpwalk()
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
end

-- ========== ВКЛАДКА ИГРОК ==========
local playerContainer, playerScroll, playerContent = createScrollableTab()
local yOffsetP = 8

local tpwalkBtn = createButton(playerContent, "TPWALK: ВЫКЛ", yOffsetP, Color3.fromRGB(0, 120, 200))
tpwalkBtn.MouseButton1Click:Connect(function()
    tpwalkActive = not tpwalkActive
    if tpwalkActive then
        startTpwalk()
        tpwalkBtn.Text = "TPWALK: ВКЛ"
        tpwalkBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        if tpwalkConn then tpwalkConn:Disconnect() end
        tpwalkBtn.Text = "TPWALK: ВЫКЛ"
        tpwalkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)
yOffsetP = yOffsetP + buttonHeight + spacing

local tpwalkSlider = createSlider(playerContent, yOffsetP, "СКОРОСТЬ TPWALK", 5, 35, 15, function(value)
    tpwalkSpeed = value / 100
    if tpwalkActive then
        startTpwalk()
    end
end)
yOffsetP = yOffsetP + 50

playerContent.Size = UDim2.new(1, 0, 0, yOffsetP + 20)
playerScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetP + 20)
playerContainer.Parent = frame
playerContainer.Visible = true

-- ========== ВКЛАДКА ВИЗУАЛ (ESP) ==========
local visualContainer, visualScroll, visualContent = createScrollableTab()
local yOffsetV = 8

local espEnabled = false
local espThread = nil
local espHighlights = {}

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
                        createHighlight(obj, Color3.new(1, 0, 0), Color3.new(1, 0.5, 0.5))
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
                        createHighlight(obj, Color3.new(0, 1, 0), Color3.new(0.5, 1, 0.5))
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
                        createHighlight(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
                    end
                end
            end
        end
    end
end

local espBtn = createButton(visualContent, "ESP: ВЫКЛ", yOffsetV, Color3.fromRGB(0, 120, 200))
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        updateESP()
        if espThread then espThread:Disconnect() end
        espThread = RunService.Heartbeat:Connect(function()
            if espEnabled then updateESP() end
        end)
        espBtn.Text = "ESP: ВКЛ"
        espBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        if espThread then espThread:Disconnect() end
        clearESP()
        espBtn.Text = "ESP: ВЫКЛ"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)
yOffsetV = yOffsetV + buttonHeight + spacing + 20

visualContent.Size = UDim2.new(1, 0, 0, yOffsetV)
visualScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetV)
visualContainer.Parent = frame
visualContainer.Visible = false

-- ========== ВКЛАДКА ГЕНЕРАТОРЫ ==========
local genContainer, genScroll, genContent = createScrollableTab()
local yOffsetG = 8

local autoGenEnabled = false
local autoGenLoop = nil

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

local autoGenBtn = createButton(genContent, "АВТО-ЧИНКА: ВЫКЛ", yOffsetG, Color3.fromRGB(0, 120, 200))
autoGenBtn.MouseButton1Click:Connect(function()
    autoGenEnabled = not autoGenEnabled
    if autoGenEnabled then
        autoGenLoop = spawn(function()
            while autoGenEnabled do
                fixGens()
                wait(2.5)
            end
        end)
        autoGenBtn.Text = "АВТО-ЧИНКА: ВКЛ"
        autoGenBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        if autoGenLoop then task.cancel(autoGenLoop) end
        autoGenBtn.Text = "АВТО-ЧИНКА: ВЫКЛ"
        autoGenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)
yOffsetG = yOffsetG + buttonHeight + spacing + 20

genContent.Size = UDim2.new(1, 0, 0, yOffsetG)
genScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetG)
genContainer.Parent = frame
genContainer.Visible = false

-- ========== ВКЛАДКА АИМБОТ ==========
local aimContainer, aimScroll, aimContent = createScrollableTab()
local yOffsetA = 8

local aimEnabled = false
local aimConn = nil
local aimRadius = 150

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

local aimBtn = createButton(aimContent, "АИМБОТ: ВЫКЛ", yOffsetA, Color3.fromRGB(0, 120, 200))
aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    if aimEnabled then
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(aimFunc)
        aimBtn.Text = "АИМБОТ: ВКЛ"
        aimBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        if aimConn then aimConn:Disconnect() end
        aimBtn.Text = "АИМБОТ: ВЫКЛ"
        aimBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)
yOffsetA = yOffsetA + buttonHeight + spacing

local radiusSlider = createSlider(aimContent, yOffsetA, "РАДИУС НАВОДКИ", 50, 300, 150, function(value)
    aimRadius = value
end)
yOffsetA = yOffsetA + 50 + 20

aimContent.Size = UDim2.new(1, 0, 0, yOffsetA)
aimScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetA)
aimContainer.Parent = frame
aimContainer.Visible = false

-- ========== ВКЛАДКА РАЗВЛЕЧЕНИЯ ==========
local funContainer, funScroll, funContent = createScrollableTab()
local yOffsetF = 8

local fullbrightBtn = createButton(funContent, "ПОЛНАЯ ОСВЕЩЁННОСТЬ", yOffsetF, Color3.fromRGB(100, 150, 200))
fullbrightBtn.MouseButton1Click:Connect(function()
    pcall(function()
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.Brightness = 1
        game.Lighting.FogEnd = 1e10
        game.Lighting.FogStart = 100000
        game.Lighting.TimeOfDay = "12:00:00"
        game.Lighting.Technology = Enum.Technology.Future
    end)
end)
yOffsetF = yOffsetF + buttonHeight + spacing

local fogBtn = createButton(funContent, "УБРАТЬ ТУМАН", yOffsetF, Color3.fromRGB(100, 150, 200))
fogBtn.MouseButton1Click:Connect(function()
    game.Lighting.FogStart = math.huge
    game.Lighting.FogEnd = math.huge
end)
yOffsetF = yOffsetF + buttonHeight + spacing + 20

funContent.Size = UDim2.new(1, 0, 0, yOffsetF)
funScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetF)
funContainer.Parent = frame
funContainer.Visible = false

-- ========== ВКЛАДКА НАСТРОЙКИ ==========
local settingsContainer, settingsScroll, settingsContent = createScrollableTab()
local yOffsetT = 8

local unloadBtn = createButton(settingsContent, "ВЫГРУЗИТЬ GUI", yOffsetT, Color3.fromRGB(180, 70, 70))
unloadBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
yOffsetT = yOffsetT + buttonHeight + spacing + 20

settingsContent.Size = UDim2.new(1, 0, 0, yOffsetT)
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, yOffsetT)
settingsContainer.Parent = frame
settingsContainer.Visible = false

-- ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
local function setActiveTab(activeTab)
    playerContainer.Visible = (activeTab == btnPlayer)
    visualContainer.Visible = (activeTab == btnVisual)
    genContainer.Visible = (activeTab == btnGenerators)
    aimContainer.Visible = (activeTab == btnAimbot)
    funContainer.Visible = (activeTab == btnFun)
    settingsContainer.Visible = (activeTab == btnSettings)
    
    local colOn = Color3.fromRGB(80, 60, 110)
    local colOff = Color3.fromRGB(30, 30, 42)
    btnPlayer.BackgroundColor3 = (activeTab == btnPlayer) and colOn or colOff
    btnVisual.BackgroundColor3 = (activeTab == btnVisual) and colOn or colOff
    btnGenerators.BackgroundColor3 = (activeTab == btnGenerators) and colOn or colOff
    btnAimbot.BackgroundColor3 = (activeTab == btnAimbot) and colOn or colOff
    btnFun.BackgroundColor3 = (activeTab == btnFun) and colOn or colOff
    btnSettings.BackgroundColor3 = (activeTab == btnSettings) and colOn or colOff
end

btnPlayer.MouseButton1Click:Connect(function() setActiveTab(btnPlayer) end)
btnVisual.MouseButton1Click:Connect(function() setActiveTab(btnVisual) end)
btnGenerators.MouseButton1Click:Connect(function() setActiveTab(btnGenerators) end)
btnAimbot.MouseButton1Click:Connect(function() setActiveTab(btnAimbot) end)
btnFun.MouseButton1Click:Connect(function() setActiveTab(btnFun) end)
btnSettings.MouseButton1Click:Connect(function() setActiveTab(btnSettings) end)

setActiveTab(btnPlayer)

print("FORSAKEN BY ELPRIMO228RB - ЗАПУЩЕН")
print("КНОПКИ МОЖНО ЛИСТАТЬ ВО ВСЕХ ВКЛАДКАХ")
