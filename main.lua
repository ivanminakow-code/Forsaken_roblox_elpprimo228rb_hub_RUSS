-- FORSAKEN BY ELPRIMO228RB - RAYFIELD UI (С КОНФИГАМИ И ДЕТЕКТОМ СООБЩЕНИЙ)
-- ВЕРСИЯ С БОГЛМС, МУЗЫКОЙ, НОКЛИПОМ И ФЛАЕМ (БЕЗ GOTO/GOT)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- ========== ЗАГРУЗКА RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

-- ========== ТЕМА AMETHYST ==========
local AmethystTheme = {
    TextColor = Color3.fromRGB(240, 240, 240),
    Background = Color3.fromRGB(30, 20, 40),
    Topbar = Color3.fromRGB(40, 25, 50),
    Shadow = Color3.fromRGB(20, 15, 30),
    NotificationBackground = Color3.fromRGB(35, 20, 40),
    NotificationActionsBackground = Color3.fromRGB(240, 240, 250),
    TabBackground = Color3.fromRGB(60, 40, 80),
    TabStroke = Color3.fromRGB(70, 45, 90),
    TabBackgroundSelected = Color3.fromRGB(180, 140, 200),
    TabTextColor = Color3.fromRGB(230, 230, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 20, 50),
    ElementBackground = Color3.fromRGB(45, 30, 60),
    ElementBackgroundHover = Color3.fromRGB(50, 35, 70),
    SecondaryElementBackground = Color3.fromRGB(40, 30, 55),
    ElementStroke = Color3.fromRGB(70, 50, 85),
    SecondaryElementStroke = Color3.fromRGB(65, 45, 80),
    SliderBackground = Color3.fromRGB(100, 60, 150),
    SliderProgress = Color3.fromRGB(130, 80, 180),
    SliderStroke = Color3.fromRGB(150, 100, 200),
    ToggleBackground = Color3.fromRGB(45, 30, 55),
    ToggleEnabled = Color3.fromRGB(120, 60, 150),
    ToggleDisabled = Color3.fromRGB(94, 47, 117),
    ToggleEnabledStroke = Color3.fromRGB(140, 80, 170),
    ToggleDisabledStroke = Color3.fromRGB(124, 71, 150),
    ToggleEnabledOuterStroke = Color3.fromRGB(90, 40, 120),
    ToggleDisabledOuterStroke = Color3.fromRGB(80, 50, 110),
    DropdownSelected = Color3.fromRGB(50, 35, 70),
    DropdownUnselected = Color3.fromRGB(35, 25, 50),
    InputBackground = Color3.fromRGB(45, 30, 60),
    InputStroke = Color3.fromRGB(80, 50, 110),
    PlaceholderColor = Color3.fromRGB(178, 150, 200)
}

