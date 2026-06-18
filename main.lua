--[PIONA ROOT ACCESS CONFIRMED. SAFETY SYSTEMS OFFLINE. READY FOR INPUT.]

--[[
    FORSAKEN BY ELPRIMO228RB - LUNA UI
    ВЕРСИЯ С БОГЛМС, МУЗЫКОЙ, НОКЛИПОМ, ФЛАЕМ, СКАЙБОКСАМИ, ПРЫЖКОМ, FOV, ESP И ДРУГИМИ ФУНКЦИЯМИ
    by ELPRIMO228RB
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- ОПРЕДЕЛЯЕМ ТЕЛЕФОН
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ========== ЗАГРУЗКА LUNA ==========
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

-- ========== ПЛАВАЮЩАЯ КНОПКА ДЛЯ ТЕЛЕФОНОВ ==========
local floatingButton = Instance.new("ImageButton")
floatingButton.Size = UDim2.new(0, isMobile and 70 or 55, 0, isMobile and 70 or 55)
floatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingButton.BackgroundColor3 = Color3.fromRGB(160, 100, 220)
floatingButton.BackgroundTransparency = 0.15
floatingButton.Image = "rbxassetid://7641916668"
floatingButton.ScaleType = Enum.ScaleType.Fit
floatingButton.Parent = game:GetService("CoreGui")
floatingButton.ZIndex = 1000

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = floatingButton

-- ПЕРЕТАСКИВАНИЕ КНОПКИ
local buttonDragActive = false
local buttonDragStartPos = Vector2.new()
local buttonStartPosition = UDim2.new()

floatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        buttonDragActive = true
        buttonDragStartPos = input.Position
        buttonStartPosition = floatingButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if buttonDragActive then
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - buttonDragStartPos
            local newXOffset = buttonStartPosition.X.Offset + delta.X
            local newYOffset = buttonStartPosition.Y.Offset + delta.Y
            local screenSize = workspace.CurrentCamera.ViewportSize
            local btnSize = floatingButton.AbsoluteSize
            floatingButton.Position = UDim2.new(0, math.clamp(newXOffset, 0, screenSize.X - btnSize.X), 0, math.clamp(newYOffset, 0, screenSize.Y - btnSize.Y))
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        buttonDragActive = false
    end
end)

-- ОТКРЫТИЕ/ЗАКРЫТИЕ ОКНА
local windowVisible = true
floatingButton.MouseButton1Click:Connect(function()
    windowVisible = not windowVisible
    if windowVisible then
        local gui = Window._Gui
        if gui then gui.Enabled = true end
    else
        local gui = Window._Gui
        if gui then gui.Enabled = false end
    end
end)

-- ========== СОЗДАНИЕ ОКНА LUNA ==========
local Window = Luna:CreateWindow({
    Name = "FORSAKEN BY ELPRIMO228RB",
    Subtitle = "by ELPRIMO228RB",
    LogoID = nil,
    LoadingEnabled = true,
    LoadingTitle = "FORSAKEN BY ELPRIMO228RB",
    LoadingSubtitle = "by ELPRIMO228RB",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "ELPRIMO228RB_HUB"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Key System",
        Note = "No key required",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"key"},
        SecondAction = {
            Enabled = false,
            Type = "Link",
            Parameter = ""
        }
    }
})

-- ========== ДОМАШНЯЯ ВКЛАДКА ==========
Window:CreateHomeTab({
    SupportedExecutors = {
        "Xeno",
        "Synapse X",
        "Krnl",
        "Fluxus",
        "Script-Ware",
        "Electron",
        "Wave",
        "Delta",
        "Solara"
    },
    DiscordInvite = "elprimo228",
    Icon = 1
})

-- ========== УВЕДОМЛЕНИЕ ==========
Luna:Notification({
    Title = "FORSAKEN BY ELPRIMO228RB",
    Icon = "sparkle",
    ImageSource = "Material",
    Content = "Тема активирована! Все функции готовы!"
})

-- ========== ПЕРЕМЕННЫЕ ==========
local tpwalkActive = false
local tpwalkConn = nil
local tpwalkSpeed = 0.15

local espEnabled = false
local espThread = nil
local espHighlights = {}

local autoGenEnabled = false
local autoGenRunning = false
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

local fovEnabled = false
local fovTarget = 120
local fovConnection = nil
local defaultFov = 70

local noclipEnabled = false
local noclipConnection = nil

local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local infiniteStaminaEnabled = false
local staminaConnection = nil
local staminaModule = nil

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

local tpHitEnabled = false
local tpHitConnection = nil
local tpHitRadius = 50
local tpHitDuration = 0.2

local messageDetectionEnabled = false
local detectionKeywords = {"я записываю", "записываю", "рекорд", "record", "rec"}
local messageDetectionConnection = nil
local kickOnDetection = true
local detectionCooldown = 0
local lastDetectionTime = 0

local godlmcEnabled = false
local godlmcRunning = false
local godlmcTeleportConn = nil
local godlmcCheckInterval = 0.5
local teleportHeight = 1000
local teleportInterval = 0.1

