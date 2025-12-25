loadstring(game:HttpGet("https://raw.githubusercontent.com/HelloKittyWare/HelloKittyWare/refs/heads/main/Auto%20Pink%20Theme.lua"))()
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
    ShowCustomCursor = true,
    DisableSearch = true,
    Size = UDim2.fromOffset(650, 500),
    Footer = ' ',
    NotifySide = "Right",
    Resizable = false,
})

local Tabs = {
    Home = Window:AddTab("Home", "house"),
	Main = Window:AddTab("Main", "globe"),
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


local LeftGroupbox = Tabs.Main:AddLeftGroupbox("Aimbot", "crosshair")

local Options = Library.Options
local Toggles = Library.Toggles

local AimbotToggle = LeftGroupbox:AddToggle("AimbotToggle", {
    Text = "Enable Cube Aimbot",
    Default = false,
})

local Keybind = AimbotToggle:AddKeyPicker("MyKeybind", {
    Text = "Aimbot",
    Default = "None",
    Mode = "Toggle",
	SyncToggleState = true,
})

LeftGroupbox:AddSlider("Smoothing", {
    Text = "Less = More Smooth",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
})

-- === Variables ===
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local cubes = {}
local currentTarget = nil
local aimbotEnabled = false
local smoothingFactor = 1.0

-- === Functions ===

-- Get oldest cube
local function getOldestCube()
    local oldest = nil
    local earliestTime = math.huge

    for cube, timestamp in pairs(cubes) do
        if cube and cube.Parent then
            if timestamp < earliestTime then
                oldest = cube
                earliestTime = timestamp
            end
        else
            cubes[cube] = nil
        end
    end

    return oldest
end

-- Move mouse with smoothing and precision
local function lockMouseToCube(cube)
    if not cube or not cube.Parent then return end

    local pos, onScreen = camera:WorldToScreenPoint(cube.Position)
    if onScreen then
        local deltaX = (pos.X - mouse.X) * smoothingFactor
        local deltaY = (pos.Y - mouse.Y) * smoothingFactor
        mousemoverel(deltaX, deltaY) -- bewegt die Maus relativ
    end
end

-- Monitor cubes
local function startMonitoringCubes()
    local folder = workspace:FindFirstChild("Client")
    folder = folder and folder:FindFirstChild("Game")

    if folder then
        -- Füge sofort alle vorhandenen Cubes hinzu
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj.Name == "Cube_Mesh" and obj:IsA("BasePart") then
                cubes[obj] = tick()
                if not currentTarget then
                    currentTarget = getOldestCube()
                end
            end
        end

        -- Danach neue Cubes überwachen
        folder.DescendantAdded:Connect(function(obj)
            if obj.Name == "" and obj:IsA("BasePart") then
                cubes[obj] = tick()
                if not currentTarget then
                    currentTarget = getOldestCube()
                end
            end
        end)
    else
        -- Folder noch nicht da, nach 3 Sekunden erneut prüfen
        delay(3, startMonitoringCubes)
    end
end

-- Main loop
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        if not currentTarget or not currentTarget.Parent then
            currentTarget = getOldestCube()
        end

        if currentTarget then
            lockMouseToCube(currentTarget)
        end
    end
end)

-- === Callbacks ===

Toggles.AimbotToggle:OnChanged(function(state)
    aimbotEnabled = state
end)

Options.Smoothing:OnChanged(function(value)
    smoothingFactor = value / 100
end)

-- Start monitoring cubes
startMonitoringCubes()

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
    Default = true,
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
SaveManager:SetFolder("HelloKittyWare/SoundSpace")
SaveManager:SetSubFolder("")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig("")