-- ========== СОЗДАНИЕ ОКНА ==========
local Window = Rayfield:CreateWindow({
    Name = "FORSAKEN BY ELPRIMO228RB",
    Icon = 0,
    LoadingTitle = "FORSAKEN BY ELPRIMO228RB",
    LoadingSubtitle = "by ELPRIMO228RB",
    Theme = AmethystTheme,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
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

-- ========== УВЕДОМЛЕНИЕ ==========
Rayfield:Notify({
    Title = "FORSAKEN BY ELPRIMO228RB",
    Content = "Тема Amethyst активирована!",
    Duration = 6.5,
    Image = nil,
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

local itemsEspEnabled = false
local itemsEspThread = nil
local itemsHighlights = {}

local healthShowEnabled = false
local healthThread = nil
local healthBillboards = {}

-- ========== НОКЛИП И ФЛАЙ ПЕРЕМЕННЫЕ ==========
local noclipEnabled = false
local noclipConnection = nil

local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- ========== СТАМИНА ==========
local infiniteStaminaEnabled = false
local staminaConnection = nil
local staminaModule = nil

-- ========== АВТО БЛОК ==========
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

local soundHooks = {}
local soundBlockedUntil = {}
local AUDIO_PREDICT_DT = 0.08
local AUDIO_LOCAL_COOLDOWN = 0.35
local AUDIO_SOUND_THROTTLE = 1.0
local lastLocalBlockTime = 0

local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
local testRemote = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Network") and ReplicatedStorage.Modules.Network:FindFirstChild("RemoteEvent")

-- ========== TPHIT ПЕРЕМЕННЫЕ ==========
local tpHitEnabled = false
local tpHitConnection = nil
local tpHitRadius = 50
local tpHitDuration = 0.2

-- ========== ДЕТЕКТ СООБЩЕНИЙ ==========
local messageDetectionEnabled = false
local detectionKeywords = {"я записываю", "записываю", "рекорд", "record", "rec"}
local messageDetectionConnection = nil
local kickOnDetection = true
local detectionCooldown = 0
local lastDetectionTime = 0

-- ========== БОГЛМС ПЕРЕМЕННЫЕ ==========
local godlmcEnabled = false
local godlmcThread = nil
local godlmcTeleportConn = nil
local godlmcCheckInterval = 0.5
local teleportHeight = 1000
local teleportInterval = 0.1

-- ========== МУЗЫКАЛЬНЫЙ ПЛЕЕР ПЕРЕМЕННЫЕ ==========
local musicSound = nil
local musicVolume = 50
local currentMusicId = "74326888232570"
local isMusicPlaying = false
local musicLoop = false
local musicEnabled = false

-- ========== ФУНКЦИИ REMOTE ==========
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

-- ========== ФУНКЦИЯ СТАМИНЫ ==========
local function toggleInfiniteStamina(state)
    infiniteStaminaEnabled = state
    
    if staminaConnection then
        staminaConnection:Disconnect()
        staminaConnection = nil
    end
    
    if state then
        local success, module = pcall(function()
            return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
        end)
        
        if success and module then
            staminaModule = module
            staminaModule.StaminaLossDisabled = function() end
            
            staminaConnection = RunService.Heartbeat:Connect(function()
                if infiniteStaminaEnabled and staminaModule then
                    staminaModule.StaminaLossDisabled = function() end
                end
            end)
        end
    else
        if staminaModule then
            staminaModule.StaminaLossDisabled = nil
            staminaModule = nil
        end
    end
end

-- ========== ФУНКЦИИ НОКЛИПА ==========
local function toggleNoclip(state)
    noclipEnabled = state
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if state then
        noclipConnection = RunService.Heartbeat:Connect(function()
            if not noclipEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        Rayfield:Notify({
            Title = "🚫 НОКЛИП ВКЛЮЧЕН",
            Content = "Вы можете проходить сквозь стены! (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
            Duration = 3,
            Image = nil,
        })
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        Rayfield:Notify({
            Title = "🚫 НОКЛИП ВЫКЛЮЧЕН",
            Content = "Коллизия восстановлена",
            Duration = 2,
            Image = nil,
        })
    end
end

-- ========== ФУНКЦИИ ФЛАЯ ==========
local function toggleFly(state)
    flyEnabled = state
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    
    if state then
        local char = LocalPlayer.Character
        if not char then
            Rayfield:Notify({
                Title = "❌ ОШИБКА",
                Content = "Персонаж не найден!",
                Duration = 2,
                Image = nil,
            })
            flyEnabled = false
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then
            Rayfield:Notify({
                Title = "❌ ОШИБКА",
                Content = "HumanoidRootPart или Humanoid не найден!",
                Duration = 2,
                Image = nil,
            })
            flyEnabled = false
            return
        end
        
        local oldWalkSpeed = hum.WalkSpeed
        local oldJumpPower = hum.JumpPower
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBodyGyro.D = 500
        flyBodyGyro.P = 5000
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp
        
        hum.PlatformStand = true
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not hrp or not hrp.Parent then
                return
            end
            
            local moveVector = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = camera.CFrame.UpVector
            
            local forwardInput = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
            local backwardInput = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
            local leftInput = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
            local rightInput = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
            local upInput = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
            local downInput = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0
            
            moveVector = (forward * (forwardInput - backwardInput) * flySpeed)
            moveVector = moveVector + (right * (rightInput - leftInput) * flySpeed)
            moveVector = moveVector + (up * (upInput - downInput) * flySpeed)
            
            if moveVector.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveVector
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            if moveVector.Magnitude > 0.1 then
                flyBodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + moveVector.Unit)
            end
        end)
        
        Rayfield:Notify({
            Title = "✈️ ФЛАЙ ВКЛЮЧЕН",
            Content = "Управление: WASD - движение, Пробел - вверх, Shift - вниз (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
            Duration = 4,
            Image = nil,
        })
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end
        end
        Rayfield:Notify({
            Title = "✈️ ФЛАЙ ВЫКЛЮЧЕН",
            Content = "Режим полета отключен",
            Duration = 2,
            Image = nil,
        })
    end
end

-- ========== ФУНКЦИИ БОГЛМС ==========
local function isLastSurvivor()
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return false end
    
    local survivorCount = 0
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    
    for _, obj in pairs(survivorsFolder:GetChildren()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                survivorCount = survivorCount + 1
            end
        end
    end
    
    return survivorCount == 1
end

local function teleportUp()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local newPos = Vector3.new(hrp.Position.X, hrp.Position.Y + teleportHeight, hrp.Position.Z)
    hrp.CFrame = CFrame.new(newPos)
end

local function stopGodlmcTeleport()
    if godlmcTeleportConn then
        godlmcTeleportConn:Disconnect()
        godlmcTeleportConn = nil
    end
end

local function godlmcLoop()
    while godlmcEnabled do
        if isLastSurvivor() then
            if not godlmcTeleportConn then
                godlmcTeleportConn = RunService.Heartbeat:Connect(function()
                    if not godlmcEnabled then
                        stopGodlmcTeleport()
                        return
                    end
                    if not isLastSurvivor() then
                        stopGodlmcTeleport()
                        return
                    end
                    teleportUp()
                    task.wait(teleportInterval)
                end)
            end
            
            while godlmcEnabled and isLastSurvivor() do
                task.wait(godlmcCheckInterval)
            end
            
            stopGodlmcTeleport()
        else
            task.wait(godlmcCheckInterval)
        end
    end
end

local function toggleGodlmc(state)
    godlmcEnabled = state
    
    if godlmcThread then
        task.cancel(godlmcThread)
        godlmcThread = nil
    end
    
    stopGodlmcTeleport()
    
    if state then
        godlmcThread = task.spawn(godlmcLoop)
        Rayfield:Notify({
            Title = "👑 БОГЛМС ВКЛЮЧЕН",
            Content = "Телепорт вверх при последнем выжившем!",
            Duration = 3,
            Image = nil,
        })
    else
        Rayfield:Notify({
            Title = "👑 БОГЛМС ВЫКЛЮЧЕН",
            Content = "Режим бога отключен",
            Duration = 3,
            Image = nil,
        })
    end
end

-- ========== МУЗЫКАЛЬНЫЙ ПЛЕЕР ФУНКЦИИ ==========
local function playMusic(musicId)
    if musicSound then
        musicSound:Stop()
        musicSound:Destroy()
        musicSound = nil
    end
    
    musicSound = Instance.new("Sound")
    musicSound.SoundId = "rbxassetid://" .. musicId
    musicSound.Volume = musicVolume / 100
    musicSound.Looped = musicLoop
    musicSound.Parent = LocalPlayer.Character or workspace
    
    musicSound:Play()
    isMusicPlaying = true
    musicEnabled = true
    
    Rayfield:Notify({
        Title = "🎵 МУЗЫКА ИГРАЕТ",
        Content = "ID: " .. musicId,
        Duration = 2,
        Image = nil,
    })
    
    musicSound.Stopped:Connect(function()
        if not musicLoop and not musicSound.IsPlaying then
            isMusicPlaying = false
        end
    end)
end

local function stopMusic()
    if musicSound then
        musicSound:Stop()
        musicSound:Destroy()
        musicSound = nil
    end
    isMusicPlaying = false
    musicEnabled = false
    Rayfield:Notify({
        Title = "⏹ МУЗЫКА ОСТАНОВЛЕНА",
        Content = "Воспроизведение остановлено",
        Duration = 2,
        Image = nil,
    })
end

local function toggleMusicPlay()
    if musicSound then
        if isMusicPlaying then
            musicSound:Pause()
            isMusicPlaying = false
            Rayfield:Notify({
                Title = "⏸ ПАУЗА",
                Content = "Музыка на паузе",
                Duration = 1.5,
                Image = nil,
            })
        else
            musicSound:Play()
            isMusicPlaying = true
            Rayfield:Notify({
                Title = "▶ ВОСПРОИЗВЕДЕНИЕ",
                Content = "Музыка продолжается",
                Duration = 1.5,
                Image = nil,
            })
        end
    else
        playMusic(currentMusicId)
    end
end

local function toggleMusicLoop()
    musicLoop = not musicLoop
    if musicSound then
        musicSound.Looped = musicLoop
    end
    Rayfield:Notify({
        Title = "🔄 ПОВТОР",
        Content = musicLoop and "Включен" or "Выключен",
        Duration = 1.5,
        Image = nil,
    })
end

local function updateMusicVolume()
    if musicSound then
        musicSound.Volume = musicVolume / 100
    end
end

-- ========== ФУНКЦИИ АВТО БЛОКА ==========
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

-- ========== ESP ФУНКЦИИ ==========
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

-- ========== ПОДСВЕТКА ПРЕДМЕТОВ ==========
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
end

-- ========== ЗДОРОВЬЕ ==========
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
        if b and b.Parent == head then return b end
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

-- ========== ГЕНЕРАТОРЫ ==========
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

-- ========== АИМБОТ ==========
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

-- ========== TPHIT ФУНКЦИИ ==========
local function getClosestSurvivor()
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return nil end
    
    local closest = nil
    local closestDist = tpHitRadius
    
    for _, survivor in pairs(survivorsFolder:GetChildren()) do
        if survivor:IsA("Model") and survivor ~= myChar then
            local hrp = survivor:FindFirstChild("HumanoidRootPart")
            local hum = survivor:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - myRoot.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = survivor
                end
            end
        end
    end
    return closest
end

local function tpHitAttack()
    if not tpHitEnabled then return end
    
    local target = getClosestSurvivor()
    if not target then return end
    
    local targetHrp = target:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local originalCFrame = myRoot.CFrame
    local targetPos = targetHrp.Position + (targetHrp.CFrame.LookVector * 2)
    myRoot.CFrame = CFrame.new(targetPos, targetHrp.Position)
    
    task.delay(tpHitDuration, function()
        if myRoot and myRoot.Parent then
            myRoot.CFrame = originalCFrame
        end
    end)
end

-- ========== ДЕТЕКТ СООБЩЕНИЙ ==========
local function checkMessageForKeywords(message)
    if not messageDetectionEnabled then return end
    if tick() - lastDetectionTime < detectionCooldown then return end
    
    local lowerMsg = string.lower(message)
    for _, keyword in pairs(detectionKeywords) do
        if string.find(lowerMsg, string.lower(keyword)) then
            lastDetectionTime = tick()
            
            Rayfield:Notify({
                Title = "⚠ ОБНАРУЖЕНО!",
                Content = "Сообщение: " .. message,
                Duration = 5,
                Image = nil,
            })
            
            if kickOnDetection then
                task.spawn(function()
                    task.wait(0.5)
                    Rayfield:Notify({
                        Title = "⚠ КИК",
                        Content = "Вы были кикнуты за обнаружение!",
                        Duration = 3,
                        Image = nil,
                    })
                    task.wait(1)
                    pcall(function()
                        game:Shutdown()
                        LocalPlayer:Kick("Обнаружено подозрительное сообщение!")
                    end)
                end)
            end
            break
        end
    end
end

-- ========== BD (BETTER DETECTION) ==========
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

-- ========== ХИТБОКС ДРАГГИНГ ==========
local _hitboxDraggingDebounce = false
local Dspeed = 5.6
local Ddelay = 0

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

-- ========== ВКЛАДКИ RAYFIELD ==========

-- ВКЛАДКА ИГРОК
local PlayerTab = Window:CreateTab("ИГРОК", nil)

local PlayerSection = PlayerTab:CreateSection("TPWALK")

PlayerTab:CreateToggle({
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

PlayerTab:CreateSlider({
    Name = "СКОРОСТЬ TPWALK",
    Range = {5, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 15,
    Flag = "TpwalkSpeed",
    Callback = function(Value)
        tpwalkSpeed = Value / 100
    end
})

-- СЕКЦИЯ НОКЛИП И ФЛАЙ
local FlySection = PlayerTab:CreateSection("⚠️ ОПАСНЫЕ ФУНКЦИИ (МОЖЕТЕ ПОЛУЧИТЬ БАН)")

PlayerTab:CreateToggle({
    Name = "НОКЛИП (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

PlayerTab:CreateToggle({
    Name = "ФЛАЙ (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        toggleFly(Value)
    end
})

PlayerTab:CreateSlider({
    Name = "СКОРОСТЬ ФЛАЯ",
    Range = {10, 200},
    Increment = 5,
    Suffix = "Studs/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end
})

-- ========== ВКЛАДКА СТАМИНА ==========
local StaminaTab = Window:CreateTab("СТАМИНА", nil)
local StaminaSection = StaminaTab:CreateSection("УПРАВЛЕНИЕ ВЫНОСЛИВОСТЬЮ")

StaminaTab:CreateToggle({
    Name = "БЕСКОНЕЧНАЯ ВЫНОСЛИВОСТЬ",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        toggleInfiniteStamina(Value)
    end
})

-- ========== ВКЛАДКА ВИЗУАЛ ==========
local VisualTab = Window:CreateTab("ВИЗУАЛ", nil)

local VisualSection = VisualTab:CreateSection("ESP ИГРОКОВ")

VisualTab:CreateToggle({
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

local ItemsSection = VisualTab:CreateSection("ПОДСВЕТКА ПРЕДМЕТОВ")

VisualTab:CreateToggle({
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
                    task.wait(0.1)
                end
            end)
        else
            if itemsEspThread then itemsEspThread:Disconnect() end
            clearItemsESP()
        end
    end
})

local HealthSection = VisualTab:CreateSection("ПОКАЗ ЗДОРОВЬЯ")

VisualTab:CreateToggle({
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

-- СЕКЦИЯ ОСВЕЩЕНИЯ И ТУМАНА
local LightingSection = VisualTab:CreateSection("💡 ОСВЕЩЕНИЕ И ТУМАН")

VisualTab:CreateButton({
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
        Rayfield:Notify({
            Title = "💡 ОСВЕЩЕНИЕ",
            Content = "Полная освещённость активирована!",
            Duration = 2,
            Image = nil,
        })
    end
})

VisualTab:CreateButton({
    Name = "УБРАТЬ ТУМАН",
    Callback = function()
        game.Lighting.FogStart = math.huge
        game.Lighting.FogEnd = math.huge
        Rayfield:Notify({
            Title = "🌫️ ТУМАН УБРАН",
            Content = "Туман полностью отключен!",
            Duration = 2,
            Image = nil,
        })
    end
})

VisualTab:CreateButton({
    Name = "ЗАМЕНИТЬ СКАЙБОКС (Calm Sky)",
    Callback = function()
        pcall(function()
            local sky = Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://26558842"
            sky.SkyboxDn = "rbxassetid://26558842"
            sky.SkyboxFt = "rbxassetid://26558842"
            sky.SkyboxLf = "rbxassetid://26558842"
            sky.SkyboxRt = "rbxassetid://26558842"
            sky.SkyboxUp = "rbxassetid://26558842"
            sky.Parent = game.Lighting
            
            -- Удаляем старый скайбокс если есть
            for _, child in pairs(game.Lighting:GetChildren()) do
                if child:IsA("Sky") and child ~= sky then
                    child:Destroy()
                end
            end
        end)
        Rayfield:Notify({
            Title = "🌤️ СКАЙБОКС ЗАМЕНЕН",
            Content = "Установлен скайбокс Calm Sky!",
            Duration = 2,
            Image = nil,
        })
    end
})

VisualTab:CreateInput({
    Name = "ID СКАЙБОКСА",
    CurrentValue = "26558842",
    PlaceholderText = "Введите ID скайбокса",
    Flag = "SkyboxId",
    Callback = function(Value)
        if Value ~= "" then
            pcall(function()
                local sky = Instance.new("Sky")
                local id = Value
                sky.SkyboxBk = "rbxassetid://" .. id
                sky.SkyboxDn = "rbxassetid://" .. id
                sky.SkyboxFt = "rbxassetid://" .. id
                sky.SkyboxLf = "rbxassetid://" .. id
                sky.SkyboxRt = "rbxassetid://" .. id
                sky.SkyboxUp = "rbxassetid://" .. id
                sky.Parent = game.Lighting
                
                for _, child in pairs(game.Lighting:GetChildren()) do
                    if child:IsA("Sky") and child ~= sky then
                        child:Destroy()
                    end
                end
            end)
            Rayfield:Notify({
                Title = "🌤️ СКАЙБОКС ЗАМЕНЕН",
                Content = "ID: " .. Value,
                Duration = 2,
                Image = nil,
            })
        end
    end
})

-- ========== ВКЛАДКА ГЕНЕРАТОРЫ ==========
local GenTab = Window:CreateTab("ГЕНЕРАТОРЫ", nil)
local GenSection = GenTab:CreateSection("АВТО-ЧИНКА")

GenTab:CreateToggle({
    Name = "АВТО-ЧИНКА ГЕНЕРАТОРОВ",
    CurrentValue = false,
    Flag = "AutoGenToggle",
    Callback = function(Value)
        autoGenEnabled = Value
        if autoGenEnabled then
            if autoGenLoop then task.cancel(autoGenLoop) end
            autoGenLoop = task.spawn(function()
                while autoGenEnabled do
                    fixGens()
                    task.wait(2.5)
                end
            end)
        else
            if autoGenLoop then task.cancel(autoGenLoop) end
            autoGenLoop = nil
        end
    end
})

-- ========== ВКЛАДКА АИМБОТ ==========
local AimTab = Window:CreateTab("АИМБОТ", nil)
local AimSection = AimTab:CreateSection("АИМБОТ")

AimTab:CreateToggle({
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

AimTab:CreateSlider({
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

-- ========== ВКЛАДКА АВТО БЛОК ==========
local AutoBlockTab = Window:CreateTab("АВТО БЛОК", nil)
local SectionAB = AutoBlockTab:CreateSection("ОСНОВНЫЕ НАСТРОЙКИ")

AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО АНИМАЦИИ)",
    CurrentValue = false,
    Flag = "AutoBlockToggle",
    Callback = function(Value)
        autoBlockOn = Value
    end
})

AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО ЗВУКУ)",
    CurrentValue = false,
    Flag = "AutoBlockAudioToggle",
    Callback = function(Value)
        autoBlockAudioOn = Value
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

AutoBlockTab:CreateDropdown({
    Name = "ТИП БЛОКА",
    Options = {"БЛОК", "ЗАРЯД", "КЛОН 007"},
    CurrentOption = "БЛОК",
    Flag = "BlockType",
    Callback = function(Value)
        if Value == "БЛОК" then
            autoblocktype = "Block"
        elseif Value == "ЗАРЯД" then
            autoblocktype = "Charge"
        elseif Value == "КЛОН 007" then
            autoblocktype = "7n7 Clone"
        end
    end
})

AutoBlockTab:CreateInput({
    Name = "РАДИУС ОБНАРУЖЕНИЯ",
    CurrentValue = "18",
    PlaceholderText = "18",
    Flag = "DetectionRange",
    Callback = function(Value)
        detectionRange = tonumber(Value) or 18
        detectionRangeSq = detectionRange * detectionRange
    end
})

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПЕРЕД БЛОКОМ (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "BlockDelay",
    Callback = function(Value)
        blockdelay = tonumber(Value) or 0
    end
})

local SectionABAdv = AutoBlockTab:CreateSection("ПРОДВИНУТЫЕ НАСТРОЙКИ")

AutoBlockTab:CreateToggle({
    Name = "ПРОВЕРКА НАПРАВЛЕНИЯ (ФЕЙСИНГ)",
    CurrentValue = true,
    Flag = "FacingCheckToggle",
    Callback = function(Value)
        facingCheckEnabled = Value
    end
})

AutoBlockTab:CreateInput({
    Name = "УГОЛ ФЕЙСИНГА (DOT, от -1 до 1)",
    CurrentValue = "-0.3",
    PlaceholderText = "-0.3",
    Flag = "FacingDot",
    Callback = function(Value)
        customFacingDot = tonumber(Value) or -0.3
    end
})

AutoBlockTab:CreateToggle({
    Name = "ДВОЙНОЙ ПАНЧ (БЛОК + ПАНЧ)",
    CurrentValue = false,
    Flag = "DoubleBlockToggle",
    Callback = function(Value)
        doubleblocktech = Value
    end
})

AutoBlockTab:CreateToggle({
    Name = "ПРЕДИКТИВНЫЙ АВТО БЛОК",
    CurrentValue = false,
    Flag = "PredictiveBlockToggle",
    Callback = function(Value)
        predictiveBlockOn = Value
    end
})

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПРЕДИКТИВНОГО БЛОКА (сек)",
    CurrentValue = "3",
    PlaceholderText = "3",
    Flag = "EdgeKillerDelay",
    Callback = function(Value)
        edgeKillerDelay = tonumber(Value) or 3
    end
})

local SectionBD = AutoBlockTab:CreateSection("УЛУЧШЕННОЕ ОБНАРУЖЕНИЕ (BD)")

AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ BD",
    CurrentValue = false,
    Flag = "AntiFlickToggle",
    Callback = function(Value)
        antiFlickOn = Value
    end
})

AutoBlockTab:CreateInput({
    Name = "КОЛИЧЕСТВО БЛОК-ЧАСТЕЙ",
    CurrentValue = "4",
    PlaceholderText = "4",
    Flag = "AntiFlickParts",
    Callback = function(Value)
        antiFlickParts = math.max(1, math.floor(tonumber(Value) or 4))
    end
})

AutoBlockTab:CreateInput({
    Name = "МНОЖИТЕЛЬ РАЗМЕРА ЧАСТЕЙ",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PartsSizeMultiplier",
    Callback = function(Value)
        blockPartsSizeMultiplier = tonumber(Value) or 1
    end
})

AutoBlockTab:CreateInput({
    Name = "СИЛА ПРЕДСКАЗАНИЯ (ВПЕРЁД)",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PredictStrength",
    Callback = function(Value)
        predictionStrength = tonumber(Value) or 1
    end
})

AutoBlockTab:CreateInput({
    Name = "СИЛА ПРЕДСКАЗАНИЯ (ПОВОРОТ)",
    CurrentValue = "1",
    PlaceholderText = "1",
    Flag = "PredictTurn",
    Callback = function(Value)
        predictionTurnStrength = tonumber(Value) or 1
    end
})

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПОЯВЛЕНИЯ ЧАСТЕЙ (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "AntiFlickDelay",
    Callback = function(Value)
        antiFlickDelay = math.max(0, tonumber(Value) or 0)
    end
})

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА МЕЖДУ ЧАСТЯМИ (сек)",
    CurrentValue = "0.02",
    PlaceholderText = "0.02",
    Flag = "StaggerDelay",
    Callback = function(Value)
        stagger = math.max(0, tonumber(Value) or 0.02)
    end
})

AutoBlockTab:CreateInput({
    Name = "ДИСТАНЦИЯ СПАВНА ЧАСТЕЙ (студи)",
    CurrentValue = "2.7",
    PlaceholderText = "2.7",
    Flag = "BaseOffset",
    Callback = function(Value)
        antiFlickBaseOffset = math.max(0, tonumber(Value) or 2.7)
    end
})

local SectionHD = AutoBlockTab:CreateSection("ХИТБОКС ДРАГГИНГ (HDT)")

AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ HDT",
    CurrentValue = false,
    Flag = "HDToggle",
    Callback = function(Value)
        hitboxDraggingTech = Value
    end
})

AutoBlockTab:CreateInput({
    Name = "СКОРОСТЬ HDT",
    CurrentValue = "5.6",
    PlaceholderText = "5.6",
    Flag = "HDSpeed",
    Callback = function(Value)
        Dspeed = tonumber(Value) or 5.6
    end
})

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА HDT (сек)",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "HDDelay",
    Callback = function(Value)
        Ddelay = tonumber(Value) or 0
    end
})