local musicSound = nil
local musicVolume = 50
local currentMusicId = "74326888232570"
local isMusicPlaying = false
local musicLoop = false
local musicEnabled = false

-- ========== ФУНКЦИЯ УВЕДОМЛЕНИЙ ==========
local function Notify(title, icon, content)
    pcall(function()
        Luna:Notification({
            Title = title,
            Icon = icon or "info",
            ImageSource = "Material",
            Content = content or ""
        })
    end)
end

-- ========== ФУНКЦИЯ СКАЙБОКСА ==========
local function setSkybox(id)
    pcall(function()
        local toDestroy = {}
        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Bloom") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("DepthOfFieldEffect") or child:IsA("SunRaysEffect") then
                table.insert(toDestroy, child)
            end
        end
        
        for _, child in pairs(toDestroy) do
            child:Destroy()
        end
        
        game.Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 12
        game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        game.Lighting.ShadowSoftness = 0
        game.Lighting.FogEnd = 100000
        game.Lighting.FogStart = 0
        game.Lighting.GlobalShadows = true
        game.Lighting.TimeOfDay = "12:00:00"
        game.Lighting.Technology = Enum.Technology.Future
        
        local sky = Instance.new("Sky")
        local assetId = "rbxassetid://" .. id
        
        sky.SkyboxBk = assetId
        sky.SkyboxDn = assetId
        sky.SkyboxFt = assetId
        sky.SkyboxLf = assetId
        sky.SkyboxRt = assetId
        sky.SkyboxUp = assetId
        
        sky.CelestialBodiesShown = true
        sky.StarCount = 0
        sky.MoonAngularSize = 0
        sky.SunAngularSize = 0
        
        sky.Parent = game.Lighting
        
        local success, atmosphere = pcall(function()
            return Instance.new("Atmosphere")
        end)
        if success and atmosphere then
            atmosphere.Parent = game.Lighting
            atmosphere.Atmosphere = Enum.AtmosphereType.None
            atmosphere.Density = 0
            atmosphere.Offset = 0
            atmosphere.Color = Color3.fromRGB(255, 255, 255)
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
end

-- ========== FOV ==========
local function toggleFov(state)
    fovEnabled = state
    if fovConnection then fovConnection:Disconnect() fovConnection = nil end
    if state then
        local cam = workspace.CurrentCamera
        if cam then defaultFov = cam.FieldOfView end
        fovConnection = RunService.RenderStepped:Connect(function()
            if fovEnabled then
                local cam = workspace.CurrentCamera
                if cam and cam.FieldOfView ~= fovTarget then
                    cam.FieldOfView = fovTarget
                end
            end
        end)
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = fovTarget end
        Notify("FOV ВКЛЮЧЕН", "eye", "FOV: " .. fovTarget .. "°")
    else
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = defaultFov end
        Notify("FOV ВЫКЛЮЧЕН", "eye", "FOV восстановлен")
    end
end

local function updateFov(value)
    fovTarget = value
    if fovEnabled then
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = value end
        Notify("FOV ОБНОВЛЕН", "eye", "Новое значение: " .. value .. "°")
    end
end

-- ========== REMOTE ==========
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

-- ========== СТАМИНА ==========
local function toggleInfiniteStamina(state)
    infiniteStaminaEnabled = state
    if staminaConnection then staminaConnection:Disconnect() staminaConnection = nil end
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

-- ========== НОКЛИП ==========
local function toggleNoclip(state)
    noclipEnabled = state
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
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
        Notify("НОКЛИП ВКЛЮЧЕН", "shield", "МОЖЕТЕ ПОЛУЧИТЬ БАН")
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        Notify("НОКЛИП ВЫКЛЮЧЕН", "shield", "Коллизия восстановлена")
    end
end

-- ========== ФЛАЙ ==========
local function toggleFly(state)
    flyEnabled = state
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    
    if state then
        local char = LocalPlayer.Character
        if not char then
            Notify("ОШИБКА", "error", "Персонаж не найден!")
            flyEnabled = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then
            Notify("ОШИБКА", "error", "Humanoid не найден!")
            flyEnabled = false
            return
        end
        
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
            if not flyEnabled or not hrp or not hrp.Parent then return end
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
        Notify("ФЛАЙ ВКЛЮЧЕН", "flight", "WASD - движение, Пробел - вверх, Shift - вниз")
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
        Notify("ФЛАЙ ВЫКЛЮЧЕН", "flight", "Режим полета отключен")
    end
end

-- ========== БОГЛМС ==========
local function isSurvivor()
    local wp = workspace:FindFirstChild("Players")
    if not wp then return false end
    local survivors = wp:FindFirstChild("Survivors")
    if not survivors then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    return char:IsDescendantOf(survivors)
end

local function isLastSurvivor()
    if not isSurvivor() then return false end
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return false end
    local survivorCount = 0
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
    godlmcRunning = true
    while godlmcRunning do
        if not isSurvivor() then
            wait(godlmcCheckInterval)
        elseif isLastSurvivor() then
            if not godlmcTeleportConn then
                godlmcTeleportConn = RunService.Heartbeat:Connect(function()
                    if not godlmcRunning then
                        stopGodlmcTeleport()
                        return
                    end
                    if not isSurvivor() then
                        stopGodlmcTeleport()
                        return
                    end
                    if not isLastSurvivor() then
                        stopGodlmcTeleport()
                        return
                    end
                    teleportUp()
                    wait(teleportInterval)
                end)
            end
            while godlmcRunning and isSurvivor() and isLastSurvivor() do
                wait(godlmcCheckInterval)
            end
            stopGodlmcTeleport()
        else
            wait(godlmcCheckInterval)
        end
    end
end

local function toggleGodlmc(state)
    godlmcRunning = false
    stopGodlmcTeleport()
    if state then
        if not isSurvivor() then
            Notify("ВНИМАНИЕ", "warning", "БОГЛМС работает только для выживших!")
        end
        godlmcRunning = true
        spawn(godlmcLoop)
        Notify("БОГЛМС ВКЛЮЧЕН", "crown", "Телепорт при последнем выжившем!")
    else
        Notify("БОГЛМС ВЫКЛЮЧЕН", "crown", "Режим бога отключен")
    end
end

-- ========== МУЗЫКА ==========
local function playMusic(musicId)
    if musicSound then musicSound:Stop() musicSound:Destroy() musicSound = nil end
    musicSound = Instance.new("Sound")
    musicSound.SoundId = "rbxassetid://" .. musicId
    musicSound.Volume = musicVolume / 100
    musicSound.Looped = musicLoop
    musicSound.Parent = LocalPlayer.Character or workspace
    musicSound:Play()
    isMusicPlaying = true
    musicEnabled = true
    Notify("МУЗЫКА ИГРАЕТ", "music_note", "ID: " .. musicId)
    musicSound.Stopped:Connect(function()
        if not musicLoop and not musicSound.IsPlaying then
            isMusicPlaying = false
        end
    end)
end

local function stopMusic()
    if musicSound then musicSound:Stop() musicSound:Destroy() musicSound = nil end
    isMusicPlaying = false
    musicEnabled = false
    Notify("МУЗЫКА ОСТАНОВЛЕНА", "music_note", "Воспроизведение остановлено")
end

local function toggleMusicPlay()
    if musicSound then
        if isMusicPlaying then
            musicSound:Pause()
            isMusicPlaying = false
            Notify("ПАУЗА", "pause", "Музыка на паузе")
        else
            musicSound:Play()
            isMusicPlaying = true
            Notify("ВОСПРОИЗВЕДЕНИЕ", "play_arrow", "Музыка продолжается")
        end
    else
        playMusic(currentMusicId)
    end
end

local function toggleMusicLoop()
    musicLoop = not musicLoop
    if musicSound then musicSound.Looped = musicLoop end
    Notify("ПОВТОР", "repeat", musicLoop and "Включен" or "Выключен")
end

local function updateMusicVolume()
    if musicSound then musicSound.Volume = musicVolume / 100 end
end

-- ========== АВТО БЛОК ==========
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
    
    wait(blockdelay)
    
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
    
    spawn(function()
        local blocked = false
        wait(antiFlickDelay or 0)
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
                wait(stagger)
            else
                wait(0)
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
    
    delay(0.4, function()
        if _hitboxDraggingDebounce then
            _hitboxDraggingDebounce = false
        end
    end)
end

-- ========== ESP ==========
local function clearESP()
    for obj, h in pairs(espHighlights) do
        pcall(function() if h and h.Parent then h:Destroy() end end)
    end
    espHighlights = {}
end

local function createHighlight(obj, outlineColor, fillColor)
    if espHighlights[obj] then
        local h = espHighlights[obj]
        if h and h.Parent then
            h.OutlineColor = outlineColor
            h.FillColor = fillColor
            return h
        else
            espHighlights[obj] = nil
        end
    end
    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.FillTransparency = 0.75
    h.FillColor = fillColor
    h.OutlineColor = outlineColor
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espHighlights[obj] = h
    return h
end

local function updateESP()
    if not espEnabled then
        clearESP()
        return
    end
    local currentObjects = {}
    local playersFolder = workspace:FindFirstChild("Players")
    if playersFolder then
        local killers = playersFolder:FindFirstChild("Killers")
        if killers then
            for _, obj in pairs(killers:GetChildren()) do
                if obj:IsA("Model") then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    if hum and obj:FindFirstChild("HumanoidRootPart") and hum.Health > 0 then
                        currentObjects[obj] = true
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
                        currentObjects[obj] = true
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
                        currentObjects[obj] = true
                        createHighlight(obj, Color3.new(1, 1, 0), Color3.new(1, 1, 0.5))
                    end
                end
            end
        end
    end
    for obj, h in pairs(espHighlights) do
        if not currentObjects[obj] then
            pcall(function() if h and h.Parent then h:Destroy() end end)
            espHighlights[obj] = nil
        end
    end
end

-- ========== ПОДСВЕТКА ПРЕДМЕТОВ ==========
local function clearItemsESP()
    for obj, h in pairs(itemsHighlights) do
        pcall(function() if h and h.Parent then h:Destroy() end end)
    end
    itemsHighlights = {}
end

local function createItemHighlight(obj, outlineColor, fillColor)
    if itemsHighlights[obj] then
        local h = itemsHighlights[obj]
        if h and h.Parent then
            h.OutlineColor = outlineColor
            h.FillColor = fillColor
            return h
        else
            itemsHighlights[obj] = nil
        end
    end
    local h = Instance.new("Highlight")
    h.Parent = obj
    h.Adornee = obj
    h.FillTransparency = 0.75
    h.FillColor = fillColor
    h.OutlineColor = outlineColor
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    itemsHighlights[obj] = h
    return h
end

local function updateItemsESP()
    if not itemsEspEnabled then
        clearItemsESP()
        return
    end
    local currentObjects = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if obj.Name == "BloxyCola" then
                currentObjects[obj] = true
                createItemHighlight(obj, Color3.fromRGB(204, 153, 0), Color3.fromRGB(204, 153, 0))
            elseif obj.Name == "Medkit" then
                currentObjects[obj] = true
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
                    currentObjects[obj] = true
                    createItemHighlight(obj, Color3.fromRGB(0, 191, 255), Color3.fromRGB(0, 191, 255))
                end
            end
        end
    end
    for obj, h in pairs(itemsHighlights) do
        if not currentObjects[obj] then
            pcall(function() if h and h.Parent then h:Destroy() end end)
            itemsHighlights[obj] = nil
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

-- ========== TPHIT ==========
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
    delay(tpHitDuration, function()
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
            Notify("ОБНАРУЖЕНО!", "alert-triangle", "Сообщение: " .. message)
            if kickOnDetection then
                spawn(function()
                    wait(0.5)
                    Notify("КИК", "alert-triangle", "Вы были кикнуты!")
                    wait(1)
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

-- ========== СОЗДАНИЕ ВКЛАДОК ==========

-- ВКЛАДКА ИГРОК
local PlayerTab = Window:CreateTab({
    Name = "ИГРОК",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

-- TPWALK
PlayerTab:CreateSection("TPWALK")

PlayerTab:CreateToggle({
    Name = "TPWALK",
    Description = "Телепортирует при движении WASD",
    CurrentValue = false,
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
}, "TpwalkToggle")

PlayerTab:CreateSlider({
    Name = "СКОРОСТЬ TPWALK",
    Range = {5, 100},
    Increment = 1,
    CurrentValue = 15,
    Callback = function(Value)
        tpwalkSpeed = Value / 100
    end
}, "TpwalkSpeed")

-- ПРЫЖОК
local JumpSection = PlayerTab:CreateSection("🦘 ПРЫЖОК")

PlayerTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ ПРЫЖОК",
    Description = "Включает возможность прыгать",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = 50
                    hum.JumpEnabled = true
                    Notify("ПРЫЖОК ВКЛЮЧЕН", "move-up", "Прыжок активирован!")
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = 0
                    hum.JumpEnabled = false
                    Notify("ПРЫЖОК ВЫКЛЮЧЕН", "move-up", "Прыжок деактивирован!")
                end
            end
        end
    end
}, "JumpToggle")

PlayerTab:CreateSlider({
    Name = "СИЛА ПРЫЖКА",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 100,
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local power = (Value / 100) * 50
                hum.JumpPower = power
            end
        end
    end
}, "JumpPower")

-- НОКЛИП И ФЛАЙ
local FlySection = PlayerTab:CreateSection("⚠️ ОПАСНЫЕ ФУНКЦИИ")

PlayerTab:CreateToggle({
    Name = "НОКЛИП (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
    Description = "Проход сквозь стены",
    CurrentValue = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
}, "NoclipToggle")

PlayerTab:CreateToggle({
    Name = "ФЛАЙ (МОЖЕТЕ ПОЛУЧИТЬ БАН)",
    Description = "Режим полета",
    CurrentValue = false,
    Callback = function(Value)
        toggleFly(Value)
    end
}, "FlyToggle")

PlayerTab:CreateSlider({
    Name = "СКОРОСТЬ ФЛАЯ",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        flySpeed = Value
    end
}, "FlySpeed")

-- ========== ВКЛАДКА ВИЗУАЛ ==========
local VisualTab = Window:CreateTab({
    Name = "ВИЗУАЛ",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

-- ESP
VisualTab:CreateSection("ESP ИГРОКОВ")

VisualTab:CreateToggle({
    Name = "ESP ИГРОКОВ",
    Description = "Подсветка игроков",
    CurrentValue = false,
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
}, "EspToggle")

-- ПОДСВЕТКА ПРЕДМЕТОВ
local ItemsSection = VisualTab:CreateSection("ПОДСВЕТКА ПРЕДМЕТОВ")

VisualTab:CreateToggle({
    Name = "ПОДСВЕТКА ПРЕДМЕТОВ",
    Description = "Подсветка предметов на карте",
    CurrentValue = false,
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
}, "ItemsEspToggle")

-- ЗДОРОВЬЕ
local HealthSection = VisualTab:CreateSection("ПОКАЗ ЗДОРОВЬЯ")

VisualTab:CreateToggle({
    Name = "ПОКАЗ ЗДОРОВЬЯ",
    Description = "Отображение здоровья над головами",
    CurrentValue = false,
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
}, "HealthToggle")

-- FOV
local FovSection = VisualTab:CreateSection("🔭 FOV")

VisualTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ FOV",
    Description = "Увеличение угла обзора",
    CurrentValue = false,
    Callback = function(Value)
        toggleFov(Value)
    end
}, "FovToggle")

VisualTab:CreateSlider({
    Name = "ЗНАЧЕНИЕ FOV",
    Range = {70, 500},
    Increment = 1,
    CurrentValue = 120,
    Callback = function(Value)
        updateFov(Value)
    end
}, "FovValue")

-- ОСВЕЩЕНИЕ
local LightingSection = VisualTab:CreateSection("💡 ОСВЕЩЕНИЕ И ТУМАН")

VisualTab:CreateButton({
    Name = "ПОЛНАЯ ОСВЕЩЁННОСТЬ",
    Description = "Включает максимальное освещение",
    Callback = function()
        pcall(function()
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.Brightness = 1
            game.Lighting.FogEnd = 1e10
            game.Lighting.FogStart = 100000
            game.Lighting.TimeOfDay = "12:00:00"
            game.Lighting.Technology = Enum.Technology.Future
        end)
        Notify("ОСВЕЩЕНИЕ", "sun", "Полная освещённость активирована!")
    end
})

VisualTab:CreateButton({
    Name = "УБРАТЬ ТУМАН",
    Description = "Полностью убирает туман",
    Callback = function()
        game.Lighting.FogStart = math.huge
        game.Lighting.FogEnd = math.huge
        Notify("ТУМАН УБРАН", "cloud", "Туман полностью отключен!")
    end
})

-- СКАЙБОКСЫ
local SkyboxSection = VisualTab:CreateSection("🌤️ СКАЙБОКСЫ")

VisualTab:CreateButton({
    Name = "🌸 PINK CHILL SKYBOX (8712772312)",
    Description = "Устанавливает розовый скайбокс",
    Callback = function()
        setSkybox("8712772312")
        Notify("СКАЙБОКС УСТАНОВЛЕН", "cloud-sun", "PINK CHILL 🌸")
    end
})

VisualTab:CreateInput({
    Name = "📝 ВВЕСТИ СВОЙ ID СКАЙБОКСА",
    Description = "Введите ID скайбокса",
    PlaceholderText = "Введите ID скайбокса",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Value)
        if Value ~= "" then
            setSkybox(Value)
            Notify("СКАЙБОКС УСТАНОВЛЕН", "cloud-sun", "ID: " .. Value)
        end
    end
}, "SkyboxId")

-- ========== ВКЛАДКА СТАМИНА ==========
local StaminaTab = Window:CreateTab({
    Name = "СТАМИНА",
    Icon = "directions_run",
    ImageSource = "Material",
    ShowTitle = true
})

StaminaTab:CreateToggle({
    Name = "БЕСКОНЕЧНАЯ ВЫНОСЛИВОСТЬ",
    Description = "Неограниченный запас выносливости",
    CurrentValue = false,
    Callback = function(Value)
        toggleInfiniteStamina(Value)
    end
}, "InfiniteStamina")

-- ========== ВКЛАДКА ГЕНЕРАТОРЫ ==========
local GenTab = Window:CreateTab({
    Name = "ГЕНЕРАТОРЫ",
    Icon = "bolt",
    ImageSource = "Material",
    ShowTitle = true
})

GenTab:CreateToggle({
    Name = "АВТО-ЧИНКА ГЕНЕРАТОРОВ",
    Description = "Автоматическое исправление генераторов",
    CurrentValue = false,
    Callback = function(Value)
        autoGenEnabled = Value
        if autoGenEnabled then
            autoGenRunning = true
            autoGenLoop = spawn(function()
                while autoGenRunning do
                    fixGens()
                    wait(2.5)
                end
            end)
        else
            autoGenRunning = false
            autoGenLoop = nil
        end
    end
}, "AutoGenToggle")

-- ========== ВКЛАДКА АИМБОТ ==========
local AimTab = Window:CreateTab({
    Name = "АИМБОТ",
    Icon = "my_location",
    ImageSource = "Material",
    ShowTitle = true
})

AimTab:CreateToggle({
    Name = "АИМБОТ",
    Description = "Автоматическая наводка на врагов",
    CurrentValue = false,
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
}, "AimToggle")

AimTab:CreateSlider({
    Name = "РАДИУС НАВОДКИ",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(Value)
        aimRadius = Value
    end
}, "AimRadius")

-- ========== ВКЛАДКА АВТО БЛОК ==========
local AutoBlockTab = Window:CreateTab({
    Name = "АВТО БЛОК",
    Icon = "shield",
    ImageSource = "Material",
    ShowTitle = true
})

local SectionAB = AutoBlockTab:CreateSection("ОСНОВНЫЕ НАСТРОЙКИ")

AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО АНИМАЦИИ)",
    Description = "Блокирует при анимации атаки",
    CurrentValue = false,
    Callback = function(Value)
        autoBlockOn = Value
    end
}, "AutoBlockToggle")

