-- // VilarisUi | Version : 0.2.2 | Fixed Animation Title & Footer | Main.lua

local HttpService = game:GetService("HttpService") 
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/"
local function load(path) return loadstring(game:HttpGet(BASE .. path))() end
local function loadUrl(url) return loadstring(game:HttpGet(url))() end

local ColorModule    = load("src/elements/color.lua")
local ElementsModule = load("src/elements/Elements.lua")
local KeybindModule  = load("src/elements/keybind.lua")
local DialogModule   = load("src/elements/dialog.lua")
local TabsModule          = loadUrl("https://fitri324.pythonanywhere.com/Tabs.lua/raw")
local SearchModule        = loadUrl("https://fitri324.pythonanywhere.com/Search.lua/raw")
local _ColorpickerSetup   = loadUrl("https://fitri324.pythonanywhere.com/Colorpicker.lua/raw")

local defaultIcons = load("src/elements/icon/basic.lua")
local lucideIcons  = load("src/elements/icon/lucide.lua")
local solarIcons   = load("src/elements/icon/solar.lua")

local Icons = {}
for name, id in pairs(defaultIcons) do
    Icons[name] = id
end
for name, id in pairs(lucideIcons) do
    Icons["lucide:" .. name] = id
end
for name, id in pairs(solarIcons) do
    Icons["solar:" .. name] = id
end

local function getIconId(iconName)
    if not iconName or iconName == "" then
        return ""
    end
    if iconName:match("^%d+$") then
        return "rbxassetid://" .. iconName
    end
    if Icons[iconName] then
        return Icons[iconName]
    end
    if iconName:match("^https?://") then
        return iconName
    end
    return ""
end

local function getColor(colorInput)
    if typeof(colorInput) == "Color3" then
        return colorInput
    end
    if type(colorInput) == "string" then
        if ColorModule[colorInput] then
            return ColorModule[colorInput]
        else
            return ColorModule["Default"] or Color3.fromRGB(0, 208, 255)
        end
    end
    return ColorModule["Default"] or Color3.fromRGB(0, 208, 255)
end

local Elements = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local viewport = workspace.CurrentCamera.ViewportSize

local function isMobileDevice()
    return UserInputService.TouchEnabled
        and not UserInputService.KeyboardEnabled
        and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

local function safeSize(pxWidth, pxHeight)
    local scaleX = pxWidth / viewport.X
    local scaleY = pxHeight / viewport.Y
    if isMobile then
        if scaleX > 0.5 then scaleX = 0.5 end
        if scaleY > 0.3 then scaleY = 0.3 end
    end
    return UDim2.new(scaleX, 0, scaleY, 0)
end

local function MakeDraggable(topbarobject, object, GuiConfig)
    local function CustomPos(topbarobject, object)
        local Dragging, DragInput, DragStart, StartPosition

        local function UpdatePos(input)
            local Delta = input.Position - DragStart
            local pos = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
            local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Position = pos })
            Tween:Play()
        end

        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        topbarobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdatePos(input)
            end
        end)
    end

    local function CustomSize(object)
        local Dragging, DragInput, DragStart, StartSize
        local minSizeX, minSizeY
        local defSizeX, defSizeY

        local cfgW = (GuiConfig and GuiConfig.Size and GuiConfig.Size.X.Offset) or 640
        local cfgH = (GuiConfig and GuiConfig.Size and GuiConfig.Size.Y.Offset) or 400

        if isMobile then
            minSizeX, minSizeY = 100, 100
            defSizeX = math.min(cfgW, 470)
            defSizeY = math.min(cfgH, 270)
        else
            minSizeX, minSizeY = 100, 100
            defSizeX = cfgW
            defSizeY = cfgH
        end

        object.Size = UDim2.new(0, defSizeX, 0, defSizeY)

        local changesizeobject = Instance.new("Frame")
        changesizeobject.AnchorPoint = Vector2.new(1, 1)
        changesizeobject.BackgroundTransparency = 1
        changesizeobject.Size = UDim2.new(0, 40, 0, 40)
        changesizeobject.Position = UDim2.new(1, 20, 1, 20)
        changesizeobject.Name = "changesizeobject"
        changesizeobject.Parent = object

        local function UpdateSize(input)
            local Delta = input.Position - DragStart
            local newWidth = StartSize.X.Offset + Delta.X
            local newHeight = StartSize.Y.Offset + Delta.Y
            newWidth = math.max(newWidth, minSizeX)
            newHeight = math.max(newHeight, minSizeY)
            local Tween = TweenService:Create(object, TweenInfo.new(0.2), { Size = UDim2.new(0, newWidth, 0, newHeight) })
            Tween:Play()
        end

        changesizeobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartSize = object.Size
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)

        changesizeobject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                UpdateSize(input)
            end
        end)
    end

    CustomSize(object)
    CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
        Circle.ImageTransparency = 0.8999999761581421
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Name = "Circle"
        Circle.Parent = Button

        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = 0
        if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.Y * 1.5
        elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
            Size = Button.AbsoluteSize.X * 1.5
        end

        local Time = 0.5
        Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad",
            Time, false, nil)
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.01
            wait(Time / 10)
        end
        Circle:Destroy()
    end)
end

local _CPGui          = nil
local _CPPanel        = nil
local _CPPanelButtons = nil
local _CPPanelRefs    = nil
local _CPActive       = nil

local _ColorpickerModule = nil
local function _InitColorpicker(AccentColor, MainDropShadow)
    if _ColorpickerModule then return end
    _ColorpickerModule = _ColorpickerSetup(
        TweenService, UserInputService, CoreGui,
        getIconId, {}, false, function() end, ElementsModule
    )
end

local function _MakeColorPicker(Config, SectionAdd, CountItem, AccentColor, MainDropShadow)
    _InitColorpicker(AccentColor, MainDropShadow)
    if not _ColorpickerModule then
        warn("[VelarisUI] Colorpicker.lua gagal dimuat dari server")
        return {}
    end
    return _ColorpickerModule.MakeColorPicker(Config, SectionAdd, CountItem, AccentColor, MainDropShadow)
end

local Chloex = {}

