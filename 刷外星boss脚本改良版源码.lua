--改良者:西施珍宝
--以后见到少打我就行
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
local VirtualInputManager
pcall(function()
	VirtualInputManager = game:GetService("VirtualInputManager")
end)
local VirtualUser
pcall(function()
	VirtualUser = game:GetService("VirtualUser")
end)
local HEIGHT_OFFSET = Vector3.new(0, 55, 0) -- 上次52，再加3 = 55
local PUNCH_INTERVAL = 0.05
local CLICK_DURATION = 5
local TP_SETTLE = 0.15
local CLICK_OFFSET_X = 0
local CLICK_OFFSET_Y = 0
local KILL_CFRAME = CFrame.new(
	-1835.37622, 50.7084084 + 5, -10978.874,
	0.799689353, 6.68484859e-08, -0.600413978,
	-6.14595024e-08, 1, 2.94796223e-08,
	0.600413978, 1.33266056e-08, 0.799689353
)
local enabled = false
local running = false
local teleporting = false
local dead = false
local charAddedConn = nil
local humanoidDiedConn = nil
local equipToolLoop = nil

local function checkBossStatus()
	local alien = workspace:FindFirstChild("Alien Boss")
	if not alien then return "gone", nil end
	local hitbox = alien:FindFirstChild("BossDamageHitbox")
	if not hitbox then return "gone", nil end
	local humanoid = alien:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		return "dead", hitbox
	end
	return "alive", hitbox
end
local function unequipTools()
	local char = LP.Character
	if char then
		local human = char:FindFirstChildOfClass("Humanoid")
		if human then human:UnequipTools() end
	end
end
local camAnchor = Instance.new("Part")
camAnchor.Name = "AlienBossCamAnchor"
camAnchor.Anchored = true
camAnchor.CanCollide = false
camAnchor.CanQuery = false
camAnchor.CanTouch = false
camAnchor.Transparency = 1
camAnchor.Size = Vector3.new(0.1, 0.1, 0.1)
camAnchor.Parent = workspace

local function pressEHold(seconds)
	if not VirtualInputManager then return end
	local endTime = os.clock() + seconds
	while os.clock() < endTime do
		pcall(function()
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
			task.wait(0.1)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
		end)
		task.wait(0.15)
	end
end

local function forceTeleport()
	local char = LP.Character
	if not char then return end
	pcall(function() char:PivotTo(KILL_CFRAME) end)
	task.spawn(function()
		local startTime = os.clock()
		while os.clock() - startTime < 0.5 do
			if not char.Parent then break end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = KILL_CFRAME
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end
			task.wait()
		end
	end)
end
local function afterKillClick()
	teleporting = true
	local ok, err = pcall(function()
		unequipTools()
		if TP_SETTLE > 0 then task.wait(TP_SETTLE) end
		pressEHold(CLICK_DURATION)
	end)
	if not ok then warn("[AlienBoss] 击杀后处理出错:", err) end
	task.wait(0.2)
	teleporting = false
end
local conn = nil
local function stopRuntime()
	if conn then
		conn:Disconnect()
		conn = nil
	end
	if equipToolLoop then
		equipToolLoop:Disconnect()
		equipToolLoop = nil
	end
	local char = LP.Character
	if char then
		local human = char:FindFirstChildOfClass("Humanoid")
		if human then
			human.AutoRotate = true
			if camera.CameraSubject == camAnchor then camera.CameraSubject = human end
			pcall(function() human:UnequipTools() end)
		end
	end
	running = false
end
local function startRuntime()
	if running then return end
	running = true
	local lastPunch = 0
	-- 每0.1秒装备道具
	equipToolLoop = RunService.Heartbeat:Connect(function()
		pcall(function()
			local char = LP.Character
			if not char then return end
			local human = char:FindFirstChildOfClass("Humanoid")
			local backpack = LP:FindFirstChild("Backpack")
			if not human or not backpack then return end
			local punch = backpack:FindFirstChild("Punch")
			if punch then
				human:EquipTool(punch)
			end
		end)
	end)
	conn = RunService.Heartbeat:Connect(function()
		local ok, err = pcall(function()
			local char = LP.Character
			if not char then stopRuntime() return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local human = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not human then stopRuntime() return end

			local status, hitbox = checkBossStatus()
			if status ~= "alive" then
				local wasKill = running and enabled
				if wasKill then forceTeleport() end
				stopRuntime()
				if wasKill then task.spawn(afterKillClick) end
				return
			end
			if not enabled then
				stopRuntime()
				return
			end
			local target = hitbox.Position + HEIGHT_OFFSET
			hrp.CFrame = CFrame.new(target, target + Vector3.new(0, -1, 0))
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
			camAnchor.CFrame = CFrame.new(target)
			human.AutoRotate = false
			camera.CameraSubject = camAnchor
			local now = os.clock()
			if now - lastPunch >= PUNCH_INTERVAL then
				lastPunch = now
				if checkBossStatus() == "alive" then
					local ev = LP:FindFirstChild("muscleEvent")
					if ev then ev:FireServer("punch", "leftHand") end
				end
			end
		end)
		if not ok then warn("[AlienBoss] 心跳回调异常:", err) end
	end)