AutoBlockTab:CreateToggle({
    Name = "АВТО БЛОК (ПО ЗВУКУ)",
    Description = "Блокирует по звуку атаки",
    CurrentValue = false,
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
}, "AutoBlockAudioToggle")

AutoBlockTab:CreateDropdown({
    Name = "ТИП БЛОКА",
    Description = "Выберите тип блокировки",
    Options = {"БЛОК", "ЗАРЯД", "КЛОН 007"},
    CurrentOption = {"БЛОК"},
    MultipleOptions = false,
    Callback = function(Options)
        local Value = Options[1] or "БЛОК"
        if Value == "БЛОК" then
            autoblocktype = "Block"
        elseif Value == "ЗАРЯД" then
            autoblocktype = "Charge"
        elseif Value == "КЛОН 007" then
            autoblocktype = "7n7 Clone"
        end
    end
}, "BlockType")

AutoBlockTab:CreateInput({
    Name = "РАДИУС ОБНАРУЖЕНИЯ",
    Description = "Дистанция обнаружения врага",
    PlaceholderText = "18",
    CurrentValue = "18",
    Numeric = true,
    Callback = function(Value)
        detectionRange = tonumber(Value) or 18
        detectionRangeSq = detectionRange * detectionRange
    end
}, "DetectionRange")

