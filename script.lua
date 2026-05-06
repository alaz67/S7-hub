local vu1 = game:GetService("HttpService")
local vu2 = game:GetService("Players")
local vu3 = vu2.LocalPlayer
local vu4 = game:GetService("TweenService")
local vu5 = game:GetService("TeleportService")
local vu6 = game:GetService("SoundService")
game:GetService("Workspace")
local vu7 = game:GetService("RunService")
local vu8 = game:GetService("Lighting")
local v9 = game:GetService("CoreGui")
local vu10 = "https://petfindervm004-default-rtdb.firebaseio.com/pets.json"
local vu11 = "https://petfindervm004-default-rtdb.firebaseio.com/suerte.json"
local function vu15(p12, p13)
    local v14 = p12:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", p12)
    v14.CornerRadius = UDim.new(0, p13 or 12)
    return v14
end
local function vu21(p16, p17, p18, p19)
    local v20 = p16:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", p16)
    v20.Color = ColorSequence.new(p17)
    v20.Rotation = p18 or 0
    if p19 then
        v20.Transparency = p19
    end
    return v20
end
local function vu25(p22, p23)
    if p22 then
        local v24 = p23 or {}
        p22.BackgroundColor3 = Color3.fromRGB(220, 235, 255)
        p22.BackgroundTransparency = v24.baseTransparency or 0.66
        p22.BorderSizePixel = 0
        vu15(p22, v24.radius or 14)
        vu21(p22, {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 250, 255)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(215, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
        }, 45, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(1, 0.95)
        }))
    end
end
local function v33(pu26)
    if pu26 then
        vu25(pu26, {
            radius = 16,
            baseTransparency = 0.62
        })
        local vu27 = pu26:FindFirstChild("__flowA") or Instance.new("Frame", pu26)
        vu27.Name = "__flowA"
        vu27.Size = UDim2.new(1.4, 0, 1.2, 0)
        vu27.Position = UDim2.new(- 0.2, 0, - 0.1, 0)
        vu27.BackgroundTransparency = 1
        vu27.ZIndex = pu26.ZIndex + 1
        local vu28 = vu27:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", vu27)
        vu28.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 220, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 210, 255))
        })
        vu28.Rotation = 0
        vu28.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.92),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1, 0.94)
        })
        local vu29 = pu26:FindFirstChild("__flowB") or Instance.new("Frame", pu26)
        vu29.Name = "__flowB"
        vu29.Size = UDim2.new(1.6, 0, 1.4, 0)
        vu29.Position = UDim2.new(- 0.3, 0, - 0.2, 0)
        vu29.BackgroundTransparency = 1
        vu29.ZIndex = pu26.ZIndex + 2
        local vu30 = vu29:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", vu29)
        vu30.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 230, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 240, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 225, 255))
        })
        vu30.Rotation = 90
        vu30.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.5, 0.82),
            NumberSequenceKeypoint.new(1, 0.92)
        })
        task.spawn(function()
            local v31 = tick()
            while pu26 and pu26.Parent do
                local v32 = tick() - v31
                if vu28 and (vu30 and (vu27 and vu29)) then
                    vu28.Rotation = v32 * 6 % 360
                    vu30.Rotation = (90 + v32 * 4) % 360
                    vu27.Position = UDim2.new(- 0.22 + math.sin(v32 * 0.6) * 0.01, 0, - 0.1 + math.cos(v32 * 0.4) * 0.01, 0)
                    vu29.Position = UDim2.new(- 0.32 + math.cos(v32 * 0.45) * 0.01, 0, - 0.2 + math.sin(v32 * 0.55) * 0.01, 0)
                end
                task.wait(0.04)
            end
        end)
    end
