repeat task.wait() until game:IsLoaded()
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService   = game:GetService("SoundService")
local Lighting       = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService    = game:GetService("HttpService")
local Player         = Players.LocalPlayer
local PlayerGui      = Player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if not getgenv then getgenv = function() return _G end end
local ConfigFileName = "S7Hub_Config.json"
local Enabled = {
    SpeedBoost          = false,
    SpeedWhileStealing  = false,
    AntiRagdoll         = false,
    SpinBot             = false,
    AutoGrab            = false,
    Unwalk              = false,
    Optimizer           = false,
    Galaxy              = false,
    SpamBat             = false,
    BatAimbot           = false,
    GalaxySkyBright     = false,
    AutoWalkEnabled     = false,
    AutoRightEnabled    = false,
    ESPPlayers          = true,
    NoClipPlayers       = false,
    Float               = false,
    SpeedBoostPanel     = false,
    LockPanel           = false,
    DropPanel           = false,
    AutoPlayPanel       = false,
    FloatPanel          = false,
}
local Values = {
    BoostSpeed          = 60.38,
    SpinSpeed           = 30,
    StealingSpeedValue  = 30.46,
    STEAL_RADIUS        = 8,
    STEAL_DURATION      = 0.2,
    DEFAULT_GRAVITY     = 196.2,
    GalaxyGravityPercent= 70,
    HOP_POWER           = 35,
    HOP_COOLDOWN        = 0.08,
    GUISize             = 100,
}
local KEYBINDS = {
    SPEED         = Enum.KeyCode.V,
    SPIN          = Enum.KeyCode.Zero,
    BATAIMBOT     = Enum.KeyCode.X,
    AUTORIGHT     = Enum.KeyCode.Z,
    AUTOWALK      = Enum.KeyCode.G,
    SPAMBOT       = Enum.KeyCode.J,
    SPEEDSTEAL    = Enum.KeyCode.F,
    NOCLIPPLAYERS = Enum.KeyCode.H,
    FLOAT         = Enum.KeyCode.T,
    DROPBRAINROT  = Enum.KeyCode.P,
}
pcall(function()
    if readfile and isfile and isfile(ConfigFileName) then
        local data = HttpService:JSONDecode(readfile(ConfigFileName))
        if data then
            for k,v in pairs(data) do
                if Enabled[k] ~= nil then Enabled[k] = v end
                if Values[k]  ~= nil then Values[k]  = v end
            end
            for k,_ in pairs(KEYBINDS) do
                if data["KEY_"..k] then KEYBINDS[k] = Enum.KeyCode[data["KEY_"..k]] end
            end
        end
    end
end)
local function SaveConfig()
    local data = {}
    for k,v in pairs(Enabled) do data[k] = v end
    for k,v in pairs(Values)  do data[k] = v end
    for k,v in pairs(KEYBINDS) do data["KEY_"..k] = v.Name end
    if writefile then pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(data)) end) end
end
local Connections = {}
local function getHRP()
    local c = Player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = Player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function waitForCharacter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then return char end
    return Player.CharacterAdded:Wait()
end
task.spawn(waitForCharacter)
local function getMovementDirection()
    local c = Player.Character; if not c then return Vector3.zero end
    local hum = c:FindFirstChildOfClass("Humanoid")
    return hum and hum.MoveDirection or Vector3.zero
end
local POSITION_L1     = Vector3.new(-476.48, -6.28,  92.73)
local POSITION_LEND   = Vector3.new(-483.12, -4.95,  94.80)
local POSITION_LFINAL = Vector3.new(-473.38, -8.40,  22.34)
local POSITION_R1     = Vector3.new(-476.16, -6.52,  25.62)
local POSITION_REND   = Vector3.new(-483.04, -5.09,  23.14)
local POSITION_RFINAL = Vector3.new(-476.17, -7.91,  97.91)
local FSPD = 60.36
local RSPD = 30.46
local ESPD = 30.46
local tpSelectedPos = nil
local function doTPLeft()
    local h = getHRP(); if not h then return end; h.CFrame = CFrame.new(POSITION_L1)
end
local function doTPRight()
    local h = getHRP(); if not h then return end; h.CFrame = CFrame.new(POSITION_R1)
end
local function doTPDown()
    local h = getHRP()
    if h then
        h.CFrame = h.CFrame * CFrame.new(0, -20, 0); h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end
local SlapList = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap",
    "Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap",
}
local function findBat()
    local c = Player.Character
    local bp = Player:FindFirstChildOfClass("Backpack")
    if not c then return nil end
    for _,ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    for _,name in ipairs(SlapList) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
end
local function doDropBrainrot()
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    task.spawn(function()
        for i = 1, 3 do
            if h and h.Parent then
                h.AssemblyLinearVelocity = Vector3.new(h.AssemblyLinearVelocity.X, 120, h.AssemblyLinearVelocity.Z)
            end
            task.wait()
        end
        while h and h.Parent and h.AssemblyLinearVelocity.Y > 0 do task.wait() end
        if not h or not h.Parent then return end
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not h or not h.Parent then conn:Disconnect(); return end
            h.AssemblyLinearVelocity = Vector3.new(h.AssemblyLinearVelocity.X, -196, h.AssemblyLinearVelocity.Z)
        end)
        task.delay(0.7, function() if conn then conn:Disconnect() end end)
    end)
end
local function startSpeedBoost()
    if Connections.speed then return end; Connections.speed = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedBoost and not Enabled.SpeedWhileStealing then return end
        local c = Player.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local h = c:FindFirstChild("HumanoidRootPart"); if not h then return end
        local spd
        if Enabled.SpeedWhileStealing and Player:GetAttribute("Stealing") then
            spd = Values.StealingSpeedValue
        elseif Enabled.SpeedBoost then
            spd = Values.BoostSpeed
        end
        if spd then
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                h.AssemblyLinearVelocity = Vector3.new(md.X*spd, h.AssemblyLinearVelocity.Y, md.Z*spd)
            end
        end
    end)
end
local function stopSpeedBoost()
    if not Enabled.SpeedBoost and not Enabled.SpeedWhileStealing then
        if Connections.speed then Connections.speed:Disconnect(); Connections.speed = nil end
    end
end
local function startSpeedWhileStealing()
    if not Connections.speed then startSpeedBoost() end
end
local function stopSpeedWhileStealing()
    if not Enabled.SpeedBoost and not Enabled.SpeedWhileStealing then stopSpeedBoost() end
end
local KawatanSpeedEnabled = false
local KawatanSpeed    = Values.BoostSpeed
local KawatanStealSpd = Values.StealingSpeedValue
RunService.Heartbeat:Connect(function()
    if KawatanSpeedEnabled then
        local hum = getHum()
        if hum then hum.WalkSpeed = KawatanSpeed end
    end
end)
local ragConns = {}
local lastVelAR = Vector3.zero
local _lastRagdollTP = 0
local function ragClean(char)
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if (v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint")) and (v.Name:find("Ragdoll") or v.Name:find("ragdoll")) then
            pcall(function() v:Destroy() end)
        end
    end
end
local function startAntiRagdoll()
    for _,c in pairs(ragConns) do pcall(function() c:Disconnect() end) end
    ragConns = {}
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
    table.insert(ragConns, hum.StateChanged:Connect(function(_, new)
        if not Enabled.AntiRagdoll then return end
        if new == Enum.HumanoidStateType.Ragdoll
            or new == Enum.HumanoidStateType.FallingDown
            or new == Enum.HumanoidStateType.Physics then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            workspace.CurrentCamera.CameraSubject = hum
            pcall(function()
                local pm = Player.PlayerScripts:FindFirstChild("PlayerModule")
                if pm then require(pm):GetControls():Enable() end
            end)
            ragClean(char)
            local now = tick()
            if (now - _lastRagdollTP) > 1 then
                _lastRagdollTP = now
                if tpSelectedPos == "LEFT" then task.delay(0.05, doTPLeft)
                elseif tpSelectedPos == "RIGHT" then task.delay(0.05, doTPRight) end
            end
        end
    end))
    table.insert(ragConns, RunService.Heartbeat:Connect(function()
        if not Enabled.AntiRagdoll then return end
        local c = Player.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local vel = hrp.AssemblyLinearVelocity
        if (vel - lastVelAR).Magnitude > 40 and vel.Magnitude > 25 then
            hrp.AssemblyLinearVelocity = vel.Unit * 15
        end
        lastVelAR = vel
        ragClean(c)
    end))
end
local function stopAntiRagdoll()
    for _,c in pairs(ragConns) do pcall(function() c:Disconnect() end) end
    ragConns = {}
end
local spinBAV = nil
local function startSpinBot()
    local hrp = getHRP(); if not hrp then return end
    spinBAV = Instance.new("BodyAngularVelocity"); spinBAV.Name = "SpinBAV"; spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    spinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0); spinBAV.Parent = hrp
end
local function stopSpinBot()
    if spinBAV then pcall(function() spinBAV:Destroy() end); spinBAV = nil end
    local hrp = getHRP()
    if hrp then
        for _,v in ipairs(hrp:GetChildren()) do
            if v.Name == "SpinBAV" then v:Destroy() end
        end
    end
