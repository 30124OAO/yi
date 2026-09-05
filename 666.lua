--养大一只鸡战士功能面板
--脚本作者b站UID:647396778
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 全局总开关
local globalRunning = true
local loopChallengeRunning = false
local panelVisible = false
local suspendTowerLoops = false
local detectTriggerCount = 0
local triggerCooldown = 0
local autoAfk = false
local rangeLimit = 16.66
local spawnPosition = nil

local autoScrapRunning = false
local reachRange = 5.5
local targetScrapPos = nil
local collectedCount = 0
local selectNum = 1
local recycleDestination
local towerDelaySliderValue = 12
local threadPool = {}

-- === 弹窗总开关（默认开启）===
local popupEnable = true

-- 塔弹窗全局记录（用于：检测不到TOWER立刻关闭弹窗）
local towerNotifyData = nil

-- ★★新：塔计时器全局状态（单条线程，不复开）
local towerTimerRunning = false
local towerRemainingTime = 0

-- ========= 弹窗通知模块（右上角、无淡入淡出、到时直接销毁） =========
local activePopups = {}
local function CreatePopup(text, lifeTime)
    --弹窗总开关关闭，则直接退出，不创建弹窗
    if not popupEnable then return end
	
    --弹窗数量上限3，移除最早的弹窗防止界面拥挤
    while #activePopups >= 3 do
        local oldGui = table.remove(activePopups,1)
        pcall(function() oldGui:Destroy() end)
    end

    local PopGui = Instance.new("ScreenGui")
    PopGui.Name = "NotifyPopup"
    PopGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PopGui.ResetOnSpawn = false
    PopGui.Parent = localPlayer:WaitForChild("PlayerGui")

    local PopFrame = Instance.new("Frame")
    PopFrame.Size = UDim2.new(0,240,0,56)
    PopFrame.Position = UDim2.new(1,-250,0.02, #activePopups * 62)
    PopFrame.BackgroundColor3 = Color3.new(0.15,0.18,0.25)
    PopFrame.BorderColor3 = Color3.new(0.25,0.65,1)
    PopFrame.BorderSizePixel = 2
    PopFrame.Parent = PopGui

    local PopLabel = Instance.new("TextLabel")
    PopLabel.Size = UDim2.new(1,0,1,0)
    PopLabel.BackgroundTransparency = 1
    PopLabel.Text = text
    PopLabel.TextColor3 = Color3.new(1,1,1)
    PopLabel.Font = Enum.Font.SourceSansBold
    PopLabel.TextSize = 14
    PopLabel.TextWrapped = true
    PopLabel.Parent = PopFrame

    table.insert(activePopups,PopGui)

    task.spawn(function()
        task.wait(lifeTime)
        local idx = table.find(activePopups,PopGui)
        if idx then table.remove(activePopups,idx) end
        pcall(function() PopGui:Destroy() end)
    end)
    return {gui = PopGui, label = PopLabel}
end

-- 专门销毁塔弹窗
local function ClearTowerPopup()
    if towerNotifyData then
        pcall(function() towerNotifyData.gui:Destroy() end)
        local idx = table.find(activePopups, towerNotifyData.gui)
        if idx then table.remove(activePopups, idx) end
        towerNotifyData = nil
    end
end
-- =====================================================================

--===================== 【新版UI界面，来自你提供的模板】=====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileMenuUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingMenuBtn"
FloatingBtn.Size = UDim2.new(0, 85, 0, 45)
FloatingBtn.Position = UDim2.new(0, 30, 0, 80)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
FloatingBtn.Text = "功能菜单"
FloatingBtn.TextColor3 = Color3.new(1, 1, 1)
FloatingBtn.TextSize = 14
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Active = true
FloatingBtn.Draggable = true
FloatingBtn.ZIndex = 10
FloatingBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 8)
FloatCorner.Parent = FloatingBtn

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 340, 0, 420)
MainPanel.Position = UDim2.new(0.5, -170, 0.5, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true
MainPanel.Visible = false
MainPanel.ZIndex = 20
MainPanel.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainPanel

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 42)
MainTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MainTitle.Text = "养大一只鸡战士｜功能菜单"
MainTitle.TextColor3 = Color3.new(1, 1, 1)
MainTitle.TextSize = 17
MainTitle.Font = Enum.Font.GothamBold
MainTitle.ZIndex = 21
MainTitle.Parent = MainPanel

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = MainTitle

