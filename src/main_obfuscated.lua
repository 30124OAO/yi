local a=game:GetService("UserInputService")
local b=game:GetService("Players")
local c=b.LocalPlayer
local d=false
local e=false
local f=false
local g=16.66
local h=nil
local i=false
local j=10
local k=nil
local l=0
local m=1
local n
local o=Instance.new("ScreenGui")
o.Name="MainPanelUI"
o.ResetOnSpawn=false
o.Parent=c:WaitForChild("PlayerGui")
local p=Instance.new("TextButton")
p.Size=UDim2.new(0,140,0,48)
p.Position=UDim2.new(0.05,0,0.3,0)
p.BackgroundColor3=Color3.new(0.12,0.22,0.35)
p.BorderColor3=Color3.new(0.5,0.8,1)
p.BorderSizePixel=2
p.Text="养大一只鸡战士功能菜单"
p.TextColor3=Color3.new(1,1,1)
p.Font=Enum.Font.SourceSansBold
p.TextSize=14
p.Parent=o
local q=Instance.new("Frame")
q.Size=UDim2.new(0,320,0,290)
q.AnchorPoint=Vector2.new(0.5,0.5)
q.Position=UDim2.new(0.5,0,0.5,0)
q.BackgroundColor3=Color3.new(0.1,0.1,0.15)
q.BorderColor3=Color3.new(0.4,0.6,0.9)
q.BorderSizePixel=2
q.Visible=false
q.Parent=o
local r=Instance.new("TextLabel")
r.Size=UDim2.new(1,-40,0,32)
r.BackgroundTransparency=1
r.Text="功能主面板"
r.TextColor3=Color3.new(1,1,1)
r.Font=Enum.Font.SourceSansBold
r.TextSize=17
r.Position=UDim2.new(0,10,0,0)
r.Parent=q
local s=Instance.new("TextButton")
s.Size=UDim2.new(0,36,0,36)
s.Position=UDim2.new(1,-38,0,0)
s.BackgroundColor3=Color3.new(0.7,0.15,0.15)
s.Text="×"
s.TextColor3=Color3.new(1,1,1)
s.Font=Enum.Font.SourceSansBold
s.TextSize=22
s.Parent=q
local t=Instance.new("TextButton")
t.Size=UDim2.new(0,32,0,32)
t.Position=UDim2.new(1,-32,1,-32)
t.BackgroundTransparency=0.6
t.BackgroundColor3=Color3.new(0.35,0.45,0.65)
t.Text="丿"
t.TextColor3=Color3.new(1,1,1)
t.Font=Enum.Font.SourceSansBold
t.TextSize=20
t.Parent=q
local u=Instance.new("TextLabel")
u.Size=UDim2.new(0.9,0,0,24)
u.Position=UDim2.new(0.05,0,0.10,0)
u.BackgroundTransparency=1
u.Text="已添加达到重生要求自动撤离（前提:必须要让你的当前重生UI保持为点开）"
u.TextColor3=Color3.new(0.85,0.85,0.85)
u.Font=Enum.Font.SourceSans
u.TextSize=10
u.TextWrapped=true
u.Parent=q
local v=Instance.new("TextButton")
v.Size=UDim2.new(0.9,0,0,34)
v.Position=UDim2.new(0.05,0,0.18,0)
v.BackgroundColor3=Color3.new(0.15,0.15,0.2)
v.Text="自动重生 当前状态:[关闭]"
v.TextColor3=Color3.new(1,1,1)
v.Font=Enum.Font.SourceSansBold
v.TextSize=14
v.BorderSizePixel=2
v.BorderColor3=Color3.new(0.4,0.6,1)
v.Parent=q
local w=Instance.new("TextButton")
w.Size=UDim2.new(0.9,0,0,34)
w.Position=UDim2.new(0.05,0,0.33,0)
w.BackgroundColor3=Color3.new(0.15,0.15,0.2)
w.Text="挂机移动 当前状态:[关闭]"
w.TextColor3=Color3.new(1,1,1)
w.Font=Enum.Font.SourceSansBold
w.TextSize=14
w.BorderSizePixel=2
w.BorderColor3=Color3.new(0.4,0.6,1)
w.Parent=q
local x=Instance.new("TextButton")
x.Size=UDim2.new(0.9,0,0,34)
x.Position=UDim2.new(0.05,0,0.48,0)
x.BackgroundColor3=Color3.new(0.15,0.15,0.2)
x.Text="自动捡垃圾 [关闭]"
x.TextColor3=Color3.new(1,1,1)
x.Font=Enum.Font.SourceSansBold
x.TextSize=13
x.BorderSizePixel=2
x.BorderColor3=Color3.new(0.4,0.6,1)
x.Parent=q
local y=Instance.new("Frame")
y.Size=UDim2.new(0.9,0,0,20)
y.Position=UDim2.new(0.05,0,0.62,0)
y.BackgroundColor3=Color3.new(0.07,0.07,0.11)
y.BorderSizePixel=1
y.BorderColor3=Color3.new(0.3,0.4,0.7)
y.Parent=q
local z=Instance.new("Frame")
z.Size=UDim2.new(0,0,1,0)
z.BackgroundColor3=Color3.new(0.2,0.7,0.9)
z.Parent=y
local A=Instance.new("TextButton")
A.Size=UDim2.new(0,18,0,18)
A.BackgroundColor3=Color3.new(1,1,1)
A.Text=""
A.Position=UDim2.new(0,-9,0.5,-9)
A.BorderSizePixel=0
A.Parent=y
local B=Instance.new("TextLabel")
B.Size=UDim2.new(0.9,0,0,18)
B.Position=UDim2.new(0.05,0,0.72,0)
B.BackgroundTransparency=1
B.Text="捡（1）垃圾回去"
B.TextColor3=Color3.new(0.9,0.9,0.9)
B.Font=Enum.Font.SourceSans
B.TextSize=11
B.Parent=q
local C=Instance.new("TextLabel")
C.Size=UDim2.new(0.9,0,0,18)
C.Position=UDim2.new(0.05,0,0.78,0)
C.BackgroundTransparency=1
C.Text="提示:此脚本无防挂机功能，可用自动点击器来代替"
C.TextColor3=Color3.new(0.75,0.75,0.75)
C.Font=Enum.Font.SourceSans
C.TextSize=10
C.Parent=q
local D=1
local E=6
local F=false
local function G(H)
    local I=(H-D)/(E-D)
    z.Size=UDim2.new(I,0,1,0)
    A.Position=UDim2.new(I,-9,0.5,-9)
    m=math.floor(H)
    B.Text="捡（"..m.."）垃圾回去"
