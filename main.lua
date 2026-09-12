-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]
-- [[ Main Script Bundle: ScriptVerse - Steal An Egg ]]
-- File: main.lua (All-in-one compiled version)
do
-- [[ 1. Compatibility & Environment Setup ]]
local g = (getgenv and getgenv()) or _G
local C = rawget(g, "SVCompat")
if type(C) ~= "table" or not C.__svcompat then
local function executorName()
local ok, n = pcall(function()
return (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or ""
end)
return (ok and tostring(n) or ""):lower()
end
local exec = executorName()
local isSolara = exec:find("solara", 1, true) ~= nil
or exec:find("xeno", 1, true) ~= nil
or exec:find("micro", 1, true) ~= nil
local realRequire = require
C = {
__svcompat = true,
Executor = exec,
IsSolara = isSolara,
AllowRequire = true,
AllowHooks = (not isSolara) and typeof(hookmetamethod) == "function",
AllowGc = typeof(getgc) == "function",
AllowDrawing = typeof(Drawing) == "table" and typeof(Drawing.new) == "function",
rawRequire = realRequire,
}
function C.softRequire(mod)
if mod == nil then return nil end
local ok, res = pcall(realRequire, mod)
if ok then return res end
local err = string.lower(tostring(res))
if err:find("cannot require", 1, true)
or err:find("cast string to bool", 1, true)
or err:find("unable to cast", 1, true)
then
C.IsSolara = true
C.AllowRequire = false
end
return nil
end
C.require = C.softRequire
C.rawRequire = realRequire
function C.child(parent, ...)
local cur = parent
for i = 1, select("#", ...) do
if typeof(cur) ~= "Instance" then return nil end
cur = cur:FindFirstChild((select(i, ...)))
end
return cur
end
function C.softDrawing(class)
if not C.AllowDrawing then return nil end
local ok, obj = pcall(Drawing.new, class)
return ok and obj or nil
end
function C.canHook() return C.AllowHooks == true end
function C.canGc() return C.AllowGc == true end
g.SVCompat = C
end
end
local require = (function()
local g = (getgenv and getgenv()) or _G
local C = rawget(g, "SVCompat")
if type(C) == "table" and type(C.require) == "function" then
return C.require
end
return require
end)()
-- [[ 2. Core Variables & Place ID Check ]]
local PLACE_ID = 107778070777162
local genv = (getgenv and getgenv()) or _G
if type(genv.SV_SAE_SHUTDOWN) == "function" then
pcall(genv.SV_SAE_SHUTDOWN)
task.wait(0.1)
end
if genv.SV_SAE_RUNNING then
return
end
genv.SV_SAE_RUNNING = true
print("[ScriptVerse] Steal An Egg - loading main module...")
-- [[ 3. Client Anti-Cheat Bypass ]]
local function bypassClientDetections()
if typeof(filtergc) ~= "function" or typeof(debug) ~= "table" or typeof(debug.getupvalues) ~= "function" then
return false, "no filtergc"
end
local ok, fn = pcall(function()
return filtergc("function", {
Constants = { "gmatch", "GetFullName" },
}, true)
end)
if not ok or type(fn) ~= "function" then
return false, "filter miss"
end
local setMeta = (typeof(setrawmetatable) == "function" and setrawmetatable)
or (typeof(setmetatable) == "function" and setmetatable)
if not setMeta then
return false, "no setmeta"
end
local blocked = 0
local okUv, ups = pcall(debug.getupvalues, fn)
if not okUv or type(ups) ~= "table" then
return false, "no upvalues"
end
for _, tbl in pairs(ups) do
if typeof(tbl) == "table" then
local okSet = pcall(setMeta, tbl, {
__newindex = function() end,
})
if okSet then
blocked += 1
end
end
end
return blocked > 0, blocked
end
local acOk, acInfo = bypassClientDetections()
if acOk then
print("[ScriptVerse] Client AC bypassed (" .. tostring(acInfo) .. " tables)")
else
warn("[ScriptVerse] Client AC bypass skipped: " .. tostring(acInfo))
end
-- [[ 4. Service References & State Configuration ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local HAS_DRAWING = typeof(Drawing) == "table" or typeof(Drawing) == "userdata"
local function pinUiToPlayerGui()
return LocalPlayer:WaitForChild("PlayerGui")
end
local SVUI = genv.SVUI or _G.SVUI
if not SVUI then
pinUiToPlayerGui()
local ok, lib = pcall(function()
return loadstring(game:HttpGet("https://scriptversekey.xyz/svui.lua"))()
end)
if ok then
SVUI = lib
end
end
if not SVUI then
warn("[ScriptVerse] SVUI failed to load")
genv.SV_SAE_RUNNING = nil
return
end
local Accent = Color3.fromRGB(120, 220, 160)
local OkGreen = Color3.fromRGB(120, 220, 140)
local WarnOrange = Color3.fromRGB(255, 140, 80)
local function softRequire(inst)
if typeof(inst) ~= "Instance" then
return nil
end
local ok, mod = pcall(require, inst)
return ok and mod or nil
end
local Lib = ReplicatedStorage:WaitForChild("Library", 30)
local Client = Lib:WaitForChild("Client", 15)
local Util = Lib:WaitForChild("Util", 15)
local Globals = Lib:WaitForChild("Globals", 15)
local EggCmds = softRequire(Client:WaitForChild("EggCmds", 15))
local PlotCmds = softRequire(Client:WaitForChild("PlotCmds", 15))
local Network = softRequire(Client:WaitForChild("Network", 15))
local Guard = softRequire(Client:WaitForChild("ToolGameplayGuard", 15))
local Lookup = softRequire(Util:WaitForChild("GuardAreaLookupUtil", 15))
local Save = softRequire(Client:WaitForChild("Save", 15))
local BaseUpgrade = softRequire(Client:WaitForChild("BaseUpgradeClient", 15))
local AssetCmds = softRequire(Client:WaitForChild("AssetCmds", 15))
local Constants = softRequire(Globals:WaitForChild("Constants", 15))
local SpeedPowerProjection = softRequire(Client:FindFirstChild("SpeedPowerProjection"))
local TreadmillUtil = softRequire(Util:FindFirstChild("TreadmillUtil"))
if not EggCmds or not PlotCmds or not Guard or not Lookup then
warn("[ScriptVerse] Steal An Egg modules unavailable")
genv.SV_SAE_RUNNING = nil
return
end
local NetMap = (Constants and Constants.NETWORK_MAP) or (Network and Network.NET_MAP)
local PivotKey = (NetMap and NetMap.ClientCharacter and NetMap.ClientCharacter.SET_PIVOT)
or "ClientCharacter: SetPivot"
local ImpulseKey = (NetMap and NetMap.ClientCharacter and NetMap.ClientCharacter.BEGIN_IMPULSE)
or "ClientCharacter: BeginImpulse"
local SeparationLine = nil
local cachedPlayPos, cachedSafePos
local function getSeparationLine()
if SeparationLine and SeparationLine.Parent then
return SeparationLine
end
local objs = Workspace:FindFirstChild("__OBJECTS") or Workspace:WaitForChild("__OBJECTS", 20)
if not objs then
return nil
end
local areas = objs:FindFirstChild("Areas")
if not areas then
return nil
end
SeparationLine = areas:FindFirstChild("SeparationLine")
return SeparationLine
end
local conns = {}
local espPool = {}
local flyConn, noclipConn, infJumpConn
local State = {
running = true,
busy = false,
busySince = nil,
status = "Idle",
carrying = false,
instantSteal = false,
autofarm = false,
preferHighValue = true,
speedOn = false,
walkSpeed = 32,
jumpOn = false,
jumpPower = 80,
infJump = false,
noclip = false,
fly = false,
flySpeed = 32,
antiAfk = true,
}
local function notify(title, content, color, dur)
pcall(function()
SVUI:Notify({
Title = title,
Content = content,
Duration = dur or 2.2,
Color = color or Accent,
})
end)
end
local function track(conn)
table.insert(conns, conn)
return conn
end
if EggCmds and EggCmds.AreaEggCarryStateChanged and type(EggCmds.AreaEggCarryStateChanged.Connect) == "function" then
track(EggCmds.AreaEggCarryStateChanged:Connect(function(payload)
if payload and payload.IsCarrying == true then
State.carrying = true
elseif payload and payload.IsCarrying == false then
State.carrying = false
end
end))
end
local function root()
local char = LocalPlayer.Character
return char and char:FindFirstChild("HumanoidRootPart")
end
local function hum()
local char = LocalPlayer.Character
return char and char:FindFirstChildOfClass("Humanoid")
end
local function zeroVel(part)
if not part then return end
part.AssemblyLinearVelocity = Vector3.zero
part.AssemblyAngularVelocity = Vector3.zero
end
local function waitRoot(timeout)
timeout = timeout or 15
local char = LocalPlayer.Character
if not char then
char = LocalPlayer.CharacterAdded:Wait()
end
return char:WaitForChild("HumanoidRootPart", timeout)
end
local AssetsDirectory = nil
pcall(function()
local Assets = require(ReplicatedStorage.Directory.Assets)
AssetsDirectory = Assets and Assets.Directory
end)
local function burstPivot(cf, fires)
local r = root()
if not r or not cf then return end
fires = fires or 2
for _ = 1, fires do
if Network and PivotKey then
pcall(function()
Network.Fire(PivotKey, cf)
end)
end
r.CFrame = cf
zeroVel(r)
task.wait(0.014)
end
end
local function smoothPath(goal, steps, firesPerStep)
local r = root()
if not r or not goal then return false end
steps = steps or 16
firesPerStep = firesPerStep or 2
local from = r.Position
for i = 1, steps do
if not State.running then return false end
r = root()
if not r then return false end
local p = from:Lerp(goal, i / steps)
burstPivot(CFrame.new(p.X, math.max(p.Y, r.Position.Y), p.Z), firesPerStep)
end
return true
end
local function inGameplay()
if type(Guard.IsLocalPlayerInGameplayArea) == "function" then
return Guard.IsLocalPlayerInGameplayArea() == true
end
return false
end
local function onGameplaySide(pos)
local line = getSeparationLine()
if not line or not pos then return false end
if type(Lookup.IsInGameplaySide) == "function" then
return Lookup.IsInGameplaySide(line, pos) == true
end
local rel = line.CFrame:PointToObjectSpace(pos)
return rel.Z > 0
end
local function crossToArena()
if inGameplay() then return true end
local line = getSeparationLine()
if not line then return false end
local playPos = line.Position + Vector3.new(55, 4, 0)
local safePos = line.Position - Vector3.new(55, 4, 0)
State.status = "Walking to arena"
walkRunTo(safePos, 16, 20)
walkRunTo(playPos, 16, 25)
task.wait(0.2)
return inGameplay()
end
local function freezeSpeedPower()
local fn = SpeedPowerProjection and SpeedPowerProjection.GetSpeedPower
if type(fn) ~= "function" or type(setupvalue) ~= "function" or type(getupvalue) ~= "function" then
return
end
pcall(function()
for i = 1, 12 do
local v = getupvalue(fn, i)
if type(v) == "number" then
setupvalue(fn, i, 1e7)
break
end
end
end)
end
local speedBV
local function applySpeed()
local r = root()
local h = hum()
if State.speedOn or State.fly then
freezeSpeedPower()
end
if speedBV and (not State.speedOn or not r or speedBV.Parent ~= r) then
pcall(function() speedBV:Destroy() end)
speedBV = nil
end
if State.speedOn and r then
if not speedBV or speedBV.Parent ~= r then
speedBV = Instance.new("BodyVelocity")
speedBV.Name = "SV_Speed"
speedBV.MaxForce = Vector3.new(8e4, 0, 8e4)
speedBV.Parent = r
end
local dir = Vector3.zero
if h and h.MoveDirection.Magnitude > 0.05 then
dir = Vector3.new(h.MoveDirection.X, 0, h.MoveDirection.Z).Unit
end
speedBV.Velocity = dir * State.walkSpeed
end
end
-- [[ 5. UI Initialization & Main Menu Construction ]]
pinUiToPlayerGui()
task.wait(0.15)
local Window = SVUI:CreateWindow({
Title = "Steal An Egg",
Subtitle = "ScriptVerse",
})
pcall(function()
local pg = LocalPlayer:WaitForChild("PlayerGui")
if Window and Window.Gui then
Window.Gui.Parent = pg
Window.Gui.DisplayOrder = 10
end
end)
local CharTab = Window:CreateTab({ Title = "Character" })
local EspTab = Window:CreateTab({ Title = "ESP" })
CharTab:CreateSection("Movement")
CharTab:CreateToggle({
Title = "Walk Speed",
Default = false,
Callback = function(v)
State.speedOn = v
applySpeed()
notify("Speed", v and "On" or "Off", v and OkGreen or WarnOrange)
end,
})
CharTab:CreateSlider({
Title = "Speed",
Min = 16,
Max = 80,
Default = 32,
Increment = 1,
Callback = function(v)
State.walkSpeed = v
if State.speedOn then applySpeed() end
end,
})
CharTab:CreateButton({
Title = "Unload",
Callback = function()
pcall(genv.SV_SAE_SHUTDOWN)
end,
})
-- [[ 6. Shutdown Cleanups ]]
genv.SV_SAE_SHUTDOWN = function()
State.running = false
for _, c in ipairs(conns) do
pcall(function() c:Disconnect() end)
end
table.clear(conns)
if speedBV then
pcall(function() speedBV:Destroy() end)
speedBV = nil
end
genv.SV_SAE_RUNNING = nil
genv.SV_SAE_SHUTDOWN = nil
end
notify("Steal An Egg", "Main Bundle Loaded Successfully", OkGreen, 3)