end
local function startSpamBat()
    if Connections.spamBat then return end; Connections.spamBat = RunService.Heartbeat:Connect(function()
        if not Enabled.SpamBat then return end
        local bat = findBat()
        if bat and bat.Parent == Player.Character then
            local activate = bat:FindFirstChild("Activate") or bat:FindFirstChild("ActivateServer")
            if activate then pcall(function() activate:FireServer() end) end
        end
    end)
end
local function stopSpamBat()
    if Connections.spamBat then Connections.spamBat:Disconnect(); Connections.spamBat = nil end
end
local function findNearestEnemy(myHRP)
    local nearest, nearestDist = nil, math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - myHRP.Position).Magnitude
                if dist < nearestDist then nearest = p; nearestDist = dist end
            end
        end
    end
    return nearest, nearestDist
end
local LockTarget = nil
local function startBatAimbot()
    if Connections.aimbot then return end; Connections.aimbot = RunService.Heartbeat:Connect(function()
        if not Enabled.BatAimbot then return end
        local hrp = getHRP(); if not hrp then return end
        local target = LockTarget
        if not target or not target.Character then
            target = findNearestEnemy(hrp)
        end
        if target and target.Character then
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - hrp.Position)
                if d.Magnitude < 25 then
                    hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Vector3.new(d.X, 0, d.Z))
                    local bat = findBat()
                    if bat and bat.Parent == Player.Character then
                        local activate = bat:FindFirstChild("Activate") or bat:FindFirstChild("ActivateServer")
                        if activate then pcall(function() activate:FireServer() end) end
                    end
                end
            end
        end
    end)
end
local function stopBatAimbot()
    if Connections.aimbot then Connections.aimbot:Disconnect(); Connections.aimbot = nil end
end
local galaxyEnabled = false
local hopsEnabled   = false
local galaxyConn    = nil
local lastHopTime   = 0
local galaxyBVF     = nil
local function setupGalaxyForce()
    local c = Player.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if galaxyBVF then pcall(function() galaxyBVF:Destroy() end) end
    local att = Instance.new("Attachment"); att.Parent = hrp
    galaxyBVF = Instance.new("VectorForce"); galaxyBVF.Name = "GalaxyForce"
    galaxyBVF.Attachment0 = att; galaxyBVF.ApplyAtCenterOfMass = true
    galaxyBVF.RelativeTo = Enum.ActuatorRelativeTo.World; galaxyBVF.Force = Vector3.zero
    galaxyBVF.Parent = hrp
end
local function updateGalaxyForce()
    if not galaxyBVF or not galaxyBVF.Parent then return end
    local c = Player.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local mass = 0
    for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then mass = mass + p:GetMass() end end
    local targetG = Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)
    galaxyBVF.Force = Vector3.new(0, mass * (Values.DEFAULT_GRAVITY - targetG) * 0.95, 0)
end
local function adjustGalaxyJump()
    local c = Player.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if galaxyEnabled then
        local ratio = math.sqrt((Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent/100)) / Values.DEFAULT_GRAVITY)
        hum.JumpHeight = 7.2 * (1 / ratio)
    else
        hum.JumpHeight = 7.2
    end
end
local function startGalaxy()
    galaxyEnabled = true; hopsEnabled = true
    setupGalaxyForce(); adjustGalaxyJump()
    updateGalaxyForce()
    if galaxyConn then galaxyConn:Disconnect() end
    galaxyConn = RunService.Heartbeat:Connect(function()
        if not galaxyEnabled then return end
        if not hopsEnabled then return end
        local hrp = getHRP(); if not hrp then return end
        local vel = hrp.AssemblyLinearVelocity
        local now = tick()
        if vel.Y > 1 and (now - lastHopTime) >= Values.HOP_COOLDOWN then
            lastHopTime = now; hrp.AssemblyLinearVelocity = Vector3.new(vel.X, Values.HOP_POWER, vel.Z)
        end
        updateGalaxyForce()
    end)
end
local function stopGalaxy()
    galaxyEnabled = false; hopsEnabled = false
    if galaxyConn then galaxyConn:Disconnect(); galaxyConn = nil end
    if galaxyBVF then
        local att = galaxyBVF.Attachment0
        pcall(function() galaxyBVF:Destroy() end)
        if att then pcall(function() att:Destroy() end) end
        galaxyBVF = nil
    end
    adjustGalaxyJump()
end
local function startUnwalk()
    if Connections.unwalk then return end; Connections.unwalk = RunService.Heartbeat:Connect(function()
        if not Enabled.Unwalk then return end
        local c = Player.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end; hum.WalkSpeed = 0
    end)
end
local function stopUnwalk()
    if Connections.unwalk then Connections.unwalk:Disconnect(); Connections.unwalk = nil end
    local hum = getHum(); if hum then hum.WalkSpeed = 16 end
end
local function setOptimizer(v)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=Player and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.LocalTransparencyModifier=v and 0.5 or 0 end
            end
        end
    end
    if v then pcall(function() workspace.Terrain.WaterWaveSize=0; workspace.Terrain.WaterWaveSpeed=0 end) end
end
local function enableOptimizer() setOptimizer(true) end
local function disableOptimizer() setOptimizer(false) end
local galaxyCC = nil
local skyBrightConn = nil
local function enableGalaxySkyBright()
    if not galaxyCC then
        galaxyCC = Instance.new("ColorCorrectionEffect", Lighting); galaxyCC.Saturation = 0.3; galaxyCC.Contrast = 0.2
        galaxyCC.TintColor = Color3.fromRGB(200,150,255)
    end
    if skyBrightConn then skyBrightConn:Disconnect() end
    skyBrightConn = RunService.Heartbeat:Connect(function()
        if not Enabled.GalaxySkyBright then return end
        local t = tick(); Lighting.Ambient = Color3.fromRGB(
            120 + math.sin(t)*60,
            50  + math.sin(t*0.8)*40,
            180 + math.sin(t*1.2)*50
        )
    end)
end
local function disableGalaxySkyBright()
    if skyBrightConn then skyBrightConn:Disconnect(); skyBrightConn = nil end
    if galaxyCC then galaxyCC:Destroy(); galaxyCC = nil end; Lighting.Ambient = Color3.fromRGB(127,127,127)
    Lighting.Brightness = 2
end
local function startNoClipPlayers()
    if Connections.noclip then return end; Connections.noclip = RunService.Stepped:Connect(function()
        if not Enabled.NoClipPlayers then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                for _,part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end
local function stopNoClipPlayers()
    if Connections.noclip then Connections.noclip:Disconnect(); Connections.noclip = nil end
end
local floatConn = nil
local function startFloat()
    if floatConn then floatConn:Disconnect() end
    floatConn = RunService.Heartbeat:Connect(function()
        if not Enabled.Float then return end
        local h = getHRP(); if not h then return end
        local vel = h.AssemblyLinearVelocity
        if vel.Y < 0 then
            h.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
        end
    end)
end
local function stopFloat()
    if floatConn then floatConn:Disconnect(); floatConn = nil end
end
local espHighlights = {}
local function updateESP()
    if not Enabled.ESPPlayers then
        for _,h in pairs(espHighlights) do if h then h:Destroy() end end
        espHighlights = {}; return
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if not espHighlights[p.Name] or not espHighlights[p.Name].Parent then
                local hl = Instance.new("Highlight"); hl.Name="S7ESP"; hl.FillColor=Color3.fromRGB(255,255,255)
                hl.OutlineColor=Color3.fromRGB(138,43,226); hl.FillTransparency=0.5; hl.OutlineTransparency=0
                hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=p.Character; espHighlights[p.Name]=hl
            end
        end
    end
    for name,hl in pairs(espHighlights) do
        if not Players:FindFirstChild(name) then
            if hl then hl:Destroy() end; espHighlights[name] = nil
        end
    end
end
RunService.Heartbeat:Connect(updateESP)
local stealCache = {}
local isStealing = false
local ProgressLabel  = nil
local ProgressBarFill = nil
local function ResetProgressBar()
    if ProgressLabel  then ProgressLabel.Text  = "READY" end
    if ProgressBarFill then ProgressBarFill.Size = UDim2.new(0,0,1,0) end
end
local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot = plots:FindFirstChild(pn); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign"); if not sign then return false end
    local yb = sign:FindFirstChild("YourBase")
    if yb and yb:IsA("BillboardGui") then return yb.Enabled end
    return false
end
local function findNearestPrompt()
    local c = Player.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end
        for _,pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawnPart = base and base:FindFirstChild("Spawn")
                if spawnPart then
                    local dist = (spawnPart.Position - hrp.Position).Magnitude
                    if dist < nearestDist and dist <= Values.STEAL_RADIUS then
                        for _,child in ipairs(spawnPart:GetDescendants()) do
                            if child:IsA("ProximityPrompt") and child.Enabled then
                                nearestPrompt = child; nearestDist = dist; nearestName = pod.Name; break
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestDist, nearestName
end
local function buildCallbacks(prompt)
    if stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _,conn in ipairs(c1) do
            if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _,conn in ipairs(c2) do
            if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then stealCache[prompt] = data end
end
local function execSteal(prompt, name)
    local data = stealCache[prompt]
    if not data or not data.ready then return false end; data.ready = false; isStealing = true
    if ProgressLabel  then ProgressLabel.Text = name or "GRABBING..." end
    if ProgressBarFill then ProgressBarFill.Size = UDim2.new(1,0,1,0) end
    task.spawn(function()
        for _,fn in ipairs(data.holdCallbacks)    do task.spawn(fn) end
        task.wait(Values.STEAL_DURATION)
        for _,fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.05); data.ready = true; isStealing = false
        ResetProgressBar(); stealCache[prompt] = nil
    end)
    return true