local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 34, 0, 34)
CloseX.Position = UDim2.new(1, -34, 0, 0)
CloseX.BackgroundTransparency = 1
CloseX.Text = "×"
CloseX.TextColor3 = Color3.new(1, 1, 1)
CloseX.TextSize = 28
CloseX.Font = Enum.Font.GothamBold
CloseX.ZIndex = 22
CloseX.Parent = MainTitle

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 24, 0, 24)
ResizeHandle.Position = UDim2.new(1, -12, 1, -18)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "丿"
ResizeHandle.TextColor3 = Color3.new(1, 1, 1)
ResizeHandle.TextSize = 22
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.ZIndex = 30
ResizeHandle.Parent = MainPanel

local isResizing = false
local resizeStartPos = Vector2.new()
local startPanelSize = UDim2.new()

local MIN_WIDTH = 320
local MIN_HEIGHT = 380

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        resizeStartPos = input.Position
        startPanelSize = MainPanel.Size
        UserInputService.MouseIconEnabled = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isResizing then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local deltaX = input.Position.X - resizeStartPos.X
        local deltaY = input.Position.Y - resizeStartPos.Y
        local newWidth = math.max(MIN_WIDTH, startPanelSize.X.Offset + deltaX)
        local newHeight = math.max(MIN_HEIGHT, startPanelSize.Y.Offset + deltaY)
        MainPanel.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
        UserInputService.MouseIconEnabled = true
    end
end)

local ConfirmPanel = Instance.new("Frame")
ConfirmPanel.Size = UDim2.new(0, 300, 0, 240)
ConfirmPanel.Position = UDim2.new(0.5, -150, 0.5, -120)
ConfirmPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ConfirmPanel.BorderSizePixel = 0
ConfirmPanel.Active = false
ConfirmPanel.Visible = false
ConfirmPanel.ZIndex = 999
ConfirmPanel.Parent = ScreenGui

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 12)
ConfirmCorner.Parent = ConfirmPanel

local TipText = Instance.new("TextLabel")
TipText.Size = UDim2.new(1, 0, 0, 100)
TipText.Position = UDim2.new(0, 0, 0, 10)
TipText.BackgroundTransparency = 1
TipText.Text = "是否关闭面板，这将会停止全部正在运行的功能⚠️"
TipText.TextColor3 = Color3.new(1, 1, 1)
TipText.TextSize = 16
TipText.Font = Enum.Font.GothamBold
TipText.TextWrapped = true
TipText.ZIndex = 1000
TipText.Parent = ConfirmPanel

local BtnNo = Instance.new("TextButton")
BtnNo.Size = UDim2.new(0, 100, 0, 50)
BtnNo.Position = UDim2.new(0, 25, 0, 150)
BtnNo.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
BtnNo.Text = "否"
BtnNo.TextColor3 = Color3.new(1, 1, 1)
BtnNo.TextSize = 16
BtnNo.Font = Enum.Font.GothamBold
BtnNo.ZIndex = 1000
BtnNo.Parent = ConfirmPanel

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 8)
NoCorner.Parent = BtnNo

local BtnYes = Instance.new("TextButton")
BtnYes.Size = UDim2.new(0, 100, 0, 50)
BtnYes.Position = UDim2.new(0, 175, 0, 150)
BtnYes.BackgroundColor3 = Color3.fromRGB(50, 160, 70)
BtnYes.Text = "是"
BtnYes.TextColor3 = Color3.new(1, 1, 1)
BtnYes.TextSize = 16
BtnYes.Font = Enum.Font.GothamBold
BtnYes.ZIndex = 1000
BtnYes.Parent = ConfirmPanel

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 8)
YesCorner.Parent = BtnYes

