-- [[ ADVANCED ANTI-BAN & MEMORY PROTECTOR v3.0 ]] --
if not hookmetamethod then 
    return warn("[LỖI] Executor của bạn không hỗ trợ hookmetamethod! Không thể chạy Anti-Ban.") 
end

-- ==========================================
-- TẠO CHỮ HIỂN THỊ CHÍNH GIỮA MÀN HÌNH
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Xóa thông báo cũ nếu có để tránh trùng lặp
if CoreGui:FindFirstChild("AntiBanNotification") then
    CoreGui.AntiBanNotification:Destroy()
end

-- Tạo giao diện (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiBanNotification"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 300, 0, 30)
TextLabel.Position = UDim2.new(0.5, -150, 0.5, -15) -- Căn chính giữa màn hình
TextLabel.BackgroundTransparency = 1 -- Ẩn nền, chỉ hiện chữ
TextLabel.Text = "Anti-Ban: Đã Bật"
TextLabel.TextColor3 = Color3.fromRGB(0, 255, 127) -- Màu xanh lá neon nổi bật
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 20
TextLabel.TextStrokeTransparency = 0.5 -- Viền chữ đen giúp dễ đọc hơn
TextLabel.TextTransparency = 1 -- Bắt đầu bằng ẩn để làm hiệu ứng hiện lên
TextLabel.Parent = ScreenGui

-- Hiệu ứng chữ hiện hình mượt mà (Fade In)
TweenService:Create(TextLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

-- Chờ 3 giây rồi chữ sẽ mờ dần và tự xóa (Fade Out)
task.delay(3, function()
    local fadeOut = TweenService:Create(TextLabel, TweenInfo.new(0.5), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- ==========================================
-- HỆ THỐNG PHÒNG THỦ ANTI-BAN (CORE)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local BlacklistedRemotes = {"report", "cheat", "exploit", "kick", "ban", "anticheat", "log", "detection", "crash"}

-- Hook kiểm tra chỉ số bộ nhớ (Anti-Memory Scan)
local IndexHook
IndexHook = hookmetamethod(game, "__index", function(Self, Key)
    if not checkcaller() and Self:IsA("Humanoid") then
        if Key == "WalkSpeed" then return 16 end
        if Key == "JumpPower" then return 50 end
        if Key == "HipHeight" then return 0 end
    end
    return IndexHook(Self, Key)
end)

-- Hook ngăn chặn các lệnh trục xuất và báo cáo (Anti-Kick/Report)
local NamecallHook
NamecallHook = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if not checkcaller() then
        if Method == "Kick" and Self == LocalPlayer then
            print("[Anti-Ban] Đã chặn một yêu cầu KICK từ Server!")
            return nilend
        if Method == "FireServer" or Method == "InvokeServer" then
            local RemoteName = tostring(Self):lower()
            for _, Keyword in ipairs(BlacklistedRemotes) do
                if RemoteName:find(Keyword) then
                    warn("[Anti-Ban] Đã chặn đứng Remote gửi báo cáo: " .. tostring(Self))
                    return nil
                end
            end
        end
    end
    return NamecallHook(Self, ...)
end)

-- Anti-Screenshot & Anti-Log
if setfflag then
    pcall(function()
        setfflag("RobloxScreenShotQuality", "0")
        setfflag("EnableScreenshotUpload", "false")
    end)
end

local LogService = game:GetService("LogService")
local ScriptContext = game:GetService("ScriptContext")
LogService.MessageReceived:Connect(function(Message, MessageType)
    if MessageType == Enum.MessageType.MessageError then
        pcall(function() ScriptContext:ClearAllErrorLogs() end)
    end
end)