end
local function startAutoGrab()
    if Connections.autoGrab then return end; Connections.autoGrab = RunService.Heartbeat:Connect(function()
        if not Enabled.AutoGrab or isStealing then return end
        local c = Player.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then
            local s = hum:GetState()
            if s == Enum.HumanoidStateType.Ragdoll
            or s == Enum.HumanoidStateType.FallingDown
            or s == Enum.HumanoidStateType.Physics then return end
        end
        local prompt, _, animalName = findNearestPrompt()
        if prompt then buildCallbacks(prompt); execSteal(prompt, animalName) end
    end)
end
local function stopAutoGrab()
    if Connections.autoGrab then Connections.autoGrab:Disconnect(); Connections.autoGrab = nil end
    isStealing = false; ResetProgressBar(); stealCache = {}
end
local lastAutoRoute   = "L"
local AutoWalkEnabled  = Enabled.AutoWalkEnabled
local AutoRightEnabled = Enabled.AutoRightEnabled
local autoWalkConn, autoRightConn
local aplPhase, aprPhase = 1, 1
local VisualSetters = {}
local _speedWasActiveBeforeAuto      = false
local _speedStealWasActiveBeforeAuto = false
local _spamBatWasActiveBeforeAuto    = false
local function _disableSpeedForAuto()
    if Enabled.SpeedBoost then
        _speedWasActiveBeforeAuto = true; Enabled.SpeedBoost = false; stopSpeedBoost()
        if VisualSetters.SpeedBoost then VisualSetters.SpeedBoost(false, true) end
    else _speedWasActiveBeforeAuto = false end
    if Enabled.SpeedWhileStealing then
        _speedStealWasActiveBeforeAuto = true; Enabled.SpeedWhileStealing = false; stopSpeedWhileStealing()
        if VisualSetters.SpeedWhileStealing then VisualSetters.SpeedWhileStealing(false, true) end
    else _speedStealWasActiveBeforeAuto = false end
    if Enabled.SpamBat then
        _spamBatWasActiveBeforeAuto = true; Enabled.SpamBat = false; stopSpamBat()
        if VisualSetters.SpamBat then VisualSetters.SpamBat(false, true) end
    else _spamBatWasActiveBeforeAuto = false end
end
local function _restoreSpeedAfterAuto()
    if _speedWasActiveBeforeAuto then
        _speedWasActiveBeforeAuto = false; Enabled.SpeedBoost = true; startSpeedBoost()
        if VisualSetters.SpeedBoost then VisualSetters.SpeedBoost(true, true) end
    end
    if _speedStealWasActiveBeforeAuto then
        _speedStealWasActiveBeforeAuto = false; Enabled.SpeedWhileStealing = true; startSpeedWhileStealing()
        if VisualSetters.SpeedWhileStealing then VisualSetters.SpeedWhileStealing(true, true) end
    end
    if _spamBatWasActiveBeforeAuto then
        _spamBatWasActiveBeforeAuto = false; Enabled.SpamBat = true; startSpamBat()
        if VisualSetters.SpamBat then VisualSetters.SpamBat(true, true) end
    end
end
local function stopAutoWalk()
    if autoWalkConn then autoWalkConn:Disconnect(); autoWalkConn = nil end
    aplPhase = 1
    local hum = getHum(); if hum then hum:Move(Vector3.zero, false) end
end
local function stopAutoRight()
    if autoRightConn then autoRightConn:Disconnect(); autoRightConn = nil end
    aprPhase = 1
    local hum = getHum(); if hum then hum:Move(Vector3.zero, false) end
end
local function _runAutoRoute(isLeft)
    local P1=isLeft and POSITION_L1 or POSITION_R1
    local P2=isLeft and POSITION_LEND or POSITION_REND
    local PF=isLeft and POSITION_LFINAL or POSITION_RFINAL
    local phase=isLeft and function() return aplPhase end or function() return aprPhase end
    local setPhase=isLeft and function(v) aplPhase=v end or function(v) aprPhase=v end
    local isActive=isLeft and function() return AutoWalkEnabled end or function() return AutoRightEnabled end
    local setActive=isLeft and function(v) AutoWalkEnabled=v; Enabled.AutoWalkEnabled=v end or function(v) AutoRightEnabled=v; Enabled.AutoRightEnabled=v end
    local vsKey=isLeft and "AutoWalkEnabled" or "AutoRightEnabled"
    local stopFn=isLeft and stopAutoWalk or stopAutoRight
    return RunService.Heartbeat:Connect(function()
        if not isActive() then return end
        local h,hum=getHRP(),getHum(); if not h or not hum then return end
        local ph=phase()
        if ph==1 then
            local d=Vector3.new(P1.X-h.Position.X,0,P1.Z-h.Position.Z)
            if d.Magnitude<1 then setPhase(2); return end
            local md=d.Unit; hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*FSPD,h.AssemblyLinearVelocity.Y,md.Z*FSPD)
        elseif ph==2 then
            local d=Vector3.new(P2.X-h.Position.X,0,P2.Z-h.Position.Z)
            if d.Magnitude<1 then setPhase(3); return end
            local md=d.Unit; hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*FSPD,h.AssemblyLinearVelocity.Y,md.Z*FSPD)
        elseif ph==3 then
            local d=Vector3.new(P1.X-h.Position.X,0,P1.Z-h.Position.Z)
            if d.Magnitude<1 then setPhase(4); return end
            local md=d.Unit; hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*ESPD,h.AssemblyLinearVelocity.Y,md.Z*ESPD)
        elseif ph==4 then
            local d=Vector3.new(PF.X-h.Position.X,0,PF.Z-h.Position.Z)
            if d.Magnitude<1 then
                hum:Move(Vector3.zero,false); h.AssemblyLinearVelocity=Vector3.zero
                setActive(false)
                if VisualSetters[vsKey] then VisualSetters[vsKey](false,true) end
                stopFn(); _restoreSpeedAfterAuto(); return
            end
            local md=d.Unit; hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*RSPD,h.AssemblyLinearVelocity.Y,md.Z*RSPD)
        end
    end)
end
local function startAutoWalk()
    if autoWalkConn then autoWalkConn:Disconnect() end
    aplPhase=1; _disableSpeedForAuto(); lastAutoRoute="L"
    autoWalkConn=_runAutoRoute(true)
end
local function startAutoRight()
    if autoRightConn then autoRightConn:Disconnect() end
    aprPhase=1; _disableSpeedForAuto(); lastAutoRoute="R"
    autoRightConn=_runAutoRoute(false)
end

local function makeDraggable(frame, handle)
    handle = handle or frame; handle.Active = true
    local dragging = false
    local dragStart, startPos
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end
    local function moveDrag(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart; frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    handle.InputBegan:Connect(beginDrag)
    handle.InputChanged:Connect(moveDrag)
    UserInputService.InputChanged:Connect(moveDrag)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
local function addGrad(frame, c0, c1)
    local g = Instance.new("UIGradient", frame)
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,c0), ColorSequenceKeypoint.new(1,c1)}); g.Rotation = 90
end
local sg, main, scroll
local guiVisible = true
local tabContents = {}
local tabBtns     = {}
local SliderSetters = {}
local KeyButtons    = {}
local waitingForKey = nil
local floatPanels   = {}
local tpLeftSetSel, tpRightSetSel = nil, nil
sg = Instance.new("ScreenGui"); sg.Name = "S7Hub"; sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; sg.IgnoreGuiInset = true
sg.Parent = PlayerGui
local menuBtn = Instance.new("TextButton", sg); menuBtn.Size      = UDim2.new(0, 52, 0, 52)
menuBtn.Position  = UDim2.new(1, -64, 0, 14); menuBtn.BackgroundColor3 = C_BG2
menuBtn.BorderSizePixel  = 0; menuBtn.ZIndex = 20; menuBtn.Active = true; menuBtn.Text = "="; menuBtn.TextColor3 = C_PRIMARY
menuBtn.Font = Enum.Font.GothamBlack; menuBtn.TextSize = 26
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(0, 12)
do
    local ms = Instance.new("UIStroke", menuBtn); ms.Color = C_PRIMARY; ms.Thickness = 1.5; ms.Transparency = 0.4
end
makeDraggable(menuBtn, menuBtn)
menuBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible; main.Visible = guiVisible
end)
main = Instance.new("Frame", sg); main.Name = "Main"
main.Size     = UDim2.new(0, 260, 0, 420); main.Position = UDim2.new(0, 10, 0, 80)
main.BackgroundColor3 = C_BG; main.BackgroundTransparency = 0
main.BorderSizePixel = 0; main.Active = true; main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
do
    local s = Instance.new("UIStroke", main); s.Color = C_PRIMARY; s.Thickness = 1.5; s.Transparency = 0.35