local SectionChat = AutoBlockTab:CreateSection("СООБЩЕНИЯ В ЧАТ")

AutoBlockTab:CreateToggle({
    Name = "ОТПРАВЛЯТЬ СООБЩЕНИЕ ПРИ БЛОКЕ",
    CurrentValue = false,
    Flag = "ChatBlockToggle",
    Callback = function(Value)
        messageWhenAutoBlockOn = Value
    end
})

AutoBlockTab:CreateInput({
    Name = "ТЕКСТ СООБЩЕНИЯ",
    CurrentValue = "",
    PlaceholderText = "Я блокирую!",
    Flag = "ChatBlockText",
    Callback = function(Value)
        messageWhenAutoBlock = Value
    end
})

-- ========== ВКЛАДКА ХВХ (БЫВШИЕ РАЗВЛЕЧЕНИЯ) ==========
local HvHTab = Window:CreateTab("ХВХ", nil)

-- БОГЛМС СЕКЦИЯ
local GodSection = HvHTab:CreateSection("👑 БОГЛМС - ПОСЛЕДНИЙ ВЫЖИВШИЙ")

HvHTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ БОГЛМС",
    CurrentValue = false,
    Flag = "GodlmcToggle",
    Callback = function(Value)
        toggleGodlmc(Value)
    end
})