end
local function vu40(pu34, p35)
    if pu34 then
        local vu36 = p35 or {}
        pu34.AutoButtonColor = false
        pu34.BackgroundColor3 = vu36.bgColor or Color3.fromRGB(200, 220, 255)
        pu34.BackgroundTransparency = vu36.bgTransparency or 0.48
        vu15(pu34, vu36.radius or 10)
        local v37 = pu34:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", pu34)
        v37.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
        })
        v37.Rotation = vu36.rotation or 90
        v37.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0.2)
        })
        pu34.InputBegan:Connect(function(p38)
            if p38.UserInputType == Enum.UserInputType.MouseButton1 or p38.UserInputType == Enum.UserInputType.Touch then
                pcall(function()
                    vu4:Create(pu34, TweenInfo.new(0.09, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = math.max(0, (pu34.BackgroundTransparency or 0) - 0.12)
                    }):Play()
                end)
            end
        end)
        pu34.InputEnded:Connect(function(p39)
            if p39.UserInputType == Enum.UserInputType.MouseButton1 or p39.UserInputType == Enum.UserInputType.Touch then
                pcall(function()
                    vu4:Create(pu34, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = vu36.bgTransparency or 0.48
                    }):Play()
                end)
            end
        end)
    end
end
local function vu49(pu41)
    if pu41 then
        local v42 = pu41:FindFirstChild("__waterRing") or Instance.new("Frame", pu41)
        v42.Name = "__waterRing"
        v42.Size = UDim2.new(1.06, 0, 1.06, 0)
        v42.Position = UDim2.new(- 0.03, 0, - 0.03, 0)
        v42.BackgroundTransparency = 1
        v42.ZIndex = pu41.ZIndex + 1
        vu15(v42, 12)
        local vu43 = v42:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", v42)
        vu43.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 140, 220))
        })
        vu43.Rotation = 0
        vu43.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(1, 0.85)
        })
        local vu44 = v42:FindFirstChild("__waterHigh") or Instance.new("Frame", v42)
        vu44.Name = "__waterHigh"
        vu44.Size = UDim2.new(0.18, 0, 1.4, 0)
        vu44.Position = UDim2.new(- 0.25, 0, - 0.2, 0)
        vu44.BackgroundTransparency = 1
        vu44.ZIndex = v42.ZIndex + 1
        local v45 = vu44:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", vu44)
        v45.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 235, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
        v45.Rotation = 20
        v45.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.5, 0.75),
            NumberSequenceKeypoint.new(1, 0.9)
        })
        task.spawn(function()
            local v46 = tick()
            while pu41 and pu41.Parent do
                local v47 = tick() - v46
                local v48 = - 0.35 + v47 * 0.25 % 1.7
                vu44.Position = UDim2.new(v48, 0, - 0.2, 0)
                vu43.Rotation = v47 * 40 % 360
                task.wait(0.03)
            end
        end)
    end
end
local function vu51()
    local v50 = vu8:FindFirstChild("LiquidGlassBlur")
    if not v50 then
        v50 = Instance.new("BlurEffect", vu8)
        v50.Name = "LiquidGlassBlur"
        v50.Size = 0
        v50.Enabled = true
    end
    return v50
end
local function vu59(p52, p53)
    local v54 = vu51()
    local v55 = p53 or 0.28
    local v56 = v54.Size
    local v57 = math.max(1, math.floor(v55 / 0.02))
    for v58 = 1, v57 do
        v54.Size = v56 + (p52 - v56) * (v58 / v57)
        task.wait(v55 / v57)
    end
    v54.Size = p52
end
local v60 = Instance.new("ScreenGui", v9)
v60.Name = "PhucmaxRainbowUI"
v60.ResetOnSpawn = false
v60.DisplayOrder = 1000
local function v64(pu61)
    local vu62 = Instance.new("UIStroke", pu61)
    vu62.Thickness = 2
    vu62.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu62.Color = Color3.new(1, 0, 0)
    task.spawn(function()
        local v63 = 0
        while pu61.Parent do
            v63 = (v63 + 1) % 255
            vu62.Color = Color3.fromHSV(v63 / 255, 1, 1)
            task.wait(0.03)
        end
    end)