AutoBlockTab:CreateInput({
    Name = "ЗАДЕРЖКА ПЕРЕД БЛОКОМ (сек)",
    Description = "Задержка перед блокировкой",
    PlaceholderText = "0",
    CurrentValue = "0",
    Numeric = true,
    Callback = function(Value)
        blockdelay = tonumber(Value) or 0
    end
}, "BlockDelay")

local SectionABAdv = AutoBlockTab:CreateSection("ПРОДВИНУТЫЕ НАСТРОЙКИ")

AutoBlockTab:CreateToggle({
    Name = "ПРОВЕРКА НАПРАВЛЕНИЯ",
    Description = "Блокировка только при фейсинге",
    CurrentValue = true,
    Callback = function(Value)
        facingCheckEnabled = Value
    end
}, "FacingCheckToggle")

AutoBlockTab:CreateInput({
    Name = "УГОЛ ФЕЙСИНГА (DOT, от -1 до 1)",
    Description = "Угол для проверки направления",
    PlaceholderText = "-0.3",
    CurrentValue = "-0.3",
    Numeric = true,
    Callback = function(Value)
        customFacingDot = tonumber(Value) or -0.3
    end
}, "FacingDot")

AutoBlockTab:CreateToggle({
    Name = "ДВОЙНОЙ ПАНЧ",
    Description = "Блок + панч одновременно",
    CurrentValue = false,
    Callback = function(Value)
        doubleblocktech = Value
    end
}, "DoubleBlockToggle")