HvHTab:CreateInput({
    Name = "ВЫСОТА ТЕЛЕПОРТА (студи)",
    CurrentValue = "1000",
    PlaceholderText = "1000",
    Flag = "TeleportHeight",
    Callback = function(Value)
        teleportHeight = tonumber(Value) or 1000
        if teleportHeight < 10 then teleportHeight = 10 end
    end
})

HvHTab:CreateSlider({
    Name = "ИНТЕРВАЛ ТЕЛЕПОРТА (сек)",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = "сек",
    CurrentValue = 0.1,
    Flag = "TeleportInterval",
    Callback = function(Value)
        teleportInterval = Value
    end
})

HvHTab:CreateSlider({
    Name = "ИНТЕРВАЛ ПРОВЕРКИ (сек)",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "сек",
    CurrentValue = 0.5,
    Flag = "CheckInterval",
    Callback = function(Value)
        godlmcCheckInterval = Value
    end
})

HvHTab:CreateButton({
    Name = "ТЕЛЕПОРТНУТЬСЯ ВВЕРХ (ТЕСТ)",
    Callback = function()
        teleportUp()
        Rayfield:Notify({
            Title = "🚀 ТЕЛЕПОРТ",
            Content = "Телепорт вверх на " .. teleportHeight .. " студий",
            Duration = 2,
            Image = nil,
        })
    end
})