-- ===================== 在新版面板内部添加原有全部功能按钮 =====================
local contentStartY = 46
local itemGap = 38

--版本提示
local VersionTip = Instance.new("TextLabel")
VersionTip.Size = UDim2.new(0.94,0,0,28)
VersionTip.Position = UDim2.new(0.03,0,0,contentStartY)
VersionTip.BackgroundTransparency = 1
VersionTip.Text = "塔计时｜单一线程不复开，TOWER消失暂停计时"
VersionTip.TextColor3 = Color3.new(0.65,0.85,1)
VersionTip.Font = Enum.Font.Gotham
VersionTip.TextSize = 10
VersionTip.TextWrapped = true
VersionTip.Parent = MainPanel
contentStartY += itemGap

--【弹窗开关按钮】
local popupToggleBtn = Instance.new("TextButton")
popupToggleBtn.Size = UDim2.new(0.94, 0, 0, 32)
popupToggleBtn.Position = UDim2.new(0.03, 0, 0, contentStartY)
popupToggleBtn.BackgroundColor3 = Color3.fromRGB(40,44,60)
popupToggleBtn.Text = "弹窗丨当前状态:开"
popupToggleBtn.TextColor3 = Color3.new(1,1,1)
popupToggleBtn.Font = Enum.Font.GothamBold
popupToggleBtn.TextSize = 14
popupToggleBtn.Parent = MainPanel
local popCorner = Instance.new("UICorner")
popCorner.CornerRadius = UDim.new(0,6)
popCorner.Parent = popupToggleBtn
contentStartY += itemGap

--【自动重生按钮】
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.94, 0, 0, 32)
toggleBtn.Position = UDim2.new(0.03, 0, 0, contentStartY)
toggleBtn.BackgroundColor3 = Color3.fromRGB(38,38,50)
toggleBtn.Text = "自动重生 当前状态:[关闭] | 本次挂机已重生"..detectTriggerCount.."次"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = MainPanel
local rebCorner = Instance.new("UICorner")
rebCorner.CornerRadius = UDim.new(0,6)
rebCorner.Parent = toggleBtn
contentStartY += itemGap

--塔延迟滑块容器
local DelaySliderFrame = Instance.new("Frame")
DelaySliderFrame.Size = UDim2.new(0.94,0,0,20)
DelaySliderFrame.Position = UDim2.new(0.03,0,0,contentStartY)
DelaySliderFrame.BackgroundColor3 = Color3.fromRGB(28,28,40)
DelaySliderFrame.Parent = MainPanel
local delayFrameCorner = Instance.new("UICorner")
delayFrameCorner.CornerRadius = UDim.new(0,4)
delayFrameCorner.Parent = DelaySliderFrame

local DelaySliderFill = Instance.new("Frame")
DelaySliderFill.Size = UDim2.new(0,0,1,0)
DelaySliderFill.BackgroundColor3 = Color3.fromRGB(45,160,210)
DelaySliderFill.Parent = DelaySliderFrame
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0,4)
fillCorner.Parent = DelaySliderFill

local DelaySliderKnob = Instance.new("TextButton")
DelaySliderKnob.Size = UDim2.new(0,18,0,18)
DelaySliderKnob.Position = UDim2.new(0,-9,0.5,-9)
DelaySliderKnob.BackgroundColor3 = Color3.new(1,1,1)
DelaySliderKnob.Text = ""
DelaySliderKnob.Parent = DelaySliderFrame