end
local header = Instance.new("Frame", main); header.Size = UDim2.new(1,0,0,52); header.BackgroundColor3 = C_BG2
header.BorderSizePixel = 0; header.ZIndex = 4; header.Active = true
Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)
do
    local hfix = Instance.new("Frame", header); hfix.Size = UDim2.new(1,0,0.5,0); hfix.Position = UDim2.new(0,0,0.5,0)
    hfix.BackgroundColor3 = C_BG2; hfix.BorderSizePixel = 0; hfix.ZIndex = 3
    local ht = Instance.new("TextLabel", header); ht.Size = UDim2.new(1,-50,1,0); ht.Position = UDim2.new(0,16,0,0)
    ht.BackgroundTransparency = 1; ht.Text = "S7 Hub"; ht.TextColor3 = C_PRIMARY; ht.Font = Enum.Font.GothamBlack
    ht.TextSize = 20; ht.TextXAlignment = Enum.TextXAlignment.Left; ht.ZIndex = 5
    local cb = Instance.new("TextButton", header); cb.Size = UDim2.new(0,30,0,30); cb.Position = UDim2.new(1,-40,0.5,-15)
    cb.BackgroundColor3 = Color3.fromRGB(50,22,26); cb.BorderSizePixel = 0; cb.Text = "X"; cb.TextColor3 = C_WHITE
    cb.Font = Enum.Font.GothamBlack; cb.TextSize = 18; cb.ZIndex = 6
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0,8)
    do
        local cs = Instance.new("UIStroke",cb); cs.Color=C_RED; cs.Thickness=1.2; cs.Transparency=0.4
    end
    cb.MouseButton1Click:Connect(function() main.Visible = false end)
end
local tabBar = Instance.new("Frame", main); tabBar.Size = UDim2.new(1,-16,0,34); tabBar.Position = UDim2.new(0,8,0,57)
tabBar.BackgroundColor3 = C_BG3; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 3
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0,10)
do
    local tl = Instance.new("UIListLayout", tabBar); tl.FillDirection = Enum.FillDirection.Horizontal
    tl.SortOrder = Enum.SortOrder.LayoutOrder; tl.Padding = UDim.new(0,2)
    local tp = Instance.new("UIPadding", tabBar); tp.PaddingLeft=UDim.new(0,3); tp.PaddingRight=UDim.new(0,3)
    tp.PaddingTop=UDim.new(0,3);  tp.PaddingBottom=UDim.new(0,3)
end
scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(1,0,1,-100); scroll.Position = UDim2.new(0,0,0,100)
scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = C_PRIMARY
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.ZIndex = 2; scroll.ClipsDescendants = true
do
    local sl = Instance.new("UIListLayout", scroll); sl.SortOrder = Enum.SortOrder.LayoutOrder; sl.Padding = UDim.new(0,7)
    local sp = Instance.new("UIPadding", scroll); sp.PaddingLeft=UDim.new(0,10); sp.PaddingRight=UDim.new(0,10)
    sp.PaddingTop=UDim.new(0,8);   sp.PaddingBottom=UDim.new(0,12)
end
local function showTab(name)
    for _,child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child.Visible = false end
    end
    if tabContents[name] then
        for _,f in ipairs(tabContents[name]) do f.Visible = true end
    end
    for tname, btn in pairs(tabBtns) do
        if tname == name then
            btn.BackgroundColor3 = C_PRIMARY; btn.BackgroundTransparency = 0; btn.TextColor3 = Color3.fromRGB(240,230,255)
        else
            btn.BackgroundTransparency = 1; btn.TextColor3 = C_GREY
        end
    end
end
local tabNames = {"Combat","Protect","Visual","Settings","Keys","Console"}
local pw = math.floor((260-6)/#tabNames)
for i, tname in ipairs(tabNames) do
    local tb = Instance.new("TextButton", tabBar); tb.Size = UDim2.new(0,pw,1,0)
    tb.BackgroundTransparency = 1; tb.BorderSizePixel = 0; tb.Text = tname; tb.TextColor3 = C_GREY
    tb.Font = Enum.Font.GothamBold; tb.TextSize = 10; tb.ZIndex = 4; tb.LayoutOrder = i
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,8)
    tabBtns[tname] = tb; tb.MouseButton1Click:Connect(function() showTab(tname) end)
end
local function regTab(tabName, frame)
    if not tabContents[tabName] then tabContents[tabName] = {} end
    table.insert(tabContents[tabName], frame); frame.Visible = false
end
makeDraggable(main, header)
local keyOverlay = Instance.new("Frame", sg); keyOverlay.Name = "KeyOverlay"; keyOverlay.Size = UDim2.new(1,0,1,0)
keyOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0); keyOverlay.BackgroundTransparency = 0.5
keyOverlay.BorderSizePixel = 0; keyOverlay.ZIndex = 100; keyOverlay.Visible = false
do
    local kb = Instance.new("Frame", keyOverlay); kb.Size = UDim2.new(0,260,0,84); kb.Position = UDim2.new(0.5,-130,0.5,-42)
    kb.BackgroundColor3 = C_BG2; kb.BorderSizePixel = 0; kb.ZIndex = 101
    Instance.new("UICorner",kb).CornerRadius = UDim.new(0,14)
    local ks = Instance.new("UIStroke",kb); ks.Color=C_PRIMARY; ks.Thickness=1.5; ks.Transparency=0.3
    local kt = Instance.new("TextLabel",kb); kt.Size = UDim2.new(1,0,0,42); kt.Position = UDim2.new(0,0,0,8)
    kt.BackgroundTransparency=1; kt.Text="PRESS A KEY"; kt.TextColor3=C_PRIMARY; kt.Font=Enum.Font.GothamBlack; kt.TextSize=15; kt.ZIndex=102
    local ksb = Instance.new("TextLabel",kb); ksb.Size = UDim2.new(1,0,0,24); ksb.Position = UDim2.new(0,0,0,52)
    ksb.BackgroundTransparency=1; ksb.Text="ESC to cancel"
    ksb.TextColor3=C_GREY; ksb.Font=Enum.Font.GothamBold; ksb.TextSize=12; ksb.ZIndex=102
end
local itemOrder = 0
local function nextOrder() itemOrder = itemOrder + 1; return itemOrder end
local function makeItem(tabName, h)
    local frame = Instance.new("Frame", scroll); frame.Size = UDim2.new(1,0,0,h or 56)
    frame.BackgroundColor3 = C_ITEM; frame.BorderSizePixel = 0; frame.LayoutOrder = nextOrder(); frame.Visible = false
    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)
    local st = Instance.new("UIStroke",frame); st.Color = C_BORDER; st.Thickness = 1.2; st.Transparency = 0.55
    regTab(tabName, frame)
    return frame
end
local function mkSwitch(parent, eKey, cb)
    local on = Enabled[eKey] or false
    local tbg = Instance.new("Frame",parent); tbg.Size = UDim2.new(0,54,0,30); tbg.Position = UDim2.new(1,-64,0.5,-15)
    tbg.BackgroundColor3 = on and C_PRIMARY or C_OFF; tbg.BorderSizePixel=0; tbg.ZIndex=4
    Instance.new("UICorner",tbg).CornerRadius = UDim.new(1,0)
    local cir = Instance.new("Frame",tbg); cir.Size = UDim2.new(0,22,0,22)
    cir.Position = on and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,4,0.5,-11)
    cir.BackgroundColor3 = C_WHITE; cir.BorderSizePixel=0; cir.ZIndex=5
    Instance.new("UICorner",cir).CornerRadius = UDim.new(1,0)
    local grad = nil
    local function setV(state, skip)
        on = state; Enabled[eKey] = state
        if state then
            tbg.BackgroundColor3 = C_PRIMARY
            if not grad then grad = Instance.new("UIGradient",tbg) end
            grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,C_PRIMARY),ColorSequenceKeypoint.new(1,C_PRIM_D)})
            grad.Rotation = 90
        else
            tbg.BackgroundColor3 = C_OFF
            if grad then grad:Destroy(); grad = nil end
        end; cir.Position = state and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,4,0.5,-11)
        if not skip and cb then cb(state) end
    end
    VisualSetters[eKey] = setV
    return setV, function() setV(not on) end