end
local v65 = Instance.new("Frame", v60)
v65.Size = UDim2.new(0, 280, 0, 340)
v65.AnchorPoint = Vector2.new(0.5, 0.5)
v65.Position = UDim2.new(0.5, 0, 0.5, 0)
v65.ClipsDescendants = true
v65.Visible = false
v65.Active = true
v65.Draggable = true
vu15(v65, 16)
v64(v65)
v33(v65)
local vu66 = Instance.new("ScrollingFrame", v65)
vu66.Size = UDim2.new(1, - 20, 0, 36)
vu66.Position = UDim2.new(0, 10, 0, 10)
vu66.ScrollBarThickness = 4
vu66.ScrollingDirection = Enum.ScrollingDirection.X
vu66.CanvasSize = UDim2.new(0, 0, 0, 0)
vu66.BackgroundTransparency = 1
local vu67 = Instance.new("UIListLayout", vu66)
vu67.FillDirection = Enum.FillDirection.Horizontal
vu67.Padding = UDim.new(0, 5)
vu67.SortOrder = Enum.SortOrder.LayoutOrder
local function vu74()
    task.wait()
    local v68 = vu66
    local v69, v70, v71 = pairs(v68:GetChildren())
    local v72 = 0
    while true do
        local v73
        v71, v73 = v69(v70, v71)
        if v71 == nil then
            break
        end
        if v73:IsA("TextButton") then
            v72 = v72 + v73.Size.X.Offset + vu67.Padding.Offset
        end
    end
    vu66.CanvasSize = UDim2.new(0, v72, 0, 0)
end
local vu75 = Instance.new("Frame", v65)
vu75.Size = UDim2.new(1, - 20, 1, - 60)
vu75.Position = UDim2.new(0, 10, 0, 50)
vu75.BackgroundTransparency = 1
local vu76 = {}
local vu77 = nil
local function vu83(p78)
    local v79, v80, v81 = pairs(vu76)
    while true do
        local v82
        v81, v82 = v79(v80, v81)
        if v81 == nil then
            break
        end
        v82.Visible = v81 == p78
    end
end
local function v88(pu84)
    local v85 = Instance.new("TextButton", vu66)
    v85.Size = UDim2.new(0, 80, 1, 0)
    v85.Text = pu84
    v85.TextColor3 = Color3.new(1, 1, 1)
    v85.Font = Enum.Font.GothamBold
    v85.TextSize = 14
    v85.BackgroundTransparency = 0.6
    vu15(v85, 8)
    vu40(v85, {
        bgColor = Color3.fromRGB(200, 220, 255),
        bgTransparency = 0.58,
        radius = 8
    })
    local v86 = Instance.new("ScrollingFrame", vu75)
    v86.Size = UDim2.new(1, 0, 1, 0)
    v86.CanvasSize = UDim2.new(0, 0, 0, 0)
    v86.ScrollBarThickness = 4
    v86.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v86.BackgroundTransparency = 1
    local v87 = Instance.new("UIListLayout", v86)
    v87.Padding = UDim.new(0, 6)
    v87.SortOrder = Enum.SortOrder.LayoutOrder
    v87.HorizontalAlignment = Enum.HorizontalAlignment.Center
    vu76[pu84] = v86
    v86.Visible = false
    v85.MouseButton1Click:Connect(function()
        vu83(pu84)
    end)
    if not vu77 then
        vu77 = pu84
        v86.Visible = true
    end
    vu74()
    return v86
end
v88("Home")
v88("Finder")
local vu89 = Instance.new("Sound", vu6)
vu89.SoundId = "rbxassetid://130735042055734"
vu89.Volume = 0.5
local vu90 = Instance.new("Sound", vu6)
vu90.SoundId = "rbxassetid://142376088"
vu90.Volume = 0.5
local vu91 = Instance.new("Sound", vu6)
vu91.SoundId = "rbxassetid://5735662572"
vu91.Volume = 1
local v92 = Instance.new("Sound", vu6)
v92.SoundId = "rbxassetid://6234792983"
v92.Volume = 1
local v93 = Instance.new("Sound", vu6)
v93.SoundId = "rbxassetid://1837258874"
v93.Volume = 0.5
local function vu99(pu94, p95)
    pu94.TimePosition = 0
    pu94:Play()
    task.delay(p95, function()
        local v96 = 1
        local v97 = pu94.Volume
        local v98 = v97 / (v96 * 30)
        for _ = 1, v96 * 30 do
            pu94.Volume = pu94.Volume - v98
            task.wait(0.03333333333333333)
        end
        pu94:Stop()
        pu94.Volume = v97
    end)