local DelaySliderText = Instance.new("TextLabel")
DelaySliderText.Size = UDim2.new(1,0,1,0)
DelaySliderText.BackgroundTransparency = 1
DelaySliderText.TextColor3 = Color3.new(1,1,1)
DelaySliderText.Font = Enum.Font.GothamBold
DelaySliderText.TextSize = 11
DelaySliderText.Text = tostring(towerDelaySliderValue).." / 30"
DelaySliderText.Parent = DelaySliderFrame

local sliderMinDelay = 6
local sliderMaxDelay = 30
local draggingDelaySlider = false

local function UpdateDelaySliderUI(val)
    local ratio = (val-sliderMinDelay)/(sliderMaxDelay-sliderMinDelay)
    DelaySliderFill.Size = UDim2.new(ratio,0,1,0)
    DelaySliderKnob.Position = UDim2.new(ratio,-9,0.5,-9)
    towerDelaySliderValue = math.floor(val+0.5)
    DelaySliderText.Text = string.format("%d / 30",towerDelaySliderValue)
end
UpdateDelaySliderUI(towerDelaySliderValue)

DelaySliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingDelaySlider = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingDelaySlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local absPos = input.Position.X
        local frameAbs = DelaySliderFrame.AbsolutePosition.X
        local frameW = DelaySliderFrame.AbsoluteSize.X
        local t = math.clamp((absPos-frameAbs)/frameW,0,1)
        local v = sliderMinDelay + t*(sliderMaxDelay-sliderMinDelay)
        UpdateDelaySliderUI(v)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingDelaySlider = false
    end
end)
contentStartY += itemGap

--挂机移动按钮
local afkMoveBtn = Instance.new("TextButton")
afkMoveBtn.Size = UDim2.new(0.94, 0, 0, 32)
afkMoveBtn.Position = UDim2.new(0.03, 0, 0, contentStartY)
afkMoveBtn.BackgroundColor3 = Color3.fromRGB(38,38,50)
afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
afkMoveBtn.TextColor3 = Color3.new(1,1,1)
afkMoveBtn.Font = Enum.Font.GothamBold
afkMoveBtn.TextSize = 14
afkMoveBtn.Parent = MainPanel
local afkCorner = Instance.new("UICorner")
afkCorner.CornerRadius = UDim.new(0,6)
afkCorner.Parent = afkMoveBtn
contentStartY += itemGap

--自动捡垃圾按钮
local scrapBtn = Instance.new("TextButton")
scrapBtn.Size = UDim2.new(0.94, 0, 0, 32)
scrapBtn.Position = UDim2.new(0.03, 0, 0, contentStartY)
scrapBtn.BackgroundColor3 = Color3.fromRGB(38,38,50)
scrapBtn.Text = "自动捡垃圾 当前状态:[关闭]"
scrapBtn.TextColor3 = Color3.new(1,1,1)
scrapBtn.Font = Enum.Font.GothamBold
scrapBtn.TextSize = 13
scrapBtn.Parent = MainPanel
local scrapCorner = Instance.new("UICorner")
scrapCorner.CornerRadius = UDim.new(0,6)
scrapCorner.Parent = scrapBtn
contentStartY += itemGap

--捡垃圾数量滑块
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.94,0,0,18)
SliderFrame.Position = UDim2.new(0.03,0,0,contentStartY)
SliderFrame.BackgroundColor3 = Color3.fromRGB(26,26,38)
SliderFrame.Parent = MainPanel
local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0,4)
sliderFrameCorner.Parent = SliderFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(50,180,220)
SliderFill.Parent = SliderFrame
local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0,4)
sliderFillCorner.Parent = SliderFill

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0,18,0,18)
SliderKnob.Position = UDim2.new(0,-9,0.5,-9)
SliderKnob.BackgroundColor3 = Color3.new(1,1,1)
SliderKnob.Text = ""
SliderKnob.Parent = SliderFrame

