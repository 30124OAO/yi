--脚本作者b站UID:647396778
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--获取远程事件
local SetSelectedSlot = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SetSelectedSlot")
local StartEating = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartEating")
local BeginBlocking = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BeginBlocking")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ButtonUIPack"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--=============第一个开关：循环吃金苹果，2秒执行一轮=============
local eatLoopActive = false
local eatLoopThread = nil

local EatBtn = Instance.new("TextButton")
EatBtn.Size = UDim2.new(0,120,0,40)
EatBtn.Position = UDim2.new(0.01, 0, 0.01, 0)
EatBtn.BackgroundColor3 = Color3.new(0.7,0.2,0.2)
EatBtn.Text = "循环吃金苹果 OFF"
EatBtn.Font = Enum.Font.SourceSansBold
EatBtn.TextSize = 14
EatBtn.TextColor3 = Color3.new(1,1,1)
EatBtn.Parent = ScreenGui

EatBtn.MouseButton1Click:Connect(function()
    if not eatLoopActive then
        eatLoopActive = true
        EatBtn.Text = "循环吃金苹果 ON"
        EatBtn.BackgroundColor3 = Color3.new(0.15,0.75,0.35)
        eatLoopThread = task.spawn(function()
            while eatLoopActive do
                --执行整套进食流程
                local args1 = {[1] = 6}
                SetSelectedSlot:FireServer(unpack(args1))
                task.wait(0.08)
                StartEating:FireServer()
                task.wait(0.08)
                local args2 = {[1] = 1}
                SetSelectedSlot:FireServer(unpack(args2))
                
                task.wait(2) --间隔2秒执行一轮
            end
        end)
    else
        eatLoopActive = false
        EatBtn.Text = "循环吃金苹果 OFF"
        EatBtn.BackgroundColor3 = Color3.new(0.7,0.2,0.2)
    end
end)

--=============第二个按钮：循环防御（开启时无法攻击）0.5秒发包=============
local blockLoopActive = false
local blockLoopThread = nil

local BlockBtn = Instance.new("TextButton")
BlockBtn.Size = UDim2.new(0,95,0,40) --加宽按钮尺寸放下完整文字
BlockBtn.Position = UDim2.new(0.01,125,0.01,0)
BlockBtn.BackgroundColor3 = Color3.new(0.7,0.2,0.2)
BlockBtn.Text = "循环防御(开启时无法攻击)OFF"
BlockBtn.Font = Enum.Font.SourceSansBold
BlockBtn.TextSize = 10
BlockBtn.TextColor3 = Color3.new(1,1,1)
BlockBtn.Parent = ScreenGui

BlockBtn.MouseButton1Click:Connect(function()
    if not blockLoopActive then
        blockLoopActive = true
        BlockBtn.Text = "循环防御(开启时无法攻击)ON"
        BlockBtn.BackgroundColor3 = Color3.new(0.15,0.7,0.35)
        blockLoopThread = task.spawn(function()
            while blockLoopActive do
                BeginBlocking:FireServer()
                task.wait(0.5)
            end
        end)
    else
        blockLoopActive = false
        BlockBtn.Text = "循环防御(开启时无法攻击)OFF"
        BlockBtn.BackgroundColor3 = Color3.new(0.7,0.2,0.2)
    end
end)