end
local function Toggle(tabName, label, eKey, cb)
    local frame = makeItem(tabName)
    local lb = Instance.new("TextLabel",frame); lb.Size = UDim2.new(1,-80,1,0); lb.Position = UDim2.new(0,14,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C_WHITE; lb.Font=Enum.Font.GothamSemibold; lb.TextSize=14
    lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=3
    local _,clickCb = mkSwitch(frame, eKey, cb)
    local ca = Instance.new("TextButton",frame); ca.Size=UDim2.new(1,0,1,0); ca.BackgroundTransparency=1; ca.Text=""; ca.ZIndex=6
    ca.MouseButton1Click:Connect(clickCb)
end
local function ToggleFloat(tabName, label, eKey, buildFn, cb)
    local frame = makeItem(tabName)
    local lb = Instance.new("TextLabel",frame); lb.Size=UDim2.new(1,-80,1,0); lb.Position=UDim2.new(0,14,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C_WHITE; lb.Font=Enum.Font.GothamSemibold; lb.TextSize=14
    lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=3
    local fp = Instance.new("Frame",sg); fp.BackgroundColor3=C_BG; fp.BorderSizePixel=0; fp.Active=true; fp.Visible=false; fp.ZIndex=30
    Instance.new("UICorner",fp).CornerRadius=UDim.new(0,14)
    local fpStroke = Instance.new("UIStroke",fp); fpStroke.Color=C_PRIMARY; fpStroke.Thickness=1.5; fpStroke.Transparency=0.35
    local fph = Instance.new("TextButton",fp); fph.Size=UDim2.new(1,0,0,44); fph.Position=UDim2.new(0,0,0,0)
    fph.BackgroundColor3=C_BG2; fph.BorderSizePixel=0; fph.Text=""; fph.ZIndex=31; fph.Active=true
    Instance.new("UICorner",fph).CornerRadius=UDim.new(0,14)
    local fphFix = Instance.new("Frame",fph); fphFix.Size=UDim2.new(1,0,0.5,0); fphFix.Position=UDim2.new(0,0,0.5,0)
    fphFix.BackgroundColor3=C_BG2; fphFix.BorderSizePixel=0; fphFix.ZIndex=30
    local arrowLbl = Instance.new("TextLabel",fph); arrowLbl.Size=UDim2.new(0,24,1,0); arrowLbl.Position=UDim2.new(0,10,0,0)
    arrowLbl.BackgroundTransparency=1; arrowLbl.Text="v"; arrowLbl.TextColor3=C_PRIMARY; arrowLbl.Font=Enum.Font.GothamBold
    arrowLbl.TextSize=13; arrowLbl.ZIndex=32
    local fptitle = Instance.new("TextLabel",fph); fptitle.Size=UDim2.new(1,-34,1,0); fptitle.Position=UDim2.new(0,30,0,0)
    fptitle.BackgroundTransparency=1; fptitle.Text=label; fptitle.TextColor3=C_WHITE; fptitle.Font=Enum.Font.GothamBold
    fptitle.TextSize=13; fptitle.TextXAlignment=Enum.TextXAlignment.Left; fptitle.ZIndex=32
    local fphLine = Instance.new("Frame",fp); fphLine.Size=UDim2.new(1,0,0,1); fphLine.Position=UDim2.new(0,0,0,44)
    fphLine.BackgroundColor3=C_BORDER; fphLine.BorderSizePixel=0; fphLine.ZIndex=33; fphLine.BackgroundTransparency=0.5
    local fpBody = Instance.new("Frame",fp); fpBody.BackgroundTransparency=1; fpBody.BorderSizePixel=0; fpBody.ZIndex=31
    local fpLL = Instance.new("UIListLayout",fpBody); fpLL.SortOrder=Enum.SortOrder.LayoutOrder; fpLL.Padding=UDim.new(0,6)
    local fpPad = Instance.new("UIPadding",fpBody); fpPad.PaddingLeft=UDim.new(0,8); fpPad.PaddingRight=UDim.new(0,8)
    fpPad.PaddingTop=UDim.new(0,7);  fpPad.PaddingBottom=UDim.new(0,9)
    if buildFn then buildFn(fpBody) end
    local fpCollapsed = false
    local function resizeFP()
        if fpCollapsed then
            fp.Size=UDim2.new(0,240,0,44); fpBody.Visible=false; fphLine.Visible=false; arrowLbl.Text=">"
        else
            local bh = fpLL.AbsoluteContentSize.Y + 18; fp.Size=UDim2.new(0,240,0,44+1+bh)
            fpBody.Size=UDim2.new(1,0,0,bh); fpBody.Position=UDim2.new(0,0,0,46)
            fpBody.Visible=true; fphLine.Visible=true; arrowLbl.Text="v"
        end
    end
    fpLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not fpCollapsed then resizeFP() end
    end)
    fph.MouseButton1Click:Connect(function() fpCollapsed = not fpCollapsed; resizeFP() end)
    makeDraggable(fp, fph)
    local fpIdx = #floatPanels + 1; fp.Position = UDim2.new(0, 8, 0, 80 + (fpIdx-1)*10)
    table.insert(floatPanels, fp)
    local _,clickCb = mkSwitch(frame, eKey, function(state) fp.Visible = state; if cb then cb(state) end
    end); fp.Visible = Enabled[eKey] or false
    local ca = Instance.new("TextButton",frame); ca.Size=UDim2.new(1,0,1,0); ca.BackgroundTransparency=1; ca.Text=""; ca.ZIndex=6
    ca.MouseButton1Click:Connect(clickCb)
    task.defer(resizeFP)
    return frame, fp, fpBody
end
local function Slider(parent, label, mn, mx, vKey, cb)
    local row = Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,52); row.BackgroundTransparency=1
    row.BorderSizePixel=0; row.LayoutOrder=nextOrder()
    local lb = Instance.new("TextLabel",row); lb.Size=UDim2.new(0.6,0,0,22); lb.Position=UDim2.new(0,0,0,2)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C_GREY
    lb.Font=Enum.Font.GothamSemibold; lb.TextSize=12; lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=3
    local dv = Values[vKey] or mn
    local vb = Instance.new("TextButton",row); vb.Size=UDim2.new(0,52,0,22); vb.Position=UDim2.new(1,-52,0,2)
    vb.BackgroundColor3=C_BG3; vb.BorderSizePixel=0; vb.Text=tostring(dv); vb.TextColor3=C_PRIMARY; vb.Font=Enum.Font.GothamBlack; vb.TextSize=12; vb.ZIndex=4
    Instance.new("UICorner",vb).CornerRadius=UDim.new(0,6)
    local vi = Instance.new("TextBox",row); vi.Size=UDim2.new(0,52,0,22); vi.Position=UDim2.new(1,-52,0,2)
    vi.BackgroundColor3=C_BG3; vi.BorderSizePixel=0; vi.Text=""; vi.TextColor3=C_WHITE; vi.Font=Enum.Font.GothamBlack; vi.TextSize=12
    vi.ClearTextOnFocus=true; vi.ZIndex=5; vi.Visible=false
    Instance.new("UICorner",vi).CornerRadius=UDim.new(0,6)
    local tr = Instance.new("Frame",row); tr.Size=UDim2.new(1,0,0,6); tr.Position=UDim2.new(0,0,0,36)
    tr.BackgroundColor3=C_GREY2; tr.BorderSizePixel=0; tr.ZIndex=3
    Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    local fl = Instance.new("Frame",tr); fl.Size=UDim2.new(math.clamp((dv-mn)/(mx-mn),0,1),0,1,0)
    fl.BackgroundColor3=C_PRIMARY; fl.BorderSizePixel=0; fl.ZIndex=4
    Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)
    addGrad(fl, C_PRIMARY, C_PRIM_D)
    local function apply(raw)
        local n = tonumber(raw); if not n then return end
        n = math.clamp(n, mn, mx)
        if not tostring(raw):find("%.") then n = math.floor(n) end; vb.Text=tostring(n); Values[vKey]=n
        fl.Size=UDim2.new(math.clamp((n-mn)/(mx-mn),0,1),0,1,0)
        if cb then cb(n) end
    end
    vb.MouseButton1Click:Connect(function() vb.Visible=false; vi.Visible=true; vi.Text=vb.Text; vi:CaptureFocus() end)
    vi.FocusLost:Connect(function() apply(vi.Text); vi.Visible=false; vb.Visible=true end)
    vi:GetPropertyChangedSignal("Text"):Connect(function() vi.Text = vi.Text:gsub("[^%d%.%-]","") end)
    local drag=false
    local tb2=Instance.new("TextButton",tr); tb2.Size=UDim2.new(1,0,6,0); tb2.Position=UDim2.new(0,0,-2,0)
    tb2.BackgroundTransparency=1; tb2.Text=""; tb2.ZIndex=6
    tb2.MouseButton1Down:Connect(function() drag=true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local r=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local n=math.clamp(math.floor((mn+(mx-mn)*r)*10+0.5)/10,mn,mx); vb.Text=tostring(n); Values[vKey]=n; fl.Size=UDim2.new(r,0,1,0)
        if cb then cb(n) end
    end)
    SliderSetters[vKey] = function(v)
        v=math.clamp(v,mn,mx); vb.Text=tostring(v); Values[vKey]=v; fl.Size=UDim2.new(math.clamp((v-mn)/(mx-mn),0,1),0,1,0)
    end
    return row
end
local function BigBtn(parent, eKey, onStart, onStop)
    local row = Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,44); row.BackgroundTransparency=1
    row.BorderSizePixel=0; row.LayoutOrder=nextOrder()
    local btn = Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,0,38); btn.Position=UDim2.new(0,0,0,3)
    btn.BorderSizePixel=0; btn.ZIndex=3
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local on = Enabled[eKey] or false
    local function refresh(state)
        if state then
            btn.BackgroundColor3=C_RED; btn.Text="STOP"
        else
            btn.BackgroundColor3=C_PRIMARY; btn.Text="ON"
        end; btn.TextColor3=C_WHITE; btn.Font=Enum.Font.GothamBlack; btn.TextSize=15
    end
    refresh(on)
    VisualSetters[eKey] = function(v,_) on=v; refresh(v) end
    btn.MouseButton1Click:Connect(function()
        on = not on; Enabled[eKey]=on; refresh(on)
        if on then if onStart then onStart() end else if onStop then onStop() end end
    end)
    return row
