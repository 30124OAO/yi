--养大一只鸡战士功能融合面板
--脚本作者b站UID:647396778
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local loopChallengeRunning = false
local panelVisible = false

local autoAfk = false
local rangeLimit = 16.66
local spawnPosition = nil

local autoScrapRunning = false
local reachRange = 10
local targetScrapPos = nil
local collectedCount = 0
local selectNum = 1
local recycleDestination

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainPanelUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 140, 0, 48)
MainButton.Position = UDim2.new(0.05, 0, 0.3, 0)
MainButton.BackgroundColor3 = Color3.new(0.12, 0.22, 0.35)
MainButton.BorderColor3 = Color3.new(0.5, 0.8, 1)
MainButton.BorderSizePixel = 2
MainButton.Text = "养大一只鸡战士功能菜单"
MainButton.TextColor3 = Color3.new(1,1,1)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.TextSize = 14
MainButton.Parent = ScreenGui

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 320, 0, 290)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
MainPanel.BorderColor3 = Color3.new(0.4, 0.6, 0.9)
MainPanel.BorderSizePixel = 2
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 32)
Title.BackgroundTransparency = 1
Title.Text = "功能主面板"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 17
Title.Position = UDim2.new(0,10,0,0)
Title.Parent = MainPanel

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -38, 0, 0)
CloseBtn.BackgroundColor3 = Color3.new(0.7,0.15,0.15)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 22
CloseBtn.Parent = MainPanel

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 32, 0, 32)
ResizeHandle.Position = UDim2.new(1, -32, 1, -32)
ResizeHandle.BackgroundTransparency = 0.6
ResizeHandle.BackgroundColor3 = Color3.new(0.35,0.45,0.65)
ResizeHandle.Text = "丿"
ResizeHandle.TextColor3 = Color3.new(1,1,1)
ResizeHandle.Font = Enum.Font.SourceSansBold
ResizeHandle.TextSize = 20
ResizeHandle.Parent = MainPanel

local RebirthTipLabel = Instance.new("TextLabel")
RebirthTipLabel.Size = UDim2.new(0.9,0,0,24)
RebirthTipLabel.Position = UDim2.new(0.05,0,0.10,0)
RebirthTipLabel.BackgroundTransparency = 1
RebirthTipLabel.Text = "已添加达到重生要求自动撤离（前提:必须要让你的当前重生UI保持为点开）"
RebirthTipLabel.TextColor3 = Color3.new(0.85,0.85,0.85)
RebirthTipLabel.Font = Enum.Font.SourceSans
RebirthTipLabel.TextSize = 10
RebirthTipLabel.TextWrapped = true
RebirthTipLabel.Parent = MainPanel

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 34)
toggleBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
toggleBtn.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
toggleBtn.Text = "自动重生 当前状态:[关闭]"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.BorderSizePixel = 2
toggleBtn.BorderColor3 = Color3.new(0.4,0.6,1)
toggleBtn.Parent = MainPanel

local afkMoveBtn = Instance.new("TextButton")
afkMoveBtn.Size = UDim2.new(0.9, 0, 0, 34)
afkMoveBtn.Position = UDim2.new(0.05, 0, 0.33, 0)
afkMoveBtn.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
afkMoveBtn.TextColor3 = Color3.new(1,1,1)
afkMoveBtn.Font = Enum.Font.SourceSansBold
afkMoveBtn.TextSize = 14
afkMoveBtn.BorderSizePixel = 2
afkMoveBtn.BorderColor3 = Color3.new(0.4,0.6,1)
afkMoveBtn.Parent = MainPanel

