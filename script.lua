--[[ 
 SLAP TOWER ONLINE SCRIPT
 Hitbox Near Only + Key System
 Client-side
]]

-- ===== KEY SYSTEM =====
local CORRECT_KEY = "VU-SLAP-2025"

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function askKey()
	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "KEY_GUI"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.fromScale(0.35,0.25)
	frame.Position = UDim2.fromScale(0.325,0.35)
	frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	frame.Active = true
	frame.Draggable = true

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.fromScale(1,0.3)
	title.Text = "🔐 ENTER KEY"
	title.TextScaled = true
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.fromScale(0.9,0.25)
	box.Position = UDim2.fromScale(0.05,0.35)
	box.PlaceholderText = "Nhập key..."
	box.TextScaled = true
	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.TextColor3 = Color3.new(1,1,1)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.fromScale(0.6,0.22)
	btn.Position = UDim2.fromScale(0.2,0.68)
	btn.Text = "VERIFY"
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(40,120,40)
	btn.TextColor3 = Color3.new(1,1,1)

	local unlocked = false

	btn.MouseButton1Click:Connect(function()
		if box.Text == CORRECT_KEY then
			unlocked = true
			gui:Destroy()
		else
			box.Text = ""
			box.PlaceholderText = "SAI KEY"
		end
	end)

	repeat task.wait() until unlocked
end

askKey()

-- ===== HITBOX SETTINGS =====
local HITBOX_ON = false
local HITBOX_SIZE = 10
local RANGE = 18
local NORMAL_SIZE = Vector3.new(2,2,1)

local function HRP(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

-- ===== HITBOX LOGIC =====
task.spawn(function()
	while true do
		if HITBOX_ON and LP.Character then
			local myHRP = HRP(LP.Character)
			if myHRP then
				for _,plr in ipairs(Players:GetPlayers()) do
					if plr ~= LP and plr.Character then
						local hrp = HRP(plr.Character)
						if hrp then
							local dist = (myHRP.Position - hrp.Position).Magnitude
							if dist <= RANGE then
								hrp.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
								hrp.Transparency = 0.6
								hrp.Material = Enum.Material.Neon
								hrp.BrickColor = BrickColor.new("Really red")
								hrp.CanCollide = false
							else
								hrp.Size = NORMAL_SIZE
								hrp.Transparency = 1
								hrp.Material = Enum.Material.Plastic
							end
						end
					end
				end
			end
		end
		task.wait(0.4)
	end
end)

-- ===== GUI TOGGLE =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HITBOX_MAIN_GUI"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromScale(0.28,0.08)
btn.Position = UDim2.fromScale(0.02,0.45)
btn.Text = "🎯 HITBOX NEAR OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(140,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Active = true
btn.Draggable = true

btn.MouseButton1Click:Connect(function()
	HITBOX_ON = not HITBOX_ON
	btn.Text = HITBOX_ON and "🎯 HITBOX NEAR ON" or "🎯 HITBOX NEAR OFF"
	btn.BackgroundColor3 = HITBOX_ON
		and Color3.fromRGB(40,170,40)
		or Color3.fromRGB(140,40,40)
end)
