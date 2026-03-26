local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SteamNotificationAPI"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local notifs = {}

local function vp()
	return workspace.CurrentCamera.ViewportSize
end

local function slotY(slot)
	local v = vp()
	local h = math.round(v.Y * 0.1287)
	local gap = math.round(v.Y * 0.0074)
	return 0.86977 - ((h + gap) * slot) / v.Y
end

local function restack()
	for i, d in ipairs(notifs) do
		TweenService:Create(d, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0.74737, 0, slotY(i - 1), 0)
		}):Play()
	end
end

local function makeNotif(title, desc, iconId)
	local v = vp()
	local w = math.round(v.X * 0.252)
	local h = math.round(v.Y * 0.1287)

	local frame = Instance.new("Frame", sg)
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.fromRGB(26, 32, 41)
	frame.Size = UDim2.new(0, w, 0, h)
	frame.Name = "mainthing"

	local gradient = Instance.new("UIGradient", frame)
	gradient.Rotation = -90
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 31, 38)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	}

	local icon = Instance.new("ImageLabel", frame)
	icon.BorderSizePixel = 0
	icon.BackgroundTransparency = 1
	icon.Image = iconId and ("rbxassetid://" .. tostring(iconId)) or "rbxassetid://11374267679"
	icon.Size = UDim2.new(0, 100, 0, 100)
	icon.Position = UDim2.new(0.03721, 0, 0.13669, 0)
	icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	local line = Instance.new("Frame", frame)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Color3.fromRGB(31, 167, 0)
	line.Size = UDim2.new(0, 7, 0, 100)
	line.Position = UDim2.new(0.24425, 0, 0.13669, 0)
	line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	line.Name = "icon_line"
	Instance.new("UIStroke", line).Color = Color3.fromRGB(22, 112, 2)

	local titleL = Instance.new("TextLabel", frame)
	titleL.BorderSizePixel = 0
	titleL.TextSize = 31
	titleL.TextXAlignment = Enum.TextXAlignment.Left
	titleL.BackgroundTransparency = 1
	titleL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleL.BorderColor3 = Color3.fromRGB(0, 0, 0)
	titleL.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleL.Size = UDim2.new(0, 267, 0, 35)
	titleL.Position = UDim2.new(0.30739, 0, 0.13276, 0)
	titleL.Text = title
	titleL.Name = "title"

	local descL = Instance.new("TextLabel", frame) -- g2l love
	descL.TextWrapped = true
	descL.BorderSizePixel = 0
	descL.TextSize = 31
	descL.TextXAlignment = Enum.TextXAlignment.Left
	descL.TextYAlignment = Enum.TextYAlignment.Top
	descL.BackgroundTransparency = 1
	descL.BackgroundColor3 = Color3.fromRGB(121, 139, 168)
	descL.BorderColor3 = Color3.fromRGB(0, 0, 0)
	descL.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	descL.TextColor3 = Color3.fromRGB(190, 193, 198)
	descL.Size = UDim2.new(0, 280, 0, 65)
	descL.Position = UDim2.new(0.30739, 0, 0.38455, 0)
	descL.Text = desc
	descL.Name = "description"

	return frame
end

local SteamNotification = {}

function SteamNotification:Notify(title, desc, iconId)
	local frame = makeNotif(title or "", desc or "", iconId)

	frame.Position = UDim2.new(1.15, 0, slotY(0), 0)
	table.insert(notifs, 1, frame)

	for i = 2, #notifs do
	    notifs[i].Position = UDim2.new(0.74737, 0, slotY(i - 1), 0)
	end

	local sound = Instance.new("Sound") -- steam notification sound, message
	sound.SoundId = "rbxassetid://139308638407157"
	sound.Volume = 1
	sound.Parent = SoundService
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 5)

	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	    Position = UDim2.new(0.74737, 0, slotY(0), 0)
	}):Play()

	task.delay(5, function()
		local v = vp()
		local w = math.round(v.X * 0.252)
		local offscreenX = 1 + (w / v.X) + 0.02
		local cy = frame.Position.Y.Scale

		local t = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(offscreenX, 0, cy, 0)
		})
		t:Play()
		t.Completed:Wait()

		for i, d in ipairs(notifs) do
			if d == frame then table.remove(notifs, i) break end
		end

		frame:Destroy()
		restack()
	end)
end
-- best ui designer on earth
return SteamNotification