end
vu99(v92, 3)
local function _()
    local v100 = vu3
    local vu101 = Instance.new("ScreenGui", v100:WaitForChild("PlayerGui"))
    vu101.ResetOnSpawn = false
    local vu102 = Instance.new("TextLabel", vu101)
    vu102.Size = UDim2.new(0.8, 0, 0.2, 0)
    vu102.Position = UDim2.new(0.1, 0, 0.4, 0)
    vu102.BackgroundTransparency = 1
    vu102.Text = "\226\154\160 Haz sido baneado por utilizar el Script en Server Privado \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\nSi quieres unban escribeme a mi Telegram: @Alexvmofc\\You got ban, dont use on Private Servers"
    vu102.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu102.TextWrapped = true
    vu102.Font = Enum.Font.GothamBold
    vu102.TextScaled = true
    vu102.TextTransparency = 0
    task.delay(8, function()
        for v103 = 0, 1, 0.05 do
            vu102.TextTransparency = v103
            task.wait(0.1)
        end
        vu101:Destroy()
    end)
end
local function vu105()
    local v104 = vu3:FindFirstChildOfClass("PlayerGui")
    while not v104 do
        task.wait()
        v104 = vu3:FindFirstChildOfClass("PlayerGui")
    end
    return v104
end
local function vu109(p106, p107)
    local v108 = Instance.new("UIStroke")
    v108.Thickness = p107 or 1.4
    v108.Color = Color3.new(0, 0, 0)
    v108.LineJoinMode = Enum.LineJoinMode.Round
    v108.Parent = p106
end
local vu110 = nil
local vu111 = nil
local function v120()
    local v112 = vu105()
    local v113 = v112:FindFirstChild("TopBannerGui") or Instance.new("ScreenGui")
    v113.Name = "TopBannerGui"
    v113.IgnoreGuiInset = true
    v113.ResetOnSpawn = false
    v113.Parent = v112
    vu111 = Instance.new("TextLabel", v113)
    vu111.Name = "Top_Title"
    vu111.AnchorPoint = Vector2.new(0.5, 0)
    vu111.Position = UDim2.new(0.5, 0, 0, 8)
    vu111.Size = UDim2.new(0, 800, 0, 36)
    vu111.BackgroundTransparency = 1
    vu111.Text = "Luther Pet Finder Free/Gratis"
    vu111.Font = Enum.Font.GothamBlack
    vu111.TextSize = 28
    vu111.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu109(vu111, 2.2)
    local v114 = Instance.new("TextLabel", v113)
    v114.Name = "Subtitle"
    v114.AnchorPoint = Vector2.new(0.5, 0)
    v114.Position = UDim2.new(0.5, 0, 0, 40)
    v114.BackgroundTransparency = 1
    v114.Text = "YouTube: Alex VM Scripts | Tested by: UserX"
    v114.Font = Enum.Font.GothamSemibold
    v114.TextSize = 16
    v114.TextColor3 = Color3.fromRGB(200, 200, 200)
    vu109(v114, 1)
    if vu110 then
        vu110:Disconnect()
    end
    vu110 = vu7.Heartbeat:Connect(function()
        local v115 = os.clock() * 0.25 % 1
        vu111.TextColor3 = Color3.fromHSV(v115, 1, 1)
    end)
    vu111.AncestryChanged:Connect(function(_, p116)
        if not p116 and vu110 then
            vu110:Disconnect()
            vu110 = nil
        end
    end)
    local v117 = v112:FindFirstChild("BottomBannerGui") or Instance.new("ScreenGui")
    v117.Name = "BottomBannerGui"
    v117.IgnoreGuiInset = true
    v117.ResetOnSpawn = false
    v117.Parent = v112
    local v118 = Instance.new("Frame", v117)
    v118.Name = "BR_Block"
    v118.AnchorPoint = Vector2.new(1, 1)
    v118.Position = UDim2.new(1, - 20, 1, - 20)
    v118.Size = UDim2.new(0, 340, 0, 72)
    v118.BackgroundTransparency = 1
    local v119 = Instance.new("TextLabel", v118)
    v119.Size = UDim2.new(1, - 10, 1, - 10)
    v119.Position = UDim2.new(0, 5, 0, 5)
    v119.BackgroundTransparency = 1
    v119.Text = "This Script is Free\nEste Script es Gratis"
    v119.TextWrapped = true
    v119.TextXAlignment = Enum.TextXAlignment.Right
    v119.TextYAlignment = Enum.TextYAlignment.Center
    v119.Font = Enum.Font.GothamSemibold
    v119.TextSize = 20
    v119.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu109(v119, 2)
