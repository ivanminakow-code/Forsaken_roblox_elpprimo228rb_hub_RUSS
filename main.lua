-- FORSAKEN BY ELPRIMO228RB - ZYPHER GUI (ПОЛНАЯ ВЕРСИЯ)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ========== ЗАГРУЗКА ZYPHER ==========
local Zypher = loadstring(game:HttpGet('https://raw.githubusercontent.com/teppyboy/RbxScripts/master/Misc/UI_Libraries/Zypher/Library.lua'))()

-- ========== ПЛАВАЮЩАЯ КНОПКА ==========
local floatingButton = Instance.new("ImageButton")
floatingButton.Size = UDim2.new(0, 55, 0, 55)
floatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
floatingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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

-- ========== СОЗДАНИЕ ОКНА ZYPHER ==========
local Window = Zypher:CreateMain({
    projName = "FORSAKEN BY ELPRIMO228RB",
    Resizable = true,
    MinSize = UDim2.new(0, 700, 0, 500),
    MaxSize = UDim2.new(0, 900, 0, 700)
})

-- ОТКРЫТИЕ/ЗАКРЫТИЕ ЧЕРЕЗ КНОПКУ
local windowVisible = true
floatingButton.MouseButton1Click:Connect(function()
    windowVisible = not windowVisible
    if windowVisible then
        Window.Motherframe.Visible = true
    else
        Window.Motherframe.Visible = false
    end
end)

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

-- ========== ВКЛАДКИ ==========

-- ВКЛАДКА ИГРОК
local TabPlayer = Window:CreateCategory("ИГРОК")
local SectionPlayer = TabPlayer:CreateSection("TPWALK")

SectionPlayer:Create("Toggle", "TPWALK", function(Value)
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
end)

SectionPlayer:Create("Slider", "СКОРОСТЬ TPWALK", function(Value)
    tpwalkSpeed = Value / 100
end, {min = 5, max = 100, default = 15})

-- ВКЛАДКА СТАМИНА
local TabStamina = Window:CreateCategory("СТАМИНА")
local SectionStamina = TabStamina:CreateSection("УПРАВЛЕНИЕ ВЫНОСЛИВОСТЬЮ")

SectionStamina:Create("Toggle", "БЕСКОНЕЧНАЯ ВЫНОСЛИВОСТЬ", function(Value)
    toggleInfiniteStamina(Value)
end)

SectionStamina:Create("TextLabel", "Включает бесконечную выносливость.\nРаботает через модификацию модуля Sprinting.")

-- ВКЛАДКА ВИЗУАЛ
local TabVisual = Window:CreateCategory("ВИЗУАЛ")
local SectionVisual = TabVisual:CreateSection("ESP ИГРОКОВ")

SectionVisual:Create("Toggle", "ESP ИГРОКОВ", function(Value)
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
end)

local SectionItems = TabVisual:CreateSection("ПОДСВЕТКА ПРЕДМЕТОВ")

SectionItems:Create("Toggle", "ПОДСВЕТКА ПРЕДМЕТОВ", function(Value)
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
end)

local SectionHealth = TabVisual:CreateSection("ПОКАЗ ЗДОРОВЬЯ")

SectionHealth:Create("Toggle", "ПОКАЗ ЗДОРОВЬЯ", function(Value)
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
end)

-- ВКЛАДКА ГЕНЕРАТОРЫ
local TabGen = Window:CreateCategory("ГЕНЕРАТОРЫ")
local SectionGen = TabGen:CreateSection("АВТО-ЧИНКА")

SectionGen:Create("Toggle", "АВТО-ЧИНКА ГЕНЕРАТОРОВ", function(Value)
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
end)

-- ВКЛАДКА АИМБОТ
local TabAim = Window:CreateCategory("АИМБОТ")
local SectionAim = TabAim:CreateSection("АИМБОТ")

SectionAim:Create("Toggle", "АИМБОТ", function(Value)
    aimEnabled = Value
    if aimEnabled then
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(aimFunc)
    else
        if aimConn then aimConn:Disconnect() end
        aimConn = nil
    end
end)