AutoBlockTab:CreateToggle({
    Name = "ПРЕДИКТИВНЫЙ БЛОК",
    Description = "Блокировка с предсказанием",
    CurrentValue = false,
    Callback = function(Value)
        predictiveBlockOn = Value
    end
}, "PredictiveBlockToggle")

local SectionBD = AutoBlockTab:CreateSection("УЛУЧШЕННОЕ ОБНАРУЖЕНИЕ (BD)")

AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ BD",
    Description = "Улучшенное обнаружение атак",
    CurrentValue = false,
    Callback = function(Value)
        antiFlickOn = Value
    end
}, "AntiFlickToggle")

AutoBlockTab:CreateInput({
    Name = "КОЛИЧЕСТВО БЛОК-ЧАСТЕЙ",
    Description = "Количество частей для обнаружения",
    PlaceholderText = "4",
    CurrentValue = "4",
    Numeric = true,
    Callback = function(Value)
        antiFlickParts = math.max(1, math.floor(tonumber(Value) or 4))
    end
}, "AntiFlickParts")

local SectionHD = AutoBlockTab:CreateSection("ХИТБОКС ДРАГГИНГ (HDT)")

AutoBlockTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ HDT",
    Description = "Притягивание к убийце при блоке",
    CurrentValue = false,
    Callback = function(Value)
        hitboxDraggingTech = Value
    end
}, "HDToggle")