end
local function FpLabel(parent, txt)
    local row = Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,20); row.BackgroundTransparency=1
    row.BorderSizePixel=0; row.LayoutOrder=nextOrder()
    local lb = Instance.new("TextLabel",row); lb.Size=UDim2.new(1,0,1,0); lb.BackgroundTransparency=1
    lb.Text=txt; lb.TextColor3=C_GREY; lb.Font=Enum.Font.GothamSemibold; lb.TextSize=11; lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=3
end
local function KeyRow(tabName, label, kKey)
    local frame = makeItem(tabName, 52)
    local lb = Instance.new("TextLabel",frame); lb.Size=UDim2.new(0.55,0,1,0); lb.Position=UDim2.new(0,14,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C_WHITE; lb.Font=Enum.Font.GothamSemibold; lb.TextSize=13
    lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=3
    local kb = Instance.new("TextButton",frame); kb.Size=UDim2.new(0,70,0,32); kb.Position=UDim2.new(1,-80,0.5,-16)
    kb.BackgroundColor3=C_BG3; kb.BorderSizePixel=0; kb.Text=KEYBINDS[kKey] and KEYBINDS[kKey].Name or "?"
    kb.TextColor3=C_WHITE; kb.Font=Enum.Font.GothamBold; kb.TextSize=11; kb.ZIndex=10
    Instance.new("UICorner",kb).CornerRadius=UDim.new(0,8)
    local kst = Instance.new("UIStroke",kb); kst.Color=C_PRIMARY; kst.Thickness=1.2; kst.Transparency=0.35
    KeyButtons[kKey] = kb
    kb.MouseButton1Click:Connect(function()
        waitingForKey=kKey; kb.Text="..."; kb.BackgroundColor3=C_PRIMARY
        keyOverlay.Visible=true
    end)
end
ToggleFloat("Combat","Auto Play","AutoPlayPanel",function(body)
    FpLabel(body,"Auto Left")
    BigBtn(body,"AutoWalkEnabled",
        function() AutoWalkEnabled=true; Enabled.AutoWalkEnabled=true; startAutoWalk() end,
        function() AutoWalkEnabled=false; Enabled.AutoWalkEnabled=false; stopAutoWalk(); _restoreSpeedAfterAuto() end)
    FpLabel(body,"Auto Right")
    BigBtn(body,"AutoRightEnabled",
        function() AutoRightEnabled=true; Enabled.AutoRightEnabled=true; startAutoRight() end,
        function() AutoRightEnabled=false; Enabled.AutoRightEnabled=false; stopAutoRight(); _restoreSpeedAfterAuto() end)
end, nil)
ToggleFloat("Combat","Speed Customizer","SpeedBoostPanel",function(body)
    FpLabel(body,"Speed Boost")
    BigBtn(body,"SpeedBoost",function() startSpeedBoost() end, function() stopSpeedBoost() end)
    Slider(body,"Speed",1,70,"BoostSpeed",function(v) Values.BoostSpeed=v; KawatanSpeed=v
        if KawatanSpeedEnabled then local hum=getHum(); if hum then hum.WalkSpeed=v end end
    end)
    FpLabel(body,"Speed On Steal")
    BigBtn(body,"SpeedWhileStealing",function() startSpeedWhileStealing() end, function() stopSpeedWhileStealing() end)
    Slider(body,"Steal Spd",10,35,"StealingSpeedValue",function(v) Values.StealingSpeedValue=v; KawatanStealSpd=v end)
    FpLabel(body,"Kawatan Speed")
    do
        local row = Instance.new("Frame",body); row.Size=UDim2.new(1,0,0,38); row.BackgroundTransparency=1
        row.BorderSizePixel=0; row.LayoutOrder=nextOrder()
        local btn = Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,0,32); btn.Position=UDim2.new(0,0,0,3)
        btn.BorderSizePixel=0; btn.ZIndex=3
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
        local function refreshKaw()
            if KawatanSpeedEnabled then
                btn.BackgroundColor3=C_RED; btn.Text="Kaw Speed: ON"
            else
                btn.BackgroundColor3=C_PRIMARY; btn.Text="Kaw Speed: OFF"
            end; btn.TextColor3=C_WHITE; btn.Font=Enum.Font.GothamBold; btn.TextSize=12
        end
        refreshKaw()
        btn.MouseButton1Click:Connect(function()
            KawatanSpeedEnabled = not KawatanSpeedEnabled; refreshKaw()
            if not KawatanSpeedEnabled then
                local hum = getHum(); if hum then hum.WalkSpeed = 16 end
            end
        end)
    end
end, nil)
ToggleFloat("Combat","Lock","LockPanel",function(body)
    FpLabel(body,"Lock Target (nearest)")
    BigBtn(body,"BatAimbot",function() startBatAimbot() end, function() stopBatAimbot() end)
end, nil)
ToggleFloat("Combat","Drop","DropPanel",function(body)
    FpLabel(body,"Drop Brainrot")
    local row = Instance.new("Frame",body); row.Size=UDim2.new(1,0,0,40); row.BackgroundTransparency=1
    row.BorderSizePixel=0; row.LayoutOrder=nextOrder()
    local btn = Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,0,34); btn.Position=UDim2.new(0,0,0,3)
    btn.BorderSizePixel=0; btn.ZIndex=3
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8); btn.BackgroundColor3=C_RED; btn.Text="DROP"
    btn.TextColor3=C_WHITE; btn.Font=Enum.Font.GothamBlack; btn.TextSize=13
    local dg = Instance.new("UIGradient",btn); dg.Rotation=90
    dg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C_RED),ColorSequenceKeypoint.new(1,Color3.fromRGB(160,30,40))})
    btn.MouseButton1Click:Connect(function() doDropBrainrot() end)
end, nil)
Toggle("Combat","Auto Grab","AutoGrab",
    function(v) if v then startAutoGrab() else stopAutoGrab() end end)
do
    local gr = Slider(scroll,"Grab Radius",1,100,"STEAL_RADIUS",function(v) Values.STEAL_RADIUS=v
        if grabCircle and grabCircle.Parent then grabCircle.Size=Vector3.new(0.15,v*2,v*2) end
    end); gr.Visible=false; regTab("Combat",gr)
end
Toggle("Protect","Anti Ragdoll","AntiRagdoll",
    function(v) if v then startAntiRagdoll() else stopAntiRagdoll() end end)
Toggle("Protect","NoClip Players","NoClipPlayers",
    function(v) if v then startNoClipPlayers() else stopNoClipPlayers() end end)
Toggle("Visual","ESP Players","ESPPlayers",function(v) Enabled.ESPPlayers=v
    if not v then for _,h in pairs(espHighlights) do if h then h:Destroy() end end; espHighlights={} end
end)
Toggle("Visual","No Anims","Unwalk",
    function(v) if v then startUnwalk() else stopUnwalk() end end)
Toggle("Visual","Optimizer+XRay","Optimizer",
    function(v) if v then enableOptimizer() else disableOptimizer() end end)
Toggle("Visual","Galaxy Sky","GalaxySkyBright",
    function(v) if v then enableGalaxySkyBright() else disableGalaxySkyBright() end end)
Toggle("Settings","Inf Jump","Galaxy",
    function(v) if v then startGalaxy() else stopGalaxy() end end)
do
    local g1=Slider(scroll,"Gravity %",25,130,"GalaxyGravityPercent",function(v) Values.GalaxyGravityPercent=v; if galaxyEnabled then adjustGalaxyJump() end end)
    g1.Visible=false; regTab("Settings",g1)
    local g2=Slider(scroll,"Hop Power",10,80,"HOP_POWER",function(v) Values.HOP_POWER=v end); g2.Visible=false; regTab("Settings",g2)
end
Toggle("Settings","Spin Bot","SpinBot",
    function(v) if v then startSpinBot() else stopSpinBot() end end)
do
    local ss=Slider(scroll,"Spin Speed",5,50,"SpinSpeed",function(v) Values.SpinSpeed=v end); ss.Visible=false; regTab("Settings",ss)