end
task.defer(v120)
local vu121 = {
    {
        name = "Lucky -5M",
        color = Color3.fromRGB(255, 80, 80)
    },
    {
        name = "Lucky 15M",
        color = Color3.fromRGB(80, 255, 100)
    },
    {
        name = "Lucky VIP Free",
        color = Color3.fromRGB(180, 0, 255)
    }
}
local vu122 = 840
local vu123 = false
local vu124 = "Calcula tu suerte"
local vu125 = nil
local v126 = vu3
local v127 = Instance.new("ScreenGui", vu3.WaitForChild(v126, "PlayerGui"))
v127.Name = "LuckyUI"
v127.ResetOnSpawn = false
local v128 = Instance.new("TextButton", v127)
v128.TextScaled = true
v128.Font = Enum.Font.GothamBold
Instance.new("UICorner", v128).CornerRadius = UDim.new(0, 15)
vu40(v128, {
    bgColor = Color3.fromRGB(190, 210, 255),
    bgTransparency = 0.5
})
local vu129 = Instance.new("Frame", v127)
vu129.AnchorPoint = Vector2.new(0.5, 0.5)
vu129.Position = UDim2.new(0.5, 0, - 0.5, 0)
vu129.Size = UDim2.new(0, 320, 0, 170)
vu129.Visible = false
vu15(vu129, 20)
v33(vu129)
local vu130 = Instance.new("TextLabel", vu129)
vu130.Size = UDim2.new(1, - 20, 0.6, 0)
vu130.Position = UDim2.new(0, 10, 0, 10)
vu130.BackgroundTransparency = 1
vu130.Text = "Gira la ruleta para obtener buena suerte!"
vu130.TextColor3 = Color3.fromRGB(255, 255, 255)
vu130.Font = Enum.Font.GothamBold
vu130.TextScaled = true
vu130.TextWrapped = true
local vu131 = Instance.new("TextButton", vu129)
vu131.Size = UDim2.new(0.6, 0, 0.25, 0)
vu131.Position = UDim2.new(0.2, 0, 0.65, 0)
vu131.Text = "Girar"
vu131.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
vu131.TextColor3 = Color3.fromRGB(255, 255, 255)
vu131.TextScaled = true
vu131.Font = Enum.Font.GothamBold
Instance.new("UICorner", vu131).CornerRadius = UDim.new(0, 12)
vu40(vu131, {
    bgColor = Color3.fromRGB(100, 160, 235),
    bgTransparency = 0.34,
    radius = 12
})
local function vu136(p132)
    local v133, v134 = pcall(function()
        return vu1:RequestAsync({
            Url = vu11,
            Method = "GET"
        })
    end)
    if v133 and v134.Success then
        local v135 = vu1:JSONDecode(v134.Body)
        if v135 and v135[tostring(p132)] then
            return v135[tostring(p132)]
        end
    end
    return nil
end
local function vu142(p137, p138, p139)
    local v140 = {
        luck = p138,
        expiresAt = p139,
        lastSeen = os.time(),
        username = vu3.Name,
        server = game.JobId,
        ban = false
    }
    local vu141 = vu1:JSONEncode({
        [tostring(p137)] = v140
    })
    pcall(function()
        vu1:RequestAsync({
            Url = vu11,
            Method = "PATCH",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = vu141
        })
    end)
end
local function vu152(p143)
    if not p143 or p143 <= 0 then
        return "0s"
    end
    local v144 = math.floor(p143 / 86400)
    local v145 = p143 - v144 * 86400
    local v146 = math.floor(v145 / 3600)
    local v147 = v145 - v146 * 3600
    local v148 = math.floor(v147 / 60)
    local v149 = v147 - v148 * 60
    local v150 = math.floor(v149)
    local v151 = {}
    if v144 > 0 then
        table.insert(v151, v144 .. "d")
    end
    if v146 > 0 then
        table.insert(v151, v146 .. "h")
    end
    if v148 > 0 then
        table.insert(v151, v148 .. "m")
    end
    if v150 > 0 then
        table.insert(v151, v150 .. "s")
    en