local TipText = Instance.new("TextLabel")
TipText.Size = UDim2.new(0.94,0,0,16)
TipText.Position = UDim2.new(0.03,0,0,contentStartY+22)
TipText.BackgroundTransparency =1
TipText.Text = "捡（1）垃圾回去"
TipText.TextColor3 = Color3.new(0.9,0.9,0.9)
TipText.Font = Enum.Font.Gotham
TipText.TextSize =11
TipText.Parent = MainPanel

local NoticeText = Instance.new("TextLabel")
NoticeText.Size = UDim2.new(0.94,0,0,30)
NoticeText.Position = UDim2.new(0.03,0,0,contentStartY+42)
NoticeText.BackgroundTransparency =1
NoticeText.Text = "提示:本脚本无防挂机功能，可用自动点击器防止挂机踢出"
NoticeText.TextColor3 = Color3.new(0.75,0.75,0.75)
NoticeText.Font = Enum.Font.Gotham
NoticeText.TextSize =10
NoticeText.TextWrapped=true
NoticeText.Parent = MainPanel

local sliderMin =1
local sliderMax =6
local draggingSlider =false

local function UpdateSliderUI(val)
    local ratio = (val-sliderMin)/(sliderMax-sliderMin)
    SliderFill.Size = UDim2.new(ratio,0,1,0)
    SliderKnob.Position = UDim2.new(ratio,-9,0.5,-9)
    selectNum = math.floor(val)
    TipText.Text = string.format("捡（%d）垃圾回去",selectNum)
end
UpdateSliderUI(selectNum)

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local absPos = input.Position.X
        local frameAbs = SliderFrame.AbsolutePosition.X
        local frameW = SliderFrame.AbsoluteSize.X
        local t = math.clamp((absPos-frameAbs)/frameW,0,1)
        local v = sliderMin + t*(sliderMax-sliderMin)
        UpdateSliderUI(v)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)
-- ===================== UI控件创建完毕，下面绑定UI事件 =====================

FloatingBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

CloseX.MouseButton1Click:Connect(function()
    ConfirmPanel.Visible = true
    ConfirmPanel:ToFront()
end)

BtnNo.MouseButton1Click:Connect(function()
    ConfirmPanel.Visible = false
end)

BtnYes.MouseButton1Click:Connect(function()
    stopLoop()
    autoAfk = false
    autoScrapRunning = false
    afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
    scrapBtn.Text = "自动捡垃圾 当前状态:[关闭]"
    MainPanel.Visible = false
    ConfirmPanel.Visible = false
    FloatingBtn:Destroy()
end)

--【弹窗按钮点击事件】
popupToggleBtn.MouseButton1Click:Connect(function()
    popupEnable = not popupEnable
    if popupEnable then
        popupToggleBtn.Text = "弹窗丨当前状态:开"
    else
        popupToggleBtn.Text = "弹窗丨当前状态:关"
        -- 关闭弹窗时销毁屏幕上现存全部弹窗（含塔弹窗）
        ClearTowerPopup()
        for _,gui in ipairs(activePopups) do
            pcall(function() gui:Destroy() end)
        end
        table.clear(activePopups)
    end
end)

local function IsUIVisible(guiObject)
    local obj = guiObject
    while obj do
        if obj:IsA("GuiObject") then
            if not obj.Visible then
                return false
            end
        end
        obj = obj.Parent
    end
    return true
end

local function IsOnScreen(guiObj)
    local cam = workspace.CurrentCamera
    local absPos = guiObj.AbsolutePosition
    local absSize = guiObj.AbsoluteSize
    local screenW, screenH = cam.ViewportSize.X, cam.ViewportSize.Y
    local x1, y1 = absPos.X, absPos.Y
    local x2, y2 = absPos.X + absSize.X, absPos.Y + absSize.Y
    if x2 < 0 or x1 > screenW then return false end
    if y2 < 0 or y1 > screenH then return false end
    return true
end

local function CheckVisibleText(guiChild)
    if not (guiChild:IsA("TextLabel") or guiChild:IsA("TextButton")) then
        return false
    end
    if guiChild.Text == nil or guiChild.Text == "" then
        return false
    end
    if not IsUIVisible(guiChild) then
        return false
    end
    if not IsOnScreen(guiChild) then
        return false
    end
    return true