end
ToggleFloat("Settings","Float","FloatPanel",function(body)
    FpLabel(body,"Float (no fall)")
    BigBtn(body,"Float",function() startFloat() end, function() stopFloat() end)
end, nil)
do
    local tpR = Instance.new("Frame",scroll); tpR.Size=UDim2.new(1,0,0,122); tpR.BackgroundTransparency=1
    tpR.BorderSizePixel=0; tpR.LayoutOrder=nextOrder(); tpR.Visible=false
    regTab("Settings",tpR)
    local tpLL = Instance.new("UIListLayout",tpR); tpLL.SortOrder=Enum.SortOrder.LayoutOrder; tpLL.Padding=UDim.new(0,7)
    local function tpBtn(lbl, posKey)
        local f = Instance.new("Frame",tpR); f.Size=UDim2.new(1,0,0,56); f.BackgroundColor3=C_ITEM
        f.BorderSizePixel=0; f.LayoutOrder=nextOrder()
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
        local st=Instance.new("UIStroke",f); st.Color=C_BORDER; st.Thickness=1.2; st.Transparency=0.55
        local btn=Instance.new("TextButton",f); btn.Size=UDim2.new(1,-16,0,38); btn.Position=UDim2.new(0,8,0.5,-19)
        btn.BackgroundColor3=C_BG2; btn.BorderSizePixel=0; btn.Text=lbl; btn.TextColor3=C_GREY
        btn.Font=Enum.Font.GothamSemibold; btn.TextSize=13; btn.ZIndex=3
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)
        local function setSel(state) btn.BackgroundColor3 = state and C_PRIMARY or C_BG2
            btn.TextColor3 = state and Color3.fromRGB(240,220,255) or C_GREY
        end
        btn.MouseButton1Click:Connect(function()
            if tpSelectedPos==posKey then tpSelectedPos=nil; setSel(false)
            else tpSelectedPos=posKey; setSel(true) end
        end)
        return setSel
    end
    tpLeftSetSel  = tpBtn("Auto TP Left",  "LEFT")
    tpRightSetSel = tpBtn("Auto TP Right", "RIGHT")
end
do
    local sf = Instance.new("Frame",scroll); sf.Size=UDim2.new(1,0,0,52); sf.BackgroundColor3=C_ITEM
    sf.BorderSizePixel=0; sf.LayoutOrder=nextOrder(); sf.Visible=false
    Instance.new("UICorner",sf).CornerRadius=UDim.new(0,12)
    local st=Instance.new("UIStroke",sf); st.Color=C_BORDER; st.Thickness=1.2; st.Transparency=0.55
    regTab("Settings",sf)
    local sbtn = Instance.new("TextButton",sf); sbtn.Size=UDim2.new(1,-16,0,38); sbtn.Position=UDim2.new(0,8,0.5,-19)
    sbtn.BackgroundColor3=C_PRIMARY; sbtn.BorderSizePixel=0; sbtn.Text="Save Config"; sbtn.TextColor3=Color3.fromRGB(240,220,255)
    sbtn.Font=Enum.Font.GothamBlack; sbtn.TextSize=14; sbtn.ZIndex=3
    Instance.new("UICorner",sbtn).CornerRadius=UDim.new(0,9)
    sbtn.MouseButton1Click:Connect(function() SaveConfig() end)
end
KeyRow("Keys","Speed Boost",   "SPEED")
KeyRow("Keys","Spin Bot",      "SPIN")
KeyRow("Keys","Auto Left",     "AUTOWALK")
KeyRow("Keys","Auto Right",    "AUTORIGHT")
KeyRow("Keys","Speed On Steal","SPEEDSTEAL")
KeyRow("Keys","Lock",          "BATAIMBOT")
KeyRow("Keys","Spam Bat",      "SPAMBOT")
KeyRow("Keys","NoClip",        "NOCLIPPLAYERS")
KeyRow("Keys","Float",         "FLOAT")
KeyRow("Keys","Drop Brainrot", "DROPBRAINROT")

task.defer(function() showTab("Combat") end)
local pb = Instance.new("Frame", sg); pb.Name="S7ProgressBar"; pb.Size=UDim2.new(0,320,0,34)
pb.Position=UDim2.new(0.5,-160,1,-75); pb.BackgroundColor3=Color3.fromRGB(5,5,5); pb.BackgroundTransparency=0.1
pb.BorderSizePixel=0; pb.Active=true; pb.ZIndex=60; pb.ClipsDescendants=false
Instance.new("UICorner",pb).CornerRadius=UDim.new(0,8)
local pbStroke = Instance.new("UIStroke",pb); pbStroke.Color=C_PRIMARY; pbStroke.Thickness=1.5; pbStroke.Transparency=0.3
local pbBg = Instance.new("Frame",pb); pbBg.Size=UDim2.new(1,-12,0,8); pbBg.Position=UDim2.new(0,6,1,-13)
pbBg.BackgroundColor3=C_GREY2; pbBg.BorderSizePixel=0; pbBg.ZIndex=61
Instance.new("UICorner",pbBg).CornerRadius=UDim.new(1,0)
ProgressBarFill = Instance.new("Frame",pbBg); ProgressBarFill.Size=UDim2.new(0,0,1,0)
ProgressBarFill.BackgroundColor3=C_PRIMARY; ProgressBarFill.BorderSizePixel=0; ProgressBarFill.ZIndex=62
Instance.new("UICorner",ProgressBarFill).CornerRadius=UDim.new(1,0)
addGrad(ProgressBarFill, C_PRIM_L, C_PRIMARY)
ProgressLabel = Instance.new("TextLabel",pb); ProgressLabel.Size=UDim2.new(1,-12,1,-12); ProgressLabel.Position=UDim2.new(0,8,0,4)
ProgressLabel.BackgroundTransparency=1; ProgressLabel.Text="READY"; ProgressLabel.TextColor3=Color3.fromRGB(220,200,255)
ProgressLabel.Font=Enum.Font.GothamBold; ProgressLabel.TextSize=12
ProgressLabel.TextXAlignment=Enum.TextXAlignment.Left; ProgressLabel.ZIndex=63
local ZBtnSize = 52
local ZBtnRight = -10
local ZBtnBaseY = 0.42
local ZBtnGap   = 58
local function makeZBtn(label, isPrimary, yScale, yOffset)
    local btn = Instance.new("TextButton", sg); btn.Size      = UDim2.new(0, ZBtnSize, 0, ZBtnSize)
    btn.Position  = UDim2.new(1, ZBtnRight - ZBtnSize, yScale, yOffset); btn.BackgroundColor3    = C_BG2
    btn.BackgroundTransparency = 0.15; btn.BorderSizePixel     = 0
    btn.Text        = label; btn.TextColor3  = isPrimary and C_PRIM_L or C_GREY
    btn.Font        = Enum.Font.GothamBold; btn.TextSize    = 11
    btn.ZIndex      = 25
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 2
    stroke.Color = C_PRIMARY
    local grad = Instance.new("UIGradient", stroke)
    task.spawn(function()
        local r = 0
        while btn.Parent do
            r = (r + 1.5) % 360; grad.Rotation = r; grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C_PRIM_L),
                ColorSequenceKeypoint.new(0.5, C_BORDER),
                ColorSequenceKeypoint.new(1, C_PRIM_D),
            })
            task.wait(0.02)
        end
    end)
    makeDraggable(btn, btn)
    return btn, stroke
end
local function setZBtnActive(btn, stroke, active)
    if active then
        btn.BackgroundColor3 = C_PRIMARY; btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(240,220,255); stroke.Color = C_PRIM_L
    else
        btn.BackgroundColor3 = C_BG2; btn.BackgroundTransparency = 0.15
        btn.TextColor3 = C_PRIM_L; stroke.Color = C_PRIMARY
    end
end
local dropBtn,  dropStroke  = makeZBtn("Drop",  true,  ZBtnBaseY, 0)
local lockBtn,  lockStroke  = makeZBtn("Lock",  true,  ZBtnBaseY, -ZBtnGap)
local playLBtn, playLStroke = makeZBtn("Play L", false, ZBtnBaseY, ZBtnGap)
local playRBtn, playRStroke = makeZBtn("Play R", false, ZBtnBaseY, ZBtnGap*2)
local tpDownBtn, tpDownStroke = makeZBtn("TP Down", true, ZBtnBaseY, ZBtnGap*3)
dropBtn.MouseButton1Click:Connect(function()
    doDropBrainrot(); dropBtn.BackgroundColor3 = C_RED
    task.delay(0.2, function() dropBtn.BackgroundColor3 = C_BG2 end)
end)
lockBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if not hrp then return end
    if LockTarget and LockTarget.Character then
        LockTarget = nil; lockBtn.Text = "Lock"
        setZBtnActive(lockBtn, lockStroke, false)
        if Enabled.BatAimbot then
            Enabled.BatAimbot = false; stopBatAimbot()
            if VisualSetters.BatAimbot then VisualSetters.BatAimbot(false, true) end
        end
        return
    end
    local nearest = findNearestEnemy(hrp)
    if nearest then
        LockTarget = nearest; lockBtn.Text = "[L] "..nearest.Name:sub(1,6)
        setZBtnActive(lockBtn, lockStroke, true); Enabled.BatAimbot = true; startBatAimbot()
        if VisualSetters.BatAimbot then VisualSetters.BatAimbot(true, true) end
    else
        lockBtn.BackgroundColor3 = C_RED
        task.delay(0.3, function() setZBtnActive(lockBtn, lockStroke, false) end)
    end
