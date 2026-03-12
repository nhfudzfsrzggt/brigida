local hq = game:GetService("HttpService")
local im = game:GetService("Players")
local ey = im.LocalPlayer
local BASE = "https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/"
local function load(path) return loadstring(game:HttpGet(BASE..path))() end
local eq = load("src/elements/color.lua")
local br = load("src/elements/Elements.lua")
local ir = load("src/elements/keybind.lua")
local iw = load("src/elements/icon/basic.lua")
local je = load("src/elements/icon/lucide.lua")
local iy = load("src/elements/icon/solar.lua")
local dm = {}
for name, id in pairs(iw) do dm[name] = id
end
for name, id in pairs(je) do dm["lucide:"..name] = id
end
for name, id in pairs(iy) do dm["solar:"..name] = id
end
local function dr(iconName)
if not iconName or iconName=="" then
return ""
end
if iconName:match("^%d+$") then
return "rbxassetid://"..iconName
end
if dm[iconName] then
return dm[iconName]
end
if iconName:match("^https?://") then
return iconName
end
return ""
end
local function gg(colorInput)
if typeof(colorInput)=="Color3" then
return colorInput
end
if type(colorInput)=="string" then if eq[colorInput] then
return eq[colorInput]
else warn("Color '"..colorInput.."' not found, using Default")
return eq["Default"] or Color3.fromRGB(0, 208, 255)
end
end
return eq["Default"] or Color3.fromRGB(0, 208, 255)
end
local cy = "Velaris UI"
local dv = ""
local cl = {}
local dz = {}
local cz = nil
local jp = false
local hm = false
function jv()
if writefile and dv~="" then cl._version = cz
writefile(dv, hq:JSONEncode(cl))
end
end
function iq()
if not cz or dv=="" then return end
if isfile and isfile(dv) then local io, eb = pcall(function()
return hq:JSONDecode(readfile(dv))
end)
if io and type(eb)=="table" then if eb._version==cz then cl = eb
else cl = { _version = cz }
end
else cl = { _version = cz }
end
else cl = { _version = cz }
end
end
function jx()
for key, element in pairs(dz) do if cl[key]~=nil and element.Set then element:Set(cl[key], true)
end
end
end
local ea = game:GetService("UserInputService")
local b = game:GetService("TweenService")
local cn = ey:GetMouse()
local bg = game:GetService("CoreGui")
local hs = workspace.CurrentCamera.ViewportSize
local function jm()
return ea.TouchEnabled
and not ea.KeyboardEnabled
and not ea.MouseEnabled
end
local ft = jm()
local function gy(pxWidth, pxHeight)
local gn = pxWidth / hs.X
local fz = pxHeight / hs.Y
if ft then if gn > 0.5 then gn = 0.5 end
if fz > 0.3 then fz = 0.3 end
end
return UDim2.new(gn, 0, fz, 0)
end
local function jw(topbarobject, object, GuiConfig)
local function jd(topbarobject, object)
local dd, DragInput, DragStart, StartPosition
local function js(input)
local eh = input.Position - DragStart
local pos = UDim2.new( StartPosition.X.Scale, StartPosition.X.Offset + eh.X, StartPosition.Y.Scale, StartPosition.Y.Offset + eh.Y
)
local fx = b:Create(object, TweenInfo.new(0.2), { Position = pos })
fx:Play()
end
topbarobject.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dd = true
DragStart = input.Position
StartPosition = object.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then dd = false
end
end)
end
end)
topbarobject.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then DragInput = input
end
end)
ea.InputChanged:Connect(function(input)
if input==DragInput and dd then js(input)
end
end)
end
local function jh(object)
local dd, DragInput, DragStart, StartSize
local gh, minSizeY
local fu, defSizeY
local cfgW = (GuiConfig and GuiConfig.Size and GuiConfig.Size.X.Offset) or 640
local cfgH = (GuiConfig and GuiConfig.Size and GuiConfig.Size.Y.Offset) or 400
if ft then gh, minSizeY = 100, 100
fu = math.min(cfgW, 470)
defSizeY = math.min(cfgH, 270)
else gh, minSizeY = 100, 100
fu = cfgW
defSizeY = cfgH
end
object.Size = UDim2.new(0, fu, 0, defSizeY)
local cs = Instance.new("Frame")
cs.AnchorPoint = Vector2.new(1, 1)
cs.BackgroundTransparency = 1
cs.Size = UDim2.new(0, 40, 0, 40)
cs.Position = UDim2.new(1, 20, 1, 20)
cs.Name = "changesizeobject"
cs.Parent = object
local function jk(input)
local eh = input.Position - DragStart
local ga = StartSize.X.Offset + eh.X
local gf = StartSize.Y.Offset + eh.Y
ga = math.max(ga, gh)
gf = math.max(gf, minSizeY)
local fx = b:Create(object, TweenInfo.new(0.2), { Size = UDim2.new(0, ga, 0, gf) })
fx:Play()
end
cs.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dd = true
DragStart = input.Position
StartSize = object.Size
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then dd = false
end
end)
end
end)
cs.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then DragInput = input
end
end)
ea.InputChanged:Connect(function(input)
if input==DragInput and dd then jk(input)
end
end)
end
jh(object)
jd(topbarobject, object)
end
function fa(c, X, Y)
spawn(function()
c.ClipsDescendants = true
local ac = Instance.new("ImageLabel")
ac.Image = "rbxassetid://266543268"
ac.ImageColor3 = Color3.fromRGB(80, 80, 80)
ac.ImageTransparency = 0.8999999761581421
ac.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ac.BackgroundTransparency = 1
ac.ZIndex = 10
ac.Name = "Circle"
ac.Parent = c
local NewX = X - ac.AbsolutePosition.X
local NewY = Y - ac.AbsolutePosition.Y
ac.Position = UDim2.new(0, NewX, 0, NewY)
local Size = 0
if c.AbsoluteSize.X > c.AbsoluteSize.Y then Size = c.AbsoluteSize.X * 1.5
elseif c.AbsoluteSize.X < c.AbsoluteSize.Y then Size = c.AbsoluteSize.Y * 1.5
elseif c.AbsoluteSize.X==c.AbsoluteSize.Y then Size = c.AbsoluteSize.X * 1.5
end
local Time = 0.5
ac:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", Time, false, nil)
for i = 1, 10 do ac.ImageTransparency = ac.ImageTransparency + 0.01
wait(Time / 10)
end
ac:Destroy()
end)
end
local di = {}
function di:MakeNotify(NotifyConfig)
NotifyConfig = NotifyConfig or {}
NotifyConfig.Title = NotifyConfig.Title or "Velaris UI"
NotifyConfig.Description = NotifyConfig.Description or "Notification"
NotifyConfig.Content = NotifyConfig.Content or "Content"
NotifyConfig.Color = gg(NotifyConfig.Color or Color3.fromRGB(0, 208, 255))
NotifyConfig.Time = NotifyConfig.Time or 0.5
NotifyConfig.Delay = NotifyConfig.Delay or 5
local es = {}
spawn(function()
if not bg:FindFirstChild("NotifyGui") then local bz = Instance.new("ScreenGui")
bz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
bz.Name = "NotifyGui"
bz.Parent = bg
end
if not bg.NotifyGui:FindFirstChild("NotifyLayout") then local av = Instance.new("Frame")
av.AnchorPoint = Vector2.new(1, 1)
av.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
av.BackgroundTransparency = 0.999
av.BorderSizePixel = 0
av.Position = UDim2.new(1, -30, 1, -30)
av.Size = UDim2.new(0, 320, 1, 0)
av.Name = "NotifyLayout"
av.Parent = bg.NotifyGui
local et = 0
bg.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
et = 0
for _, v in bg.NotifyGui.NotifyLayout:GetChildren() do b:Create( v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * et)) }
):Play()
et = et + 1
end
end)
end
local hz = 0
for _, v in bg.NotifyGui.NotifyLayout:GetChildren() do hz = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
end
local bj = Instance.new("Frame")
local ax = Instance.new("Frame")
local bt = Instance.new("UICorner")
local fb = Instance.new("UIStroke")
local ck = Instance.new("ImageLabel")
local hg = Instance.new("UICorner")
local n = Instance.new("Frame")
local Top = Instance.new("Frame")
local bq = Instance.new("TextLabel")
local ca = Instance.new("TextLabel")
local g = Instance.new("TextButton")
local db = Instance.new("ImageLabel")
local d = Instance.new("TextLabel")
bj.BackgroundTransparency = 1
bj.BorderSizePixel = 0
bj.Size = UDim2.new(1, 0, 0, 70)
bj.Name = "NotifyFrame"
bj.AnchorPoint = Vector2.new(0, 1)
bj.Position = UDim2.new(0, 0, 1, -hz)
bj.Parent = bg.NotifyGui.NotifyLayout
ax.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
ax.BorderSizePixel = 0
ax.Position = UDim2.new(0, 400, 0, 0)
ax.Size = UDim2.new(1, 0, 1, 0)
ax.Name = "NotifyFrameReal"
ax.Parent = bj
bt.CornerRadius = UDim.new(0, 10)
bt.Parent = ax
fb.Color = Color3.fromRGB(40, 40, 45)
fb.Thickness = 1
fb.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fb.Parent = ax
local q = dr(NotifyConfig.Icon or "")
local ic = q~=""
if ic then ck.Image = q
ck.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
ck.BackgroundTransparency = 0
ck.BorderSizePixel = 0
ck.Position = UDim2.new(0, 0, 0, 0)
ck.Size = UDim2.new(0, 55, 1, 0)
ck.ScaleType = Enum.ScaleType.Fit
ck.Parent = ax
hg.CornerRadius = UDim.new(0, 10)
hg.Parent = ck
end
local gt = ic and 55 or 0
n.BackgroundTransparency = 1
n.BorderSizePixel = 0
n.Position = UDim2.new(0, gt, 0, 0)
n.Size = UDim2.new(1, -gt, 1, 0)
n.Name = "ContentFrame"
n.Parent = ax
Top.BackgroundTransparency = 1
Top.BorderSizePixel = 0
Top.Size = UDim2.new(1, 0, 0, 36)
Top.Name = "Top"
Top.Parent = n
bq.Font = Enum.Font.GothamBold
bq.Text = NotifyConfig.Title
bq.TextColor3 = Color3.fromRGB(240, 240, 245)
bq.TextSize = 14
bq.TextXAlignment = Enum.TextXAlignment.Left
bq.BackgroundTransparency = 1
bq.Size = UDim2.new(1, -50, 1, 0)
bq.Position = UDim2.new(0, 10, 0, 0)
bq.Parent = Top
ca.Font = Enum.Font.GothamMedium
ca.Text = NotifyConfig.Description
ca.TextColor3 = NotifyConfig.Color ca.TextSize = 13
ca.TextXAlignment = Enum.TextXAlignment.Left
ca.BackgroundTransparency = 1
ca.Size = UDim2.new(1, 0, 1, 0)
ca.Position = UDim2.new(0, bq.TextBounds.X + 15, 0, 0)
ca.Parent = Top
g.Text = ""
g.AnchorPoint = Vector2.new(1, 0.5)
g.BackgroundTransparency = 1
g.Position = UDim2.new(1, -8, 0.5, 0)
g.Size = UDim2.new(0, 24, 0, 24)
g.Name = "Close"
g.Parent = Top
db.Image = "rbxassetid://9886659671"
db.ImageColor3 = Color3.fromRGB(160, 160, 165)
db.AnchorPoint = Vector2.new(0.5, 0.5)
db.BackgroundTransparency = 1
db.Position = UDim2.new(0.5, 0, 0.5, 0)
db.Size = UDim2.new(0.7, 0, 0.7, 0)
db.Parent = g
d.Font = Enum.Font.Gotham
d.TextColor3 = Color3.fromRGB(160, 160, 165)
d.TextSize = 13
d.Text = NotifyConfig.Content
d.TextXAlignment = Enum.TextXAlignment.Left
d.TextYAlignment = Enum.TextYAlignment.Top
d.BackgroundTransparency = 1
d.Position = UDim2.new(0, 10, 0, 30)
d.Size = UDim2.new(1, -20, 0, 13)
d.TextWrapped = true
d.Parent = n
d.Size = UDim2.new(1, -20, 0, 13 + (13 * (d.TextBounds.X // d.AbsoluteSize.X)))
if d.AbsoluteSize.Y < 27 then bj.Size = UDim2.new(1, 0, 0, 70)
else bj.Size = UDim2.new(1, 0, 0, d.AbsoluteSize.Y + 43)
end
local gs = false
function es:Close()
if gs then return false end
gs = true
b:Create( ax, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new(0, 400, 0, 0) }
):Play()
task.wait(tonumber(NotifyConfig.Time) / 1.2)
bj:Destroy()
end
g.Activated:Connect(function()
es:Close()
end)
b:Create( ax, TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }
):Play()
task.wait(tonumber(NotifyConfig.Delay))
es:Close()
end)
return es
end
function Nt(msg, delay, color, title, desc)
return di:MakeNotify({ e = title or cy, Description = desc or "Notification", Content = msg or "Content", Color = color or Color3.fromRGB(0, 208, 255), Delay = delay or 4, })
end
Notify = Nt
local du = nil
function di:Dialog(DialogConfig)
DialogConfig = DialogConfig or {}
DialogConfig.Title = DialogConfig.Title or "Dialog"
DialogConfig.Content = DialogConfig.Content or ""
DialogConfig.Buttons = DialogConfig.Buttons or {}
if du and du.Parent then pcall(function() du:Destroy() end)
end
local co = Instance.new("ScreenGui")
co.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
co.Name = "DialogGui"
co.Parent = bg
local dh = Instance.new("Frame")
dh.Size = UDim2.new(1, 0, 1, 0)
dh.BackgroundTransparency = 1
dh.ZIndex = 50
dh.Name = "Overlay"
dh.Parent = co
local ak = Instance.new("ImageLabel")
ak.Size = UDim2.new(0, 300, 0, 150)
ak.Position = UDim2.new(0.5, -150, 0.5, -75)
ak.Image = "rbxassetid://9542022979"
ak.ImageTransparency = 0
ak.BorderSizePixel = 0
ak.ZIndex = 51
ak.Parent = dh
local bt = Instance.new("UICorner")
bt.CornerRadius = UDim.new(0, 8)
bt.Parent = ak
local bx = Instance.new("Frame")
bx.Size = UDim2.new(0, 310, 0, 160)
bx.Position = UDim2.new(0.5, -155, 0.5, -80)
bx.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bx.BackgroundTransparency = 0.75
bx.BorderSizePixel = 0
bx.ZIndex = 50
bx.Parent = dh
local hr = Instance.new("UICorner")
hr.CornerRadius = UDim.new(0, 10)
hr.Parent = bx
local gj = Instance.new("UIGradient")
gj.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 191, 255)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 140, 255)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 191, 255))
})
gj.Rotation = 90
gj.Parent = bx
local e = Instance.new("TextLabel")
e.Size = UDim2.new(1, 0, 0, 40)
e.Position = UDim2.new(0, 0, 0, 4)
e.BackgroundTransparency = 1
e.Font = Enum.Font.GothamBold
e.Text = DialogConfig.Title
e.TextSize = 22
e.TextColor3 = Color3.fromRGB(255, 255, 255)
e.ZIndex = 52
e.Parent = ak
local bu = Instance.new("TextLabel")
bu.Size = UDim2.new(1, -20, 0, 60)
bu.Position = UDim2.new(0, 10, 0, 30)
bu.BackgroundTransparency = 1
bu.Font = Enum.Font.Gotham
bu.Text = DialogConfig.Content
bu.TextSize = 14
bu.TextColor3 = Color3.fromRGB(200, 200, 200)
bu.TextWrapped = true
bu.ZIndex = 52
bu.Parent = ak
for i, buttonConfig in ipairs(DialogConfig.Buttons) do local c = Instance.new("TextButton")
c.Size = UDim2.new(0.45, -10, 0, 35)
if i==1 then c.Position = UDim2.new(0.05, 0, 1, -55)
else c.Position = UDim2.new(0.5, 10, 1, -55)
end
c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
c.BackgroundTransparency = 0.935
c.Text = buttonConfig.Name or "Button"
c.Font = Enum.Font.GothamBold
c.TextSize = 15
c.TextColor3 = Color3.fromRGB(255, 255, 255)
c.TextTransparency = 0.3
c.ZIndex = 52
c.Name = "DialogButton_"..i
c.Parent = ak
local ii = Instance.new("UICorner")
ii.CornerRadius = UDim.new(0, 6)
ii.Parent = c
c.MouseButton1Click:Connect(function()
if buttonConfig.Callback and type(buttonConfig.Callback)=="function" then pcall(function() buttonConfig.Callback() end)
end
pcall(function()
co:Destroy()
if du==co then du = nil end
end)
end)
end
du = co
return co
end
function di:Window(GuiConfig)
GuiConfig = GuiConfig or {}
GuiConfig.Title = GuiConfig.Title or "Chloe X"
GuiConfig.Footer = GuiConfig.Footer or "Chloee :3"
GuiConfig.Content = GuiConfig.Content or ""
GuiConfig.ShowUser = GuiConfig.ShowUser or false
GuiConfig.Color = gg(GuiConfig.Color or "Default")
GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
GuiConfig.Version = GuiConfig.Version or 1
GuiConfig.Uitransparent = GuiConfig.Uitransparent or 0.15
GuiConfig.Image = GuiConfig.Image or "70884221600423"
GuiConfig.Icon = GuiConfig.Icon or "rbxassetid://103875081318049"
GuiConfig.Configname = GuiConfig.Configname or "Velaris UI"
GuiConfig.Size = GuiConfig.Size or UDim2.fromOffset(640, 400)
GuiConfig.Search = GuiConfig.Search~=nil and GuiConfig.Search or false
GuiConfig.Config = GuiConfig.Config or {}
GuiConfig.Config.AutoSave = GuiConfig.Config.AutoSave~=nil and GuiConfig.Config.AutoSave or true
GuiConfig.Config.AutoLoad = GuiConfig.Config.AutoLoad~=nil and GuiConfig.Config.AutoLoad or true
cz = GuiConfig.Version
jp = GuiConfig.Config.AutoSave
hm = GuiConfig.Config.AutoLoad
cy = GuiConfig.Configname
if not isfolder(cy) then makefolder(cy) end
if not isfolder(cy.."/Config") then makefolder(cy.."/Config") end
local el = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
el = el:gsub("[^%w_ ]", "")
el = el:gsub("%s+", "_")
dv = cy.."/Config/CHX_"..el..".json"
if hm then iq() end
br:Initialize(GuiConfig, jv, cl, dm)
local ks = GuiConfig.KeySystem
if ks then local fr = false
local cv = Instance.new("ScreenGui")
cv.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
cv.Name = "KeySystemGui"
cv.ResetOnSpawn = false
cv.Parent = bg
local Card = Instance.new("Frame")
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.45, 0)
Card.Size = UDim2.new(0, 300, 0, 178)
Card.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
Card.BackgroundTransparency = 1
Card.BorderSizePixel = 0
Card.ZIndex = 101
Card.Parent = cv
local ha = Instance.new("UICorner")
ha.CornerRadius = UDim.new(0, 10)
ha.Parent = Card
local fh = Instance.new("UIStroke")
fh.Color = Color3.fromRGB(38, 38, 48)
fh.Thickness = 1
fh.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
fh.Parent = Card
local cc = Instance.new("Frame")
cc.Size = UDim2.new(0, 24, 0, 24)
cc.Position = UDim2.new(0, 14, 0, 16)
cc.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
cc.BorderSizePixel = 0
cc.ZIndex = 102
cc.Parent = Card
local hx = Instance.new("UICorner")
hx.CornerRadius = UDim.new(0, 6)
hx.Parent = cc
local fp = Instance.new("UIStroke")
fp.Color = Color3.fromRGB(50, 50, 62)
fp.Thickness = 1
fp.Parent = cc
local bv = Instance.new("ImageLabel")
bv.AnchorPoint = Vector2.new(0.5, 0.5)
bv.Position = UDim2.new(0.5, 0, 0.5, 0)
bv.Size = UDim2.new(0, 13, 0, 13)
bv.BackgroundTransparency = 1
bv.BorderSizePixel = 0
local hf = dr(ks.Icon or "")
bv.Image = (hf~="") and hf or "rbxassetid://6031094678"
bv.ImageColor3 = Color3.fromRGB(180, 180, 190)
bv.ScaleType = Enum.ScaleType.Fit
bv.ZIndex = 103
bv.Parent = cc
local at = Instance.new("TextLabel")
at.Font = Enum.Font.GothamBold
at.Text = ks.Title or GuiConfig.Title or "Key System"
at.TextColor3 = Color3.fromRGB(232, 232, 238)
at.TextSize = 14
at.TextXAlignment = Enum.TextXAlignment.Left
at.BackgroundTransparency = 1
at.BorderSizePixel = 0
at.AnchorPoint = Vector2.new(0, 0.5)
at.Position = UDim2.new(0, 44, 0, 28)
at.Size = UDim2.new(1, -58, 0, 18)
at.ZIndex = 102
at.Parent = Card
local dt = Instance.new("Frame")
dt.Size = UDim2.new(1, 0, 0, 1)
dt.Position = UDim2.new(0, 0, 0, 50)
dt.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
dt.BorderSizePixel = 0
dt.ZIndex = 102
dt.Parent = Card
local bi = Instance.new("TextLabel")
bi.Font = Enum.Font.Gotham
bi.Text = ks.Note or ""
bi.TextColor3 = Color3.fromRGB(95, 95, 108)
bi.TextSize = 12
bi.TextXAlignment = Enum.TextXAlignment.Left
bi.BackgroundTransparency = 1
bi.BorderSizePixel = 0
bi.Position = UDim2.new(0, 14, 0, 60)
bi.Size = UDim2.new(1, -28, 0, 14)
bi.ZIndex = 102
bi.Parent = Card
local bw = Instance.new("Frame")
bw.Position = UDim2.new(0, 14, 0, 84)
bw.Size = UDim2.new(1, -28, 0, 32)
bw.BackgroundColor3 = Color3.fromRGB(22, 22, 29)
bw.BorderSizePixel = 0
bw.ZIndex = 102
bw.Parent = Card
local gu = Instance.new("UICorner")
gu.CornerRadius = UDim.new(0, 7)
gu.Parent = bw
local da = Instance.new("UIStroke")
da.Color = Color3.fromRGB(44, 44, 56)
da.Thickness = 1
da.Parent = bw
local ce = Instance.new("ImageLabel")
ce.AnchorPoint = Vector2.new(0, 0.5)
ce.Position = UDim2.new(0, 9, 0.5, 0)
ce.Size = UDim2.new(0, 13, 0, 13)
ce.BackgroundTransparency = 1
ce.Image = "rbxassetid://6031094678"
ce.ImageColor3 = Color3.fromRGB(75, 75, 88)
ce.ScaleType = Enum.ScaleType.Fit
ce.ZIndex = 103
ce.Parent = bw
local w = Instance.new("TextBox")
w.Font = Enum.Font.Gotham
w.PlaceholderText = ks.Placeholder or "Enter Key"
w.PlaceholderColor3 = Color3.fromRGB(65, 65, 78)
w.Text = ks.Default or ""
w.TextColor3 = Color3.fromRGB(210, 210, 222)
w.TextSize = 12
w.TextXAlignment = Enum.TextXAlignment.Left
w.BackgroundTransparency = 1
w.BorderSizePixel = 0
w.ClearTextOnFocus = false
w.Position = UDim2.new(0, 28, 0, 0)
w.Size = UDim2.new(1, -34, 1, 0)
w.ZIndex = 103
w.Parent = bw
w.Focused:Connect(function()
b:Create(da, TweenInfo.new(0.18), { Color = GuiConfig.Color, Transparency = 0.45
}):Play()
end)
w.FocusLost:Connect(function()
b:Create(da, TweenInfo.new(0.18), { Color = Color3.fromRGB(44, 44, 56), Transparency = 0
}):Play()
end)
local dn = Instance.new("Frame")
dn.Size = UDim2.new(1, 0, 0, 1)
dn.Position = UDim2.new(0, 0, 0, 128)
dn.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
dn.BorderSizePixel = 0
dn.ZIndex = 102
dn.Parent = Card
local cq = Instance.new("Frame")
cq.BackgroundTransparency = 1
cq.BorderSizePixel = 0
cq.Position = UDim2.new(0, 14, 0, 136)
cq.Size = UDim2.new(1, -28, 0, 30)
cq.ZIndex = 102
cq.Parent = Card
local dx = Instance.new("UIListLayout")
dx.FillDirection = Enum.FillDirection.Horizontal
dx.HorizontalAlignment = Enum.HorizontalAlignment.Right
dx.VerticalAlignment = Enum.VerticalAlignment.Center
dx.Padding = UDim.new(0, 6)
dx.SortOrder = Enum.SortOrder.LayoutOrder
dx.Parent = cq
local function jt()
local ef = Card.Position
local il = {7, -7, 5, -5, 3, -3, 0}
for _, ox in ipairs(il) do Card.Position = UDim2.new( ef.X.Scale, ef.X.Offset + ox, ef.Y.Scale, ef.Y.Offset
)
task.wait(0.04)
end
Card.Position = ef
end
local ig = false
local function gm()
if ig then return end
ig = true
b:Create(Card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0.56, 0), BackgroundTransparency = 1, }):Play()
task.delay(0.25, function()
pcall(function() cv:Destroy() end)
end)
end
local fl = ks.Buttons or {}
if #fl==0 then fl = { { Name = "Exit" }, { Name = "Submit" }, }
end
for i, btnCfg in ipairs(fl) do local eu = (btnCfg.Style=="primary")
or (btnCfg.Name=="Submit")
or (i==#fl)
local Btn = Instance.new("TextButton")
Btn.Font = Enum.Font.GothamBold
Btn.Text = ""
Btn.AutomaticSize = Enum.AutomaticSize.X
Btn.Size = UDim2.new(0, 0, 1, 0)
Btn.BorderSizePixel = 0
Btn.LayoutOrder = i
Btn.ZIndex = 103
Btn.Parent = cq
if eu then Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
Btn.BackgroundTransparency = 0
else Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
Btn.BackgroundTransparency = 0
end
local gz = Instance.new("UICorner")
gz.CornerRadius = UDim.new(0, 7)
gz.Parent = Btn
local gl = Instance.new("UIStroke")
gl.Color = eu and Color3.fromRGB(65, 65, 80) or Color3.fromRGB(44, 44, 56)
gl.Thickness = 1
gl.Parent = Btn
local fo = Instance.new("UIPadding")
fo.PaddingLeft = UDim.new(0, 10)
fo.PaddingRight = UDim.new(0, 10)
fo.Parent = Btn
local by = Instance.new("Frame")
by.BackgroundTransparency = 1
by.BorderSizePixel = 0
by.AutomaticSize = Enum.AutomaticSize.X
by.Size = UDim2.new(0, 0, 1, 0)
by.ZIndex = 103
by.Parent = Btn
local fi = Instance.new("UIListLayout")
fi.FillDirection = Enum.FillDirection.Horizontal
fi.VerticalAlignment = Enum.VerticalAlignment.Center
fi.Padding = UDim.new(0, 5)
fi.Parent = by
local q = dr(btnCfg.Icon or "")
if q and q~="" then local ch = Instance.new("ImageLabel")
ch.BackgroundTransparency = 1
ch.BorderSizePixel = 0
ch.Size = UDim2.new(0, 12, 0, 12)
ch.Image = q
ch.ImageColor3 = Color3.fromRGB(180, 180, 195)
ch.ScaleType = Enum.ScaleType.Fit
ch.LayoutOrder = 0
ch.ZIndex = 104
ch.Parent = by
end
local bb = Instance.new("TextLabel")
bb.Font = Enum.Font.GothamBold
bb.Text = btnCfg.Name or "Button"
bb.TextColor3 = Color3.fromRGB(195, 195, 208)
bb.TextSize = 12
bb.BackgroundTransparency = 1
bb.BorderSizePixel = 0
bb.AutomaticSize = Enum.AutomaticSize.X
bb.Size = UDim2.new(0, 0, 1, 0)
bb.LayoutOrder = 1
bb.ZIndex = 104
bb.Parent = by
local jl = eu and Color3.fromRGB(50,50,62) or Color3.fromRGB(26,26,34)
local jq = eu and Color3.fromRGB(62,62,78) or Color3.fromRGB(34,34,44)
Btn.MouseEnter:Connect(function()
b:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = jq }):Play()
end)
Btn.MouseLeave:Connect(function()
b:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = jl }):Play()
end)
Btn.MouseButton1Click:Connect(function()
local jn = w.Text
if btnCfg.Callback then pcall(function()
local eb = btnCfg.Callback(jn)
if eb==true then fr = true
gm()
elseif eb==false then b:Create(da, TweenInfo.new(0.1), { Color = Color3.fromRGB(220, 55, 55), Transparency = 0
}):Play()
task.delay(0.7, function()
b:Create(da, TweenInfo.new(0.3), { Color = Color3.fromRGB(44,44,56), Transparency = 0
}):Play()
end)
task.spawn(jt)
else local iu = btnCfg.Close==true
or btnCfg.Name=="Exit"
or btnCfg.Name=="Close"
or btnCfg.Name=="Cancel"
if iu then gm()
end
end
end)
else gm()
end
end)
end
b:Create(Card, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0, }):Play()
repeat task.wait(0.1) until fr or not cv.Parent
if not fr then pcall(function() cv:Destroy() end)
return nil
end
end
local ar = {}
local bp = Instance.new("ScreenGui")
local m = Instance.new("Frame")
local ae = Instance.new("ImageLabel")
local Main = Instance.new("Frame")
local bt = Instance.new("UICorner")
local ek = Instance.new("UIStroke")
local Top = Instance.new("Frame")
local cm = Instance.new("ImageLabel")
local t = Instance.new("TextLabel")
local fy = Instance.new("UICorner")
local y = Instance.new("TextLabel")
local g = Instance.new("TextButton")
local cj = Instance.new("ImageLabel")
local Min = Instance.new("TextButton")
local bo = Instance.new("ImageLabel")
bp.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
bp.Name = "Chloeex"
bp.ResetOnSpawn = false
bp.Parent = game:GetService("CoreGui")
m.BackgroundTransparency = 1
m.BorderSizePixel = 0
m.AnchorPoint = Vector2.new(0.5, 0.5)
m.Position = UDim2.new(0.5, 0, 0.5, 0)
local hd = GuiConfig.Size.X.Offset
local hp = GuiConfig.Size.Y.Offset
if ft then m.Size = gy(math.min(hd, 470), math.min(hp, 270))
else m.Size = gy(hd, hp)
end
m.ZIndex = 0
m.Name = "DropShadowHolder"
m.Parent = bp
m.Position = UDim2.new( 0, (bp.AbsoluteSize.X // 2 - m.Size.X.Offset // 2), 0, (bp.AbsoluteSize.Y // 2 - m.Size.Y.Offset // 2)
)
ae.Image = "rbxassetid://6015897843"
ae.ImageColor3 = Color3.fromRGB(15, 15, 15)
ae.ImageTransparency = 1
ae.ScaleType = Enum.ScaleType.Slice
ae.SliceCenter = Rect.new(49, 49, 450, 450)
ae.AnchorPoint = Vector2.new(0.5, 0.5)
ae.BackgroundTransparency = 1
ae.BorderSizePixel = 0
ae.Position = UDim2.new(0.5, 0, 0.5, 0)
ae.Size = UDim2.new(1, 47, 1, 47)
ae.ZIndex = 0
ae.Name = "DropShadow"
ae.Parent = m
if GuiConfig.Theme then Main:Destroy()
Main = Instance.new("ImageLabel")
Main.Image = "rbxassetid://"..GuiConfig.Theme
Main.ScaleType = Enum.ScaleType.Crop
Main.BackgroundTransparency = 1
Main.ImageTransparency = GuiConfig.ThemeTransparency or GuiConfig.Uitransparent or 0.15
else Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = GuiConfig.Uitransparent
end
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(1, -47, 1, -47)
Main.Name = "Main"
Main.Parent = ae
ek.Thickness = 1.2
ek.Color = Color3.fromRGB(255, 255, 255)
ek.Transparency = 0.6
ek.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ek.Parent = Main
bt.Parent = Main
local df = Instance.new("Frame")
df.Name = "ColorTint"
df.Size = UDim2.new(1, 0, 1, 0)
df.BackgroundColor3 = GuiConfig.Color df.BackgroundTransparency = 0.93
df.BorderSizePixel = 0
df.ZIndex = 0
local cw = Instance.new("Frame")
cw.Name = "ImageWrapper"
cw.Parent = Main
cw.BackgroundTransparency = 1
cw.Size = UDim2.new(1, 0, 1, 0)
cw.Position = UDim2.new(0, 0, 0, 0)
cw.ZIndex = 0
cw.ClipsDescendants = true
df.Parent = Main
local bl = Instance.new("ImageLabel")
bl.Name = "ThemeImage"
bl.Parent = cw
bl.BackgroundTransparency = 1
bl.AnchorPoint = Vector2.new(1, 1)
bl.Position = UDim2.new(1, 0, 1, 0)
bl.Size = UDim2.new(0.55, 0, 1.0, 0)
bl.ZIndex = 0
bl.Image = ""
bl.ImageTransparency = 1
bl.ScaleType = Enum.ScaleType.Fit
local gk = Instance.new("UIGradient")
gk.Rotation = 135
gk.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0.8), NumberSequenceKeypoint.new(0.75, 0.2), NumberSequenceKeypoint.new(1, 0)
})
gk.Parent = bl
Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Top.BackgroundTransparency = 0.999
Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
Top.BorderSizePixel = 0
Top.Size = UDim2.new(1, 0, 0, 38)
Top.Name = "Top"
Top.Parent = Main
cm.Name = "TitleIcon"
cm.Parent = Top
cm.BackgroundTransparency = 1
cm.BorderSizePixel = 0
cm.AnchorPoint = Vector2.new(0, 0.5)
cm.Position = UDim2.new(0, 10, 0.5, 0)
cm.Size = UDim2.new(0, 20, 0, 20)
cm.Image = "rbxassetid://"..GuiConfig.Image
t.Font = Enum.Font.GothamBold
t.Text = GuiConfig.Title
t.TextColor3 = GuiConfig.Color t.TextSize = 14
t.TextXAlignment = Enum.TextXAlignment.Left
t.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
t.BackgroundTransparency = 0.999
t.BorderColor3 = Color3.fromRGB(0, 0, 0)
t.BorderSizePixel = 0
t.Size = UDim2.new(1, -135, 1, 0)
t.Position = UDim2.new(0, 35, 0, 0)
t.Parent = Top
fy.Parent = Top
y.Font = Enum.Font.GothamBold
y.Text = GuiConfig.Footer
y.TextColor3 = GuiConfig.Color y.TextSize = 14
y.TextXAlignment = Enum.TextXAlignment.Left
y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
y.BackgroundTransparency = 0.999
y.BorderColor3 = Color3.fromRGB(0, 0, 0)
y.BorderSizePixel = 0
y.Size = UDim2.new(1, -(t.TextBounds.X + 104), 1, 0)
y.Position = UDim2.new(0, 25 + t.TextBounds.X + 10, 0, 0)
y.Parent = Top
local ai = Instance.new("Frame")
ai.Name = "TagContainer"
ai.BackgroundTransparency = 1
ai.BorderSizePixel = 0
ai.ClipsDescendants = false
ai.AnchorPoint = Vector2.new(1, 0.5)
ai.Position = UDim2.new(1, -70, 0.5, 0)
ai.Size = UDim2.new(0, 200, 0, 26)
ai.ZIndex = 2
ai.Parent = Top
local ds = Instance.new("UIListLayout")
ds.FillDirection = Enum.FillDirection.Horizontal
ds.HorizontalAlignment = Enum.HorizontalAlignment.Right
ds.VerticalAlignment = Enum.VerticalAlignment.Center
ds.Padding = UDim.new(0, 5)
ds.SortOrder = Enum.SortOrder.LayoutOrder
ds.Parent = ai
local function dl()
local iz = t.TextBounds.X
local jb = y.TextBounds.X
local jo = 35 + iz + 10 + jb + 10
local hn = -70
local fm = Top.AbsoluteSize.X + hn - jo
if fm < 0 then fm = 0 end
ai.Size = UDim2.new(0, math.min(fm, 300), 0, 26)
ai.Position = UDim2.new(1, hn, 0.5, 0)
end
t:GetPropertyChangedSignal("TextBounds"):Connect(dl)
y:GetPropertyChangedSignal("TextBounds"):Connect(dl)
Top:GetPropertyChangedSignal("AbsoluteSize"):Connect(dl)
dl()
local function gx()
local hb = t.TextBounds.X
y.Position = UDim2.new(0, 25 + hb + 10, 0, 0)
y.Size = UDim2.new(1, -(hb + 104), 1, 0)
dl()
end
t:GetPropertyChangedSignal("TextBounds"):Connect(gx)
gx()
g.Font = Enum.Font.SourceSans
g.Text = ""
g.TextColor3 = Color3.fromRGB(0, 0, 0)
g.TextSize = 14
g.AnchorPoint = Vector2.new(1, 0.5)
g.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
g.BackgroundTransparency = 0.999
g.BorderColor3 = Color3.fromRGB(0, 0, 0)
g.BorderSizePixel = 0
g.Position = UDim2.new(1, -8, 0.5, 0)
g.Size = UDim2.new(0, 25, 0, 25)
g.Name = "Close"
g.Parent = Top
cj.Image = "rbxassetid://9886659671"
cj.AnchorPoint = Vector2.new(0.5, 0.5)
cj.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cj.BackgroundTransparency = 0.999
cj.BorderColor3 = Color3.fromRGB(0, 0, 0)
cj.BorderSizePixel = 0
cj.Position = UDim2.new(0.49, 0, 0.5, 0)
cj.Size = UDim2.new(1, -8, 1, -8)
cj.Parent = g
Min.Font = Enum.Font.SourceSans
Min.Text = ""
Min.TextColor3 = Color3.fromRGB(0, 0, 0)
Min.TextSize = 14
Min.AnchorPoint = Vector2.new(1, 0.5)
Min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Min.BackgroundTransparency = 0.999
Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
Min.BorderSizePixel = 0
Min.Position = UDim2.new(1, -38, 0.5, 0)
Min.Size = UDim2.new(0, 25, 0, 25)
Min.Name = "Min"
Min.Parent = Top
bo.Image = "rbxassetid://9886659276"
bo.AnchorPoint = Vector2.new(0.5, 0.5)
bo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bo.BackgroundTransparency = 0.999
bo.ImageTransparency = 0.2
bo.BorderColor3 = Color3.fromRGB(0, 0, 0)
bo.BorderSizePixel = 0
bo.Position = UDim2.new(0.5, 0, 0.5, 0)
bo.Size = UDim2.new(1, -9, 1, -9)
bo.Parent = Min
if GuiConfig.Content and GuiConfig.Content~="" then local n = Instance.new("Frame")
n.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
n.BackgroundTransparency = 1
n.BorderColor3 = Color3.fromRGB(0, 0, 0)
n.BorderSizePixel = 0
n.Size = UDim2.new(1, 0, 0, 25)
n.Position = UDim2.new(0, 0, 0, 38)
n.Name = "ContentFrame"
n.Parent = Main
local d = Instance.new("TextLabel")
d.Font = Enum.Font.GothamBold
d.Text = GuiConfig.Content
d.TextColor3 = GuiConfig.Color d.TextSize = 14
d.TextXAlignment = Enum.TextXAlignment.Center
d.TextYAlignment = Enum.TextYAlignment.Center
d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
d.BackgroundTransparency = 1
d.BorderColor3 = Color3.fromRGB(0, 0, 0)
d.BorderSizePixel = 0
d.Size = UDim2.new(1, -20, 1, 0)
d.Position = UDim2.new(0, 10, 0, 0)
d.Parent = n
local ab = Instance.new("Frame")
ab.BackgroundColor3 = GuiConfig.Color ab.BackgroundTransparency = 0.8
ab.BorderColor3 = Color3.fromRGB(0, 0, 0)
ab.BorderSizePixel = 0
ab.Size = UDim2.new(1, -20, 0, 1)
ab.Position = UDim2.new(0, 10, 1, -1)
ab.Parent = n
end
local al = Instance.new("Frame")
local hh = Instance.new("UICorner")
local cd = Instance.new("Frame")
local aw = Instance.new("Frame")
local ie = Instance.new("UICorner")
local x = Instance.new("TextLabel")
local bh = Instance.new("Frame")
local ec = Instance.new("Folder")
local bn = Instance.new("UIPageLayout")
local dw
if GuiConfig.Content and GuiConfig.Content~="" then dw = 38 + 25 + 10
else dw = 50
end
al.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
al.BackgroundTransparency = 0.999
al.BorderColor3 = Color3.fromRGB(0, 0, 0)
al.BorderSizePixel = 0
al.Position = UDim2.new(0, 9, 0, dw)
al.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -(dw + 9))
al.Name = "LayersTab"
al.Parent = Main
hh.CornerRadius = UDim.new(0, 2)
hh.Parent = al
local j = Instance.new("ScrollingFrame")
local gc = Instance.new("UIListLayout")
j.CanvasSize = UDim2.new(0, 0, 1.1, 0)
j.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
j.ScrollBarThickness = 0
j.Active = true
j.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
j.BackgroundTransparency = 0.999
j.BorderColor3 = Color3.fromRGB(0, 0, 0)
j.BorderSizePixel = 0
j.Name = "ScrollTab"
local en = 0
if GuiConfig.Search then en = 34
local ay = Instance.new("Frame")
ay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ay.BackgroundTransparency = 0.88
ay.BorderSizePixel = 0
ay.Size = UDim2.new(1, 0, 0, 28)
ay.Position = UDim2.new(0, 0, 0, 0)
ay.Name = "SearchContainer"
ay.Parent = al
local hu = Instance.new("UICorner")
hu.CornerRadius = UDim.new(0, 5)
hu.Parent = ay
local fk = Instance.new("UIStroke")
fk.Color = GuiConfig.Color fk.Thickness = 1
fk.Transparency = 1
fk.Parent = ay
local cf = Instance.new("ImageLabel")
cf.BackgroundTransparency = 1
cf.BorderSizePixel = 0
cf.Position = UDim2.new(0, 7, 0.5, -7)
cf.Size = UDim2.new(0, 14, 0, 14)
cf.Image = "rbxassetid://3926305904"
cf.ImageRectOffset = Vector2.new(964, 324)
cf.ImageRectSize = Vector2.new(36, 36)
cf.ImageColor3 = Color3.fromRGB(160, 160, 160)
cf.Parent = ay
local r = Instance.new("TextBox")
r.Font = Enum.Font.Gotham
r.PlaceholderText = "Search..."
r.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
r.Text = ""
r.TextColor3 = Color3.fromRGB(220, 220, 220)
r.TextSize = 12
r.TextXAlignment = Enum.TextXAlignment.Left
r.BackgroundTransparency = 1
r.BorderSizePixel = 0
r.ClearTextOnFocus = false
r.Position = UDim2.new(0, 26, 0, 0)
r.Size = UDim2.new(1, -30, 1, 0)
r.Name = "SearchBox"
r.Parent = ay
local aa = Instance.new("TextButton")
aa.Font = Enum.Font.GothamBold
aa.Text = "×"
aa.TextColor3 = Color3.fromRGB(160, 160, 160)
aa.TextSize = 16
aa.BackgroundTransparency = 1
aa.BorderSizePixel = 0
aa.AnchorPoint = Vector2.new(1, 0.5)
aa.Position = UDim2.new(1, -4, 0.5, 0)
aa.Size = UDim2.new(0, 20, 0, 20)
aa.ZIndex = 10
aa.Visible = false
aa.Name = "ClearBtn"
aa.Parent = ay
aa.MouseButton1Click:Connect(function()
r.Text = ""
end)
local p = Instance.new("Frame")
p.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
p.BackgroundTransparency = 0
p.BorderSizePixel = 0
p.ClipsDescendants = true
p.Position = UDim2.new(0, 0, 0, 30)
p.Size = UDim2.new(1, 0, 0, 0)
p.ZIndex = 20
p.Visible = false
p.Name = "MiniDropdown"
p.Parent = al
local hl = Instance.new("UICorner")
hl.CornerRadius = UDim.new(0, 6)
hl.Parent = p
local ew = Instance.new("UIStroke")
ew.Color = Color3.fromRGB(50, 50, 50)
ew.Thickness = 1
ew.Transparency = 0
ew.Parent = p
local ag = Instance.new("ScrollingFrame")
ag.ScrollBarThickness = 2
ag.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ag.BackgroundTransparency = 1
ag.BorderSizePixel = 0
ag.Position = UDim2.new(0, 0, 0, 0)
ag.Size = UDim2.new(1, 0, 1, 0)
ag.CanvasSize = UDim2.new(0, 0, 0, 0)
ag.ZIndex = 21
ag.Name = "ResultScroll"
ag.Parent = p
local ee = Instance.new("UIListLayout")
ee.Padding = UDim.new(0, 0)
ee.SortOrder = Enum.SortOrder.LayoutOrder
ee.Parent = ag
ee:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
ag.CanvasSize = UDim2.new(0, 0, 0, ee.AbsoluteContentSize.Y)
end)
local au = Instance.new("TextLabel")
au.Font = Enum.Font.Gotham
au.Text = "No results found"
au.TextColor3 = Color3.fromRGB(100, 100, 100)
au.TextSize = 11
au.BackgroundTransparency = 1
au.BorderSizePixel = 0
au.Size = UDim2.new(1, 0, 0, 36)
au.ZIndex = 22
au.Visible = false
au.Name = "NoResultLabel"
au.Parent = p
local fv = 36
local is = 5
local function ji(count)
local h = math.min(count, is) * fv
if count==0 then h = fv end
p.Size = UDim2.new(1, 0, 0, h)
end
local function iv(tabLayoutOrder, sectionRef, itemRef)
bn:JumpToIndex(tabLayoutOrder)
for _, tabFrame in _G.ScrollTab:GetChildren() do if tabFrame.Name=="Tab" then b:Create(tabFrame, TweenInfo.new(0.3), { BackgroundTransparency = tabFrame.LayoutOrder==tabLayoutOrder
and 0.92
or 0.999
}):Play()
end
end
for _, tabFrame in _G.ScrollTab:GetChildren() do if tabFrame.Name=="Tab" and tabFrame.LayoutOrder==tabLayoutOrder then local tn = tabFrame:FindFirstChild("TabName")
if tn then x.Text = tn.Text:gsub("^| ", "")
end
end
end
if sectionRef then local dp = sectionRef:FindFirstChild("SectionAdd")
local ep = sectionRef:FindFirstChild("SectionReal")
local gr = ep and ep:FindFirstChild("FeatureFrame")
local hy = sectionRef:FindFirstChild("SectionDecideFrame")
if dp then local h = 38
for _, v in dp:GetChildren() do if v:IsA("Frame") and v.Name~="UICorner" then h = h + v.Size.Y.Offset + 3
end
end
b:Create(sectionRef, TweenInfo.new(0.4), { Size = UDim2.new(1, 1, 0, h) }):Play()
b:Create(dp, TweenInfo.new(0.4), { Size = UDim2.new(1, 0, 0, h - 38) }):Play()
if gr then b:Create(gr, TweenInfo.new(0.4), { Rotation = 90 }):Play()
end
if hy then b:Create(hy, TweenInfo.new(0.4), { Size = UDim2.new(1, 0, 0, 2) }):Play()
end
end
task.wait(0.45)
if itemRef then local er
for _, sc in ec:GetChildren() do if sc:IsA("ScrollingFrame") and sc.LayoutOrder==tabLayoutOrder then er = sc
break
end
end
if er then local ei = 0
for _, sec in er:GetChildren() do if sec.Name=="Section" then if sec==sectionRef then local hi = sec:FindFirstChild("SectionAdd")
if hi then local gd = 0
for _, it in hi:GetChildren() do if it.Name~="UIListLayout" and it.Name~="UICorner" then if it==itemRef then break end
gd = gd + it.Size.Y.Offset + 3
end
end
ei = ei + 38 + gd
end
break
else ei = ei + sec.Size.Y.Offset + 3
end
end
end
b:Create(er, TweenInfo.new(0.4, Enum.EasingStyle.Quad), { CanvasPosition = Vector2.new(0, math.max(0, ei - 10))
}):Play()
local ip = itemRef.BackgroundTransparency
b:Create(itemRef, TweenInfo.new(0.3), { BackgroundTransparency = 0.5 }):Play()
task.wait(0.5)
b:Create(itemRef, TweenInfo.new(0.5), { BackgroundTransparency = ip }):Play()
end
end
end
end
local function jg(ff, fe, sectionRef, ex, itemName, itemRef, ej)
local Row = Instance.new("Frame")
Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Row.BackgroundTransparency = 1
Row.BorderSizePixel = 0
Row.Size = UDim2.new(1, 0, 0, fv)
Row.LayoutOrder = ej
Row.Name = "ResultRow"
Row.ZIndex = 21
Row.Parent = ag
local ab = Instance.new("Frame")
ab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ab.BackgroundTransparency = 0
ab.BorderSizePixel = 0
ab.AnchorPoint = Vector2.new(0, 1)
ab.Position = UDim2.new(0, 0, 1, 0)
ab.Size = UDim2.new(1, 0, 0, 1)
ab.ZIndex = 22
ab.Parent = Row
local cr = Instance.new("ImageLabel")
cr.BackgroundTransparency = 1
cr.BorderSizePixel = 0
cr.Position = UDim2.new(0, 10, 0.5, -8)
cr.Size = UDim2.new(0, 16, 0, 16)
cr.ImageColor3 = Color3.fromRGB(130, 130, 130)
cr.Image = "rbxassetid://86512767702085"
cr.ZIndex = 22
cr.Parent = Row
local ah = Instance.new("TextLabel")
ah.Font = Enum.Font.GothamBold
ah.Text = itemName
ah.TextColor3 = Color3.fromRGB(230, 230, 230)
ah.TextSize = 12
ah.TextXAlignment = Enum.TextXAlignment.Left
ah.TextTruncate = Enum.TextTruncate.AtEnd
ah.BackgroundTransparency = 1
ah.BorderSizePixel = 0
ah.Position = UDim2.new(0, 32, 0, 5)
ah.Size = UDim2.new(1, -36, 0, 14)
ah.ZIndex = 22
ah.Parent = Row
local as = Instance.new("TextLabel")
as.Font = Enum.Font.Gotham
as.Text = ff.." › "..ex
as.TextColor3 = Color3.fromRGB(90, 90, 90)
as.TextSize = 10
as.TextXAlignment = Enum.TextXAlignment.Left
as.TextTruncate = Enum.TextTruncate.AtEnd
as.BackgroundTransparency = 1
as.BorderSizePixel = 0
as.Position = UDim2.new(0, 32, 0, 20)
as.Size = UDim2.new(1, -36, 0, 12)
as.ZIndex = 22
as.Parent = Row
local ct = Instance.new("TextButton")
ct.BackgroundTransparency = 1
ct.Text = ""
ct.Size = UDim2.new(1, 0, 1, 0)
ct.ZIndex = 23
ct.Parent = Row
ct.MouseEnter:Connect(function()
b:Create(Row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0 }):Play()
b:Create(ah, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end)
ct.MouseLeave:Connect(function()
b:Create(Row, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
b:Create(ah, TweenInfo.new(0.12), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
end)
ct.MouseButton1Click:Connect(function()
r.Text = ""
p.Visible = false
aa.Visible = false
task.spawn(function()
task.wait(0.05)
iv(fe, sectionRef, itemRef)
end)
end)
return Row
end
local function ix(query)
query = query:lower():gsub("^%s+", ""):gsub("%s+$", "")
local hv = query~=""
aa.Visible = hv
if not hv then p.Visible = false
return
end
for _, child in ag:GetChildren() do if child:IsA("Frame") then child:Destroy() end
end
local ev = 0
local ej = 0
for _, scrolLayers in ec:GetChildren() do if scrolLayers:IsA("ScrollingFrame") then local fe = scrolLayers.LayoutOrder
local ff = "Tab"
for _, tabFrame in _G.ScrollTab:GetChildren() do if tabFrame.Name=="Tab" and tabFrame.LayoutOrder==fe then local tn = tabFrame:FindFirstChild("TabName")
if tn then ff = tn.Text:gsub("^| ", "") end
break
end
end
for _, section in scrolLayers:GetChildren() do if section.Name=="Section" then local dp = section:FindFirstChild("SectionAdd")
local ep = section:FindFirstChild("SectionReal")
local ex = "Section"
if ep then local st = ep:FindFirstChild("SectionTitle")
if st then ex = st.Text end
end
if dp then for _, item in dp:GetChildren() do if item:IsA("Frame") and item.Name~="UICorner" then local fw = ""
local dj = ""
local hc = 0
for _, child in item:GetChildren() do if child:IsA("TextLabel") and child.Text~="" then local txt = child.Text
if #txt > 1 and not txt:match("^%[") and child.TextSize>=hc then hc = child.TextSize
fw = txt:lower()
dj = txt
end
end
end
if fw:find(query, 1, true)~=nil and fw~="" then jg(ff, fe, section, ex, dj~="" and dj or "Item", item, ej)
ej = ej + 1
ev = ev + 1
end
end
end
end
end
end
end
end
au.Visible = (ev==0)
p.Visible = true
ji(ev)
end
r:GetPropertyChangedSignal("Text"):Connect(function()
ix(r.Text)
end)
end
if GuiConfig.ShowUser then j.Position = UDim2.new(0, 0, 0, en)
j.Size = UDim2.new(1, 0, 1, -(40 + en))
else j.Position = UDim2.new(0, 0, 0, en)
j.Size = UDim2.new(1, 0, 1, -en)
end
j.Parent = al
gc.Padding = UDim.new(0, 2)
gc.SortOrder = Enum.SortOrder.LayoutOrder
gc.Parent = j
local function hw()
local de = 0
for _, child in j:GetChildren() do if child.Name~="UIListLayout" then de = de + 3 + child.Size.Y.Offset
end
end
j.CanvasSize = UDim2.new(0, 0, 0, de)
end
j.ChildAdded:Connect(hw)
j.ChildRemoved:Connect(hw)
if GuiConfig.ShowUser then local bs = Instance.new("Frame")
bs.Name = "PlayerFooter"
bs.AnchorPoint = Vector2.new(0, 1)
bs.BackgroundTransparency = 1
bs.BorderSizePixel = 0
bs.Position = UDim2.new(0, 3, 1, -3)
bs.Size = UDim2.new(1, -18, 0, 40)
bs.Parent = al
bs.ZIndex = 100
local ba = Instance.new("ImageLabel")
ba.Name = "PlayerAvatar"
ba.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ba.BackgroundTransparency = 0.2
ba.BorderSizePixel = 0
ba.AnchorPoint = Vector2.new(0, 0.5)
ba.Position = UDim2.new(0, 0, 0.5, 2)
ba.Size = UDim2.new(0, 26, 0, 26)
ba.Image = "rbxthumb://type=AvatarHeadShot&id="..ey.UserId.."&w=150&h=150"
ba.Parent = bs
local ih = Instance.new("UICorner")
ih.CornerRadius = UDim.new(1, 0)
ih.Parent = ba
local fc = Instance.new("UIStroke")
fc.Color = GuiConfig.Color fc.Thickness = 1.2
fc.Transparency = 0.5
fc.Parent = ba
local bk = Instance.new("TextLabel")
bk.Name = "PlayerName"
bk.Font = Enum.Font.GothamBold
local dj = ey.DisplayName
local he = dj
if #dj > 3 then he = string.sub(dj, 1, 3).."***"
end
bk.Text = "Welcome, "..he
bk.TextColor3 = Color3.fromRGB(180, 180, 180)
bk.TextSize = 11
bk.TextXAlignment = Enum.TextXAlignment.Left
bk.BackgroundTransparency = 1
bk.Position = UDim2.new(0, 32, 0, 0)
bk.Size = UDim2.new(1, -32, 1, 0)
bk.TextTruncate = Enum.TextTruncate.None
bk.Parent = bs
end
_G.ScrollTab = j
cd.AnchorPoint = Vector2.new(0.5, 0)
cd.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cd.BackgroundTransparency = 0.85
cd.BorderColor3 = Color3.fromRGB(0, 0, 0)
cd.BorderSizePixel = 0
cd.Position = UDim2.new(0.5, 0, 0, 38)
cd.Size = UDim2.new(1, 0, 0, 1)
cd.Name = "DecideFrame"
cd.Parent = Main
aw.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
aw.BackgroundTransparency = 0.999
aw.BorderColor3 = Color3.fromRGB(0, 0, 0)
aw.BorderSizePixel = 0
aw.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, dw)
aw.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -(dw + 9))
aw.Name = "Layers"
aw.Parent = Main
ie.CornerRadius = UDim.new(0, 2)
ie.Parent = aw
x.Font = Enum.Font.GothamBold
x.Text = ""
x.TextColor3 = Color3.fromRGB(255, 255, 255)
x.TextSize = 24
x.TextWrapped = true
x.TextXAlignment = Enum.TextXAlignment.Left
x.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
x.BackgroundTransparency = 0.999
x.BorderColor3 = Color3.fromRGB(0, 0, 0)
x.BorderSizePixel = 0
x.Size = UDim2.new(1, 0, 0, 30)
x.Name = "NameTab"
x.Parent = aw
bh.AnchorPoint = Vector2.new(0, 1)
bh.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bh.BackgroundTransparency = 0.999
bh.BorderColor3 = Color3.fromRGB(0, 0, 0)
bh.BorderSizePixel = 0
bh.ClipsDescendants = true
bh.Position = UDim2.new(0, 0, 1, 0)
bh.Size = UDim2.new(1, 0, 1, -33)
bh.Name = "LayersReal"
bh.Parent = aw
ec.Name = "LayersFolder"
ec.Parent = bh
bn.SortOrder = Enum.SortOrder.LayoutOrder
bn.Name = "LayersPageLayout"
bn.Parent = ec
bn.TweenTime = 0.5
bn.EasingDirection = Enum.EasingDirection.InOut
bn.EasingStyle = Enum.EasingStyle.Quad
function ar:DestroyGui()
if bg:FindFirstChild("Chloeex") then bp:Destroy()
end
end
function ar:SetToggleKey(keyCode)
GuiConfig.Keybind = keyCode
end
function ar:Tag(TagConfig)
TagConfig = TagConfig or {}
TagConfig.Title = TagConfig.Title or "Tag"
TagConfig.Icon = TagConfig.Icon or ""
local dq
if typeof(TagConfig.Color)=="Color3" then dq = TagConfig.Color
elseif type(TagConfig.Color)=="string" then if TagConfig.Color:sub(1,1)=="#" then dq = Color3.fromHex(TagConfig.Color)
else dq = gg(TagConfig.Color)
end
else dq = GuiConfig.Color
end
local am = Instance.new("Frame")
am.BackgroundColor3 = dq
am.BackgroundTransparency = 0
am.BorderSizePixel = 0
am.AutomaticSize = Enum.AutomaticSize.X
am.Size = UDim2.new(0, 0, 0, 22)
am.Name = "Tag"
am.ClipsDescendants = false
am.Parent = ai
local ia = Instance.new("UICorner")
ia.CornerRadius = UDim.new(1, 0)
ia.Parent = am
local em = Instance.new("UIStroke")
em.Color = dq
em.Thickness = 1.5
em.Transparency = 0.4
em.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
em.Parent = am
local go = Instance.new("UIPadding")
go.PaddingLeft = UDim.new(0, 8)
go.PaddingRight = UDim.new(0, 8)
go.Parent = am
local cp = Instance.new("Frame")
cp.BackgroundTransparency = 1
cp.BorderSizePixel = 0
cp.AutomaticSize = Enum.AutomaticSize.X
cp.Size = UDim2.new(0, 0, 1, 0)
cp.Parent = am
local ez = Instance.new("UIListLayout")
ez.FillDirection = Enum.FillDirection.Horizontal
ez.VerticalAlignment = Enum.VerticalAlignment.Center
ez.Padding = UDim.new(0, 4)
ez.Parent = cp
local q = dr(TagConfig.Icon)
if q and q~="" then local cx = Instance.new("ImageLabel")
cx.BackgroundTransparency = 1
cx.BorderSizePixel = 0
cx.Size = UDim2.new(0, 12, 0, 12)
cx.Image = q
cx.ImageColor3 = Color3.fromRGB(15, 15, 15)
cx.ScaleType = Enum.ScaleType.Fit
cx.LayoutOrder = 0
cx.Parent = cp
end
local bm = Instance.new("TextLabel")
bm.Font = Enum.Font.GothamBold
bm.Text = TagConfig.Title
bm.TextColor3 = Color3.fromRGB(15, 15, 15)
bm.TextSize = 11
bm.BackgroundTransparency = 1
bm.BorderSizePixel = 0
bm.AutomaticSize = Enum.AutomaticSize.X
bm.Size = UDim2.new(0, 0, 1, 0)
bm.LayoutOrder = 1
bm.Parent = cp
task.defer(dl)
return am
end
Min.Activated:Connect(function()
fa(Min, cn.X, cn.Y)
m.Visible = false
end)
g.Activated:Connect(function()
fa(g, cn.X, cn.Y)
di:Dialog({ e = GuiConfig.Configname.." Window", Content = "Do you want to close this window?\nYou will not be able to open it again", Buttons = { { Name = "Yes", Callback = function()
if bp then bp:Destroy() end
if ar._toggleGui then pcall(function() ar._toggleGui:Destroy() end)
ar._toggleGui = nil
end
end
}, { Name = "Cancel", Callback = function() end
}
}
})
end)
function ar:ToggleUI()
if ar._toggleGui then pcall(function() ar._toggleGui:Destroy() end)
ar._toggleGui = nil
end
local eg = Instance.new("ScreenGui")
eg.Parent = game:GetService("CoreGui")
eg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
eg.Name = "ToggleUIButton"
ar._toggleGui = eg
local bf = Instance.new("ImageLabel")
bf.Parent = eg
bf.Size = UDim2.new(0, 40, 0, 40)
bf.Position = UDim2.new(0, 20, 0, 100)
bf.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
bf.BackgroundTransparency = 0.1
bf.Image = "rbxassetid://"..GuiConfig.Image
bf.ScaleType = Enum.ScaleType.Fit
local gv = Instance.new("UICorner")
gv.CornerRadius = UDim.new(0, 8)
gv.Parent = bf
local c = Instance.new("TextButton")
c.Parent = bf
c.Size = UDim2.new(1, 0, 1, 0)
c.BackgroundTransparency = 1
c.Text = ""
c.MouseButton1Click:Connect(function()
if m then m.Visible = not m.Visible
end
end)
local gq = false
local gw, startPos
local function ik(input)
local ib = input.Position - gw
bf.Position = UDim2.new( startPos.X.Scale, startPos.X.Offset + ib.X, startPos.Y.Scale, startPos.Y.Offset + ib.Y
)
end
c.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then gq = true
gw = input.Position
startPos = bf.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then gq = false
end
end)
end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
if gq and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then ik(input)
end
end)
end
ar:ToggleUI()
GuiConfig.Keybind = GuiConfig.Keybind or Enum.KeyCode.RightShift
ea.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
if input.KeyCode==GuiConfig.Keybind then m.Visible = not m.Visible
end
end)
jw(Top, m, GuiConfig)
local o = Instance.new("Frame")
local dg = Instance.new("Frame")
local aq = Instance.new("ImageLabel")
local ju = Instance.new("UICorner")
local az = Instance.new("TextButton")
o.AnchorPoint = Vector2.new(1, 1)
o.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
o.BackgroundTransparency = 0.999
o.BorderColor3 = Color3.fromRGB(0, 0, 0)
o.BorderSizePixel = 0
o.ClipsDescendants = true
o.Position = UDim2.new(1, 8, 1, 8)
o.Size = UDim2.new(1, 154, 1, 54)
o.Visible = false
o.Name = "MoreBlur"
o.Parent = aw
dg.BackgroundTransparency = 1
dg.BorderSizePixel = 0
dg.Size = UDim2.new(1, 0, 1, 0)
dg.ZIndex = 0
dg.Name = "DropShadowHolder"
dg.Parent = o
aq.Image = "rbxassetid://6015897843"
aq.ImageColor3 = Color3.fromRGB(0, 0, 0)
aq.ImageTransparency = 1
aq.ScaleType = Enum.ScaleType.Slice
aq.SliceCenter = Rect.new(49, 49, 450, 450)
aq.AnchorPoint = Vector2.new(0.5, 0.5)
aq.BackgroundTransparency = 1
aq.BorderSizePixel = 0
aq.Position = UDim2.new(0.5, 0, 0.5, 0)
aq.Size = UDim2.new(1, 35, 1, 35)
aq.ZIndex = 0
aq.Name = "DropShadow"
aq.Parent = dg
ju.Parent = o
az.Font = Enum.Font.SourceSans
az.Text = ""
az.TextColor3 = Color3.fromRGB(0, 0, 0)
az.TextSize = 14
az.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
az.BackgroundTransparency = 0.999
az.BorderColor3 = Color3.fromRGB(0, 0, 0)
az.BorderSizePixel = 0
az.Size = UDim2.new(1, 0, 1, 0)
az.Name = "ConnectButton"
az.Parent = o
local ad = Instance.new("Frame")
local ht = Instance.new("UICorner")
local fj = Instance.new("UIStroke")
local bd = Instance.new("Frame")
local fg = Instance.new("Folder")
local cb = Instance.new("UIPageLayout")
ad.AnchorPoint = Vector2.new(1, 0.5)
ad.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ad.BorderColor3 = Color3.fromRGB(0, 0, 0)
ad.BorderSizePixel = 0
ad.LayoutOrder = 1
ad.Position = UDim2.new(1, 172, 0.5, 0)
ad.Size = UDim2.new(0, 160, 1, -16)
ad.Name = "DropdownSelect"
ad.ClipsDescendants = true
ad.Parent = o
az.Activated:Connect(function()
if o.Visible then b:Create(ad, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(1, 172, 0.5, 0)
}):Play()
b:Create(o, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 0.999
}):Play()
task.wait(0.3)
o.Visible = false
end
end)
ht.CornerRadius = UDim.new(0, 6)
ht.Parent = ad
fj.Color = GuiConfig.Color fj.Thickness = 1.5
fj.Transparency = 0.7
fj.Parent = ad
bd.AnchorPoint = Vector2.new(0.5, 0.5)
bd.BackgroundColor3 = Color3.fromRGB(0, 27, 98)
bd.BackgroundTransparency = 0.7
bd.BorderColor3 = Color3.fromRGB(0, 0, 0)
bd.BorderSizePixel = 0
bd.LayoutOrder = 1
bd.Position = UDim2.new(0.5, 0, 0.5, 0)
bd.Size = UDim2.new(1, 1, 1, 1)
bd.Name = "DropdownSelectReal"
bd.Parent = ad
fg.Name = "DropdownFolder"
fg.Parent = bd
cb.EasingDirection = Enum.EasingDirection.InOut
cb.EasingStyle = Enum.EasingStyle.Quad
cb.TweenTime = 0.01
cb.SortOrder = Enum.SortOrder.LayoutOrder
cb.FillDirection = Enum.FillDirection.Vertical
cb.Archivable = false
cb.Name = "DropPageLayout"
cb.Parent = fg
local Tabs = ar
local dy = 0
local gp = 0
function Tabs:AddTab(an)
local an = an or {}
an.Name = an.Name or "Tab"
an.Icon = an.Icon or ""
local u = Instance.new("ScrollingFrame")
local fn = Instance.new("UIListLayout")
u.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
u.ScrollBarThickness = 0
u.Active = true
u.LayoutOrder = dy
u.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
u.BackgroundTransparency = 0.999
u.BorderColor3 = Color3.fromRGB(0, 0, 0)
u.BorderSizePixel = 0
u.Size = UDim2.new(1, 0, 1, 0)
u.Name = "ScrolLayers"
u.Parent = ec
fn.Padding = UDim.new(0, 3)
fn.SortOrder = Enum.SortOrder.LayoutOrder
fn.Parent = u
local Tab = Instance.new("Frame")
local ij = Instance.new("UICorner")
local af = Instance.new("TextButton")
local ao = Instance.new("TextLabel")
local l = Instance.new("ImageLabel")
local ge = Instance.new("UIStroke")
local ja = Instance.new("UICorner")
Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
if dy==0 then Tab.BackgroundTransparency = 0.92
else Tab.BackgroundTransparency = 0.999
end
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.BorderSizePixel = 0
Tab.LayoutOrder = dy
Tab.Size = UDim2.new(1, 0, 0, 30)
Tab.Name = "Tab"
Tab.Parent = _G.ScrollTab
ij.CornerRadius = UDim.new(0, 4)
ij.Parent = Tab
af.Font = Enum.Font.GothamBold
af.Text = ""
af.TextColor3 = Color3.fromRGB(255, 255, 255)
af.TextSize = 13
af.TextXAlignment = Enum.TextXAlignment.Left
af.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
af.BackgroundTransparency = 0.999
af.BorderColor3 = Color3.fromRGB(0, 0, 0)
af.BorderSizePixel = 0
af.Size = UDim2.new(1, 0, 1, 0)
af.Name = "TabButton"
af.Parent = Tab
ao.Font = Enum.Font.GothamBold
ao.Text = "| "..tostring(an.Name)
ao.TextColor3 = Color3.fromRGB(255, 255, 255)
ao.TextSize = 13
ao.TextXAlignment = Enum.TextXAlignment.Left
ao.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ao.BackgroundTransparency = 0.999
ao.BorderColor3 = Color3.fromRGB(0, 0, 0)
ao.BorderSizePixel = 0
ao.Size = UDim2.new(1, 0, 1, 0)
ao.Position = UDim2.new(0, 30, 0, 0)
ao.Name = "TabName"
ao.Parent = Tab
l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
l.BackgroundTransparency = 0.999
l.BorderColor3 = Color3.fromRGB(0, 0, 0)
l.BorderSizePixel = 0
l.Position = UDim2.new(0, 9, 0, 7)
l.Size = UDim2.new(0, 16, 0, 16)
l.Name = "FeatureImg"
l.Parent = Tab
if an.Icon and an.Icon~="" then local q = dr(an.Icon)
if q and q~="" then l.Image = q
end
end
if dy==0 then bn:JumpToIndex(0)
x.Text = an.Name
local cg = Instance.new("Frame")
cg.BackgroundColor3 = GuiConfig.Color cg.BorderColor3 = Color3.fromRGB(0, 0, 0)
cg.BorderSizePixel = 0
cg.Position = UDim2.new(0, 2, 0, 9)
cg.Size = UDim2.new(0, 1, 0, 12)
cg.Name = "ChooseFrame"
cg.Parent = Tab
ge.Color = GuiConfig.Color ge.Thickness = 1.6
ge.Parent = cg
ja.Parent = cg
end
af.Activated:Connect(function()
fa(af, cn.X, cn.Y)
local eo
for a, s in _G.ScrollTab:GetChildren() do for i, v in s:GetChildren() do if v.Name=="ChooseFrame" then eo = v
break
end
end
end
if eo~=nil and Tab.LayoutOrder~=bn.CurrentPage.LayoutOrder then for _, TabFrame in _G.ScrollTab:GetChildren() do if TabFrame.Name=="Tab" then
b:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.999 }):Play()
end
end
b:Create(Tab, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { BackgroundTransparency = 0.92 }):Play()
b:Create(eo, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder)) }):Play()
bn:JumpToIndex(Tab.LayoutOrder)
task.wait(0.05)
x.Text = an.Name
b:Create(eo, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 1, 0, 20) }):Play()
task.wait(0.2)
b:Create(eo, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Size = UDim2.new(0, 1, 0, 12) }):Play()
end
end)
local gb = {}
local fq = 0
function gb:AddSection(SectionConfig)
local e = "Section"
local Icon = ""
local Open = false
if type(SectionConfig)=="string" then e = SectionConfig
elseif type(SectionConfig)=="table" then e = SectionConfig.Title or "Section"
Icon = SectionConfig.Icon or ""
Open = SectionConfig.Open or false
end
local ap = Instance.new("Frame")
local be = Instance.new("Frame")
local fy = Instance.new("UICorner")
local ho = Instance.new("UIGradient")
ap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ap.BackgroundTransparency = 0.999
ap.BorderSizePixel = 0
ap.LayoutOrder = fq
ap.ClipsDescendants = true
ap.Size = UDim2.new(1, 0, 0, 30)
ap.Name = "Section"
ap.Parent = u
local aj = Instance.new("Frame")
local bt = Instance.new("UICorner")
local ci = Instance.new("TextButton")
local cu = Instance.new("Frame")
local l = Instance.new("ImageLabel")
local z = Instance.new("TextLabel")
local dk = Instance.new("ImageLabel")
aj.AnchorPoint = Vector2.new(0.5, 0)
aj.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
aj.BackgroundTransparency = 0.935
aj.BorderSizePixel = 0
aj.Position = UDim2.new(0.5, 0, 0, 0)
aj.Size = UDim2.new(1, -2, 0, 30)
aj.Name = "SectionReal"
aj.Parent = ap
bt.CornerRadius = UDim.new(0, 4)
bt.Parent = aj
if Icon and Icon~="" then dk.BackgroundTransparency = 0.999
dk.BorderSizePixel = 0
dk.Position = UDim2.new(0, 10, 0.5, -8)
dk.Size = UDim2.new(0, 16, 0, 16)
dk.Name = "SectionIcon"
dk.Parent = aj
local q = dr(Icon)
if q and q~="" then dk.Image = q
end
end
ci.Font = Enum.Font.SourceSans
ci.Text = ""
ci.BackgroundTransparency = 0.999
ci.BorderSizePixel = 0
ci.Size = UDim2.new(1, 0, 1, 0)
ci.Name = "SectionButton"
ci.Parent = aj
cu.AnchorPoint = Vector2.new(1, 0.5)
cu.BackgroundTransparency = 0.999
cu.BorderSizePixel = 0
cu.Position = UDim2.new(1, -5, 0.5, 0)
cu.Size = UDim2.new(0, 20, 0, 20)
cu.Name = "FeatureFrame"
cu.Parent = aj
l.Image = "rbxassetid://16851841101"
l.AnchorPoint = Vector2.new(0.5, 0.5)
l.BackgroundTransparency = 0.999
l.BorderSizePixel = 0
l.Position = UDim2.new(0.5, 0, 0.5, 0)
l.Rotation = -90
l.Size = UDim2.new(1, 6, 1, 6)
l.Name = "FeatureImg"
l.Parent = cu
local jj = { Left = Enum.TextXAlignment.Left, Center = Enum.TextXAlignment.Center, Right = Enum.TextXAlignment.Right, }
z.Font = Enum.Font.GothamBold
z.Text = e
z.TextColor3 = Color3.fromRGB(230, 230, 230)
z.TextSize = 13
z.TextXAlignment = (type(SectionConfig)=="table" and jj[SectionConfig.TextXAlignment]) or Enum.TextXAlignment.Left
z.TextYAlignment = Enum.TextYAlignment.Top
z.AnchorPoint = Vector2.new(0, 0.5)
z.BackgroundTransparency = 0.999
z.BorderSizePixel = 0
if Icon and Icon~="" then z.Position = UDim2.new(0, 32, 0.5, 0)
else z.Position = UDim2.new(0, 10, 0.5, 0)
end
z.Size = UDim2.new(1, -50, 0, 13)
z.Name = "SectionTitle"
z.Parent = aj
be.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
be.AnchorPoint = Vector2.new(0.5, 0)
be.BorderSizePixel = 0
be.Position = UDim2.new(0.5, 0, 0, 33)
be.Size = UDim2.new(0, 0, 0, 2)
be.Name = "SectionDecideFrame"
be.Parent = ap
fy.Parent = be
ho.Color = ColorSequence.new { ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(0.5, GuiConfig.Color), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
ho.Parent = be
local k = Instance.new("Frame")
local hj = Instance.new("UICorner")
local gi = Instance.new("UIListLayout")
k.AnchorPoint = Vector2.new(0.5, 0)
k.BackgroundTransparency = 0.999
k.BorderSizePixel = 0
k.ClipsDescendants = true
k.LayoutOrder = 1
k.Position = UDim2.new(0.5, 0, 0, 38)
k.Size = UDim2.new(1, 0, 0, 100)
k.Name = "SectionAdd"
k.Parent = ap
hj.CornerRadius = UDim.new(0, 2)
hj.Parent = k
gi.Padding = UDim.new(0, 3)
gi.SortOrder = Enum.SortOrder.LayoutOrder
gi.Parent = k
local ed = Open
local function hk()
local de = 0
for _, child in u:GetChildren() do if child.Name~="UIListLayout" then de = de + 3 + child.Size.Y.Offset
end
end
u.CanvasSize = UDim2.new(0, 0, 0, de)
end
local function dc()
if ed then local fd = 38
for _, v in k:GetChildren() do if v.Name~="UIListLayout" and v.Name~="UICorner" then fd = fd + v.Size.Y.Offset + 3
end
end
b:Create(l, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = 0 }):Play()
b:Create(ap, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 1, 0, fd) }):Play()
b:Create(k, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, fd - 38) }):Play()
b:Create(be, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 2) }):Play()
task.delay(0.25, hk)
end
end
if ed then dc() end
ci.Activated:Connect(function()
fa(ci, cn.X, cn.Y)
ed = not ed
if ed then b:Create(z, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
dc()
else b:Create(z, TweenInfo.new(0.2), { TextColor3 = Color3.fromRGB(230, 230, 230) }):Play()
b:Create(l, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = -90 }):Play()
b:Create(ap, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 1, 0, 30) }):Play()
b:Create(be, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 2) }):Play()
task.delay(0.25, hk)
end
end)
k.ChildAdded:Connect(function()
task.wait(0.05)
dc()
end)
k.ChildRemoved:Connect(function()
task.wait(0.05)
dc()
end)
local fs = u:FindFirstChildOfClass("UIListLayout")
if fs then fs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
u.CanvasSize = UDim2.new(0, 0, 0, fs.AbsoluteContentSize.Y + 10)
end)
end
local bc = {}
local f = 0
function bc:AddParagraph(ParagraphConfig)
local func = br:CreateParagraph(k, ParagraphConfig, f)
f = f + 1
return func
end
function bc:AddPanel(PanelConfig)
local func = br:CreatePanel(k, PanelConfig, f)
f = f + 1
return func
end
function bc:AddButton(ButtonConfig)
br:CreateButton(k, ButtonConfig, f)
f = f + 1
end
function bc:AddToggle(ToggleConfig)
local func = br:CreateToggle(k, ToggleConfig, f, dc, dz)
f = f + 1
return func
end
function bc:AddSlider(SliderConfig)
local func = br:CreateSlider(k, SliderConfig, f, dc, dz)
f = f + 1
return func
end
function bc:AddInput(InputConfig)
local func = br:CreateInput(k, InputConfig, f, dc, dz)
f = f + 1
return func
end
function bc:AddDropdown(DropdownConfig)
local func = br:CreateDropdown(k, DropdownConfig, f, gp, fg, o, ad, cb, dz)
f = f + 1
gp = gp + 1
return func
end
function bc:AddDivider()
local jr = br:CreateDivider(k, f)
f = f + 1
return jr
end
function bc:AddSubSection(title)
local jc = br:CreateSubSection(k, title, f)
f = f + 1
return jc
end
function bc:AddKeybind(KeybindConfig)
local func = ir:CreateKeybind(k, KeybindConfig, f, dz)
f = f + 1
return func
end
fq = fq + 1
return bc
end
dy = dy + 1
local jf = an.Name:gsub("%s+", "_")
_G[jf] = gb
return gb
end
return Tabs
end
VelarisUI = di
return di
