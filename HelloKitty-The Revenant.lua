loadstring(game:HttpGet("https://raw.githubusercontent.com/IchMagDichNicht88/HelloKitty-Ware/refs/heads/main/Auto%20Pink%20Theme.lua"))()
wait(0.5)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()


local DraggableLabel = Library:AddDraggableLabel("Obsidian demo")
DraggableLabel:SetVisible(true)

-- FPS stuff
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name

-- Update NUR den Text
RunService.RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameCounter = 0
        FrameTimer = tick()

        -- Text aktualisieren, kein neues Label!
        DraggableLabel:SetText(('%s | %s fps | %s ms'):format(
            gameName,
            math.floor(FPS),
            math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        ))
    end
end)

local Window = Library:CreateWindow({
    Title = 'HelloKitty Ware',
    Icon = 11351620343,
    ShowCustomCursor = false,
    DisableSearch = true,
    Size = UDim2.fromOffset(650, 500),
    Footer = ' ',
    NotifySide = "Right",
    Resizable = false,
})

local Tabs = {
    Home = Window:AddTab("Home", "house"),
	Player = Window:AddTab("Player", "user"),
	Teleport = Window:AddTab("Teleport", "goal"),
	Weapon = Window:AddTab("Weapon", "bow-arrow"),
	Aimbot = Window:AddTab("Aimbot", "crosshair"),
	Esp = Window:AddTab("View", "eye"),
	Settings = Window:AddTab("UI Settings", "settings"),
}

local HomeGroupLeft = Tabs.Home:AddLeftGroupbox("Account", "user")
local HomeGroupRight = Tabs.Home:AddRightGroupbox("Script Status", "scroll")

-- Player Info
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local imageUrl = Players:GetUserThumbnailAsync(
    player.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

HomeGroupLeft:AddImage("MyImage", {
    Image = imageUrl,
    Height = 200,
})

HomeGroupLeft:AddLabel("Good afternoon "..player.DisplayName, false)
HomeGroupLeft:AddLabel("Welcome back to HelloKitty Ware!", true)

-- Services
local HttpService = game:GetService("HttpService")
local url = "https://hellokittyscriptstatus.maxi73118.workers.dev/"

-- Labels dynamisch speichern
local ScriptLabels = {}
local LastStatus = {}

-- Status aktualisieren
local function UpdateStatus()
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then return end

    local data = HttpService:JSONDecode(res)
    local scripts = data.Scripts
    if not scripts then return end

    for scriptName, status in pairs(scripts) do
        -- Label existiert noch nicht → erstellen
        if not ScriptLabels[scriptName] then
            ScriptLabels[scriptName] = HomeGroupRight:AddLabel("", false)
            LastStatus[scriptName] = nil
        end

        -- Nur aktualisieren wenn Status sich ändert
        if status ~= LastStatus[scriptName] then
            ScriptLabels[scriptName]:SetText(
                (status and "🟢" or "🔴") .. " " .. scriptName
            )
            LastStatus[scriptName] = status
        end
    end
end

-- Erstes Laden
UpdateStatus()

-- Alle 5 Sekunden aktualisieren
task.spawn(function()
    while true do
        task.wait(5)
        UpdateStatus()
    end
end)


local LeftGroupbox = Tabs.Player:AddLeftGroupbox("Player","user")
local RightGroupbox = Tabs.Player:AddRightGroupbox("Stuff","user")


local Options = Library.Options
local Toggles = Library.Toggles
 

local MyToggle = LeftGroupbox:AddToggle("MyToggle", {
    Text = "Inf Stamina",
    Default = false,
})
 
Toggles.MyToggle:OnChanged(function(state)
    infstamina = state
end)

spawn(function()
while wait(0.05) do
	if infstamina == true then
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
local I__NFSTA_AXDLOL = ReplicatedStorage.Events.I__NFSTA_AXDLOL -- RemoteEvent 
firesignal(I__NFSTA_AXDLOL.OnClientEvent, 
    true,
    2
)
else
end
end
end)



RightGroupbox:AddButton({
    Text = "Sell All Scrap",
    Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopSignal = ReplicatedStorage.Events.ShopSignal -- RemoteFunction 
ShopSignal:InvokeServer(
    "Scraps",
    {
        Type = "Sell"
    }
)
    end
})


local LeftGroupbox = Tabs.Teleport:AddLeftGroupbox("Tp","goal")
local RightGroupbox = Tabs.Teleport:AddRightGroupbox("Scrap","circle-star")

LeftGroupbox:AddButton({
    Text = "Shop",
    Func = function()
	local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local target = workspace.MAP.MAIN.Structures.Shop.ShopTrapDoor

if target and target:IsA("BasePart") then
    -- 1. Stoppe alle Bewegungen
    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)

    -- 2. PlatformStand aktivieren, damit Humanoid nicht kippt
    humanoid.PlatformStand = true

    -- 3. Teleportieren
    hrp.CFrame = target.CFrame + Vector3.new(3, 3, 5) -- 3 Studs über dem Ziel

    -- 4. Humanoid Ausrichtung fixieren
    humanoid.AutoRotate = false
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(-1,0,-1)) -- Blick nach vorne

    -- 5. Kurz warten
    task.wait(0.05)

    -- 6. PlatformStand deaktivieren, AutoRotate zurücksetzen
    humanoid.PlatformStand = false
    humanoid.AutoRotate = true
else
    warn("Das Ziel existiert nicht oder ist kein BasePart!")
end

    end
})