local scrapBtn = Instance.new("TextButton")
scrapBtn.Size = UDim2.new(0.9, 0, 0, 34)
scrapBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
scrapBtn.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
scrapBtn.Text = "自动捡垃圾 [关闭]"
scrapBtn.TextColor3 = Color3.new(1,1,1)
scrapBtn.Font = Enum.Font.SourceSansBold
scrapBtn.TextSize = 13
scrapBtn.BorderSizePixel = 2
scrapBtn.BorderColor3 = Color3.new(0.4,0.6,1)
scrapBtn.Parent = MainPanel

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(0.9, 0, 0, 20)
SliderTrack.Position = UDim2.new(0.05, 0, 0.62, 0)
SliderTrack.BackgroundColor3 = Color3.new(0.07,0.07,0.11)
SliderTrack.BorderSizePixel = 1
SliderTrack.BorderColor3 = Color3.new(0.3,0.4,0.7)
SliderTrack.Parent = MainPanel

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0,0,1,0)
SliderFill.BackgroundColor3 = Color3.new(0.2,0.7,0.9)
SliderFill.Parent = SliderTrack

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 18, 0, 18)
SliderKnob.BackgroundColor3 = Color3.new(1,1,1)
SliderKnob.Text = ""
SliderKnob.Position = UDim2.new(0,-9,0.5,-9)
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SliderTrack

local TipText = Instance.new("TextLabel")
TipText.Size = UDim2.new(0.9, 0, 0, 18)
TipText.Position = UDim2.new(0.05, 0, 0.72, 0)
TipText.BackgroundTransparency = 1
TipText.Text = "捡（1）垃圾回去"
TipText.TextColor3 = Color3.new(0.9,0.9,0.9)
TipText.Font = Enum.Font.SourceSans
TipText.TextSize = 11
TipText.Parent = MainPanel

local NoticeText = Instance.new("TextLabel")
NoticeText.Size = UDim2.new(0.9, 0, 0, 18)
NoticeText.Position = UDim2.new(0.05, 0, 0.78, 0)
NoticeText.BackgroundTransparency = 1
NoticeText.Text = "提示:此脚本无防挂机功能，可用自动点击器来代替"
NoticeText.TextColor3 = Color3.new(0.75,0.75,0.75)
NoticeText.Font = Enum.Font.SourceSans
NoticeText.TextSize = 10
NoticeText.Parent = MainPanel

local sliderMin = 1
local sliderMax = 6
local draggingSlider = false
local function UpdateSliderUI(value)
    local ratio = (value - sliderMin)/(sliderMax-sliderMin)
    SliderFill.Size = UDim2.new(ratio,0,1,0)
    SliderKnob.Position = UDim2.new(ratio,-9,0.5,-9)
    selectNum = math.floor(value)
    TipText.Text = "捡（"..selectNum.."）垃圾回去"
end
UpdateSliderUI(selectNum)

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local posX = input.Position.X
        local absX = SliderTrack.AbsolutePosition.X
        local width = SliderTrack.AbsoluteSize.X
        local scale = math.clamp((posX-absX)/width,0,1)
        local val = sliderMin + (sliderMax-sliderMin)*scale
        UpdateSliderUI(val)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

local function RunGeneratorCode()
    pcall(function()
        local args = {[1] = 5}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 3}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 4}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 6}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 6}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 4}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 3}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 5}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 1}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 2}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 1}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
    pcall(function()
        local args = {[1] = 2}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(args))
    end)
end

local function RunTowerElevatorSequence()
    local num = 1
    local totalTimes = 20
    for i = 1, totalTimes do
        if not loopChallengeRunning then break end
        pcall(function()
            local args = {[1] = num}
            game:GetService("ReplicatedStorage").Remotes.TowerElevator:InvokeServer(unpack(args))
        end)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
        end)
        num += 5
        task.wait(0.1)
    end
end

local function startLoop()
    loopChallengeRunning = true
    toggleBtn.Text = "自动重生 当前状态:[开启]"

    task.spawn(function()
        while loopChallengeRunning do
            print("🔁循环执���重生整套流程")
            pcall(function()
                local args = {[1] = "coop"}
                game:GetService("ReplicatedStorage").Remotes.SetChickenOrder:FireServer(unpack(args))
            end)
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerSurrender:InvokeServer()
            end)
            task.wait(6)
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Rebirth:InvokeServer()
            end)
            task.wait(1.2)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerContinueDecline:FireServer()
            end)
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            RunGeneratorCode()
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.ExpandCoop:InvokeServer()
            end)
            task.wait(1)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            RunGeneratorCode()
            task.wait(0.9)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
            end)
            task.wait(98)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            RunTowerElevatorSequence()
            task.wait(88)
        end
    end)

    task.spawn(function()
        while loopChallengeRunning do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.IncubatorClaim:InvokeServer()
            end)
            task.wait(1)
        end
    end)