function Chloex:MakeNotify(NotifyConfig)
    NotifyConfig              = NotifyConfig or {}
    NotifyConfig.Title        = NotifyConfig.Title or "Velaris UI"
    NotifyConfig.Description  = NotifyConfig.Description or ""
    NotifyConfig.Content      = NotifyConfig.Content or ""
    NotifyConfig.Color        = getColor(NotifyConfig.Color or Color3.fromRGB(0, 208, 255))
    NotifyConfig.Time         = NotifyConfig.Time or 0.5
    NotifyConfig.Delay        = NotifyConfig.Delay or 5
    NotifyConfig.Buttons      = NotifyConfig.Buttons or {}

    local NotifyFunction = {}
    local _closed = false

    task.spawn(function()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local ng = Instance.new("ScreenGui")
            ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ng.Name = "NotifyGui"
            ng.Parent = CoreGui
        end

        local NotifyGui = CoreGui.NotifyGui

        if not NotifyGui:FindFirstChild("NotifyHolder") then
            local holder = Instance.new("Frame")
            holder.Name              = "NotifyHolder"
            holder.AnchorPoint       = Vector2.new(1, 1)
            holder.BackgroundTransparency = 1
            holder.BorderSizePixel   = 0
            holder.Position          = UDim2.new(1, -16, 1, -16)
            holder.Size              = UDim2.new(0, 310, 1, -32)
            holder.Parent            = NotifyGui

            local list = Instance.new("UIListLayout")
            list.SortOrder          = Enum.SortOrder.LayoutOrder
            list.VerticalAlignment  = Enum.VerticalAlignment.Bottom
            list.HorizontalAlignment = Enum.HorizontalAlignment.Right
            list.Padding            = UDim.new(0, 8)
            list.Parent             = holder
        end

        local Holder = NotifyGui.NotifyHolder
        local MainContainer = Instance.new("Frame")
        MainContainer.BackgroundTransparency = 1
        MainContainer.BorderSizePixel        = 0
        MainContainer.Size                   = UDim2.new(1, 0, 0, 0)
        MainContainer.ClipsDescendants       = false
        MainContainer.Parent                 = Holder
        local Card = Instance.new("Frame")
        Card.Name                  = "NotifyCard"
        Card.BackgroundColor3      = Color3.fromRGB(22, 22, 28)
        Card.BorderSizePixel       = 0
        Card.AnchorPoint           = Vector2.new(0, 1)
        Card.Position              = UDim2.new(1, 320, 1, 0)
        Card.Size                  = UDim2.new(1, 0, 0, 0)
        Card.AutomaticSize         = Enum.AutomaticSize.Y
        Card.ClipsDescendants      = false
        Card.Parent                = MainContainer
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color           = Color3.fromRGB(50, 50, 62)
        CardStroke.Thickness       = 1
        CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        CardStroke.Parent          = Card
        local Accent = Instance.new("Frame")
        Accent.BackgroundColor3  = NotifyConfig.Color
        Accent.BorderSizePixel   = 0
        Accent.Size              = UDim2.new(0, 3, 1, 0)
        Accent.Position          = UDim2.new(0, 0, 0, 0)
        Accent.ZIndex            = 3
        Accent.Parent            = Card
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 10)

        local CardPad = Instance.new("UIPadding")
        CardPad.PaddingTop    = UDim.new(0, 10)
        CardPad.PaddingBottom = UDim.new(0, 10)
        CardPad.PaddingLeft   = UDim.new(0, 14)
        CardPad.PaddingRight  = UDim.new(0, 12)
        CardPad.Parent        = Card
        local CardList = Instance.new("UIListLayout")
        CardList.SortOrder         = Enum.SortOrder.LayoutOrder
        CardList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        CardList.Padding           = UDim.new(0, 5)
        CardList.Parent            = Card
        local TitleRow = Instance.new("Frame")
        TitleRow.BackgroundTransparency = 1
        TitleRow.BorderSizePixel        = 0
        TitleRow.Size                   = UDim2.new(1, -22, 0, 0)
        TitleRow.AutomaticSize          = Enum.AutomaticSize.Y
        TitleRow.LayoutOrder            = 0
        TitleRow.Parent                 = Card

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Font                = Enum.Font.GothamBold
        TitleLabel.Text                = NotifyConfig.Title
        TitleLabel.TextColor3          = Color3.fromRGB(240, 240, 245)
        TitleLabel.TextSize            = 13
        TitleLabel.TextXAlignment      = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.AutomaticSize       = Enum.AutomaticSize.XY
        TitleLabel.Size                = UDim2.new(0, 0, 0, 0)
        TitleLabel.Parent              = TitleRow

        if NotifyConfig.Description and NotifyConfig.Description ~= "" then
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Font                = Enum.Font.GothamMedium
            DescLabel.Text                = NotifyConfig.Description
            DescLabel.TextColor3          = NotifyConfig.Color
            DescLabel.TextSize            = 11
            DescLabel.TextXAlignment      = Enum.TextXAlignment.Left
            DescLabel.BackgroundTransparency = 1
            DescLabel.AutomaticSize       = Enum.AutomaticSize.XY
            DescLabel.Size                = UDim2.new(0, 0, 0, 0)
            DescLabel.AnchorPoint         = Vector2.new(0, 0)

            task.spawn(function()
                task.wait()
                DescLabel.Position = UDim2.new(0, TitleLabel.AbsoluteSize.X + 7, 0, 2)
                DescLabel.Parent   = TitleRow
            end)
        end
        if NotifyConfig.Content and NotifyConfig.Content ~= "" then
            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Font                = Enum.Font.Gotham
            ContentLabel.Text                = NotifyConfig.Content
            ContentLabel.TextColor3          = Color3.fromRGB(160, 160, 172)
            ContentLabel.TextSize            = 12
            ContentLabel.TextXAlignment      = Enum.TextXAlignment.Left
            ContentLabel.TextYAlignment      = Enum.TextYAlignment.Top
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.TextWrapped         = true
            ContentLabel.AutomaticSize       = Enum.AutomaticSize.Y
            ContentLabel.Size                = UDim2.new(1, -22, 0, 0)
            ContentLabel.LayoutOrder         = 1
            ContentLabel.Parent              = Card
        end
        local hasButtons = #NotifyConfig.Buttons > 0
        if hasButtons then
            local BtnRow = Instance.new("Frame")
            BtnRow.BackgroundTransparency = 1
            BtnRow.BorderSizePixel        = 0
            BtnRow.Size                   = UDim2.new(1, 0, 0, 28)
            BtnRow.LayoutOrder            = 2
            BtnRow.Parent                 = Card

            local BtnList = Instance.new("UIListLayout")
            BtnList.FillDirection         = Enum.FillDirection.Horizontal
            BtnList.HorizontalAlignment   = Enum.HorizontalAlignment.Right
            BtnList.VerticalAlignment     = Enum.VerticalAlignment.Center
            BtnList.Padding               = UDim.new(0, 6)
            BtnList.Parent                = BtnRow

            for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                local Btn = Instance.new("TextButton")
                Btn.Font           = Enum.Font.GothamBold
                Btn.TextSize       = 11
                Btn.Text           = btnCfg.Name or ("Btn" .. idx)
                Btn.AutomaticSize  = Enum.AutomaticSize.X
                Btn.Size           = UDim2.new(0, 0, 1, 0)
                Btn.BorderSizePixel = 0
                Btn.LayoutOrder    = idx

                local isPrimary = btnCfg.Primary == true
                Btn.BackgroundColor3 = isPrimary
                    and Color3.fromRGB(45, 45, 58)
                    or  Color3.fromRGB(33, 33, 42)
                Btn.TextColor3 = isPrimary
                    and Color3.fromRGB(220, 220, 230)
                    or  Color3.fromRGB(160, 160, 175)
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color     = isPrimary
                    and Color3.fromRGB(70, 70, 88)
                    or  Color3.fromRGB(50, 50, 62)
                BtnStroke.Thickness = 1
                BtnStroke.Parent    = Btn

                local BtnPad = Instance.new("UIPadding")
                BtnPad.PaddingLeft  = UDim.new(0, 10)
                BtnPad.PaddingRight = UDim.new(0, 10)
                BtnPad.Parent       = Btn

                Btn.Parent = BtnRow

                Btn.MouseButton1Click:Connect(function()
                    if btnCfg.Callback then pcall(btnCfg.Callback) end
                    NotifyFunction:Close()
                end)
            end
        end
        if not hasButtons then
            local ProgBg = Instance.new("Frame")
            ProgBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ProgBg.BorderSizePixel  = 0
            ProgBg.Size             = UDim2.new(1, 0, 0, 3)
            ProgBg.LayoutOrder      = 3
            ProgBg.Parent           = Card
            Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(1, 0)

            local ProgBar = Instance.new("Frame")
            ProgBar.BackgroundColor3 = NotifyConfig.Color
            ProgBar.BorderSizePixel  = 0
            ProgBar.Size             = UDim2.new(1, 0, 1, 0)
            ProgBar.Parent           = ProgBg
            Instance.new("UICorner", ProgBar).CornerRadius = UDim.new(1, 0)

            local delay = tonumber(NotifyConfig.Delay) or 5
            TweenService:Create(ProgBar, TweenInfo.new(delay, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()
        end
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Text               = ""
        CloseBtn.AnchorPoint        = Vector2.new(1, 0)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Position           = UDim2.new(1, -4, 0, 4)
        CloseBtn.Size               = UDim2.new(0, 18, 0, 18)
        CloseBtn.ZIndex             = 10
        CloseBtn.Parent             = Card

        local CloseImg = Instance.new("ImageLabel")
        CloseImg.Image              = "rbxassetid://9886659671"
        CloseImg.ImageColor3        = Color3.fromRGB(120, 120, 135)
        CloseImg.AnchorPoint        = Vector2.new(0.5, 0.5)
        CloseImg.BackgroundTransparency = 1
        CloseImg.Position           = UDim2.new(0.5, 0, 0.5, 0)
        CloseImg.Size               = UDim2.new(1, -2, 1, -2)
        CloseImg.Parent             = CloseBtn
        function NotifyFunction:Close()
            if _closed then return end
            _closed = true
            TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 320, 1, 0)
            }):Play()
            TweenService:Create(MainContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.wait(0.45)
            if MainContainer and MainContainer.Parent then
                MainContainer:Destroy()
            end
        end

        CloseBtn.Activated:Connect(function() NotifyFunction:Close() end)
        task.spawn(function()
            task.wait()

            local finalH = Card.AbsoluteSize.Y
            if finalH <= 0 then
                task.wait(0.05)
                finalH = Card.AbsoluteSize.Y
            end
            TweenService:Create(MainContainer, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, finalH + 2)
            }):Play()
            TweenService:Create(Card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 1, 0)
            }):Play()
            local delay = tonumber(NotifyConfig.Delay) or 5
            if not hasButtons then
                task.wait(delay)
                NotifyFunction:Close()
            elseif delay > 0 then
                task.wait(delay)
                NotifyFunction:Close()
            end
        end)
    end)

    return NotifyFunction