LeftGroupbox:AddButton({
    Text = "Main Zone",
    Func = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        -- Zielkoordinaten (x, y, z)
        local targetPos = Vector3.new(118, 21, -140)

        -- Bewegung stoppen
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- PlatformStand aktivieren, damit man nicht umfällt
        humanoid.PlatformStand = true

        -- Teleportieren (etwas über dem Boden)
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))

        -- Richtung fixieren (optional)
        humanoid.AutoRotate = false
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, 0, -1))

        -- Warten & zurücksetzen
        task.wait(0.05)
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end
})


LeftGroupbox:AddButton({
    Text = "Tree Infront of Cave",
    Func = function()
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Tree Referenz
local tree = workspace.MAP.GREENERY.Trees:GetChildren()[331]
local Blatt1 = tree:GetChildren()[3]
local Blatt2 = tree:FindFirstChild("Leaves")
local Bark = tree:FindFirstChild("Bark")

-- Blätter löschen
if Blatt1 then Blatt1:Destroy() end
if Blatt2 then Blatt2:Destroy() end

-- Teleport sicher ohne hinfallen
if Bark then
    -- Humanoid kurz setzen, damit er nicht kippt
    humanoid.PlatformStand = true
    humanoid.Sit = true
    
    -- Positionieren & ausrichten
    hrp.CFrame = CFrame.new(Bark.Position + Vector3.new(0,25,0)) * CFrame.Angles(0,0,0)
    Bark.Size = Vector3.new(6.715386867523193, 5.437560081481934, 42.97847366333008)
    
    -- Kurz warten und Humanoid wieder aktivieren
    task.wait(0.2)
    humanoid.Sit = false
    humanoid.PlatformStand = false
end

    end
})

local Options = Library.Options

local Dropdown = RightGroupbox:AddDropdown("MyDropdown", {
    Text = "Gold Scrap",
    Values = { "Scrap1", "Scrap2", "Scrap3", "Scrap4", "Scrap5", "Scrap6" },
    Default = 0,
})


local function Scrap1()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.ScrapBuilding["6"].CFrame + Vector3.new(0,3,0)
end

local function Scrap2()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.Church["3"].CFrame + Vector3.new(0,3,0)
end

local function Scrap3()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.Bunker["3"].CFrame + Vector3.new(0,3,0)
end

local function Scrap4()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.Bunker["5"].CFrame + Vector3.new(0,3,0)
end

local function Scrap5()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.Bunker["6"].CFrame + Vector3.new(0,3,0)
end

local function Scrap6()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
hrp.CFrame = workspace.MAP.Scraps.BrokenBuilding["3"].CFrame + Vector3.new(0,3,0)
end

-- Mapping der Dropdown-Werte auf Funktionen
local ScrapFunctions = {
    Scrap1 = Scrap1,
    Scrap2 = Scrap2,
    Scrap3 = Scrap3,
    Scrap4 = Scrap4,
    Scrap5 = Scrap5,
    Scrap6 = Scrap6,
}

-- Event, wenn der Dropdown-Wert geändert wird
Options.MyDropdown:OnChanged(function(value)
    if ScrapFunctions[value] then
        ScrapFunctions[value]()  -- Funktion ausführen
    end
end)

-- Optional: Dropdown auf leeren Wert setzen
Options.MyDropdown:SetValue("")



local LeftGroupbox = Tabs.Weapon:AddLeftGroupbox("Inf Ammo", "crosshair")

local Label = LeftGroupbox:AddLabel("Suported Guns:", false)
local Label = LeftGroupbox:AddLabel("Glock 19, SPAS-12, Colt Anaconda, SCAR-H And M1 Garand", true)
local Label = LeftGroupbox:AddLabel("More Comming Soon", false)

local Options = Library.Options
local Toggles = Library.Toggles

-- Toggle hinzufügen
local MyToggle = LeftGroupbox:AddToggle("MyToggle", {
    Text = "Inf Ammo",
    Default = false,
})

