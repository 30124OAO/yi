local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local loopChallengeRunning = false
local panelVisible = false
local loopInterval = 98

local autoAfk = false
local rangeLimit = 16.66
local spawnPosition = nil

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
MainPanel.Size = UDim2.new(0, 320, 0, 320)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
MainPanel.BorderColor3 = Color3.new(0.4, 0.6, 0.9)
MainPanel.BorderSizePixel = 2
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 36)
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
CloseBtn.Text="×"
CloseBtn.TextColor3=Color3.new(1，1，1)
CloseBtn.Font=枚举.Font.SourceSansBold
CloseBtn.TextSize=22
CloseBtn.Parent=主面板

本地ResizeHandle=Instance.new("TextButton")
ResizeHandle.Size=UDim2.new(0，32，0，32)
ResizeHandle.Position=UDim2.new(1，-32，1，-32)
ResizeHandle.BackgroundTransparency=0.6
ResizeHandle.BackgroundColor3=Color3.new(0.35，0.45，0.65)
ResizeHandle.Text="丿"
ResizeHandle.TextColor3=Color3.new(1，1，1)
ResizeHandle.Font=枚举.Font.SourceSansBold
ResizeHandle.TextSize=20
ResizeHandle.Parent=主面板

本地toggleBtn=Instance.new("TextButton")
toggleBtn.Size=UDim2.new(0.9，0，0，50)
toggleBtn.Position=UDim2.new(0.05，0，0.15，0)
toggleBtn.BackgroundColor3=Color3.new(0.15，0.15，0.2)
toggleBtn.Text="自动重生当前状态：[关闭]"
toggleBtn.TextColor3=Color3.new(1，1，1)
toggleBtn.Font=枚举.Font.SourceSansBold
toggleBtn.TextSize=16
toggleBtn.BorderSizePixel=2
toggleBtn.BorderColor3=Color3.new(0.4，0.6，1)
toggleBtn.Parent=主面板

local afkMoveBtn = Instance.new("TextButton")
afkMoveBtn.Size = UDim2.new(0.9, 0, 0, 50)
afkMoveBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
afkMoveBtn.BackgroundColor3 = Color3.new(0.15,0.15,0.2)
afkMoveBtn.Text = "挂机移动 当前状态:[关闭]"
afkMoveBtn.TextColor3 = Color3.new(1,1,1)
afkMoveBtn.Font = Enum.Font.SourceSansBold
afkMoveBtn.TextSize = 16
afkMoveBtn.BorderSizePixel = 2
afkMoveBtn.BorderColor3 = Color3.new(0.4,0.6,1)
afkMoveBtn.Parent = MainPanel

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
            pcall(function()
    游戏：GetService("ReplicatedStorage")远程重生：InvokeServer()
    结束)
    task.wait(0.1)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    pcall(函数()
    游戏：GetService("ReplicatedStorage")。远程。TowerContinuueDecline:FireServer()
    结束)
    task.wait(0.1)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    RunGeneratorCode()
    pcall(函数()
    游戏：GetService("ReplicatedStorage")。远程。ExpandCoop:InvokeServer()
    结束)
    task.wait(1)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    RunGeneratorCode()
    task.wait(0.9)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    pcall(函数()
    游戏：GetService("ReplicatedStorage")。远程。TowerStart:InvokeServer()
    结束)
    task.wait(loopInterval)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    RunTowerElevatorSequence()
    task.wait(88)
    结束
    结束)

    task.spawn(函数()
    while loopChallengeRunning do
    pcall(函数()
    游戏：GetService("ReplicatedStorage")。远程。孵化器声明：InvokeServer()
    结束)
    task.wait(1)
    结束
    结束)
结束

本地函数stopLoop()
loopChallengeRunning=false
toggleBtn.Text="自动重生当前状态：[关闭]"
结束

toggleBtn.鼠标按钮1单击：连接(函数()
如果loopChallengeRunning，则
stopLoop()
其他
startLoop()
结束
结束)