end

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
    local num =1
    local totalTimes =20
    for i=1,totalTimes do
        if not loopChallengeRunning or not globalRunning then break end
        if suspendTowerLoops then break end
        pcall(function()
            local args = {[1]=num}
            game:GetService("ReplicatedStorage").Remotes.TowerElevator:InvokeServer(unpack(args))
        end)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
        end)
        num = num +5
        task.wait(0.1)
    end
end

local function startLoop()
    loopChallengeRunning = true
    suspendTowerLoops = false
    toggleBtn.Text = "自动重生 当前状态:[开启] | 本次挂机已重生"..detectTriggerCount.."次"
    table.insert(threadPool, task.spawn(function()
        if loopChallengeRunning and globalRunning and not suspendTowerLoops then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
            end)
            RunTowerElevatorSequence()
        end
    end))

    table.insert(threadPool, task.spawn(function()
        while loopChallengeRunning and globalRunning do
            if suspendTowerLoops then
                task.wait(0.5)
                continue
            end
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Rebirth:InvokeServer()
            end)
            task.wait(0.5)
        end
    end))

    -- ★★【唯一塔计时器线程，整个生命周期只会启动这一条，不会重复spawn】
    if not towerTimerRunning then
        towerTimerRunning = true
        towerRemainingTime = 0
        table.insert(threadPool, task.spawn(function()
            while loopChallengeRunning and globalRunning do
                task.wait(1)
                -- 主循环这里只做倒计时扣时；TOWER检测交给UI扫描循环
                if towerRemainingTime > 0 then
                    towerRemainingTime -= 1
                    -- 时间走完，执行挑战塔
                    if towerRemainingTime <= 0 then
                        ClearTowerPopup()
                        CreatePopup("正在挑战",3.8)
                        RunTowerElevatorSequence()
                        if loopChallengeRunning and globalRunning and not suspendTowerLoops then
                            pcall(function()
                                game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
                            end)
                        end
                    end
                end
            end
            towerTimerRunning = false
        end))
    end

    table.insert(threadPool, task.spawn(function()
        local keywordRebirth = "REBIRTH READY!"
        local keywordNoThanks = "NO THANKS"
        local keywordTower = "TOWER"
        local towerKeywordCooldown = 0
        while loopChallengeRunning and globalRunning do
            task.wait(0.5)
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            if not playerGui then continue end
            if triggerCooldown > 0 then triggerCooldown -= 0.5 end
            if towerKeywordCooldown > 0 then towerKeywordCooldown -= 0.5 end
            local foundRebirth = false
            local foundNoThanks = false
            local foundTower = false
            for _,child in ipairs(playerGui:GetDescendants()) do
                if not child:IsDescendantOf(game) then continue end
                if CheckVisibleText(child) then
                    if string.find(child.Text, keywordRebirth,1,true) then foundRebirth = true end
                    if string.find(child.Text, keywordNoThanks,1,true) then foundNoThanks = true end
                    if string.find(child.Text, keywordTower,1,true) then foundTower = true end
                end
            end

            -- =========【新版逻辑：单条计时，不复开新线程】=========
            if not foundTower then
                -- TOWER消失：关闭弹窗，**计时数值保留，不重置**
                ClearTowerPopup()
            else
                -- TOWER可见
                -- 如果倒计时=0，初始化倒计时（滑块秒数）
                if towerRemainingTime <= 0 and towerKeywordCooldown <=0 then
                    towerRemainingTime = towerDelaySliderValue
                    towerKeywordCooldown = towerDelaySliderValue
                end
                -- 更新弹窗（弹窗不存在就新建；存在就更新文字）
                if not towerNotifyData and popupEnable then
                    towerNotifyData = CreatePopup(string.format("即将在%d秒后挑战塔",towerRemainingTime),9999)
                end
                if towerNotifyData then
                    towerNotifyData.label.Text = string.format("即将在%d秒后挑战塔",towerRemainingTime)
                end
            end

            --NO THANKS无冷却0.5秒检测执行
            if foundNoThanks then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.TowerContinueDecline:FireServer()
                end)
            end

            --重生检测+右上角弹窗（一次性触发弹窗，不受TOWER那条规则影响）
            if foundRebirth and triggerCooldown <= 0 then
                CreatePopup("已检测到可重生，正在返回",5)
                detectTriggerCount +=1
                triggerCooldown = 6.66
                suspendTowerLoops = true
                -- ★重生的时候重置塔计时器！
                towerRemainingTime = 0
                ClearTowerPopup()
                toggleBtn.Text = "自动重生 当前状态:[开启] | 本次挂机已重生"..detectTriggerCount.."次"
                pcall(function()
                    local args = {[1] = "coop"}
                    game:GetService("ReplicatedStorage").Remotes.SetChickenOrder:FireServer(unpack(args))
                end)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.TowerSurrender:InvokeServer()
                end)
                table.insert(threadPool, task.spawn(function()
                    task.wait(9.99)
                    if loopChallengeRunning and globalRunning then
                        suspendTowerLoops = false
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
                        end)
                        RunTowerElevatorSequence()
                    end
                end))
            end
        end
    end))

    table.insert(threadPool, task.spawn(function()
        while loopChallengeRunning and globalRunning do
            RunGeneratorCode()
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.ExpandCoop:InvokeServer()
            end)
            task.wait(1)
        end
    end))

    table.insert(threadPool, task.spawn(function()
        while loopChallengeRunning and globalRunning do
            RunGeneratorCode()
            task.wait(0.9)
        end
    end))

    table.insert(threadPool, task.spawn(function()
        while loopChallengeRunning and globalRunning do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.IncubatorClaim:InvokeServer()
            end)
            task.wait(1)
        end
    end))