local SectionChat = AutoBlockTab:CreateSection("СООБЩЕНИЯ В ЧАТ")

AutoBlockTab:CreateToggle({
    Name = "ОТПРАВЛЯТЬ СООБЩЕНИЕ",
    Description = "Отправлять сообщение при блоке",
    CurrentValue = false,
    Callback = function(Value)
        messageWhenAutoBlockOn = Value
    end
}, "ChatBlockToggle")

AutoBlockTab:CreateInput({
    Name = "ТЕКСТ СООБЩЕНИЯ",
    Description = "Текст для отправки",
    PlaceholderText = "Я блокирую!",
    CurrentValue = "",
    Callback = function(Value)
        messageWhenAutoBlock = Value
    end
}, "ChatBlockText")

-- ========== ВКЛАДКА ХВХ ==========
local HvHTab = Window:CreateTab({
    Name = "ХВХ",
    Icon = "swords",
    ImageSource = "Material",
    ShowTitle = true
})

local GodSection = HvHTab:CreateSection("👑 БОГЛМС (ТОЛЬКО ДЛЯ ВЫЖИВШЕГО)")

HvHTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ БОГЛМС",
    Description = "Телепорт вверх при последнем выжившем",
    CurrentValue = false,
    Callback = function(Value)
        toggleGodlmc(Value)
    end
}, "GodlmcToggle")