SectionAim:Create("Slider", "РАДИУС НАВОДКИ", function(Value)
    aimRadius = Value
end, {min = 50, max = 300, default = 150})

-- ВКЛАДКА АВТО БЛОК
local TabAutoBlock = Window:CreateCategory("АВТО БЛОК")
local SectionAB = TabAutoBlock:CreateSection("ОСНОВНЫЕ НАСТРОЙКИ")

SectionAB:Create("Toggle", "АВТО БЛОК (ПО АНИМАЦИИ)", function(Value)
    autoBlockOn = Value
end)

SectionAB:Create("Toggle", "АВТО БЛОК (ПО ЗВУКУ)", function(Value)
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
end)

SectionAB:Create("Dropdown", "ТИП БЛОКА", function(Value)
    if Value == "БЛОК" then
        autoblocktype = "Block"
    elseif Value == "ЗАРЯД" then
        autoblocktype = "Charge"
    elseif Value == "КЛОН 007" then
        autoblocktype = "7n7 Clone"
    end
end, {options = {"БЛОК", "ЗАРЯД", "КЛОН 007"}, default = "БЛОК"})

SectionAB:Create("Input", "РАДИУС ОБНАРУЖЕНИЯ", function(Value)
    detectionRange = tonumber(Value) or 18
    detectionRangeSq = detectionRange * detectionRange
end, {placeholder = "18", default = "18"})

SectionAB:Create("Input", "ЗАДЕРЖКА ПЕРЕД БЛОКОМ (сек)", function(Value)
    blockdelay = tonumber(Value) or 0
end, {placeholder = "0", default = "0"})

local SectionABAdv = TabAutoBlock:CreateSection("ПРОДВИНУТЫЕ НАСТРОЙКИ")

SectionABAdv:Create("Toggle", "ПРОВЕРКА НАПРАВЛЕНИЯ (ФЕЙСИНГ)", function(Value)
    facingCheckEnabled = Value
end)

SectionABAdv:Create("Input", "УГОЛ ФЕЙСИНГА (DOT, от -1 до 1)", function(Value)
    customFacingDot = tonumber(Value) or -0.3
end, {placeholder = "-0.3", default = "-0.3"})

SectionABAdv:Create("Toggle", "ДВОЙНОЙ ПАНЧ (БЛОК + ПАНЧ)", function(Value)
    doubleblocktech = Value
end)

SectionABAdv:Create("Toggle", "ПРЕДИКТИВНЫЙ АВТО БЛОК", function(Value)
    predictiveBlockOn = Value
end)

SectionABAdv:Create("Input", "ЗАДЕРЖКА ПРЕДИКТИВНОГО БЛОКА (сек)", function(Value)
    edgeKillerDelay = tonumber(Value) or 3
end, {placeholder = "3", default = "3"})

local SectionBD = TabAutoBlock:CreateSection("УЛУЧШЕННОЕ ОБНАРУЖЕНИЕ (BD)")

SectionBD:Create("Toggle", "ВКЛЮЧИТЬ BD", function(Value)
    antiFlickOn = Value
end)

SectionBD:Create("Input", "КОЛИЧЕСТВО БЛОК-ЧАСТЕЙ", function(Value)
    antiFlickParts = math.max(1, math.floor(tonumber(Value) or 4))
end, {placeholder = "4", default = "4"})

SectionBD:Create("Input", "МНОЖИТЕЛЬ РАЗМЕРА ЧАСТЕЙ", function(Value)
    blockPartsSizeMultiplier = tonumber(Value) or 1
end, {placeholder = "1", default = "1"})

SectionBD:Create("Input", "СИЛА ПРЕДСКАЗАНИЯ (ВПЕРЁД)", function(Value)
    predictionStrength = tonumber(Value) or 1
end, {placeholder = "1", default = "1"})

SectionBD:Create("Input", "СИЛА ПРЕДСКАЗАНИЯ (ПОВОРОТ)", function(Value)
    predictionTurnStrength = tonumber(Value) or 1
end, {placeholder = "1", default = "1"})