end

local function stopLoop()
    loopChallengeRunning = false
    suspendTowerLoops = false
    ClearTowerPopup()
    towerRemainingTime = 0
    toggleBtn.Text = "自动重生 当前状态:[关闭] | 本次挂机已重生"..detectTriggerCount.."次"
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

local afkThread
afkThread = task.spawn(function()
    local baseMoveStep = 10
    local maxDistance = 6.6
    local tickDelay = 0.05
    local currentDirIndex = math.random(1,#directions)
    local traveled = 0
    while task.wait(tickDelay) do
        if not globalRunning or not autoAfk then
            currentDirIndex = math.random(1,#directions)
            traveled = 0
            spawnPosition = nil
            continue
        end
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
    end
end)
table.insert(threadPool, afkThread)

afkMoveBtn.MouseButton1Click:Connect(function()
    autoAfk = not autoAfk
    if autoAfk then
        afkMoveBtn.Text = "挂机移动 当前状态:[开启]"
    else
        afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
    end
end)

--=====【捡垃圾逻辑（修复寻路卡死版）】=====
local scrapThread1, scrapThread2

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
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or not RootPart or not recycleDestination then
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
            table.sort(scrapTable, function(a,b) return a.Dist < b.Dist end)
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
        scrapBtn.Text = "自动捡垃圾 当前状态:[开启]"
        targetScrapPos = nil
        collectedCount = 0
        scrapThread1 = task.spawn(ScrapMainLoop)
        scrapThread2 = task.spawn(UpgradeRecyclerLoop)
        table.insert(threadPool, scrapThread1)
        table.insert(threadPool, scrapThread2)
    else
        scrapBtn.Text = "自动捡垃圾 当前状态:[关闭]"
        autoScrapRunning = false
        targetScrapPos = nil
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:Stop()
        end
    end
end)
--=====捡垃圾结束=====

print("✅ 新版UI脚本加载成功")
ConfirmPanel:ToFront()