end
G(m)
A.InputBegan:Connect(function(J)
    if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
        F=true
    end
end)
a.InputChanged:Connect(function(J)
    if F and(J.UserInputType==Enum.UserInputType.MouseMovement or J.UserInputType==Enum.UserInputType.Touch)then
        local K=J.Position.X
        local L=y.AbsolutePosition.X
        local M=y.AbsoluteSize.X
        local N=math.clamp((K-L)/M,0,1)
        local O=D+(E-D)*N
        G(O)
    end
end)
a.InputEnded:Connect(function(J)
    if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
        F=false
    end
end)
local function P()
    pcall(function()
        local Q={[1]=5}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=3}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=4}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=6}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=6}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=4}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=3}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=5}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=1}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=2}
        game:GetService("ReplicatedStorage").Remotes.BuyGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=1}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
    pcall(function()
        local Q={[1]=2}
        game:GetService("ReplicatedStorage").Remotes.UpgradeGenerator:InvokeServer(unpack(Q))
    end)
end
local function R()
    local S=1
    local T=20
    for U=1,T do
        if not d then break end
        pcall(function()
            local Q={[1]=S}
            game:GetService("ReplicatedStorage").Remotes.TowerElevator:InvokeServer(unpack(Q))
        end)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
        end)
        S+=5
        task.wait(0.1)
    end