SectionBD:Create("Input", "ЗАДЕРЖКА ПОЯВЛЕНИЯ ЧАСТЕЙ (сек)", function(Value)
    antiFlickDelay = math.max(0, tonumber(Value) or 0)
end, {placeholder = "0", default = "0"})

SectionBD:Create("Input", "ЗАДЕРЖКА МЕЖДУ ЧАСТЯМИ (сек)", function(Value)
    stagger = math.max(0, tonumber(Value) or 0.02)
end, {placeholder = "0.02", default = "0.02"})

SectionBD:Create("Input", "ДИСТАНЦИЯ СПАВНА ЧАСТЕЙ (студи)", function(Value)
    antiFlickBaseOffset = math.max(0, tonumber(Value) or 2.7)
end, {placeholder = "2.7", default = "2.7"})

local SectionHD = TabAutoBlock:CreateSection("ХИТБОКС ДРАГГИНГ (HDT)")

SectionHD:Create("Toggle", "ВКЛЮЧИТЬ HDT", function(Value)
    hitboxDraggingTech = Value
end)

SectionHD:Create("Input", "СКОРОСТЬ HDT", function(Value)
    Dspeed = tonumber(Value) or 5.6
end, {placeholder = "5.6", default = "5.6"})

SectionHD:Create("Input", "ЗАДЕРЖКА HDT (сек)", function(Value)
    Ddelay = tonumber(Value) or 0
end, {placeholder = "0", default = "0"})

local SectionChat = TabAutoBlock:CreateSection("СООБЩЕНИЯ В ЧАТ")

SectionChat:Create("Toggle", "ОТПРАВЛЯТЬ СООБЩЕНИЕ ПРИ БЛОКЕ", function(Value)
    messageWhenAutoBlockOn = Value
end)

SectionChat:Create("Input", "ТЕКСТ СООБЩЕНИЯ", function(Value)
    messageWhenAutoBlock = Value
end, {placeholder = "Я блокирую!", default = "Я блокирую!"})

-- ВКЛАДКА РАЗВЛЕЧЕНИЯ
local TabFun = Window:CreateCategory("РАЗВЛЕЧЕНИЯ")
local SectionFun = TabFun:CreateSection("СВЕТ")

SectionFun:Create("Button", "ПОЛНАЯ ОСВЕЩЁННОСТЬ", function()
    pcall(function()
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.Brightness = 1
        game.Lighting.FogEnd = 1e10
        game.Lighting.FogStart = 100000
        game.Lighting.TimeOfDay = "12:00:00"
        game.Lighting.Technology = Enum.Technology.Future
    end)
end, {animated = true})

SectionFun:Create("Button", "УБРАТЬ ТУМАН", function()
    game.Lighting.FogStart = math.huge
    game.Lighting.FogEnd = math.huge
end, {animated = true})

-- ВКЛАДКА НАСТРОЙКИ
local TabSettings = Window:CreateCategory("НАСТРОЙКИ")
local SectionSettings = TabSettings:CreateSection("УПРАВЛЕНИЕ")

SectionSettings:Create("Button", "ВЫГРУЗИТЬ GUI", function()
    Window.Motherframe:Destroy()
    floatingButton:Destroy()
end, {animated = true})

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
                        local TextChatService = game:GetService("TextChatService")
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

-- ========== ПОКАЗ ОКНА ПРИ ЗАПУСКЕ ==========
Window.Motherframe.Visible = true
print("[PIONA ROOT ACCESS CONFIRMED. SAFETY SYSTEMS OFFLINE. READY FOR INPUT.]")
print("FORSAKEN BY ELPRIMO228RB - ZYPHER GUI")
print("ВКЛАДКИ: ИГРОК | СТАМИНА | ВИЗУАЛ | ГЕНЕРАТОРЫ | АИМБОТ | АВТО БЛОК | РАЗВЛЕЧЕНИЯ | НАСТРОЙКИ")