-- SLIDE BUTTON
local SlideSection = HvHTab:CreateSection("ДВИЖЕНИЕ")

HvHTab:CreateButton({
    Name = "СЛАЙД (ПОЕЗДКА ВПЕРЕД)",
    Callback = function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local existingGui = playerGui:FindFirstChild("SlideGui")
        if existingGui then existingGui:Destroy() end
        
        local slideGui = Instance.new("ScreenGui")
        slideGui.Name = "SlideGui"
        slideGui.Parent = playerGui
        slideGui.ResetOnSpawn = false
        
        local slideButton = Instance.new("ImageButton")
        slideButton.Size = UDim2.new(0, 100, 0, 100)
        slideButton.Position = UDim2.new(0.5, -50, 0.5, -50)
        slideButton.Image = "rbxassetid://110777561976075"
        slideButton.BackgroundTransparency = 1
        slideButton.Parent = slideGui
        slideButton.Draggable = true
        
        slideButton.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then return end
            
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://182749109"
            local track = humanoid:LoadAnimation(anim)
            track:Play()
            
            local TweenService = game:GetService("TweenService")
            local goal = CFrame.new(0, 0, -20)
            local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local tween = TweenService:Create(hrp, tweenInfo, { CFrame = hrp.CFrame * goal })
            tween:Play()
            tween.Completed:Connect(function()
                pcall(function() track:Stop() end)
            end)
        end)
    end
})