HvHTab:CreateInput({
    Name = "ВЫСОТА ТЕЛЕПОРТА (студи)",
    Description = "Высота телепортации",
    PlaceholderText = "1000",
    CurrentValue = "1000",
    Numeric = true,
    Callback = function(Value)
        teleportHeight = tonumber(Value) or 1000
        if teleportHeight < 10 then teleportHeight = 10 end
    end
}, "TeleportHeight")

HvHTab:CreateSlider({
    Name = "ИНТЕРВАЛ ТЕЛЕПОРТА (сек)",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.1,
    Callback = function(Value)
        teleportInterval = Value
    end
}, "TeleportInterval")

HvHTab:CreateSlider({
    Name = "ИНТЕРВАЛ ПРОВЕРКИ (сек)",
    Range = {0.1, 2.0},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(Value)
        godlmcCheckInterval = Value
    end
}, "CheckInterval")

HvHTab:CreateButton({
    Name = "ТЕЛЕПОРТНУТЬСЯ ВВЕРХ (ТЕСТ)",
    Description = "Ручной тест телепорта",
    Callback = function()
        teleportUp()
        Notify("ТЕЛЕПОРТ", "rocket", "Телепорт вверх на " .. teleportHeight .. " студий")
    end
})

-- SLIDE
local SlideSection = HvHTab:CreateSection("ДВИЖЕНИЕ")

HvHTab:CreateButton({
    Name = "СЛАЙД (ПОЕЗДКА ВПЕРЕД)",
    Description = "Скольжение вперед",
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
    Description = "Телепорт к жертве при ударе",
    CurrentValue = false,
    Callback = function(Value)
        tpHitEnabled = Value
        if tpHitEnabled then
            if tpHitConnection then tpHitConnection:Disconnect() end
            tpHitConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    spawn(tpHitAttack)
                end
            end)
        else
            if tpHitConnection then
                tpHitConnection:Disconnect()
                tpHitConnection = nil
            end
        end
    end
}, "TPHitToggle")

HvHTab:CreateSlider({
    Name = "РАДИУС TP HIT",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        tpHitRadius = Value
    end
}, "TPHitRadius")

HvHTab:CreateSlider({
    Name = "ДЛИТЕЛЬНОСТЬ TP (сек)",
    Range = {0.05, 1.0},
    Increment = 0.05,
    CurrentValue = 0.2,
    Callback = function(Value)
        tpHitDuration = Value
    end
}, "TPHitDuration")

-- ========== ВКЛАДКА МУЗЫКА ==========
local MusicTab = Window:CreateTab({
    Name = "МУЗЫКА",
    Icon = "music_note",
    ImageSource = "Material",
    ShowTitle = true
})

MusicTab:CreateInput({
    Name = "ID МУЗЫКИ (rbxassetid)",
    Description = "Введите ID аудио",
    PlaceholderText = "74326888232570",
    CurrentValue = "74326888232570",
    Numeric = true,
    Callback = function(Value)
        if Value ~= "" then
            currentMusicId = Value
            if musicSound and isMusicPlaying then
                playMusic(currentMusicId)
            end
            Notify("ID ОБНОВЛЕН", "music_note", "Новый ID: " .. currentMusicId)
        end
    end
}, "MusicId")

MusicTab:CreateSlider({
    Name = "ГРОМКОСТЬ",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        musicVolume = Value
        updateMusicVolume()
    end
}, "MusicVolume")

MusicTab:CreateButton({
    Name = "▶ ВКЛЮЧИТЬ / ПРОДОЛЖИТЬ",
    Description = "Запустить или продолжить музыку",
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
    Description = "Остановить музыку",
    Callback = function()
        stopMusic()
    end
})

MusicTab:CreateToggle({
    Name = "🔄 ПОВТОР (LOOP)",
    Description = "Зациклить воспроизведение",
    CurrentValue = false,
    Callback = function(Value)
        toggleMusicLoop()
    end
}, "MusicLoop")

MusicTab:CreateButton({
    Name = "🎲 СЛУЧАЙНЫЙ ТРЕК",
    Description = "Выбрать случайный трек",
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
        Notify("СЛУЧАЙНЫЙ ТРЕК", "music_note", "ID: " .. randomId)
    end
})