end
local function V()
    d=true
    v.Text="自动重生 当前状态:[开启]"
    task.spawn(function()
        while d do
            pcall(function()
                local Q={[1]="coop"}
                game:GetService("ReplicatedStorage").Remotes.SetChickenOrder:FireServer(unpack(Q))
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
        while d do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerContinueDecline:FireServer()
            end)
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while d do
            P()
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.ExpandCoop:InvokeServer()
            end)
            task.wait(1)
        end
    end)
    task.spawn(function()
        while d do
            P()
            task.wait(0.9)
        end
    end)
    task.spawn(function()
        while d do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.TowerStart:InvokeServer()
            end)
            task.wait(98)
        end
    end)
    task.spawn(function()
        while d do
            R()
            task.wait(88)
        end
    end)
    task.spawn(function()
        while d do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.IncubatorClaim:InvokeServer()
            end)
            task.wait(1)
        end
    end)
end
local function W()
    d=false
    v.Text="自动重生 当前状态:[关闭]"
end
v.MouseButton1Click:Connect(function()
    if d then
        W()
    else
        V()
    end
end)
local X={Vector3.new(1,0,-1),Vector3.new(-1,0,-1),Vector3.new(-1,0,1),Vector3.new(1,0,1),Vector3.new(0,0,-1),Vector3.new(0,0,1),Vector3.new(-1,0,0),Vector3.new(1,0,0)}
task.spawn(function()
    local Y=10
    local Z=6.6
    local aa=0.05
    local ab=math.random(1,#X)
    local ac=0
    while task.wait(aa)do
        if f then
            local ad=c.Character
            if not ad then continue end
            local ae=ad:FindFirstChild("HumanoidRootPart")
            if not ae then continue end
            if not h then
                h=ae.Position
            end
            local af=X[ab].Unit
            local ag=ae.Position+af*Y*aa
            local ah=math.abs(ag.X-h.X)
            local ai=math.abs(ag.Z-h.Z)
            if ah>g or ai>g then
                ae.CFrame=CFrame.new(h)
                ab=math.random(1,#X)
                ac=0
                continue
            end
            ae.CFrame+=af*Y*aa
            ac+=Y*aa
            if ac>=Z then
                ab=math.random(1,#X)
                ac=0
            end
        else
            ab=math.random(1,#X)
            ac=0
            h=nil
        end
    end
end)
w.MouseButton1Click:Connect(function()
    f=not f
    if f then
        w.Text="挂机移动 当前状态:[开启]"
    else
        w.Text="挂机移动 当前状态:[关闭]"
    end
end)
local function aj()
    while i do
        local ak=0.5
        local al=workspace:FindFirstChild("Recyclers")and workspace.Recyclers:FindFirstChild("RecyclerUI")
        if al and al:FindFirstChildOfClass("Part")then
            n=al:FindFirstChildOfClass("Part").Position
        end
        local am=c.Character
        if not am then
            task.wait(ak)
            continue
        end
        local an=am:WaitForChild("HumanoidRootPart")
        local ao=am:FindFirstChildOfClass("Humanoid")
        if not ao or not n then
            task.wait(ak)
            continue
        end
        local ap
        if l<m then
            ap="FindScrap"
        else
            ap="GoHome"
        end
        if ap=="FindScrap"then
            local aq={}
            local ar=an.Position
            for _,as in ipairs(workspace:GetChildren())do
                if as:IsA("Model")and as.Name=="PitScrap"then
                    local at=as:FindFirstChildOfClass("Part")
                    if at then
                        local au=(ar-at.Position).Magnitude
                        table.insert(aq,{Model=as,PartPos=at.Position,Dist=au})
                    end
                end
            end
            table.sort(aq,function(av,aw)
                return av.Dist<aw.Dist
            end)
            if #aq>0 then
                local ax=aq[1]
                k=ax.PartPos
                local au=(ar-k).Magnitude
                if au<=j then
                    l+=1
                    k=nil
                else
                    ao:MoveTo(k)
                end
            end
        elseif ap=="GoHome"then
            local au=(an.Position-n).Magnitude
            if au<=j then
                l=0
            else
                ao:MoveTo(n)
            end
        end
        task.wait(ak)
    end
    local ay=c.Character
    if ay and ay:FindFirstChildOfClass("Humanoid")then
        ay.Humanoid:Stop()
    end
end
local function az()
    while i do
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.UpgradeRecycler:InvokeServer()
        end)
    end
end
x.MouseButton1Click:Connect(function()
    i=not i
    if i then
        x.Text="自动捡垃圾 [开启]"
        k=nil
        l=0
        task.spawn(aj)
        task.spawn(az)
    else
        x.Text="自动捡垃圾 [关闭]"
        k=nil
        local aA=c.Character
        if aA and aA:FindFirstChildOfClass("Humanoid")then
            aA.Humanoid:Stop()
        end
    end
end)
local aB=Instance.new("Frame")
aB.Size=UDim2.new(0,260,0,160)
aB.Position=UDim2.new(0.5,-130,0.5,-80)
aB.BackgroundColor3=Color3.new(0.12,0.12,0.18)
aB.BorderColor3=Color3.new(0.5,0.6,0.95)
aB.BorderSizePixel=2
aB.Visible=false
aB.Parent=o
local aC=Instance.new("TextLabel")
aC.Size=UDim2.new(0.9,0,0,50)
aC.Position=UDim2.new(0.05,0,0.05,0)
aC.BackgroundTransparency=1
aC.Text="确认关闭面板？\n将会停止所有运行功能"
aC.TextColor3=Color3.new(1,1,1)
aC.Font=Enum.Font.SourceSansBold
aC.TextSize=16
aC.TextWrapped=true
aC.Parent=aB
local aD=Instance.new("TextButton")
aD.Size=UDim2.new(0,100,0,40)
aD.Position=UDim2.new(0.05,0,0.65,0)
aD.BackgroundColor3=Color3.new(0.2,0.3,0.45)
aD.Text="否"
aD.TextColor3=Color3.new(1,1,1)
aD.Font=Enum.Font.SourceSansBold
aD.TextSize=16
aD.Parent=aB
local aE=Instance.new("TextButton")
aE.Size=UDim2.new(0,100,0,40)
aE.Position=UDim2.new(0.62,0,0.65,0)
aE.BackgroundColor3=Color3.new(0.45,0.2,0.2)
aE.Text="是"
aE.TextColor3=Color3.new(1,1,1)
aE.Font=Enum.Font.SourceSansBold
aE.TextSize=16
aE.Parent=aB
local function aF(aG)
    local aH=false
    local aI
    local aJ
    local aK=nil
    aG.InputBegan:Connect(function(J)
        if(J.UserInputType==Enum.UserInputType.Touch or J.UserInputType==Enum.UserInputType.MouseButton1)and not aH then
            aH=true
            aK=J
            aI=J.Position
            aJ=aG.Position
        end
    end)
    a.InputChanged:Connect(function(J)
        if aH and J==aK then
            local aL=J.Position-aI
            aG.Position=UDim2.new(aJ.X.Scale,aJ.X.Offset+aL.X,aJ.Y.Scale,aJ.Y.Offset+aL.Y)
        end
    end)
    a.InputEnded:Connect(function(J)
        if J==aK then
            aH=false
            aK=nil
        end
    end)
end
local aM=false
local aN
local aO
local aP=nil
t.InputBegan:Connect(function(J)
    if(J.UserInputType==Enum.UserInputType.Touch or J.UserInputType==Enum.UserInputType.MouseButton1)and not aM then
        aM=true
        aP=J
        aN=J.Position
        aO=Vector2.new(q.Size.X.Offset,q.Size.Y.Offset)
    end
end)
a.InputChanged:Connect(function(J)
    if aM and J==aP then
        local aQ=J.Position-aN
        local aR=math.max(220,aO.X+aQ.X)
        local aS=math.max(290,aO.Y+aQ.Y)
        q.Size=UDim2.new(0,aR,0,aS)
    end
end)
a.InputEnded:Connect(function(J)
    if J==aP then
        aM=false
        aP=nil
    end
end)
aF(p)
aF(q)
p.MouseButton1Click:Connect(function()
    e=not e
    q.Visible=e
    aB.Visible=false
end)
s.MouseButton1Click:Connect(function()
    aB.Visible=true
end)
aD.MouseButton1Click:Connect(function()
    aB.Visible=false
end)
aE.MouseButton1Click:Connect(function()
    W()
    f=false
    i=false
    w.Text="挂机移动 当前状态:[关闭]"
    x.Text="自动捡垃圾 [关闭]"
    aB.Visible=false
    q.Visible=false
    e=false
    p.Visible=false
end)