end

local function bindCharacter(char)
	if humanoidDiedConn then
		humanoidDiedConn:Disconnect()
		humanoidDiedConn = nil
	end
	local humanoid = char:WaitForChild("Humanoid")
	humanoidDiedConn = humanoid.Died:Connect(function()
		stopRuntime()
	end)
end
charAddedConn = LP.CharacterAdded:Connect(function(char)
	bindCharacter(char)
	if enabled then
		task.wait(0.8)
		pcall(startRuntime)
	end
end)
if LP.Character then
	bindCharacter(LP.Character)
end

task.spawn(function()
	while not dead do
		pcall(function()
			if enabled and not running and not teleporting and checkBossStatus() == "alive" then
				startRuntime()
			end
		end)
		task.wait(0.2)
	end
end)
local antiIdleConn = nil
local function antiIdleAction()
	if dead then return end
	pcall(function()
		if VirtualInputManager and camera then
			local vp = camera.ViewportSize
			local x = math.floor(vp.X * 0.5)
			local y = math.floor(vp.Y * 0.5)
			VirtualInputManager:SendMouseMoveEvent(x, y, 0, game)
			task.wait(0.05)
			VirtualInputManager:SendMouseMoveEvent(x + 1, y + 1, 0, game)
		end
	end)
	pcall(function()
		if VirtualUser and camera then
			VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
			task.wait(0.25)
			VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
		end
	end)
end
if LP.Idled then
	pcall(function()
		antiIdleConn = LP.Idled:Connect(antiIdleAction)
	end)
end
task.spawn(function()
	while not dead do
		task.wait(240)
		if dead then break end
		antiIdleAction()
	end
end)
local FB = Enum.Font.GothamBold
local FM = Enum.Font.GothamMedium
local T = {
	fast = TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	med = TweenInfo.new(.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
}
local C = {
	ball = Color3.fromRGB(12, 12, 16),
	panel = Color3.fromRGB(18, 20, 26),
	text = Color3.fromRGB(245, 247, 252),
	sub = Color3.fromRGB(176, 184, 200),
	good = Color3.fromRGB(52, 211, 153),
	bad = Color3.fromRGB(240, 86, 92),
	white = Color3.new(1, 1, 1),
}
local function new(cls, props)
	local o = Instance.new(cls)
	for k, v in next, props do o[k] = v end
	return o
end
local function tw(o, info, props)
	local t = TweenService:Create(o, info, props)
	t:Play()
	return t
end
local function round(o, r)
	new("UICorner", {CornerRadius = r and UDim.new(0, r) or UDim.new(1, 0), Parent = o})
	return o
end
local function stroke(o, color, thickness, alpha)
	new("UIStroke", {
		Color = color or C.white,
		Thickness = thickness or 1,
		Transparency = alpha or .8,
		Parent = o,
	})
	return o
end
local function label(props, t, a)
	props.BackgroundTransparency = 1
	local l = new("TextLabel", props)
	if t then
		new("UIStroke", {
			Color = Color3.new(0, 0, 0),
			Thickness = t,
			Transparency = a or .4,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Parent = l,
		})
	end
	return l
end
local hui = nil
pcall(function() hui = gethui and gethui() end)
local CoreGui = nil
pcall(function() CoreGui = game:GetService("CoreGui") end)
local container = hui or CoreGui or LP:WaitForChild("PlayerGui")
local gui = new("ScreenGui", {
	Name = "AlienBossBall",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = container,
})
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(gui) end
end)
local BALL = 52
local PANEL_W, PANEL_H = 176, 132
local function clampPos(x, y, w, h)
	local vp = camera.ViewportSize
	x = math.clamp(x, 4, math.max(4, vp.X - w - 4))
	y = math.clamp(y, 4, math.max(4, vp.Y - h - 4))
	return x, y