local Keybind = MyToggle:AddKeyPicker("AutoFarmKey", {
    Default = "None",
    Text = "Inf Ammo",
    Mode = "Toggle",
	SyncToggleState = true,
})

local infAmmoRunning = false
local infAmmoLoop = nil

Toggles.MyToggle:OnChanged(function(state)
    if state and not infAmmoRunning then
        infAmmoRunning = true
        infAmmoLoop = task.spawn(function()
            while infAmmoRunning and task.wait(0.2) do
                local Players = game:GetService("Players")
                local player = Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()

                -- Prüfen, ob Tool in der Hand ist
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name == "SCAR-H" or tool.Name == "M1 Garand" or tool.Name == "Glock-19" or tool.Name == "SPAS-12" or tool.Name == "Colt Anaconda") then
                    local Signal = tool:FindFirstChild("Signal")
                    if Signal then
                        firesignal(Signal.OnClientEvent,
                            "HandleAmmo",
                            {
                                Type = "ToMax"
                            }
                        )
                    end
                end
            end
        end)
    elseif not state and infAmmoRunning then
        infAmmoRunning = false
        infAmmoLoop = nil
    end
end)




-- Aimbot

local Options = Library.Options
local Toggles = Library.Toggles


local AimGroupbox = Tabs.Aimbot:AddLeftGroupbox("Revenant Aimbot", "crosshair")

local AimToggle = AimGroupbox:AddToggle("RevenantAimbotToggle", {
    Text = "Enable Aimbot",
    Default = false,
})

local Keybind = AimToggle:AddKeyPicker("AutoFarmKey", {
    Default = "None",
    Text = "Aimbot",
    Mode = "Toggle",
	SyncToggleState = true,
})
 



local SmoothSlider = AimGroupbox:AddSlider("RevenantAimbotSmooth", {
    Text = "Smoothness (0 = instant)",
    Default = 0,
    Min = 0,
    Max = 15,
    Rounding = 0,
})

local FOVSlider = AimGroupbox:AddSlider("RevenantAimbotFOV", {
    Text = "FOV (pixels)",
    Default = 150,
    Min = 10,
    Max = 1000,
    Rounding = 0,
})

local FOVCircleToggle = AimGroupbox:AddToggle("RevenantAimbotFOVCircle", {
    Text = "Show FOV Circle",
    Default = false,
})

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local RightMouseHeld = false

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseHeld = false
    end
end)

-- Drawing FOV circle
local DrawingAvailable = (typeof(Drawing) == "table" and type(Drawing.new) == "function")
local fovCircle = nil
if DrawingAvailable then
    local ok, res = pcall(function()
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Transparency = 1
        fovCircle.Thickness = 2
        fovCircle.Radius = FOVSlider.Value
        fovCircle.Filled = false
        fovCircle.Color = Color3.fromRGB(248, 164, 255)
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end)
    if not ok then fovCircle = nil end
end

-- Main loop
local aimConnection
aimConnection = RunService.RenderStepped:Connect(function(dt)
    Camera = workspace.CurrentCamera
    if not Camera then return end

    -- Update FOV circle
    if fovCircle and DrawingAvailable then
        fovCircle.Visible = Toggles.RevenantAimbotToggle.Value and Toggles.RevenantAimbotFOVCircle.Value
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Radius = FOVSlider.Value
    end

    -- Only aim if toggled and right click held
    if not Toggles.RevenantAimbotToggle.Value or not RightMouseHeld then return end

    -- Get Revenant Head
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if not npcsFolder then return end
    local revenant = npcsFolder:FindFirstChild("Revenant")
    if not revenant then return end
    local head = revenant:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end

    -- Project head to screen
    local headScreenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
    if not onScreen then return end

    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local head2D = Vector2.new(headScreenPos.X, headScreenPos.Y)
    local dist2D = (head2D - screenCenter).Magnitude

    -- Aim only if inside FOV slider radius
    if dist2D > FOVSlider.Value then return end

    -- Target CFrame
    local targetCFrame = CFrame.new(Camera.CFrame.Position, head.Position)

    local smoothVal = SmoothSlider.Value or 0
    if smoothVal <= 0 then
        Camera.CFrame = targetCFrame
    else
        local alpha = 1 - math.exp(-smoothVal * dt)
        alpha = math.clamp(alpha, 0, 1)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, alpha)
    end
end)

-- Cleanup
Library:OnUnload(function()
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
    if fovCircle then pcall(function() fovCircle:Remove() end) end
end)



local player = Tabs.Esp:AddLeftGroupbox('Player', 'eye')
local npc = Tabs.Esp:AddRightGroupbox('Revenant', 'eye')
local world = Tabs.Esp:AddLeftGroupbox('World', 'eye')