局部方向={
Vector3.new(1，0，-1)，
Vector3.new(-1，0，-1)，
    Vector3.new(-1,0,1),
    Vector3.new(1,0,1),
    Vector3.new(0,0,-1),
    Vector3.new(0,0,1),
    Vector3.new(-1,0,0),
    Vector3.new(1,0,0)
}
task.spawn(function()
    local moveStep = 10
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
            local nextPos = root.Position + targetDir * moveStep * tickDelay
            local dx = math.abs(nextPos.X - spawnPosition.X)
            local dz = math.abs(nextPos.Z - spawnPosition.Z)
            if dx > rangeLimit or dz > rangeLimit then
                root.CFrame = CFrame.new(spawnPosition)
                currentDirIndex = math.random(1,#directions)
                traveled = 0
                continue
            end
            root.CFrame += targetDir * moveStep * tickDelay
            traveled += moveStep * tickDelay
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
结束)

本地ConfirmFrame=Instance.new("Frame")
ConfirmFrame.Size=UDim2.new(0，260，0，160)
ConfirmFrame.Position=UDim2.new(0.5，-130，0.5，-80)
ConfirmFrame.BackgroundColor3=Color3.new(0.12，0.12，0.18)
ConfirmFrame.BorderColor3=Color3.new(0.5、0.6、0.95)
ConfirmFrame.BorderSizePixel=2
ConfirmFrame.Visible=false
ConfirmFrame.Parent=ScreenGui

本地ConfirmText=Instance.new("TextLabel")
ConfirmText.Size=UDim2.new(0.9，0，0，50)
ConfirmText.Position=UDim2.new(0.05，0，0.05，0)
ConfirmText.BackgroundTransparency=1
ConfirmText.Text="确认关闭面板？\n将会停止所有运行功能"
ConfirmText.TextColor3=Color3.new(1，1，1)
ConfirmText.Font=枚举.Font.SourceSansBold
ConfirmText.TextSize=16
ConfirmText.TextWrapped=true
ConfirmText.Parent=ConfirmFrame

本地NoBtn=Instance.new("TextButton")
NoBtn.Size=UDim2.new(0，100，0，40)
NoBtn.Position=UDim2.new(0.05，0，0.65，0)
NoBtn.BackgroundColor3=Color3.new(0.2，0.3，0.45)
NoBtn.Text="否"
NoBtn.TextColor3=Color3.new(1，1，1)
NoBtn.Font=枚举。字体.SourceSansBold
NoBtn.TextSize=16
NoBtn.Parent=ConfirmFrame

本地YesBtn=Instance.new("TextButton")
YesBtn.Size=UDim2.new(0，100，0，40)
是Btn.Position=UDim2.new(0.62，0，0.65，0)
是Btn.BackgroundColor3=Color3.新建(0.45，0.2，0.2)
是Btn.Text="是"
是Btn.TextColor3=Color3.new(1，1，1)
是Btn.Font=枚举.Font.SourceSansBold
YesBtn.TextSize=16
是Btn.Parent=ConfirmFrame

局部函数MakeDraggable(guiObj)
本地拖动=假的
本地startTouchPos
本地objStartPosition
本地activeInput=nil

    guiObj.InputBegin：连接(函数(输入)
    if(进口.userinputtype==列举。UserInputType。摸或进口。userinputtype==列举。用户输入类型.mousebutton1)，然后不拖动
    拖动=真
    activeInput=输入
    startTouchPos=输入.位置
    objStartPosition=guiObj.Position
    结束
    结束)

    UserInputService.InputChanged：连接(函数(输入)
    如果拖动并输入==activeInput，则
    本地偏移=输入。位置-startTouchPos
    guiObj.Position=UDim2.new(
    objStartPosition.X.Scale，objStartPosition.X.Offset+offset.X，
    objStartPosition.Y.scale，objStartPosition.Y.偏移+偏移。Y
            )
    结束
    结束)

    UserInputService.InputEnded：连接(函数(输入)
    如果输入==活动输入，则
    拖动=假的
    activeInput=nil
    结束
    结束)
结束

本地resizedragging=false
本地resizeStartPos
本地startSize
本地resizeinput=nil
ResizeHandle.InputBegin：连接(函数(进))
if(进口.userinputtype==列举。UserInputType。摸或进口。userinputtype==列举。UserInputType.MouseButton1)而不是resizeDragging，然后
resizeDragging=true
resizeInput=输入
resizeStartPos=输入.位置
startSize=Vector2.新建(主面板.大小.X。偏移，主面板。大小。Y。抵消)
结束
结束)

UserInputService.InputChanged：连接(函数(输入)
如果resizeDragging和input==resizeInput，则
本地增量=输入。位置-resizeStartPos
本地NEWW=math.max(220，startSize.X+delta.X)
本地NEWH=math.max(200，startSize.Y+Δy)
MainPanel.Size=UDim2.new(0，NEWW，0，NEWH)
结束
结束)

UserInputService.InputEnded：连接(函数(输入)
如果input==resizeInput，则
resizeDragging=false
resizeInput=nil
结束
结束)

MakeDraggable(MainButton)
MakeDraggable(主面板)

MainButton.MouseButton1Click:Connect(函数()
panelVisible=非PanelVisible
MainPanel.Visible=面板可视
ConfirmFrame.Visible=false
结束)

CloseBtn.MouseButton1Click:Connect(函数()
ConfirmFrame.Visible=true
结束)

NoBtn.MouseButton1Click:Connect(函数()
ConfirmFrame.Visible=false
结束)

是Btn.MouseButton1单击：连接(功能()
stopLoop()
autoAfk=false
afkMoveBtn.Text="挂机移动当前状态：[关闭]"[关闭]"

ConfirmFrame.visible=falseConfirmFrame。看得见的=false
主面板。可见=false主面板。visible=false
panelVisible=falsePanelVisible=false
MainButton。visible=falseMainButton。visible=false
结束)