end
function GuiFunc:Notify(Config)
    Config          = Config or {}
    Config.Title    = Config.Title   or "Notification"
    Config.Content  = Config.Content or ""
    Config.Duration = Config.Duration or 5
    Config.Buttons  = Config.Buttons or {}
    local NotifGui = CoreGui:FindFirstChild("VelarisUI_Notifs")
    if not NotifGui then
        NotifGui = Instance.new("ScreenGui")
        NotifGui.Name           = "VelarisUI_Notifs"
        NotifGui.ResetOnSpawn   = false
        NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifGui.Parent         = CoreGui

        local Container = Instance.new("Frame")
        Container.Name              = "Container"
        Container.BackgroundTransparency = 1
        Container.AnchorPoint       = Vector2.new(1, 1)
        Container.Position          = UDim2.new(1, -16, 1, -16)
        Container.Size              = UDim2.new(0, 310, 1, -32)
        Container.Parent            = NotifGui

        local List = Instance.new("UIListLayout")
        List.SortOrder          = Enum.SortOrder.LayoutOrder
        List.VerticalAlignment  = Enum.VerticalAlignment.Bottom
        List.HorizontalAlignment = Enum.HorizontalAlignment.Right
        List.Padding            = UDim.new(0, 8)
        List.Parent             = Container
    end

    local Container = NotifGui:FindFirstChild("Container")
    local _closed   = false
    local MainContainer = Instance.new("Frame")
    MainContainer.BackgroundTransparency = 1
    MainContainer.BorderSizePixel        = 0
    MainContainer.Size                   = UDim2.new(1, 0, 0, 0)
    MainContainer.ClipsDescendants       = false
    MainContainer.Parent                 = Container
    local Card = Instance.new("Frame")
    Card.Name             = "NotifCard"
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Card.BorderSizePixel  = 0
    Card.AnchorPoint      = Vector2.new(0, 1)
    Card.Position         = UDim2.new(1, 320, 1, 0)
    Card.Size             = UDim2.new(1, 0, 0, 0)
    Card.AutomaticSize    = Enum.AutomaticSize.Y
    Card.ClipsDescendants = false
    Card.Parent           = MainContainer
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color           = GuiConfig.Color
    CardStroke.Thickness       = 1
    CardStroke.Transparency    = 0.6
    CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    CardStroke.Parent          = Card
    local Accent = Instance.new("Frame")
    Accent.BackgroundColor3 = GuiConfig.Color
    Accent.BorderSizePixel  = 0
    Accent.Size             = UDim2.new(0, 3, 1, 0)
    Accent.ZIndex           = 2
    Accent.Parent           = Card
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(1, 0)

    local CardPad = Instance.new("UIPadding")
    CardPad.PaddingTop    = UDim.new(0, 10)
    CardPad.PaddingBottom = UDim.new(0, 10)
    CardPad.PaddingLeft   = UDim.new(0, 14)
    CardPad.PaddingRight  = UDim.new(0, 12)
    CardPad.Parent        = Card
    local CardList = Instance.new("UIListLayout")
    CardList.SortOrder           = Enum.SortOrder.LayoutOrder
    CardList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    CardList.Padding             = UDim.new(0, 6)
    CardList.Parent              = Card
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text              = Config.Title
    TitleLabel.Font              = Enum.Font.GothamBold
    TitleLabel.TextSize          = 13
    TitleLabel.TextColor3        = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextWrapped       = true
    TitleLabel.AutomaticSize     = Enum.AutomaticSize.Y
    TitleLabel.Size              = UDim2.new(1, -20, 0, 0)
    TitleLabel.LayoutOrder       = 0
    TitleLabel.Parent            = Card
    if Config.Content ~= "" then
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Text             = Config.Content
        ContentLabel.Font             = Enum.Font.Gotham
        ContentLabel.TextSize         = 11
        ContentLabel.TextColor3       = Color3.fromRGB(170, 170, 185)
        ContentLabel.TextXAlignment   = Enum.TextXAlignment.Left
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.TextWrapped      = true
        ContentLabel.AutomaticSize    = Enum.AutomaticSize.Y
        ContentLabel.Size             = UDim2.new(1, 0, 0, 0)
        ContentLabel.LayoutOrder      = 1
        ContentLabel.Parent           = Card
    end
    local hasButtons = #Config.Buttons > 0
    if hasButtons then
        local BtnRow = Instance.new("Frame")
        BtnRow.BackgroundTransparency = 1
        BtnRow.Size        = UDim2.new(1, 0, 0, 28)
        BtnRow.LayoutOrder = 2
        BtnRow.Parent      = Card

        local BtnList = Instance.new("UIListLayout")
        BtnList.FillDirection       = Enum.FillDirection.Horizontal
        BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        BtnList.VerticalAlignment   = Enum.VerticalAlignment.Center
        BtnList.Padding             = UDim.new(0, 6)
        BtnList.Parent              = BtnRow

        for idx, btnCfg in ipairs(Config.Buttons) do
            local Btn = Instance.new("TextButton")
            Btn.Text          = btnCfg.Name or ("Btn" .. idx)
            Btn.Font          = Enum.Font.GothamBold
            Btn.TextSize      = 11
            Btn.AutomaticSize = Enum.AutomaticSize.X
            Btn.Size          = UDim2.new(0, 0, 1, 0)
            Btn.BorderSizePixel = 0
            Btn.LayoutOrder   = idx

            local isPrimary = btnCfg.Primary == true or idx == 1
            Btn.BackgroundColor3 = isPrimary and GuiConfig.Color or Color3.fromRGB(40, 40, 50)
            Btn.TextColor3       = isPrimary and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,195)
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

            local BtnPad = Instance.new("UIPadding")
            BtnPad.PaddingLeft  = UDim.new(0, 10)
            BtnPad.PaddingRight = UDim.new(0, 10)
            BtnPad.Parent       = Btn

            Btn.Parent = BtnRow

            Btn.MouseButton1Click:Connect(function()
                if btnCfg.Callback then pcall(btnCfg.Callback) end
                Card:Destroy()
                MainContainer:Destroy()
            end)
        end
    end
    if Config.Duration > 0 and not hasButtons then
        local ProgBg = Instance.new("Frame")
        ProgBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ProgBg.BorderSizePixel  = 0
        ProgBg.Size             = UDim2.new(1, 0, 0, 3)
        ProgBg.LayoutOrder      = 3
        ProgBg.Parent           = Card
        Instance.new("UICorner", ProgBg).CornerRadius = UDim.new(1, 0)

        local ProgBar = Instance.new("Frame")
        ProgBar.BackgroundColor3 = GuiConfig.Color
        ProgBar.BorderSizePixel  = 0
        ProgBar.Size             = UDim2.new(1, 0, 1, 0)
        ProgBar.Parent           = ProgBg
        Instance.new("UICorner", ProgBar).CornerRadius = UDim.new(1, 0)

        TweenService:Create(ProgBar, TweenInfo.new(Config.Duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()
    end
    task.spawn(function()
        task.wait()

        local finalH = Card.AbsoluteSize.Y
        if finalH <= 0 then
            task.wait(0.05)
            finalH = Card.AbsoluteSize.Y
        end
        TweenService:Create(MainContainer,
            TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = UDim2.new(1, 0, 0, finalH + 2) }
        ):Play()
        TweenService:Create(Card,
            TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Position = UDim2.new(0, 0, 1, 0) }
        ):Play()
        task.wait(0.5)
        if Card and Card.Parent then
            Card.ClipsDescendants = true
        end
        if Config.Duration > 0 and not hasButtons then
            task.wait(Config.Duration - 0.5)
            if not _closed and Card and Card.Parent then
                _closed = true
                TweenService:Create(Card,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                    { Position = UDim2.new(1, 320, 1, 0) }
                ):Play()
                TweenService:Create(MainContainer,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                    { Size = UDim2.new(1, 0, 0, 0) }
                ):Play()
                task.wait(0.45)
                if MainContainer and MainContainer.Parent then
                    MainContainer:Destroy()
                end
            end
        end
    end)
end

function Nt(msg, delay, color, title, desc)
    return Chloex:MakeNotify({
        Title       = title or "VelarisUI",
        Description = desc or "Notification",
        Content     = msg or "Content",
        Color       = color or Color3.fromRGB(0, 208, 255),
        Delay       = delay or 4,
    })
end

Notify = Nt

function Chloex:Dialog(DialogConfig)
    return DialogModule(DialogConfig)
end