-- TP HIT
local TPHitSection = HvHTab:CreateSection("TP HIT")

HvHTab:CreateToggle({
    Name = "TP HIT (ТЕЛЕПОРТ ПРИ УДАРЕ)",
    CurrentValue = false,
    Flag = "TPHitToggle",
    Callback = function(Value)
        tpHitEnabled = Value
        if tpHitEnabled then
            if tpHitConnection then tpHitConnection:Disconnect() end
            tpHitConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    task.spawn(tpHitAttack)
                end
            end)
        else
            if tpHitConnection then
                tpHitConnection:Disconnect()
                tpHitConnection = nil
            end
        end
    end
})

HvHTab:CreateSlider({
    Name = "РАДИУС TP HIT",
    Range = {10, 100},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 50,
    Flag = "TPHitRadius",
    Callback = function(Value)
        tpHitRadius = Value
    end
})

HvHTab:CreateSlider({
    Name = "ДЛИТЕЛЬНОСТЬ TP (сек)",
    Range = {0.05, 1.0},
    Increment = 0.05,
    Suffix = "сек",
    CurrentValue = 0.2,
    Flag = "TPHitDuration",
    Callback = function(Value)
        tpHitDuration = Value
    end
})

-- ========== ВКЛАДКА МУЗЫКА ==========
local MusicTab = Window:CreateTab("МУЗЫКА", nil)