end

local function stopLoop()
    loopChallengeRunning = false
    toggleBtn.Text = "自动重生 当前状态:[关闭]"
end

toggleBtn.MouseButton1Click:Connect(function()
    if loopChallengeRunning then
        stopLoop()
    else
        startLoop()
    end
end)

local directions = {
    Vector3.new(1,0,-1),
    Vector3.new(-1,0,-1),
    Vector3.new(-1,0,1),
    Vector3.new(1,0,1),
    Vector3.new(0,0,-1),
    Vector3.new(0,0,1),
    Vector3.new(-1,0,0),
    Vector3.new(1,0,0)
}
task.spawn(function()
    local baseMoveStep = 10
    local maxDistance = 6.6
    local tickDelay = 0.05
    local currentDirIndex = math.random(1,#directions)
    local traveled = 0
    while task.wait(tickDelay) do
        if autoAfk then
            local char = localPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            if not spawnPosition then
                spawnPosition = root.Position
            end
            local targetDir = directions[currentDirIndex].Unit
            local nextPos = root.Position + targetDir * baseMoveStep * tickDelay
            local dx = math.abs(nextPos.X - spawnPosition.X)
            local dz = math.abs(nextPos.Z - spawnPosition.Z)
            if dx > rangeLimit or dz > rangeLimit then
                root.CFrame = CFrame.new(spawnPosition)
                currentDirIndex = math.random(1,#directions)
                traveled = 0
                continue
            end
            root.CFrame += targetDir * baseMoveStep * tickDelay
            traveled += baseMoveStep * tickDelay
            if traveled >= maxDistance then
                currentDirIndex = math.random(1,#directions)
                traveled = 0
            end
        else
            currentDirIndex = math.random(1,#directions)
            traveled = 0
            spawnPosition = nil
        end
    end
end)

afkMoveBtn.MouseButton1Click:Connect(function()
    autoAfk = not autoAfk
    if autoAfk then
        afkMoveBtn.Text = "挂机移动 当前状态:[开启]"
    else
        afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
    end
end)

local function ScrapMainLoop()
    while autoScrapRunning do
        local delayTime = 0.5
        local recyclerUI = workspace:FindFirstChild("Recyclers") and workspace.Recyclers:FindFirstChild("RecyclerUI")
        if recyclerUI and recyclerUI:FindFirstChildOfClass("Part") then
            recycleDestination = recyclerUI:FindFirstChildOfClass("Part").Position
        end

        local Character = localPlayer.Character
        if not Character then
            task.wait(delayTime)
            continue
        end
        local RootPart = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or not recycleDestination then
            task.wait(delayTime)
            continue
        end

        local state
        if collectedCount < selectNum then
            state = "FindScrap"
        else
            state = "GoHome"
        end

        if state == "FindScrap" then
            local scrapTable = {}
            local playerPos = RootPart.Position
            for _, item in ipairs(workspace:GetChildren()) do
                if item:IsA("Model") and item.Name == "PitScrap" then
                    local scrapPart = item:FindFirstChildOfClass("Part")
                    if scrapPart then
                        local dist = (playerPos - scrapPart.Position).Magnitude
                        table.insert(scrapTable, {
                            Model = item,
                            PartPos = scrapPart.Position,
                            Dist = dist
                        })
                    end
                end
            end
            table.sort(scrapTable, function(a,b)
                return a.Dist < b.Dist
            end)

            if #scrapTable > 0 then
                local nearestScrap = scrapTable[1]
                targetScrapPos = nearestScrap.PartPos
                local dist = (playerPos - targetScrapPos).Magnitude
                if dist <= reachRange then
                    collectedCount += 1
                    targetScrapPos = nil
                else
                    Humanoid:MoveTo(targetScrapPos)
                end
            end
        elseif state == "GoHome" then
            local dist = (RootPart.Position - recycleDestination).Magnitude
            if dist <= reachRange then
                collectedCount = 0
            else
                Humanoid:MoveTo(recycleDestination)
            end
        end
        task.wait(delayTime)
    end
    local char = localPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid:Stop()
    end
end

local function UpgradeRecyclerLoop()
    while autoScrapRunning do
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.UpgradeRecycler:InvokeServer()
        end)
    end
end

scrapBtn.MouseButton1Click:Connect(function()
    autoScrapRunning = not autoScrapRunning
    if autoScrapRunning then
        scrapBtn.Text = "自动捡垃圾 [开启]"
        targetScrapPos = nil
        collectedCount = 0
        task.spawn(ScrapMainLoop)
        task.spawn(UpgradeRecyclerLoop)
    else
        scrapBtn.Text = "自动捡垃圾 [关闭]"
        targetScrapPos = nil
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:Stop()
        end
    end
end)

local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 260, 0, 160)
ConfirmFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
ConfirmFrame.BackgroundColor3 = Color3.new(0.12,0.12,0.18)
ConfirmFrame.BorderColor3 = Color3.new(0.5,0.6,0.95)
ConfirmFrame.BorderSizePixel = 2
ConfirmFrame.Visible = false
ConfirmFrame.Parent = ScreenGui

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(0.9,0,0,50)
ConfirmText.Position = UDim2.new(0.05,0,0.05,0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "确认关闭面板？\n将会停止所有运行功能"
ConfirmText.TextColor3 = Color3.new(1,1,1)
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextSize = 16
ConfirmText.TextWrapped = true
ConfirmText.Parent = ConfirmFrame

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 40)
NoBtn.Position = UDim2.new(0.05,0,0.65,0)
NoBtn.BackgroundColor3 = Color3.new(0.2,0.3,0.45)
NoBtn.Text = "否"
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Font = Enum.Font.SourceSansBold
NoBtn.TextSize = 16
NoBtn.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 40)
YesBtn.Position = UDim2.new(0.62,0,0.65,0)
YesBtn.BackgroundColor3 = Color3.new(0.45,0.2,0.2)
YesBtn.Text = "是"
YesBtn.TextColor3 = Color3.new(1,1,1)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.TextSize = 16
YesBtn.Parent = ConfirmFrame

local function MakeDraggable(guiObj)
    local dragging = false
    local startTouchPos
    local objStartPosition
    local activeInput = nil

    guiObj.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not dragging then
            dragging = true
            activeInput = input
            startTouchPos = input.Position
            objStartPosition = guiObj.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == activeInput then
            local offset = input.Position - startTouchPos
            guiObj.Position = UDim2.new(
                objStartPosition.X.Scale, objStartPosition.X.Offset + offset.X,
                objStartPosition.Y.Scale, objStartPosition.Y.Offset + offset.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput then
            dragging = false
            activeInput = nil
        end
    end)
end

local resizeDragging = false
local resizeStartPos
local startSize
local resizeInput = nil
ResizeHandle.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not resizeDragging then
        resizeDragging = true
        resizeInput = input
        resizeStartPos = input.Position
        startSize = Vector2.new(MainPanel.Size.X.Offset, MainPanel.Size.Y.Offset)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizeDragging and input == resizeInput then
        local delta = input.Position - resizeStartPos
        local newW = math.max(220, startSize.X + delta.X)
        local newH = math.max(290, startSize.Y + delta.Y)
        MainPanel.Size = UDim2.new(0, newW, 0, newH)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == resizeInput then
        resizeDragging = false
        resizeInput = nil
    end
end)

MakeDraggable(MainButton)
MakeDraggable(MainPanel)

MainButton.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    MainPanel.Visible = panelVisible
    ConfirmFrame.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    stopLoop()
    autoAfk = false
    autoScrapRunning = false
    afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
    scrapBtn.Text = "自动捡垃圾 [关闭]"

    ConfirmFrame.Visible = false
    MainPanel.Visible = false
    panelVisible = false
    MainButton.Visible = false
end)