function Chloex:Window(GuiConfig)
    GuiConfig               = GuiConfig or {}
    GuiConfig.Title         = GuiConfig.Title or "Chloe X"
    GuiConfig.Footer        = GuiConfig.Footer or "Chloee :3"
    GuiConfig.Content       = GuiConfig.Content or ""
    GuiConfig.ShowUser      = GuiConfig.ShowUser or false
    GuiConfig.Color         = getColor(GuiConfig.Color or "Default")
    GuiConfig["Tab Width"]  = GuiConfig["Tab Width"] or 120
    GuiConfig.Uitransparent = GuiConfig.Uitransparent or 0.15
    GuiConfig.Image         = GuiConfig.Image or "70884221600423"
    GuiConfig.Icon          = GuiConfig.Icon or "rbxassetid://103875081318049"
    GuiConfig.Size          = GuiConfig.Size or UDim2.fromOffset(640, 400)
    GuiConfig.Search        = GuiConfig.Search ~= nil and GuiConfig.Search or false
    GuiConfig.Version       = GuiConfig.Version or "1.0"
    GuiConfig.Config        = GuiConfig.Config or {}
    GuiConfig.Config.ConfigFolder = GuiConfig.Config.ConfigFolder or "VelarisUI/Config/"
    GuiConfig.Config.AutoSaveFile = GuiConfig.Config.AutoSaveFile or "Default"
    GuiConfig.Config.AutoSave     = GuiConfig.Config.AutoSave ~= nil and GuiConfig.Config.AutoSave or false
    GuiConfig.Config.AutoLoad     = GuiConfig.Config.AutoLoad ~= nil and GuiConfig.Config.AutoLoad or false

    GuiConfig.DiscordSet        = GuiConfig.DiscordSet or {}
    GuiConfig.DiscordSet.Enable = GuiConfig.DiscordSet.Enable ~= nil and GuiConfig.DiscordSet.Enable or false
    GuiConfig.DiscordSet.Title  = GuiConfig.DiscordSet.Title or "DISCORD"
    GuiConfig.DiscordSet.Link   = GuiConfig.DiscordSet.Link or ""
    GuiConfig.DiscordSet.Icon   = GuiConfig.DiscordSet.Icon or ""

    ElementsModule:Initialize(GuiConfig, function() end, {}, Icons)

    local ks = GuiConfig.KeySystem
    if ks then
        local ok, result = pcall(function()
            return loadUrl("https://fitri324.pythonanywhere.com/KeySystemUi.lua/raw")
        end)
        if not ok or type(result) ~= "function" then
            warn("[VelarisUI] KeySystem gagal dimuat")
        else
            local ok2, resolved = pcall(result, ks, GuiConfig, CoreGui, TweenService, getIconId)
            if not ok2 then
                warn("[VelarisUI] KeySystem error: " .. tostring(resolved))
            elseif not resolved then
                while true do task.wait(9999) end
            end
        end
    end

    local GuiFunc = {}

    local _ConfigData     = {}
    local _ConfigElements = {}
    local _cfgFolder      = GuiConfig.Config.ConfigFolder

    local function _checkFolders()
        pcall(function()
            local parts = _cfgFolder:split("/")
            local path = ""
            for _, p in ipairs(parts) do
                if p ~= "" then
                    path = path == "" and p or (path .. "/" .. p)
                    if not isfolder(path) then makefolder(path) end
                end
            end
        end)
    end

    local function _cfgFile(name)
        return _cfgFolder .. (name or "Default") .. ".json"
    end

    function GuiFunc:SaveConfig(name)
        if not writefile then
            warn("[VelarisUI] writefile tidak tersedia")
            return false
        end
        _checkFolders()
        _ConfigData._version = GuiConfig.Version
        local ok, err = pcall(function()
            writefile(_cfgFile(name), HttpService:JSONEncode(_ConfigData))
        end)
        if not ok then warn("[VelarisUI] SaveConfig error:", err) end
        return ok
    end

    function GuiFunc:LoadConfig(name)
        if not isfile or not readfile then
            warn("[VelarisUI] isfile/readfile tidak tersedia")
            return false
        end
        _checkFolders()
        local f = _cfgFile(name)
        if not isfile(f) then return false end
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(f))
        end)
        if not (ok and type(result) == "table") then return false end
        _ConfigData = result
        for key, elem in pairs(_ConfigElements) do
            local val = _ConfigData[key]
            if val ~= nil and elem.Set then
                pcall(function() elem:Set(val) end)
            end
        end
        return true
    end

    function GuiFunc:DeleteConfig(name)
        if not isfile or not delfile then return false end
        local f = _cfgFile(name)
        if isfile(f) then
            pcall(delfile, f)
            return true
        end
        return false
    end

    function GuiFunc:ListConfigs()
        local list = {}
        if not listfiles then return list end
        _checkFolders()
        local ok, files = pcall(listfiles, _cfgFolder)
        if not ok then return list end
        for _, path in ipairs(files) do
            local name = path:match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
        return list
    end

    function GuiFunc:ResetConfig(name)
        _ConfigData = {}
        for key, elem in pairs(_ConfigElements) do
            if elem.Set then
                if elem.Type == "Toggle" then
                    pcall(function() elem:Set(false) end)
                elseif elem.Type == "Slider" then
                    pcall(function() elem:Set(elem.Default or 0) end)
                elseif elem.Type == "Dropdown" then
                    pcall(function() elem:Set(elem.Default or (elem.Multi and {} or nil)) end)
                elseif elem.Type == "Input" then
                    pcall(function() elem:Set("") end)
                end
            end
        end
        if name then GuiFunc:DeleteConfig(name) end
    end

    GuiFunc.ConfigData     = _ConfigData
    GuiFunc.ConfigElements = _ConfigElements

    local Chloeex           = Instance.new("ScreenGui")
    local DropShadowHolder  = Instance.new("Frame")
    local DropShadow        = Instance.new("ImageLabel")
    local Main              = Instance.new("Frame")
    local UICorner          = Instance.new("UICorner")
    local MainStroke        = Instance.new("UIStroke")
    local Top               = Instance.new("Frame")
    local TitleIcon         = Instance.new("ImageLabel")
    local TextLabel         = Instance.new("TextLabel")
    local UICorner1         = Instance.new("UICorner")
    local TextLabel1        = Instance.new("TextLabel")
    local Close             = Instance.new("TextButton")
    local ImageLabel1       = Instance.new("ImageLabel")
    local Min               = Instance.new("TextButton")
    local ImageLabel2       = Instance.new("ImageLabel")

    Chloeex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Chloeex.Name = "VelarisUI"
    Chloeex.ResetOnSpawn = false
    Chloeex.Parent = game:GetService("CoreGui")

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

    local baseW = GuiConfig.Size.X.Offset
    local baseH = GuiConfig.Size.Y.Offset
    if isMobile then
        DropShadowHolder.Size = safeSize(math.min(baseW, 470), math.min(baseH, 270))
    else
        DropShadowHolder.Size = safeSize(baseW, baseH)
    end

    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Chloeex

    DropShadowHolder.Position = UDim2.new(
        0, (Chloeex.AbsoluteSize.X // 2 - DropShadowHolder.Size.X.Offset // 2),
        0, (Chloeex.AbsoluteSize.Y // 2 - DropShadowHolder.Size.Y.Offset // 2)
    )

    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    DropShadow.ImageTransparency = 1
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    if GuiConfig.Theme then
        Main:Destroy()
        Main = Instance.new("ImageLabel")
        Main.Image = "rbxassetid://" .. GuiConfig.Theme
        Main.ScaleType = Enum.ScaleType.Crop
        Main.BackgroundTransparency = 1
        Main.ImageTransparency = GuiConfig.ThemeTransparency or GuiConfig.Uitransparent or 0.15
    else
        Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Main.BackgroundTransparency = GuiConfig.Uitransparent
    end

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -47, 1, -47)
    Main.Name = "Main"
    Main.Parent = DropShadow

    MainStroke.Thickness = 1.2
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.6
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main

    UICorner.Parent = Main

    local ColorTint = Instance.new("Frame")
    ColorTint.Name = "ColorTint"
    ColorTint.Size = UDim2.new(1, 0, 1, 0)
    ColorTint.BackgroundColor3 = GuiConfig.Color
    ColorTint.BackgroundTransparency = 0.93
    ColorTint.BorderSizePixel = 0
    ColorTint.ZIndex = 0

    local ImageWrapper = Instance.new("Frame")
    ImageWrapper.Name = "ImageWrapper"
    ImageWrapper.Parent = Main
    ImageWrapper.BackgroundTransparency = 1
    ImageWrapper.Size = UDim2.new(1, 0, 1, 0)
    ImageWrapper.Position = UDim2.new(0, 0, 0, 0)
    ImageWrapper.ZIndex = 0
    ImageWrapper.ClipsDescendants = true
    ColorTint.Parent = Main

    local ThemeImage = Instance.new("ImageLabel")
    ThemeImage.Name = "ThemeImage"
    ThemeImage.Parent = ImageWrapper
    ThemeImage.BackgroundTransparency = 1
    ThemeImage.AnchorPoint = Vector2.new(1, 1)
    ThemeImage.Position = UDim2.new(1, 0, 1, 0)
    ThemeImage.Size = UDim2.new(0.55, 0, 1.0, 0)
    ThemeImage.ZIndex = 0
    ThemeImage.Image = ""
    ThemeImage.ImageTransparency = 1
    ThemeImage.ScaleType = Enum.ScaleType.Fit

    local ThemeGradient = Instance.new("UIGradient")
    ThemeGradient.Rotation = 135
    ThemeGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.45, 0.8),
        NumberSequenceKeypoint.new(0.75, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    ThemeGradient.Parent = ThemeImage

    if GuiConfig.BackgroundVideo and GuiConfig.BackgroundVideo ~= "" then
        task.spawn(function()
            local videoInput = GuiConfig.BackgroundVideo
            local videoId    = nil

            local isAssetId = videoInput:match("^%d+$")
                or videoInput:match("^rbxassetid://")

            if isAssetId then
                if videoInput:match("^%d+$") then
                    videoId = "rbxassetid://" .. videoInput
                else
                    videoId = videoInput
                end
            else
                local fileName = "VelarisUI_bgvideo.webm"

                if writefile and getcustomasset and isfile then
                    if not isfile(fileName) then
                        local ok, err = pcall(function()
                            writefile(fileName, game:HttpGet(videoInput))
                        end)
                        if not ok then
                            return
                        end
                    end
                    local ok2, id = pcall(getcustomasset, fileName)
                    if ok2 and id then
                        videoId = id
                    else
                        return
                    end
                else
                    warn("[VelarisUI] BackgroundVideo: writefile/getcustomasset tidak tersedia")
                    return
                end
            end

            local VideoWrapper = Instance.new("Frame")
            VideoWrapper.Name = "VideoWrapper"
            VideoWrapper.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            VideoWrapper.BackgroundTransparency = 0
            VideoWrapper.BorderSizePixel = 0
            VideoWrapper.Size = UDim2.fromScale(1, 1)
            VideoWrapper.Position = UDim2.fromScale(0, 0)
            VideoWrapper.ZIndex = 0
            VideoWrapper.ClipsDescendants = true
            VideoWrapper.Parent = Main
            Instance.new("UICorner", VideoWrapper).CornerRadius = UDim.new(0, 8)

            local BgVideo = Instance.new("VideoFrame")
            BgVideo.Name = "BackgroundVideo"
            BgVideo.Video = videoId
            BgVideo.Looped = true
            BgVideo.Volume = 0
            BgVideo.BackgroundTransparency = 1
            BgVideo.BorderSizePixel = 0
            BgVideo.Size = UDim2.fromScale(1, 1)
            BgVideo.Position = UDim2.fromScale(0, 0)
            BgVideo.ZIndex = 0
            BgVideo.Parent = VideoWrapper

            local VideoOverlay = Instance.new("Frame")
            VideoOverlay.Name = "VideoOverlay"
            VideoOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            VideoOverlay.BackgroundTransparency = GuiConfig.BackgroundVideoOverlay or 0.4
            VideoOverlay.BorderSizePixel = 0
            VideoOverlay.Size = UDim2.fromScale(1, 1)
            VideoOverlay.ZIndex = 0
            VideoOverlay.Parent = VideoWrapper

            BgVideo.Loaded:Connect(function()
                BgVideo:Play()
            end)

            function GuiFunc:SetBackgroundVideoVolume(Vol)
                BgVideo.Volume = math.clamp(Vol, 0, 10)
            end
            function GuiFunc:PauseBackgroundVideo()
                BgVideo:Pause()
            end
            function GuiFunc:PlayBackgroundVideo()
                BgVideo:Play()
            end
            function GuiFunc:SetBackgroundVideoOverlay(Trans)
                VideoOverlay.BackgroundTransparency = math.clamp(Trans, 0, 1)
            end
        end)
    end

    Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Top.BackgroundTransparency = 0.999
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.Name = "Top"
    Top.Parent = Main

    TitleIcon.Name = "TitleIcon"
    TitleIcon.Parent = Top
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.BorderSizePixel = 0
    TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
    TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
    TitleIcon.Size = UDim2.new(0, 20, 0, 20)
    TitleIcon.Image = "rbxassetid://" .. GuiConfig.Image

    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = ""
    TextLabel.TextColor3 = GuiConfig.Color
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.999
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -135, 1, 0)
    TextLabel.Position = UDim2.new(0, 35, 0, 0)
    TextLabel.Parent = Top

    UICorner1.Parent = Top

    TextLabel1.Font = Enum.Font.GothamBold
    TextLabel1.Text = ""
    TextLabel1.TextColor3 = GuiConfig.Color
    TextLabel1.TextSize = 14
    TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel1.BackgroundTransparency = 0.999
    TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel1.BorderSizePixel = 0
    TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
    TextLabel1.Position = UDim2.new(0, 25 + TextLabel.TextBounds.X + 10, 0, 0)
    TextLabel1.Parent = Top

    if GuiConfig.Animation then
        TextLabel1.Visible = false
        task.spawn(function()
            local function typeOut(text, charDelay)
                TextLabel.Text = ""
                for i = 1, #text do
                    TextLabel.Text = string.sub(text, 1, i)
                    task.wait(charDelay)
                end
            end

            local function typeErase(charDelay)
                local current = TextLabel.Text
                for i = #current, 1, -1 do
                    TextLabel.Text = string.sub(current, 1, i - 1)
                    task.wait(charDelay)
                end
                TextLabel.Text = ""
            end

            local titleText  = GuiConfig.Title
            local footerText = GuiConfig.Footer
            local charDelay  = GuiConfig.TypeDelay or 0.07
            local pauseTime  = GuiConfig.TypePause or 2.5

            while true do
                typeOut(titleText, charDelay)
                task.wait(pauseTime)
                typeErase(charDelay)
                task.wait(0.15)
                typeOut(footerText, charDelay)
                task.wait(pauseTime)
                typeErase(charDelay)
                task.wait(0.15)
            end
        end)
    else
        TextLabel.Text  = GuiConfig.Title
        TextLabel1.Text = GuiConfig.Footer
    end

    local TagContainer = Instance.new("Frame")
    TagContainer.Name = "TagContainer"
    TagContainer.BackgroundTransparency = 1
    TagContainer.BorderSizePixel = 0
    TagContainer.ClipsDescendants = false
    TagContainer.AnchorPoint = Vector2.new(1, 0.5)
    TagContainer.Position = UDim2.new(1, -70, 0.5, 0)
    TagContainer.Size = UDim2.new(0, 200, 0, 26)
    TagContainer.ZIndex = 2
    TagContainer.Parent = Top

    local TagListLayout = Instance.new("UIListLayout")
    TagListLayout.FillDirection = Enum.FillDirection.Horizontal
    TagListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TagListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TagListLayout.Padding = UDim.new(0, 5)
    TagListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TagListLayout.Parent = TagContainer

    local function UpdateTagPosition()
        local titleW  = TextLabel.TextBounds.X
        local footerW = TextLabel1.TextBounds.X
        local textEnd = 35 + titleW + 10 + footerW + 10
        local rightBound = -70
        local availableW = Top.AbsoluteSize.X + rightBound - textEnd
        if availableW < 0 then availableW = 0 end
        TagContainer.Size = UDim2.new(0, math.min(availableW, 300), 0, 26)
        TagContainer.Position = UDim2.new(1, rightBound, 0.5, 0)
    end

    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateTagPosition)
    TextLabel1:GetPropertyChangedSignal("TextBounds"):Connect(UpdateTagPosition)
    Top:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTagPosition)
    UpdateTagPosition()

    local function UpdateFooterPosition()
        local titleWidth = TextLabel.TextBounds.X
        TextLabel1.Position = UDim2.new(0, 25 + titleWidth + 10, 0, 0)
        TextLabel1.Size = UDim2.new(1, -(titleWidth + 104), 1, 0)
        UpdateTagPosition()
    end

    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(UpdateFooterPosition)
    UpdateFooterPosition()

    Close.Font = Enum.Font.SourceSans
    Close.Text = ""
    Close.TextColor3 = Color3.fromRGB(0, 0, 0)
    Close.TextSize = 14
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Close.BackgroundTransparency = 0.999
    Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Name = "Close"
    Close.Parent = Top

    ImageLabel1.Image = "rbxassetid://9886659671"
    ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel1.BackgroundTransparency = 0.999
    ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel1.BorderSizePixel = 0
    ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
    ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
    ImageLabel1.Parent = Close

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

    ImageLabel2.Image = "rbxassetid://9886659276"
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel2.BackgroundTransparency = 0.999
    ImageLabel2.ImageTransparency = 0.2
    ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel2.BorderSizePixel = 0
    ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
    ImageLabel2.Parent = Min

    if GuiConfig.Content and GuiConfig.Content ~= "" then
        local ContentFrame = Instance.new("Frame")
        ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Size = UDim2.new(1, 0, 0, 25)
        ContentFrame.Position = UDim2.new(0, 0, 0, 38)
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Parent = Main

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Font = Enum.Font.GothamBold
        ContentLabel.Text = GuiConfig.Content
        ContentLabel.TextColor3 = GuiConfig.Color
        ContentLabel.TextSize = 14
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Center
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Center
        ContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentLabel.BorderSizePixel = 0
        ContentLabel.Size = UDim2.new(1, -20, 1, 0)
        ContentLabel.Position = UDim2.new(0, 10, 0, 0)
        ContentLabel.Parent = ContentFrame

        local Divider = Instance.new("Frame")
        Divider.BackgroundColor3 = GuiConfig.Color
        Divider.BackgroundTransparency = 0.8
        Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Divider.BorderSizePixel = 0
        Divider.Size = UDim2.new(1, -20, 0, 1)
        Divider.Position = UDim2.new(0, 10, 1, -1)
        Divider.Parent = ContentFrame
    end

    local LayersTab        = Instance.new("Frame")
    local UICorner2        = Instance.new("UICorner")
    local DecideFrame      = Instance.new("Frame")
    local Layers           = Instance.new("Frame")
    local UICorner6        = Instance.new("UICorner")
    local NameTab          = Instance.new("TextLabel")
    local LayersReal       = Instance.new("Frame")
    local LayersFolder     = Instance.new("Folder")
    local LayersPageLayout = Instance.new("UIPageLayout")

    local topOffset
    if GuiConfig.Content and GuiConfig.Content ~= "" then
        topOffset = 38 + 25 + 10
    else
        topOffset = 50
    end

    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 0.999
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 9, 0, topOffset)
    LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -(topOffset + 9))
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    UICorner2.CornerRadius = UDim.new(0, 2)
    UICorner2.Parent = LayersTab

    local ScrollTab    = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    ScrollTab.CanvasSize = UDim2.new(0, 0, 1.1, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollTab.BackgroundTransparency = 0.999
    ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.BorderSizePixel = 0
    ScrollTab.Name = "ScrollTab"

    local searchOffset = 0

    if GuiConfig.Search then
        searchOffset = 34
        SearchModule(GuiConfig, LayersTab, LayersFolder, LayersPageLayout, TweenService, searchOffset)
    end

    local ds = GuiConfig.DiscordSet
    local DISCORD_H      = 28
    local DISCORD_MARGIN = 3
    local discordBottomOffset = ds.Enable and ds.Link ~= "" and (DISCORD_H + DISCORD_MARGIN + 2) or 0

    if ds.Enable and ds.Link ~= "" then
        local resolvedIcon = getIconId(ds.Icon)
        if resolvedIcon == "" then resolvedIcon = "rbxassetid://7072725342" end

        local DiscordCard = Instance.new("TextButton")
        DiscordCard.Name                   = "DiscordCard"
        DiscordCard.AnchorPoint            = Vector2.new(0, 1)
        DiscordCard.Position               = UDim2.new(0, 3, 1, -DISCORD_MARGIN)
        DiscordCard.Size                   = UDim2.new(1, -18, 0, DISCORD_H)
        DiscordCard.BackgroundColor3       = Color3.fromRGB(22, 22, 28)
        DiscordCard.BackgroundTransparency = 0
        DiscordCard.BorderSizePixel        = 0
        DiscordCard.ClipsDescendants       = false
        DiscordCard.ZIndex                 = 100
        DiscordCard.Text                   = ""
        DiscordCard.Parent                 = LayersTab
        Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 5)

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color           = GuiConfig.Color
        CardStroke.Thickness       = 0.8
        CardStroke.Transparency    = 0.5
        CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        CardStroke.Parent          = DiscordCard

        task.spawn(function()
            local t = 0
            while DiscordCard and DiscordCard.Parent do
                local dt = task.wait(0.04)
                t = t + dt
                local pulse = (math.sin(t * 1.5) + 1) / 2
                CardStroke.Transparency = 0.2 + pulse * 0.55
            end
        end)

        local DIcon = Instance.new("ImageLabel")
        DIcon.BackgroundTransparency = 1
        DIcon.AnchorPoint   = Vector2.new(0, 0.5)
        DIcon.Position      = UDim2.new(0, 5, 0.5, 0)
        DIcon.Size          = UDim2.new(0, 18, 0, 18)
        DIcon.Image         = resolvedIcon
        DIcon.ImageColor3   = Color3.fromRGB(255, 255, 255)
        DIcon.ScaleType     = Enum.ScaleType.Fit
        DIcon.ZIndex        = 101
        DIcon.Parent        = DiscordCard

        local DTitle = Instance.new("TextLabel")
        DTitle.Font                 = Enum.Font.GothamBold
        DTitle.Text                 = string.upper(ds.Title)
        DTitle.TextColor3           = Color3.fromRGB(255, 255, 255)
        DTitle.TextSize             = 10
        DTitle.TextXAlignment       = Enum.TextXAlignment.Left
        DTitle.BackgroundTransparency = 1
        DTitle.AnchorPoint          = Vector2.new(0, 1)
        DTitle.Position             = UDim2.new(0, 28, 0.5, -1)
        DTitle.Size                 = UDim2.new(1, -32, 0, 11)
        DTitle.ZIndex               = 101
        DTitle.Parent               = DiscordCard

        local DSub = Instance.new("TextLabel")
        DSub.Font                 = Enum.Font.GothamBold
        DSub.Text                 = "JOIN DISCORD"
        DSub.TextColor3           = Color3.fromRGB(30, 200, 255)
        DSub.TextSize             = 8
        DSub.TextXAlignment       = Enum.TextXAlignment.Left
        DSub.BackgroundTransparency = 1
        DSub.AnchorPoint          = Vector2.new(0, 0)
        DSub.Position             = UDim2.new(0, 28, 0.5, 1)
        DSub.Size                 = UDim2.new(1, -32, 0, 10)
        DSub.ZIndex               = 101
        DSub.Parent               = DiscordCard

        local GradTitle = Instance.new("UIGradient")
        GradTitle.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
        })
        GradTitle.Rotation = 0
        GradTitle.Offset   = Vector2.new(-1, 0)
        GradTitle.Parent   = DTitle

        task.spawn(function()
            local dir   = 1
            local pos   = -1.0
            local speed = 0.8
            while DiscordCard and DiscordCard.Parent do
                local dt = task.wait(0.03)
                pos = pos + speed * dir * dt
                if pos >= 1.0 then pos = 1.0; dir = -1
                elseif pos <= -1.0 then pos = -1.0; dir = 1 end
                GradTitle.Offset = Vector2.new(pos, 0)
            end
        end)

        local _copied = false
        DiscordCard.Activated:Connect(function()
            if _copied then return end
            _copied = true
            pcall(function() setclipboard(ds.Link) end)
            local origText  = DSub.Text
            local origColor = DSub.TextColor3
            DSub.Text       = "LINK COPIED!"
            DSub.TextColor3 = Color3.fromRGB(180, 180, 180)
            task.wait(1.5)
            DSub.Text       = origText
            DSub.TextColor3 = origColor
            _copied = false
        end)
    end

    if GuiConfig.ShowUser then
        ScrollTab.Position = UDim2.new(0, 0, 0, searchOffset)
        ScrollTab.Size = UDim2.new(1, 0, 1, -(40 + searchOffset + discordBottomOffset))
    else
        ScrollTab.Position = UDim2.new(0, 0, 0, searchOffset)
        ScrollTab.Size = UDim2.new(1, 0, 1, -(searchOffset + discordBottomOffset))
    end

    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollTab

    local function UpdateSize1()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child.Name ~= "UIListLayout" then
                OffsetY = OffsetY + 3 + child.Size.Y.Offset
            end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateSize1)
    ScrollTab.ChildRemoved:Connect(UpdateSize1)

    if GuiConfig.ShowUser then
        local pfOffsetY = -(3 + discordBottomOffset)
        local PlayerFooter = Instance.new("Frame")
        PlayerFooter.Name = "PlayerFooter"
        PlayerFooter.AnchorPoint = Vector2.new(0, 1)
        PlayerFooter.BackgroundTransparency = 1
        PlayerFooter.BorderSizePixel = 0
        PlayerFooter.Position = UDim2.new(0, 3, 1, pfOffsetY)
        PlayerFooter.Size = UDim2.new(1, -18, 0, 40)
        PlayerFooter.Parent = LayersTab
        PlayerFooter.ZIndex = 100

        local PlayerAvatar = Instance.new("ImageLabel")
        PlayerAvatar.Name = "PlayerAvatar"
        PlayerAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        PlayerAvatar.BackgroundTransparency = 0.2
        PlayerAvatar.BorderSizePixel = 0
        PlayerAvatar.AnchorPoint = Vector2.new(0, 0.5)
        PlayerAvatar.Position = UDim2.new(0, 0, 0.5, 2)
        PlayerAvatar.Size = UDim2.new(0, 26, 0, 26)
        PlayerAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
        PlayerAvatar.Parent = PlayerFooter

        local AvatarCorner = Instance.new("UICorner")
        AvatarCorner.CornerRadius = UDim.new(1, 0)
        AvatarCorner.Parent = PlayerAvatar

        local AvatarStroke = Instance.new("UIStroke")
        AvatarStroke.Color = GuiConfig.Color
        AvatarStroke.Thickness = 1.2
        AvatarStroke.Transparency = 0.5
        AvatarStroke.Parent = PlayerAvatar

        local PlayerName = Instance.new("TextLabel")
        PlayerName.Name = "PlayerName"
        PlayerName.Font = Enum.Font.GothamBold

        local displayName = LocalPlayer.DisplayName
        local shortName = displayName
        if #displayName > 3 then
            shortName = string.sub(displayName, 1, 3) .. "***"
        end
        PlayerName.Text = "Welcome, " .. shortName

        PlayerName.TextColor3 = Color3.fromRGB(180, 180, 180)
        PlayerName.TextSize = 11
        PlayerName.TextXAlignment = Enum.TextXAlignment.Left
        PlayerName.BackgroundTransparency = 1
        PlayerName.Position = UDim2.new(0, 32, 0, 0)
        PlayerName.Size = UDim2.new(1, -32, 1, 0)
        PlayerName.TextTruncate = Enum.TextTruncate.None
        PlayerName.Parent = PlayerFooter
    end

    _G.ScrollTab = ScrollTab

    DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
    DecideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DecideFrame.BackgroundTransparency = 0.85
    DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DecideFrame.BorderSizePixel = 0
    DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
    DecideFrame.Size = UDim2.new(1, 0, 0, 1)
    DecideFrame.Name = "DecideFrame"
    DecideFrame.Parent = Main

    Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Layers.BackgroundTransparency = 0.999
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, topOffset)
    Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -(topOffset + 9))
    Layers.Name = "Layers"
    Layers.Parent = Main

    UICorner6.CornerRadius = UDim.new(0, 2)
    UICorner6.Parent = Layers

    NameTab.Font = Enum.Font.GothamBold
    NameTab.Text = ""
    NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.TextSize = 24
    NameTab.TextWrapped = true
    NameTab.TextXAlignment = Enum.TextXAlignment.Left
    NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.BackgroundTransparency = 0.999
    NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NameTab.BorderSizePixel = 0
    NameTab.Size = UDim2.new(1, 0, 0, 30)
    NameTab.Name = "NameTab"
    NameTab.Parent = Layers

    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersReal.BackgroundTransparency = 0.999
    LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersReal.BorderSizePixel = 0
    LayersReal.ClipsDescendants = true
    LayersReal.Position = UDim2.new(0, 0, 1, 0)
    LayersReal.Size = UDim2.new(1, 0, 1, -33)
    LayersReal.Name = "LayersReal"
    LayersReal.Parent = Layers

    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = LayersReal

    LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LayersPageLayout.Name = "LayersPageLayout"
    LayersPageLayout.Parent = LayersFolder
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

    function GuiFunc:DestroyGui()
        if CoreGui:FindFirstChild("VelarisUI") then
            Chloeex:Destroy()
        end
    end

    function GuiFunc:SetToggleKey(keyCode)
        GuiConfig.Keybind = keyCode
    end

    function GuiFunc:Tag(TagConfig)
        TagConfig = TagConfig or {}
        TagConfig.Title = TagConfig.Title or "Tag"
        TagConfig.Icon  = TagConfig.Icon or ""

        local function resolveColor(c)
            if typeof(c) == "Color3" then
                return c
            elseif type(c) == "string" then
                if c:sub(1,1) == "#" then
                    return Color3.fromHex(c)
                else
                    return getColor(c)
                end
            end
            return GuiConfig.Color
        end

        local tagColor = resolveColor(TagConfig.Color)

        local TagFrame = Instance.new("Frame")
        TagFrame.BackgroundColor3 = tagColor
        TagFrame.BackgroundTransparency = 0
        TagFrame.BorderSizePixel = 0
        TagFrame.AutomaticSize = Enum.AutomaticSize.X
        TagFrame.Size = UDim2.new(0, 0, 0, 22)
        TagFrame.Name = "Tag"
        TagFrame.ClipsDescendants = false
        TagFrame.Parent = TagContainer

        local TagCorner = Instance.new("UICorner")
        TagCorner.CornerRadius = UDim.new(1, 0)
        TagCorner.Parent = TagFrame

        local TagStroke = Instance.new("UIStroke")
        TagStroke.Color = tagColor
        TagStroke.Thickness = 1.5
        TagStroke.Transparency = 0.4
        TagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TagStroke.Parent = TagFrame

        local TagPadding = Instance.new("UIPadding")
        TagPadding.PaddingLeft = UDim.new(0, 8)
        TagPadding.PaddingRight = UDim.new(0, 8)
        TagPadding.Parent = TagFrame

        local TagInner = Instance.new("Frame")
        TagInner.BackgroundTransparency = 1
        TagInner.BorderSizePixel = 0
        TagInner.AutomaticSize = Enum.AutomaticSize.X
        TagInner.Size = UDim2.new(0, 0, 1, 0)
        TagInner.Parent = TagFrame

        local TagInnerList = Instance.new("UIListLayout")
        TagInnerList.FillDirection = Enum.FillDirection.Horizontal
        TagInnerList.VerticalAlignment = Enum.VerticalAlignment.Center
        TagInnerList.Padding = UDim.new(0, 4)
        TagInnerList.Parent = TagInner

        local TagIcon = Instance.new("ImageLabel")
        TagIcon.BackgroundTransparency = 1
        TagIcon.BorderSizePixel = 0
        TagIcon.Size = UDim2.new(0, 12, 0, 12)
        TagIcon.ImageColor3 = Color3.fromRGB(15, 15, 15)
        TagIcon.ScaleType = Enum.ScaleType.Fit
        TagIcon.LayoutOrder = 0
        TagIcon.Parent = TagInner

        local function applyIcon(iconName)
            local id = getIconId(iconName or "")
            TagIcon.Image = id
            TagIcon.Visible = (id ~= "")
        end
        applyIcon(TagConfig.Icon)

        local TagLabel = Instance.new("TextLabel")
        TagLabel.Font = Enum.Font.GothamBold
        TagLabel.Text = TagConfig.Title
        TagLabel.TextColor3 = Color3.fromRGB(15, 15, 15)
        TagLabel.TextSize = 11
        TagLabel.BackgroundTransparency = 1
        TagLabel.BorderSizePixel = 0
        TagLabel.AutomaticSize = Enum.AutomaticSize.X
        TagLabel.Size = UDim2.new(0, 0, 1, 0)
        TagLabel.LayoutOrder = 1
        TagLabel.Parent = TagInner

        task.defer(UpdateTagPosition)

        local TagApi = {}

        function TagApi:SetTitle(newTitle)
            TagLabel.Text = tostring(newTitle or "")
            task.defer(UpdateTagPosition)
        end

        function TagApi:SetIcon(iconName)
            applyIcon(iconName)
            task.defer(UpdateTagPosition)
        end

        function TagApi:SetColor(colorInput)
            local newColor = resolveColor(colorInput)
            TweenService:Create(TagFrame, TweenInfo.new(0.2), { BackgroundColor3 = newColor }):Play()
            TweenService:Create(TagStroke, TweenInfo.new(0.2), { Color = newColor }):Play()
        end

        function TagApi:Destroy()
            TagFrame:Destroy()
            task.defer(UpdateTagPosition)
        end

        TagApi.Frame = TagFrame
        return TagApi
    end

    local _lastPos = nil

    local function AnimateClose(callback)
        _lastPos = DropShadowHolder.Position
        DropShadowHolder.Visible = false
        if callback then callback() end
    end

    local function AnimateOpen()
        if _lastPos then
            DropShadowHolder.Position = _lastPos
        end
        DropShadowHolder.Visible = true
    end

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        AnimateClose()
    end)

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        Chloex:Dialog({
            Title = "Window",
            Content = "Do you want to close this window?\nYou will not be able to open it again",
            Buttons = {
                {
                    Name = "Yes",
                    Callback = function()
                        AnimateClose(function()
                            if Chloeex then Chloeex:Destroy() end
                            if GuiFunc._toggleGui then
                                pcall(function() GuiFunc._toggleGui:Destroy() end)
                                GuiFunc._toggleGui = nil
                            end
                        end)
                    end
                },
                {
                    Name = "Cancel",
                    Callback = function() end
                }
            }
        })
    end)

    function GuiFunc:ToggleUI()
        if GuiFunc._toggleGui then
            pcall(function() GuiFunc._toggleGui:Destroy() end)
            GuiFunc._toggleGui = nil
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Name = "ToggleUIButton"

        GuiFunc._toggleGui = ScreenGui

        local MainButton = Instance.new("ImageLabel")
        MainButton.Parent = ScreenGui
        MainButton.Size = UDim2.new(0, 40, 0, 40)
        MainButton.Position = UDim2.new(0, 20, 0, 100)
        MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        MainButton.BackgroundTransparency = 0.1
        MainButton.Image = "rbxassetid://" .. GuiConfig.Image
        MainButton.ScaleType = Enum.ScaleType.Fit

        local UICornerBtn = Instance.new("UICorner")
        UICornerBtn.CornerRadius = UDim.new(0, 8)
        UICornerBtn.Parent = MainButton

        local Button = Instance.new("TextButton")
        Button.Parent = MainButton
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""

        Button.MouseButton1Click:Connect(function()
            if DropShadowHolder then
                if DropShadowHolder.Visible then
                    AnimateClose(function()
                        DropShadowHolder.Visible = false
                        DropShadowHolder.Position = UDim2.new(
                            DropShadowHolder.Position.X.Scale,
                            DropShadowHolder.Position.X.Offset,
                            DropShadowHolder.Position.Y.Scale,
                            DropShadowHolder.Position.Y.Offset + 30
                        )
                    end)
                else
                    AnimateOpen()
                end
            end
        end)

        local dragging = false
        local dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            MainButton.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end

        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainButton.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    GuiFunc:ToggleUI()

    GuiConfig.Keybind = GuiConfig.Keybind or Enum.KeyCode.RightShift

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == GuiConfig.Keybind then
            if DropShadowHolder.Visible then
                AnimateClose(function()
                    DropShadowHolder.Visible = false
                    DropShadowHolder.Position = UDim2.new(
                        DropShadowHolder.Position.X.Scale,
                        DropShadowHolder.Position.X.Offset,
                        DropShadowHolder.Position.Y.Scale,
                        DropShadowHolder.Position.Y.Offset + 30
                    )
                end)
            else
                AnimateOpen()
            end
        end
    end)

    MakeDraggable(Top, DropShadowHolder, GuiConfig)

    local MoreBlur          = Instance.new("Frame")
    local DropShadowHolder1 = Instance.new("Frame")
    local DropShadow1       = Instance.new("ImageLabel")
    local UICorner28        = Instance.new("UICorner")
    local ConnectButton     = Instance.new("TextButton")

    MoreBlur.AnchorPoint = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BackgroundTransparency = 0.999
    MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MoreBlur.BorderSizePixel = 0
    MoreBlur.ClipsDescendants = true
    MoreBlur.Position = UDim2.new(1, 8, 1, 8)
    MoreBlur.Size = UDim2.new(1, 154, 1, 54)
    MoreBlur.Visible = false
    MoreBlur.Name = "MoreBlur"
    MoreBlur.Parent = Layers

    DropShadowHolder1.BackgroundTransparency = 1
    DropShadowHolder1.BorderSizePixel = 0
    DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder1.ZIndex = 0
    DropShadowHolder1.Name = "DropShadowHolder"
    DropShadowHolder1.Parent = MoreBlur

    DropShadow1.Image = "rbxassetid://6015897843"
    DropShadow1.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow1.ImageTransparency = 1
    DropShadow1.ScaleType = Enum.ScaleType.Slice
    DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow1.BackgroundTransparency = 1
    DropShadow1.BorderSizePixel = 0
    DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow1.Size = UDim2.new(1, 35, 1, 35)
    DropShadow1.ZIndex = 0
    DropShadow1.Name = "DropShadow"
    DropShadow1.Parent = DropShadowHolder1

    UICorner28.Parent = MoreBlur

    ConnectButton.Font = Enum.Font.SourceSans
    ConnectButton.Text = ""
    ConnectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.TextSize = 14
    ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ConnectButton.BackgroundTransparency = 0.999
    ConnectButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ConnectButton.BorderSizePixel = 0
    ConnectButton.Size = UDim2.new(1, 0, 1, 0)
    ConnectButton.Name = "ConnectButton"
    ConnectButton.Parent = MoreBlur

    local DropdownSelect     = Instance.new("Frame")
    local UICorner36         = Instance.new("UICorner")
    local UIStroke14         = Instance.new("UIStroke")
    local DropdownSelectReal = Instance.new("Frame")
    local DropdownFolder     = Instance.new("Folder")
    local DropPageLayout     = Instance.new("UIPageLayout")

    DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelect.BorderSizePixel = 0
    DropdownSelect.LayoutOrder = 1
    DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
    DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
    DropdownSelect.Name = "DropdownSelect"
    DropdownSelect.ClipsDescendants = true
    DropdownSelect.Parent = MoreBlur

    ConnectButton.Activated:Connect(function()
        if MoreBlur.Visible then
            TweenService:Create(DropdownSelect, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 172, 0.5, 0)
            }):Play()
            TweenService:Create(MoreBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 0.999
            }):Play()
            task.wait(0.3)
            MoreBlur.Visible = false
        end
    end)

    UICorner36.CornerRadius = UDim.new(0, 6)
    UICorner36.Parent = DropdownSelect

    UIStroke14.Color = GuiConfig.Color
    UIStroke14.Thickness = 1.5
    UIStroke14.Transparency = 0.7
    UIStroke14.Parent = DropdownSelect

    DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
    DropdownSelectReal.BackgroundColor3 = Color3.fromRGB(0, 27, 98)
    DropdownSelectReal.BackgroundTransparency = 0.7
    DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownSelectReal.BorderSizePixel = 0
    DropdownSelectReal.LayoutOrder = 1
    DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropdownSelectReal.Size = UDim2.new(1, 1, 1, 1)
    DropdownSelectReal.Name = "DropdownSelectReal"
    DropdownSelectReal.Parent = DropdownSelect

    DropdownFolder.Name = "DropdownFolder"
    DropdownFolder.Parent = DropdownSelectReal

    DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
    DropPageLayout.EasingStyle = Enum.EasingStyle.Quad
    DropPageLayout.TweenTime = 0.01
    DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropPageLayout.FillDirection = Enum.FillDirection.Vertical
    DropPageLayout.Archivable = false
    DropPageLayout.Name = "DropPageLayout"
    DropPageLayout.Parent = DropdownFolder

    local Tabs = TabsModule(
        GuiConfig,
        LayersFolder,
        LayersPageLayout,
        _G.ScrollTab,
        NameTab,
        MoreBlur,
        DropdownFolder,
        DropdownSelect,
        DropPageLayout,
        Elements,
        ElementsModule,
        KeybindModule,
        Mouse,
        TweenService,
        getIconId,
        CircleClick,
        function() end,
        {}
    )

    for k, v in pairs(Tabs) do
        GuiFunc[k] = v
    end

    if GuiConfig.Config.AutoLoad then
        task.defer(function()
            GuiFunc:LoadConfig(GuiConfig.Config.AutoSaveFile)
        end)
    end

    local origAddTab = GuiFunc.AddTab
    GuiFunc.AddTab = function(self, TabConfig)
        local Sections = origAddTab(self, TabConfig)
        local origAddSection = Sections.AddSection
        Sections.AddSection = function(self2, SectionConfig)
            local Items = origAddSection(self2, SectionConfig)

            local _itemCount = 0

            function Items:AddColorpicker(Config)
                local sa = rawget(self, "_sectionAdd") or (type(self) == "table" and self._sectionAdd)
                local ci = (type(self) == "table" and rawget(self, "_getCountItem") and self._getCountItem()) or _itemCount

                if not sa then
                    local origToggle = Items.AddToggle
                    if origToggle then
                        local origCreate = ElementsModule.CreateToggle
                        local probeFrame = nil
                        ElementsModule.CreateToggle = function(self_em, parent, cfg, ci2, ...)
                            probeFrame = parent
                            ElementsModule.CreateToggle = origCreate
                            return { Set = function() end, GetValue = function() return false end,
                                     Value = false, IgnoreConfig = false, Class = "Toggle" }
                        end
                        pcall(function()
                            Items:AddToggle({ Title = "__probe__", Default = false, Callback = function() end })
                        end)
                        ElementsModule.CreateToggle = origCreate
                        sa = probeFrame
                        if sa then
                            for _, child in ipairs(sa:GetChildren()) do
                                if child:IsA("Frame") and child:FindFirstChild("ToggleTitle") then
                                    local tt = child:FindFirstChild("ToggleTitle")
                                    if tt and tt.Text == "__probe__" then
                                        child:Destroy()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end

                if not sa then return {} end

                local api = _MakeColorPicker(Config, sa, ci, GuiConfig.Color, DropShadowHolder)
                _itemCount = _itemCount + 1
                return api
            end

            Items.AddColorPicker = Items.AddColorpicker

            local function _wrapElem(elem, Cfg, elemType, defaultVal)
                if not elem then return elem end
                if not Cfg.Flag or Cfg.Flag == "" then return elem end

                local key = tostring(Cfg.Flag)
                elem.Type    = elem.Type or elemType
                elem.Default = defaultVal
                elem.Flag    = key
                local saved = _ConfigData[key]
                if saved ~= nil and elem.Set then
                    pcall(function() elem:Set(saved) end)
                end
                local origSet = elem.Set
                if origSet then
                    elem.Set = function(self_e, val)
                        origSet(self_e, val)
                        _ConfigData[key] = val
                        if GuiConfig.Config.AutoSave then
                            GuiFunc:SaveConfig(GuiConfig.Config.AutoSaveFile)
                        end
                    end
                end
                _ConfigElements[key] = elem
                return elem
            end

            local origAddToggle = Items.AddToggle
            if origAddToggle then
                Items.AddToggle = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddToggle(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Toggle", Cfg.Default or false)
                end
            end

            local origAddSlider = Items.AddSlider
            if origAddSlider then
                Items.AddSlider = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddSlider(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Slider", Cfg.Default or 0)
                end
            end

            local origAddDropdown = Items.AddDropdown
            if origAddDropdown then
                Items.AddDropdown = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddDropdown(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Dropdown", Cfg.Default)
                end
            end

            local origAddInput = Items.AddInput
            if origAddInput then
                Items.AddInput = function(self3, Cfg)
                    Cfg = Cfg or {}
                    if Cfg.Flag and Cfg.Flag ~= "" then
                        local saved = _ConfigData[tostring(Cfg.Flag)]
                        if saved ~= nil then Cfg.Default = saved end
                    end
                    local elem = origAddInput(self3, Cfg)
                    return _wrapElem(elem, Cfg, "Input", Cfg.Default or "")
                end
            end

            return Items
        end
        return Sections
    end

    return GuiFunc
end

VelarisUI = Chloex

return Chloex