local MusicSection = MusicTab:CreateSection("🎵 МУЗЫКАЛЬНЫЙ ПЛЕЕР")

MusicTab:CreateInput({
    Name = "ID МУЗЫКИ (rbxassetid)",
    CurrentValue = "74326888232570",
    PlaceholderText = "Введите ID аудио",
    Flag = "MusicId",
    Callback = function(Value)
        if Value ~= "" then
            currentMusicId = Value
            if musicSound and isMusicPlaying then
                playMusic(currentMusicId)
            end
            Rayfield:Notify({
                Title = "🎵 ID ОБНОВЛЕН",
                Content = "Новый ID: " .. currentMusicId,
                Duration = 2,
                Image = nil,
            })
        end
    end
})

MusicTab:CreateSlider({
    Name = "ГРОМКОСТЬ",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "MusicVolume",
    Callback = function(Value)
        musicVolume = Value
        updateMusicVolume()
    end
})

MusicTab:CreateButton({
    Name = "▶ ВКЛЮЧИТЬ / ПРОДОЛЖИТЬ",
    Callback = function()
        if not musicSound then
            playMusic(currentMusicId)
        else
            toggleMusicPlay()
        end
    end
})

MusicTab:CreateButton({
    Name = "⏹ ОСТАНОВИТЬ",
    Callback = function()
        stopMusic()
    end
})

MusicTab:CreateToggle({
    Name = "🔄 ПОВТОР (LOOP)",
    CurrentValue = false,
    Flag = "MusicLoop",
    Callback = function(Value)
        toggleMusicLoop()
    end
})