world:AddButton({
    Text = "Full Bright",
    Func = function()
        -- 🌕 FullBright Script (permanent)
if getgenv().FullBrightExecuted then
    warn("FullBright already active!")
    return
end
getgenv().FullBrightExecuted = true

local Lighting = game:GetService("Lighting")

-- Speichere alte Werte (falls du sie später zurücksetzen willst)
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogEnd = Lighting.FogEnd
local oldGlobalShadows = Lighting.GlobalShadows
local oldAmbient = Lighting.Ambient

-- FullBright aktivieren
Lighting.Brightness = 2
Lighting.ClockTime = 12
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false
Lighting.Ambient = Color3.fromRGB(255, 255, 255)

-- Automatisches Wiederherstellen falls Lighting sich ändert
Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
    Lighting.Brightness = 2
end)
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
    Lighting.ClockTime = 12
end)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
    Lighting.FogEnd = 100000
end)
Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
    Lighting.GlobalShadows = false
end)
Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end)

print("✅ FullBright activated!")

    end
})


local Options = Library.Options
local Toggles = Library.Toggles
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')

-- ===== Spieler Highlight =====
local HighlightToggle = player:AddToggle('HighlightToggle', {
    Text = 'Player Chams',
    Default = false,
})

local HighlightEnabled = HighlightToggle.Value
local playerHighlights = {}

local function updatePlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local char = player.Character
            if char then
                local existingH = playerHighlights[player]
                if HighlightEnabled then
                    if not existingH or not existingH.Parent then
                        local h = Instance.new('Highlight')
                        h.FillColor = Color3.fromRGB(255, 255, 255)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.FillTransparency = 0.5
                        h.Parent = char
                        playerHighlights[player] = h
                    end
                else
                    if existingH and existingH.Parent then
                        existingH:Destroy()
                        playerHighlights[player] = nil
                    end
                end
            end
        end
    end
end

Toggles.HighlightToggle:OnChanged(function(state)
    HighlightEnabled = state
end)

-- ===== NPC Highlight =====
local NPCToggle = npc:AddToggle('NPCHighlightToggle', {
    Text = 'Revenant Chams',
    Default = false,
})

local NPCEnabled = NPCToggle.Value
local npcHighlights = {}

local function updateNPCs()
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if not npcsFolder then return end

    for _, npc in ipairs(npcsFolder:GetChildren()) do
        if npc:IsA("Model") then
            local existingH = npcHighlights[npc]
            if NPCEnabled then
                if not existingH or not existingH.Parent then
                    local h = Instance.new('Highlight')
                    h.FillColor = Color3.fromRGB(248, 164, 255) -- Rot für NPCs
                    h.OutlineColor = Color3.fromRGB(248, 164, 255)
                    h.FillTransparency = 0.5
                    h.Parent = npc
                    npcHighlights[npc] = h
                end
            else
                if existingH and existingH.Parent then
                    existingH:Destroy()
                    npcHighlights[npc] = nil
                end
            end
        end
    end
end

Toggles.NPCHighlightToggle:OnChanged(function(state)
    NPCEnabled = state
end)

-- ===== Update Loop =====
RunService.Heartbeat:Connect(function()
    updatePlayers()
    updateNPCs()
end)


local LeftGroupbox = Tabs.Settings:AddLeftGroupbox('UI', 'app-window')


LeftGroupbox:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})

local Options = Library.Options
local Toggles = Library.Toggles
 
-- Watermark Toggle

local MyToggle = LeftGroupbox:AddToggle("MyToggle", {
    Text = "Watermark",
    Default = true,
})
 
Toggles.MyToggle:OnChanged(function(state)
    DraggableLabel:SetVisible(state)
end)

local Options = Library.Options
local Toggles = Library.Toggles

-- Custom Cursor Toggle

local MyToggle = LeftGroupbox:AddToggle("MyToggle", {
    Text = "Custom Cursor",
    Default = false,
})

Toggles.MyToggle:OnChanged(function(state)
    Library.ShowCustomCursor = state
end)

LeftGroupbox:AddDivider()

-- Dpi Dropdown

LeftGroupbox:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})



-- Unload
LeftGroupbox:AddDivider()


LeftGroupbox:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightControl", NoUI = true, Text = "Menu keybind" })


LeftGroupbox:AddButton('Unload', function()
    Library:Unload()
end)


Library.ToggleKeybind = Options.MenuKeybind 

-- ================================
-- SaveManager & ThemeManager
-- ================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("HelloKittyWare")
SaveManager:SetFolder("HelloKittyWare/The Revenant")
SaveManager:SetSubFolder("")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig("")