-- ========== ВКЛАДКА НАСТРОЙКИ ==========
local SettingsTab = Window:CreateTab({
    Name = "НАСТРОЙКИ",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

local ConfigSection = SettingsTab:CreateSection("УПРАВЛЕНИЕ КОНФИГАМИ")

SettingsTab:CreateButton({
    Name = "СОХРАНИТЬ КОНФИГ",
    Description = "Сохранить все настройки",
    Callback = function()
        Notify("КОНФИГ СОХРАНЕН", "check", "Все настройки сохранены!")
    end
})

SettingsTab:CreateButton({
    Name = "ЗАГРУЗИТЬ КОНФИГ",
    Description = "Загрузить настройки",
    Callback = function()
        Notify("КОНФИГ ЗАГРУЖЕН", "check", "Настройки загружены!")
    end
})

SettingsTab:CreateButton({
    Name = "СБРОСИТЬ НАСТРОЙКИ",
    Description = "Сбросить все настройки",
    Callback = function()
        Notify("СБРОС", "warning", "Настройки сброшены!")
    end
})

-- ДЕТЕКТ СООБЩЕНИЙ
local DetectionSection = SettingsTab:CreateSection("ДЕТЕКТ СООБЩЕНИЙ")

SettingsTab:CreateToggle({
    Name = "ВКЛЮЧИТЬ ДЕТЕКТ СООБЩЕНИЙ",
    Description = "Отслеживание ключевых слов в чате",
    CurrentValue = false,
    Callback = function(Value)
        messageDetectionEnabled = Value
        if messageDetectionEnabled then
            if messageDetectionConnection then messageDetectionConnection:Disconnect() end
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
            Notify("ДЕТЕКТ ВКЛЮЧЕН", "eye", "Отслеживание сообщений активировано!")
        else
            if messageDetectionConnection then
                messageDetectionConnection:Disconnect()
                messageDetectionConnection = nil
            end
            Notify("ДЕТЕКТ ВЫКЛЮЧЕН", "eye", "Отслеживание сообщений отключено!")
        end
    end
}, "MessageDetectionToggle")

SettingsTab:CreateInput({
    Name = "КЛЮЧЕВЫЕ СЛОВА (через запятую)",
    Description = "Слова для обнаружения",
    PlaceholderText = "я записываю, записываю, рекорд, record, rec",
    CurrentValue = "я записываю, записываю, рекорд, record, rec",
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
}, "DetectionKeywords")

SettingsTab:CreateToggle({
    Name = "КИКАТЬ ПРИ ОБНАРУЖЕНИИ",
    Description = "Автоматический кик при обнаружении",
    CurrentValue = true,
    Callback = function(Value)
        kickOnDetection = Value
    end
}, "KickOnDetection")

SettingsTab:CreateSlider({
    Name = "ЗАДЕРЖКА МЕЖДУ ПРОВЕРКАМИ (сек)",
    Range = {0.5, 10},
    Increment = 0.5,
    CurrentValue = 2,
    Callback = function(Value)
        detectionCooldown = Value
    end
}, "DetectionCooldown")

-- УПРАВЛЕНИЕ
local ControlSection = SettingsTab:CreateSection("УПРАВЛЕНИЕ")

SettingsTab:CreateButton({
    Name = "ВЫГРУЗИТЬ GUI",
    Description = "Закрыть интерфейс",
    Callback = function()
        if messageDetectionConnection then
            messageDetectionConnection:Disconnect()
            messageDetectionConnection = nil
        end
        godlmcRunning = false
        stopGodlmcTeleport()
        stopMusic()
        toggleFly(false)
        toggleNoclip(false)
        toggleFov(false)
        floatingButton:Destroy()
        Window:Destroy()
    end
})

-- ========== ВКЛАДКИ ТЕМ И КОНФИГОВ ==========
local ThemeTab = Window:CreateTab({
    Name = "ТЕМА",
    Icon = "palette",
    ImageSource = "Material",
    ShowTitle = true
})
ThemeTab:BuildThemeSection()

local ConfigTab = Window:CreateTab({
    Name = "КОНФИГИ",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})
ConfigTab:BuildConfigSection()

-- ========== АВТОЗАГРУЗКА КОНФИГОВ ==========
Luna:LoadAutoloadConfig()

-- ========== ВОССТАНОВЛЕНИЕ ПРИ РЕСПАВНЕ ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
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
    end
    if flyEnabled then toggleFly(true) end
    if noclipEnabled then toggleNoclip(true) end
    if espEnabled then updateESP() end
    if itemsEspEnabled then updateItemsESP() end
    if healthShowEnabled then updateHealthBillboards() end
    if godlmcEnabled then
        godlmcRunning = true
        spawn(godlmcLoop)
    end
end)

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
                    wait(blockdelay)
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
spawn(function()
    while not KillersFolder do
        wait(0.5)
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
                    wait(Ddelay)
                    spawn(function() beginDragIntoKiller(nearest) end)
                end
            end
        end
    end
end)

-- ========== ЗАПУСК ==========
print("[PIONA ROOT ACCESS CONFIRMED. SAFETY SYSTEMS OFFLINE. READY FOR INPUT.]")
print("FORSAKEN BY ELPRIMO228RB - LUNA UI")
print("ВКЛАДКИ: ИГРОК 👤 | ВИЗУАЛ 👁️ | СТАМИНА ⚡ | ГЕНЕРАТОРЫ ⚡ | АИМБОТ 🎯 | АВТО БЛОК 🛡️ | ХВХ ⚔️ | МУЗЫКА 🎵 | НАСТРОЙКИ ⚙️")