end
local ball = new("TextButton", {
	Name = "Ball",
	Position = UDim2.new(0, 24, 0, 110),
	Size = UDim2.fromOffset(BALL, BALL),
	BackgroundColor3 = C.ball,
	BackgroundTransparency = .42,
	Text = "",
	AutoButtonColor = false,
	BorderSizePixel = 0,
	ZIndex = 10,
	Parent = gui,
})
round(ball)
stroke(ball, C.white, 1.5, .42)
local glyph = label({
	AnchorPoint = Vector2.new(.5, .5),
	Position = UDim2.fromScale(.5, .5),
	Size = UDim2.fromScale(1, 1),
	Text = "怪",
	TextColor3 = C.white,
	TextSize = 22,
	Font = FB,
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 11,
	Parent = ball,
}, 2, .3)
local panel = new("Frame", {
	Name = "Panel",
	Position = UDim2.new(0, 24, 0, 110),
	Size = UDim2.fromOffset(PANEL_W, PANEL_H),
	BackgroundColor3 = C.panel,
	BackgroundTransparency = .18,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 10,
	Parent = gui,
})
round(panel, 16)
stroke(panel, C.white, 1, .78)
local header = new("TextButton", {
	Size = UDim2.new(1, 0, 0, 26),
	BackgroundTransparency = 1,
	Text = "",
	AutoButtonColor = false,
	ZIndex = 11,
	Parent = panel,
})
label({
	Position = UDim2.new(0, 12, 0, 5),
	Size = UDim2.new(1, -52, 0, 16),
	Text = "Alien Boss",
	TextColor3 = C.text,
	TextSize = 12,
	Font = FB,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 12,
	Parent = header,
}, 1.4, .35)
local collapseBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 4),
	Size = UDim2.fromOffset(18, 18),
	BackgroundColor3 = C.white,
	BackgroundTransparency = .94,
	Text = "-",
	TextColor3 = C.text,
	TextSize = 14,
	Font = FB,
	AutoButtonColor = false,
	ZIndex = 12,
	Parent = panel,
})
round(collapseBtn, 6)
stroke(collapseBtn, C.white, 1, .8)
local status = label({
	Position = UDim2.new(0, 12, 0, 30),
	Size = UDim2.new(1, -24, 0, 14),
	Text = "已关闭",
	TextColor3 = C.sub,
	TextSize = 11,
	Font = FM,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 11,
	Parent = panel,
}, 1.2, .55)
local toggleBtn = new("TextButton", {
	Position = UDim2.new(0, 12, 0, 50),
	Size = UDim2.new(1, -24, 0, 34),
	BackgroundColor3 = C.good,
	Text = "开启",
	TextColor3 = C.white,
	TextSize = 13,
	Font = FB,
	AutoButtonColor = false,
	ZIndex = 11,
	Parent = panel,
})
round(toggleBtn, 10)
stroke(toggleBtn, C.white, 1, .8)
local destroyBtn = new("TextButton", {
	Position = UDim2.new(0, 12, 0, 92),
	Size = UDim2.new(1, -24, 0, 26),
	BackgroundColor3 = C.bad,
	BackgroundTransparency = .25,
	Text = "销毁",
	TextColor3 = C.white,
	TextSize = 11,
	Font = FB,
	AutoButtonColor = false,
	ZIndex = 11,
	Parent = panel,
})
round(destroyBtn, 8)
stroke(destroyBtn, C.white, 1, .86)
local brand = label({
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -24, 0, 58),
	Size = UDim2.fromOffset(120, 28),
	Text = "冰美式",
	TextColor3 = C.white,
	TextSize = 20,
	Font = FB,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 30,
	Parent = gui,
}, 2, .35)
local brandGrad = new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 92, 141)),
		ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 168, 76)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 240, 102)),
		ColorSequenceKeypoint.new(0.60, Color3.fromRGB(109, 240, 168)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(94, 200, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(186, 134, 255)),
	}),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.00, .18),
		NumberSequenceKeypoint.new(0.30, .15),
		NumberSequenceKeypoint.new(0.46, 0),
		NumberSequenceKeypoint.new(0.54, 0),
		NumberSequenceKeypoint.new(0.70, .15),
		NumberSequenceKeypoint.new(1.00, .18),
	}),
	Offset = Vector2.new(-1, 0),
	Parent = brand,
})
task.spawn(function()
	while not dead and brandGrad.Parent do
		brandGrad.Offset = Vector2.new(-1, 0)
		local t = TweenService:Create(
			brandGrad,
			TweenInfo.new(1.8, Enum.EasingStyle.Linear),
			{Offset = Vector2.new(1, 0)}
		)
		t:Play()
		t.Completed:Wait()
		task.wait(0.08)
	end
end)
tw(brandGrad, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
local function refresh()
	if dead then return end
	if teleporting then
		status.Text = "传送 / 开箱中…"
		status.TextColor3 = Color3.fromRGB(120, 180, 255)
		toggleBtn.Text = "停止"
		toggleBtn.BackgroundColor3 = C.bad
	elseif enabled then
		status.Text = running and "攻击中" or "等待 Boss…"
		status.TextColor3 = C.good
		toggleBtn.Text = "停止"
		toggleBtn.BackgroundColor3 = C.bad
	else
		status.Text = "已关闭"
		status.TextColor3 = C.sub
		toggleBtn.Text = "开启"
		toggleBtn.BackgroundColor3 = C.good
	end
	glyph.TextColor3 = enabled and Color3.fromRGB(120, 255, 170) or C.white
end
toggleBtn.Activated:Connect(function()
	if dead then return end
	enabled = not enabled
	if not enabled then stopRuntime() end
	refresh()
end)
local expanded = false
local function setExpanded(v)
	if dead or expanded == v then return end
	expanded = v
	if v then
		local x, y = clampPos(ball.Position.X.Offset, ball.Position.Y.Offset, PANEL_W, PANEL_H)
		panel.Position = UDim2.new(0, x, 0, y)
		panel.Visible = true
		panel.Size = UDim2.fromOffset(PANEL_W * .92, PANEL_H * .92)
		ball.Visible = false
		tw(panel, T.med, {Size = UDim2.fromOffset(PANEL_W, PANEL_H)})
	else
		local x, y = clampPos(panel.Position.X.Offset, panel.Position.Y.Offset, BALL, BALL)
		ball.Position = UDim2.new(0, x, 0, y)
		ball.Visible = true
		panel.Visible = false
	end
end
local function makeDraggable(handle, target, w, h, onTap)
	local dragging, moved = false, false
	local startInput, startX, startY
	handle.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch
			and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		dragging, moved = true, false
		startInput = input.Position
		startX = target.Position.X.Offset
		startY = target.Position.Y.Offset
		local conn
		conn = input.Changed:Connect(function()
			if not dragging then
				conn:Disconnect()
				return
			end
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				conn:Disconnect()
				if not moved and onTap then onTap() end
				return
			end
			if input.UserInputState ~= Enum.UserInputState.Change then return end
			local d = input.Position - startInput
			if not moved and d.Magnitude > 6 then moved = true end
			if moved then
				local x, y = clampPos(startX + d.X, startY + d.Y, w, h)
				target.Position = UDim2.new(0, x, 0, y)
			end
		end)
	end)
end
makeDraggable(ball, ball, BALL, BALL, function()
	setExpanded(true)
end)
makeDraggable(header, panel, PANEL_W, PANEL_H, nil)
collapseBtn.Activated:Connect(function()
	setExpanded(false)
end)
local function destroyUI()
	if dead then return end
	dead = true
	enabled = false
	pcall(stopRuntime)
	if charAddedConn then
		pcall(function() charAddedConn:Disconnect() end)
		charAddedConn = nil
	end
	if humanoidDiedConn then
		pcall(function() humanoidDiedConn:Disconnect() end)
		humanoidDiedConn = nil
	end
	if antiIdleConn then
		pcall(function() antiIdleConn:Disconnect() end)
		antiIdleConn = nil
	end
	if camAnchor then
		pcall(function() camAnchor:Destroy() end)
		camAnchor = nil
	end
	pcall(function() gui:Destroy() end)
end
destroyBtn.Activated:Connect(destroyUI)
task.spawn(function()
	while not dead do
		pcall(refresh)
		task.wait(0.2)
	end
end)
refresh()
print("[AlienBoss｜高度+3，当前55，其余全部不变]")