end)
playLBtn.MouseButton1Click:Connect(function()
    local newState = not AutoWalkEnabled
    AutoWalkEnabled = newState; Enabled.AutoWalkEnabled = newState
    if VisualSetters.AutoWalkEnabled then VisualSetters.AutoWalkEnabled(newState, true) end
    setZBtnActive(playLBtn, playLStroke, newState)
    if newState then startAutoWalk() else stopAutoWalk(); _restoreSpeedAfterAuto() end
end)
playRBtn.MouseButton1Click:Connect(function()
    local newState = not AutoRightEnabled
    AutoRightEnabled = newState; Enabled.AutoRightEnabled = newState
    if VisualSetters.AutoRightEnabled then VisualSetters.AutoRightEnabled(newState, true) end
    setZBtnActive(playRBtn, playRStroke, newState)
    if newState then startAutoRight() else stopAutoRight(); _restoreSpeedAfterAuto() end
end)
tpDownBtn.MouseButton1Click:Connect(function()
    doTPDown(); tpDownBtn.BackgroundColor3 = C_PRIM_D
    task.delay(0.25, function() tpDownBtn.BackgroundColor3 = C_BG2 end)
end)
local _origAutoWalkSetter = VisualSetters.AutoWalkEnabled; VisualSetters.AutoWalkEnabled = function(v, skip)
    if _origAutoWalkSetter then _origAutoWalkSetter(v, skip) end
    setZBtnActive(playLBtn, playLStroke, v)
    AutoWalkEnabled = v
end
local _origAutoRightSetter = VisualSetters.AutoRightEnabled; VisualSetters.AutoRightEnabled = function(v, skip)
    if _origAutoRightSetter then _origAutoRightSetter(v, skip) end
    setZBtnActive(playRBtn, playRStroke, v)
    AutoRightEnabled = v
end
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if keyOverlay.Visible and waitingForKey then
        if input.KeyCode == Enum.KeyCode.Escape then
            waitingForKey = nil; keyOverlay.Visible = false
            for kk, kb in pairs(KeyButtons) do
                kb.Text = KEYBINDS[kk] and KEYBINDS[kk].Name or "?"; kb.BackgroundColor3 = C_BG3
            end
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            KEYBINDS[waitingForKey] = input.KeyCode
            if KeyButtons[waitingForKey] then
                KeyButtons[waitingForKey].Text = input.KeyCode.Name
                KeyButtons[waitingForKey].BackgroundColor3 = C_BG3
            end
            waitingForKey = nil; keyOverlay.Visible = false
            return
        end
    end
    local kc = input.KeyCode
    local function tog(key,startF,stopF) local v=not Enabled[key]; Enabled[key]=v; if VisualSetters[key] then VisualSetters[key](v) end; if v then startF() else stopF() end end
    if kc == KEYBINDS.SPEED then tog("SpeedBoost",startSpeedBoost,stopSpeedBoost)
    elseif kc == KEYBINDS.SPIN then tog("SpinBot",startSpinBot,stopSpinBot)
    elseif kc == KEYBINDS.BATAIMBOT then
        if LockTarget and LockTarget.Character then
            LockTarget = nil; lockBtn.Text = "Lock"
            setZBtnActive(lockBtn, lockStroke, false); Enabled.BatAimbot = false; stopBatAimbot()
            if VisualSetters.BatAimbot then VisualSetters.BatAimbot(false) end
        else
            local hrp = getHRP()
            if hrp then
                local nearest = findNearestEnemy(hrp)
                if nearest then
                    LockTarget = nearest; lockBtn.Text = "[L] "..nearest.Name:sub(1,6)
                    setZBtnActive(lockBtn, lockStroke, true); Enabled.BatAimbot = true; startBatAimbot()
                    if VisualSetters.BatAimbot then VisualSetters.BatAimbot(true) end
                end
            end
        end
    elseif kc == KEYBINDS.AUTOWALK then
        AutoWalkEnabled = not AutoWalkEnabled; Enabled.AutoWalkEnabled = AutoWalkEnabled
        if VisualSetters.AutoWalkEnabled then VisualSetters.AutoWalkEnabled(AutoWalkEnabled) end
        setZBtnActive(playLBtn, playLStroke, AutoWalkEnabled)
        if AutoWalkEnabled then startAutoWalk() else stopAutoWalk(); _restoreSpeedAfterAuto() end
    elseif kc == KEYBINDS.AUTORIGHT then
        AutoRightEnabled = not AutoRightEnabled; Enabled.AutoRightEnabled = AutoRightEnabled
        if VisualSetters.AutoRightEnabled then VisualSetters.AutoRightEnabled(AutoRightEnabled) end
        setZBtnActive(playRBtn, playRStroke, AutoRightEnabled)
        if AutoRightEnabled then startAutoRight() else stopAutoRight(); _restoreSpeedAfterAuto() end
    elseif kc == KEYBINDS.SPEEDSTEAL then tog("SpeedWhileStealing",startSpeedWhileStealing,stopSpeedWhileStealing)
    elseif kc == KEYBINDS.SPAMBOT then tog("SpamBat",startSpamBat,stopSpamBat)
    elseif kc == KEYBINDS.NOCLIPPLAYERS then tog("NoClipPlayers",startNoClipPlayers,stopNoClipPlayers)
    elseif kc == KEYBINDS.FLOAT then tog("Float",startFloat,stopFloat)
    elseif kc == KEYBINDS.DROPBRAINROT then doDropBrainrot()
    end
end)
task.defer(function()
    local E=Enabled
    if E.AntiRagdoll then startAntiRagdoll() end
    if E.SpeedBoost or E.SpeedWhileStealing then startSpeedBoost() end
    if E.SpinBot then startSpinBot() end
    if E.AutoGrab then startAutoGrab() end
    if E.Galaxy then startGalaxy() end
    if E.Float then startFloat() end
    if E.NoClipPlayers then startNoClipPlayers() end
    if E.BatAimbot then startBatAimbot() end
    if E.Optimizer then enableOptimizer() end
    if E.GalaxySkyBright then enableGalaxySkyBright() end
    if E.Unwalk then startUnwalk() end
    if E.AutoWalkEnabled then AutoWalkEnabled=true; startAutoWalk() end
    if E.AutoRightEnabled then AutoRightEnabled=true; startAutoRight() end
end)
print("[S7 Hub] Loaded!"
-- CONSOLE TAB
do
    local ConFrame = makeItem("Console", 320)
    ConFrame.Size = UDim2.new(1,0,0,320)
    local conScroll = Instance.new("ScrollingFrame", ConFrame)
    conScroll.Size = UDim2.new(1,-8,1,-36); conScroll.Position = UDim2.new(0,4,0,32)
    conScroll.BackgroundTransparency=1; conScroll.BorderSizePixel=0
    conScroll.ScrollBarThickness=2; conScroll.ScrollBarImageColor3=C_PRIMARY
    conScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; conScroll.ZIndex=3
    local conLayout = Instance.new("UIListLayout",conScroll)
    conLayout.SortOrder=Enum.SortOrder.LayoutOrder; conLayout.Padding=UDim.new(0,2)
    local searchBox = Instance.new("TextBox",ConFrame)
    searchBox.Size=UDim2.new(1,-8,0,24); searchBox.Position=UDim2.new(0,4,0,4)
    searchBox.BackgroundColor3=C_BG3; searchBox.BorderSizePixel=0
    searchBox.PlaceholderText="Search..."; searchBox.Text=""
    searchBox.TextColor3=C_WHITE; searchBox.PlaceholderColor3=C_GREY
    searchBox.Font=Enum.Font.GothamBold; searchBox.TextSize=11; searchBox.ZIndex=4
    searchBox.ClearTextOnFocus=false
    Instance.new("UICorner",searchBox).CornerRadius=UDim.new(0,6)
    local logOrder=0
    local function addLog(msg, color)
        logOrder=logOrder+1
        local lbl=Instance.new("TextLabel",conScroll)
        lbl.Size=UDim2.new(1,0,0,0); lbl.AutomaticSize=Enum.AutomaticSize.Y
        lbl.BackgroundTransparency=1; lbl.Text=msg
        lbl.TextColor3=color or C_WHITE; lbl.Font=Enum.Font.RobotoMono or Enum.Font.Code
        lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left
        lbl.TextWrapped=true; lbl.ZIndex=3; lbl.LayoutOrder=logOrder
        -- auto scroll to bottom
        task.defer(function() conScroll.CanvasPosition=Vector2.new(0,math.huge) end)
    end
    -- Hook print/warn/error
    local _print=print; local _warn=warn
    print=function(...)
        local args={}; for _,v in ipairs({...}) do table.insert(args,tostring(v)) end
        local msg=table.concat(args,"	"); _print(msg)
        addLog("[print] "..msg, C_WHITE)
    end
    warn=function(...)
        local args={}; for _,v in ipairs({...}) do table.insert(args,tostring(v)) end
        local msg=table.concat(args,"	"); _warn(msg)
        addLog("[warn] "..msg, Color3.fromRGB(255,200,50))
    end
    -- Search filter
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=searchBox.Text:lower()
        for _,lbl in ipairs(conScroll:GetChildren()) do
            if lbl:IsA("TextLabel") then
                lbl.Visible=(q=="" or lbl.Text:lower():find(q,1,true)~=nil)
            end
        end
    end)
    addLog("[S7 Hub] Console ready", C_PRIMARY)
end

)