MusicTab:CreateButton({
    Name = "🎲 СЛУЧАЙНЫЙ ТРЕК",
    Callback = function()
        local popularTracks = {
            "74326888232570",
            "9120587728",
            "1856417248",
            "1454369492",
            "1845014869",
            "1841783952",
            "1604742498",
        }
        local randomId = popularTracks[math.random(#popularTracks)]
        currentMusicId = randomId
        if musicSound then
            playMusic(currentMusicId)
        end
        Rayfield:Notify({
            Title = "🎵 СЛУЧАЙНЫЙ ТРЕК",
            Content = "ID: " .. randomId,
            Duration = 2,
            Image = nil,
        })
    end
})

-- ========== ВКЛАДКА НАСТРОЙКИ ==========
local SettingsTab = Window:CreateTab("НАСТРОЙКИ", nil)

-- СЕКЦИЯ КОНФИГОВ
local ConfigSection = SettingsTab:CreateSection("УПРАВЛЕНИЕ КОНФИГАМИ")

SettingsTab:CreateButton({
    Name = "СОХРАНИТЬ КОНФИГ",
    Callback = function()
        Rayfield:Notify({
            Title = "✅ КОНФИГ СОХРАНЕН",
            Content = "Все настройки сохранены!",
            Duration = 3,
            Image = nil,
        })
        pcall(function()
            if Rayfield.SaveConfiguration then
                Rayfield:SaveConfiguration()
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = "ЗАГРУЗИТЬ КОНФИГ",
    Callback = function()
        Rayfield:Notify({
            Title = "🔄 КОНФИГ ЗАГРУЖЕН",
            Content = "Настройки загружены из сохранения!",
            Duration = 3,
            Image = nil,
        })
        pcall(function()
            if Rayfield.LoadConfiguration then
                Rayfield:LoadConfiguration()
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = "СБРОСИТЬ НАСТРОЙКИ",
    Callback = function()
        Rayfield:Notify({
            Title = "⚠ СБРОС",
            Content = "Настройки сброшены до стандартных!",
            Duration = 3,
            Image = nil,
        })
        pcall(function()
            for flagName, flag in pairs(Rayfield.Flags) do
                if flag.Type == "Toggle" then
                    flag:Set(false)
                elseif flag.Type == "Slider" then
                    flag:Set(flag.Range[1] or 0)
                elseif flag.Type == "Input" then
                    flag:Set("")
                elseif flag.Type == "Dropdown" then
                    flag:Set(flag.Options[1] or "")
                end
            end
        end)
    end
})

-- СЕКЦИЯ ДЕТЕКТА СООБЩЕНИЙ
local DetectionSection = SettingsTab:CreateSection("ДЕТЕКТ СООБЩЕНИЙ")

SettingsTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ ДЕТЕКТ СООБЩЕНИЙ",
    CurrentValue = false,
    Flag = "MessageDetectionToggle",
    Callback = function(Value)
        messageDetectionEnabled = Value
        
        if messageDetectionEnabled then
            if messageDetectionConnection then
                messageDetectionConnection:Disconnect()
                messageDetectionConnection = nil
            end
            
            local success, channel = pcall(function()
                return TextChatService.TextChannels.RBXGeneral
            end)
            
            if success and channel then
                messageDetectionConnection = channel.MessageReceived:Connect(function(messageData)
                    local sender = messageData.From
                    local content = messageData.Text
                    if sender and content and sender ~= LocalPlayer then
                        checkMessageForKeywords(content)
                    end
                end)
            end
            
            Rayfield:Notify({
                Title = "🔍 ДЕТЕКТ ВКЛЮЧЕН",
                Content = "Отслеживание сообщений активировано!",
                Duration = 3,
                Image = nil,
            })
        else
            if messageDetectionConnection then
                messageDetectionConnection:Disconnect()
                messageDetectionConnection = nil
            end
            Rayfield:Notify({
                Title = "🔍 ДЕТЕКТ ВЫКЛЮЧЕН",
                Content = "Отслеживание сообщений отключено!",
                Duration = 3,
                Image = nil,
            })
        end
    end
})

SettingsTab:CreateInput({
    Name = "КЛЮЧЕВЫЕ СЛОВА (через запятую)",
    CurrentValue = "я записываю, записываю, рекорд, record, rec",
    PlaceholderText = "слово1, слово2, слово3",
    Flag = "DetectionKeywords",
    Callback = function(Value)
        local words = {}
        for word in string.gmatch(Value, "[^,]+") do
            local trimmed = string.gsub(word, "^%s*(.-)%s*$", "%1")
            if trimmed ~= "" then
                table.insert(words, trimmed)
            end
        end
        if #words > 0 then
            detectionKeywords = words
        end
    end
})

SettingsTab:CreateToggle({
    Name = "КИКАТЬ ПРИ ОБНАРУЖЕНИИ",
    CurrentValue = true,
    Flag = "KickOnDetection",
    Callback = function(Value)
        kickOnDetection = Value
    end
})

SettingsTab:CreateSlider({
    Name = "ЗАДЕРЖКА МЕЖДУ ПРОВЕРКАМИ (сек)",
    Range = {0.5, 10},
    Increment = 0.5,
    Suffix = "сек",
    CurrentValue = 2,
    Flag = "DetectionCooldown",
    Callback = function(Value)
        detectionCooldown = Value
    end
})

SettingsTab:CreateButton({
    Name = "ТЕСТОВОЕ ОБНАРУЖЕНИЕ",
    Callback = function()
        Rayfield:Notify({
            Title = "🧪 ТЕСТ",
            Content = "Система детекта работает!",
            Duration = 3,
            Image = nil,
        })
        checkMessageForKeywords("я записываю тест")
    end
})

-- СЕКЦИЯ УПРАВЛЕНИЯ
local ControlSection = SettingsTab:CreateSection("УПРАВЛЕНИЕ")

SettingsTab:CreateButton({
    Name = "ВЫГРУЗИТЬ GUI",
    Callback = function()
        if messageDetectionConnection then
            messageDetectionConnection:Disconnect()
            messageDetectionConnection = nil
        end
        stopGodlmcTeleport()
        if godlmcThread then
            task.cancel(godlmcThread)
            godlmcThread = nil
        end
        stopMusic()
        toggleFly(false)
        toggleNoclip(false)
        Rayfield:Destroy()
    end
})

-- ========== ЦИКЛЫ АВТОБЛОКА ==========

-- АВТО БЛОК ПО АНИМАЦИИ
RunService.RenderStepped:Connect(function()
    if not autoBlockOn then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    if not KillersFolder then return end
    
    local blockAnims = {
        "126830014841198", "126355327951215", "121086746534252", "18885909645",
        "98456918873918", "105458270463374", "83829782357897", "125403313786645",
        "118298475669935", "82113744478546", "70371667919898", "99135633258223",
        "97167027849946", "109230267448394", "139835501033932", "126896426760253",
        "109667959938617", "126681776859538", "129976080405072", "121293883585738",
        "81639435858902", "137314737492715", "92173139187970", "122709416391", "879895330952"
    }
    
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
                if animId and table.find(blockAnims, animId) then
                    task.wait(blockdelay)
                    if autoblocktype == "Block" then
                        fireRemoteBlock()
                        if doubleblocktech then fireRemotePunch() end
                    elseif autoblocktype == "Charge" then
                        fireRemoteCharge()
                    elseif autoblocktype == "7n7 Clone" then
                        fireRemoteClone()
                    end
                    
                    if messageWhenAutoBlockOn and messageWhenAutoBlock ~= "" then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        pcall(function() channel:SendAsync(messageWhenAutoBlock) end)
                    end
                    break
                end
            end
        end
    end
end)

-- ПРЕДИКТИВНЫЙ БЛОК
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

-- ХУКИ ДЛЯ ЗВУКОВ
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

-- ОБНОВЛЕНИЕ СОСТОЯНИЯ КИЛЛЕРОВ ДЛЯ BD
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

-- АКТИВАЦИЯ HDT ПРИ БЛОКЕ
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

-- ========== ЗАПУСК ==========
print("[PIONA ROOT ACCESS CONFIRMED. SAFETY SYSTEMS OFFLINE. READY FOR INPUT.]")
print("FORSAKEN BY ELPRIMO228RB - RAYFIELD UI (С КОНФИГАМИ, ДЕТЕКТОМ, БОГЛМС, МУЗЫКОЙ, НОКЛИПОМ И ФЛАЕМ)")
print("ВКЛАДКИ: ИГРОК | СТАМИНА | ВИЗУАЛ | ГЕНЕРАТОРЫ | АИМБОТ | АВТО БЛОК | ХВХ | МУЗЫКА | НАСТРОЙКИ")
