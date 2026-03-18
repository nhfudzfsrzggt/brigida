-- // Vilaris Ui | Keybind.lua

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local KEY_LABELS = {
    RightShift="RShift", LeftShift="LShift",
    RightControl="RCtrl", LeftControl="LCtrl",
    RightAlt="RAlt", LeftAlt="LAlt",
    Return="Enter", BackSpace="Bksp",
    CapsLock="Caps", Delete="Del",
    Insert="Ins", PageUp="PgUp",
    PageDown="PgDn", Space="Space",
    Up="↑", Down="↓", Left="←", Right="→",
    F1="F1", F2="F2", F3="F3", F4="F4",
    F5="F5", F6="F6", F7="F7", F8="F8",
    F9="F9", F10="F10", F11="F11", F12="F12",
}

local MODIFIER_NAMES = {
    LeftShift=true, RightShift=true,
    LeftControl=true, RightControl=true,
    LeftAlt=true, RightAlt=true,
    CapsLock=true, Tab=true,
}

local MB_TO_NAME = {
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
}
local NAME_TO_MB = {
    MB1 = Enum.UserInputType.MouseButton1,
    MB2 = Enum.UserInputType.MouseButton2,
    MB3 = Enum.UserInputType.MouseButton3,
}

local BADGE_COLORS = {
    New=Color3.fromRGB(60,200,100),   Warning=Color3.fromRGB(255,165,0),
    Bug=Color3.fromRGB(220,50,50),    Beta=Color3.fromRGB(140,80,255),
    Hot=Color3.fromRGB(255,80,80),    Fixed=Color3.fromRGB(50,200,80),
    Soon=Color3.fromRGB(100,160,255),
}
local BADGE_PULSE = { New=true, Warning=true, Bug=true, Hot=true }

-- Ukuran pill: Full kalau ada key, Small kalau kosong
local SZ_FULL  = UDim2.new(0, 90, 0, 24)
local SZ_SMALL = UDim2.new(0, 28, 0, 24)

local GuiConfig  = { Color = Color3.fromRGB(0, 208, 255) }
local ConfigData = {}
local SaveConfig = function() end

local function isNone(k)
    return k == nil or k == "" or k == "None"
end

local function keyLabel(k)
    if isNone(k) then return "—" end
    return KEY_LABELS[k] or tostring(k)
end

local function cfgKey(cfg)
    if cfg.Flag and cfg.Flag ~= "" then return cfg.Flag end
    return "Keybind_" .. (cfg.Title or "Untitled")
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[keybind.lua]", err) end
end

local function tw(inst, t, props)
    TweenService:Create(
        inst,
        TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function makeBadge(parent, badgeType)
    local col   = BADGE_COLORS[badgeType] or GuiConfig.Color
    local pulse = BADGE_PULSE[badgeType] or false

    local f = Instance.new("Frame")
    f.Name = badgeType.."Badge"
    f.AnchorPoint = Vector2.new(1, 0)
    f.Position = UDim2.new(1, -6, 0, 6)
    f.Size = UDim2.new(0, 10, 0, 18)
    f.BackgroundColor3 = col
    f.BackgroundTransparency = 0.78
    f.BorderSizePixel = 0
    f.ZIndex = 5
    f.ClipsDescendants = false
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Color = col; stroke.Thickness = 1; stroke.Transparency = 0.5
    stroke.Parent = f

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,5,0,5)
    dot.AnchorPoint = Vector2.new(0,0.5)
    dot.Position = UDim2.new(0,6,0.5,0)
    dot.BackgroundColor3 = col
    dot.BorderSizePixel = 0; dot.ZIndex = 7
    dot.Parent = f
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = string.upper(badgeType)
    lbl.TextColor3 = col; lbl.TextTransparency = 0.05
    lbl.TextSize = 9; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.AnchorPoint = Vector2.new(0,0.5)
    lbl.Position = UDim2.new(0,14,0.5,0)
    lbl.Size = UDim2.new(1,-18,1,0)
    lbl.ZIndex = 6; lbl.Parent = f

    lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
        task.wait()
        if lbl.Parent then
            f.Size = UDim2.new(0, math.max(30, lbl.TextBounds.X + 22), 0, 18)
        end
    end)
    task.defer(function()
        if lbl.Parent then
            f.Size = UDim2.new(0, math.max(30, lbl.TextBounds.X + 22), 0, 18)
        end
    end)

    if pulse then
        local sIn  = TweenService:Create(stroke, TweenInfo.new(0.85,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Transparency=0.1})
        local sOut = TweenService:Create(stroke, TweenInfo.new(0.85,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Transparency=0.65})
        local dIn  = TweenService:Create(dot,    TweenInfo.new(0.85,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {BackgroundTransparency=0.55})
        local dOut = TweenService:Create(dot,    TweenInfo.new(0.85,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {BackgroundTransparency=0})
        sIn.Completed:Connect(function() sOut:Play() end)
        sOut.Completed:Connect(function() sIn:Play() end)
        dIn.Completed:Connect(function() dOut:Play() end)
        dOut.Completed:Connect(function() dIn:Play() end)
        sIn:Play() dIn:Play()
    end
end

local function makeLock(frame, locked)
    local lk = { IsLocked = locked == true }
    local ov, pillLbl
    local _dead = false

    local function build()
        if _dead then return end
        if ov and ov.Parent then ov:Destroy() end

        ov = Instance.new("TextButton")
        ov.Text = ""; ov.AutoButtonColor = false
        ov.Size = UDim2.new(1,0,1,0)
        ov.BackgroundColor3 = Color3.fromRGB(8,8,14)
        ov.BackgroundTransparency = 0.38
        ov.BorderSizePixel = 0; ov.ZIndex = 10
        ov.Visible = lk.IsLocked; ov.Parent = frame
        Instance.new("UICorner", ov).CornerRadius = UDim.new(0,4)
        local st = Instance.new("UIStroke", ov)
        st.Color = Color3.fromRGB(255,255,255); st.Thickness = 1; st.Transparency = 0.82

        local pill = Instance.new("Frame", ov)
        pill.AnchorPoint = Vector2.new(0.5,0.5)
        pill.Position = UDim2.new(0.5,0,0.5,0)
        pill.Size = UDim2.new(0,84,0,22)
        pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        pill.BackgroundTransparency = 0.88
        pill.BorderSizePixel = 0; pill.ZIndex = 11
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
        local ps = Instance.new("UIStroke", pill)
        ps.Color = Color3.fromRGB(255,255,255); ps.Thickness = 1; ps.Transparency = 0.72

        local ico = Instance.new("ImageLabel", pill)
        ico.Size = UDim2.new(0,12,0,12); ico.AnchorPoint = Vector2.new(0,0.5)
        ico.Position = UDim2.new(0,8,0.5,0); ico.BackgroundTransparency = 1
        ico.Image = "rbxassetid://134724289526879"
        ico.ImageColor3 = Color3.fromRGB(210,210,210)
        ico.ScaleType = Enum.ScaleType.Fit; ico.ZIndex = 12

        pillLbl = Instance.new("TextLabel", pill)
        pillLbl.Font = Enum.Font.GothamBold; pillLbl.Text = "Locked"
        pillLbl.TextSize = 11; pillLbl.TextColor3 = Color3.fromRGB(210,210,210)
        pillLbl.BackgroundTransparency = 1; pillLbl.ZIndex = 12
        pillLbl.AnchorPoint = Vector2.new(0,0.5)
        pillLbl.Position = UDim2.new(0,24,0.5,0)
        pillLbl.Size = UDim2.new(1,-28,1,0)
        pillLbl.TextXAlignment = Enum.TextXAlignment.Left
        pillLbl.TextTruncate = Enum.TextTruncate.AtEnd

        pillLbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
            task.wait()
            if pillLbl.Parent then
                pill.Size = UDim2.new(0, math.max(60, pillLbl.TextBounds.X + 36), 0, 22)
            end
        end)

        ov.MouseButton1Click:Connect(function()
            if not pill.Parent then return end
            local w = pill.Size.X.Offset
            TweenService:Create(pill, TweenInfo.new(0.08,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size=UDim2.new(0,w+6,0,26)}):Play()
            task.delay(0.18, function()
                if pill.Parent then
                    TweenService:Create(pill, TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {Size=UDim2.new(0,w,0,22)}):Play()
                end
            end)
        end)
    end

    build()
    frame.DescendantRemoving:Connect(function(d)
        if d == ov and lk.IsLocked and not _dead then task.defer(build) end
    end)
    frame.AncestryChanged:Connect(function(_, p)
        if p == nil then _dead = true end
    end)

    function lk:SetLocked(s)
        lk.IsLocked = s == true
        if ov then ov.Visible = lk.IsLocked end
        if lk.IsLocked and (not ov or not ov.Parent) then build() end
    end
    function lk:GetLocked() return lk.IsLocked end
    function lk:SetMessage(msg)
        if pillLbl then pillLbl.Text = tostring(msg or "Locked") end
    end
    return lk
end

-- =============================================================================

local KeybindModule = {}

function KeybindModule:Initialize(config, saveFunc, configData)
    if config     then GuiConfig  = config     end
    if saveFunc   then SaveConfig = saveFunc   end
    if configData then ConfigData = configData end
end

function KeybindModule:CreateKeybind(SectionAdd, KeybindConfig, CountItem, Elements)
    KeybindConfig          = KeybindConfig or {}
    KeybindConfig.Title    = KeybindConfig.Title    or "Keybind"
    KeybindConfig.Content  = KeybindConfig.Content  or ""
    KeybindConfig.Value    = KeybindConfig.Value    or "None"
    KeybindConfig.Mode     = KeybindConfig.Mode     or "Toggle"
    KeybindConfig.Modes    = KeybindConfig.Modes    or {"Toggle","Hold","Always"}
    KeybindConfig.Callback = KeybindConfig.Callback or function() end
    KeybindConfig.Changed  = KeybindConfig.Changed  or function() end
    KeybindConfig.Badge    = KeybindConfig.Badge    or nil
    KeybindConfig.Locked   = KeybindConfig.Locked   or false
    KeybindConfig.LockMsg  = KeybindConfig.LockMsg  or "Locked"

    -- Load nilai tersimpan
    local ck    = cfgKey(KeybindConfig)
    local saved = ConfigData[ck]
    if type(saved) == "table" then
        if type(saved.Key) == "string" and saved.Key ~= "" then
            KeybindConfig.Value = saved.Key
        end
        if type(saved.Mode) == "string" and table.find(KeybindConfig.Modes, saved.Mode) then
            KeybindConfig.Mode = saved.Mode
        end
    elseif type(saved) == "string" and saved ~= "" then
        KeybindConfig.Value = saved
    end

    -- Pastikan Value adalah string yang bersih
    if type(KeybindConfig.Value) ~= "string" then
        KeybindConfig.Value = "None"
    end

    local curKey    = KeybindConfig.Value
    local curMode   = KeybindConfig.Mode
    local toggled   = false
    local listening = false
    local listenC, trigC, trigEndC

    -- Tentukan tampilan awal key
    local hasKey     = not isNone(curKey)
    local initText   = hasKey and keyLabel(curKey) or "—"
    local initSize   = hasKey and SZ_FULL or SZ_SMALL

    -- Frame utama row
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.BackgroundColor3       = Color3.fromRGB(255,255,255)
    KeybindFrame.BackgroundTransparency = 0.935
    KeybindFrame.BorderSizePixel        = 0
    KeybindFrame.LayoutOrder            = CountItem
    KeybindFrame.Size                   = UDim2.new(1,0,0,46)
    KeybindFrame.Name                   = "KeybindFrame"
    KeybindFrame.ClipsDescendants       = false
    KeybindFrame.Parent                 = SectionAdd
    Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0,4)

    if KeybindConfig.Badge then makeBadge(KeybindFrame, KeybindConfig.Badge) end

    local KBTitle = Instance.new("TextLabel")
    KBTitle.Font               = Enum.Font.GothamBold
    KBTitle.Text               = KeybindConfig.Title
    KBTitle.TextColor3         = Color3.fromRGB(231,231,231)
    KBTitle.TextSize           = 13
    KBTitle.TextXAlignment     = Enum.TextXAlignment.Left
    KBTitle.TextYAlignment     = Enum.TextYAlignment.Top
    KBTitle.BackgroundTransparency = 1
    KBTitle.Position           = UDim2.new(0,10,0,10)
    KBTitle.Size               = UDim2.new(1,-150,0,13)
    KBTitle.Parent             = KeybindFrame

    local KBContent = Instance.new("TextLabel")
    KBContent.Font               = Enum.Font.GothamBold
    KBContent.Text               = KeybindConfig.Content
    KBContent.TextColor3         = Color3.fromRGB(255,255,255)
    KBContent.TextSize           = 12
    KBContent.TextTransparency   = 0.6
    KBContent.TextXAlignment     = Enum.TextXAlignment.Left
    KBContent.TextYAlignment     = Enum.TextYAlignment.Bottom
    KBContent.BackgroundTransparency = 1
    KBContent.TextWrapped        = true
    KBContent.Position           = UDim2.new(0,10,0,25)
    KBContent.Size               = UDim2.new(1,-150,0,12)
    KBContent.Parent             = KeybindFrame

    KBContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        KBContent.TextWrapped = false
        local lines = math.max(1, KBContent.TextBounds.X // math.max(1, KBContent.AbsoluteSize.X))
        KBContent.Size = UDim2.new(1,-150,0, 12 + 12*lines)
        KeybindFrame.Size = UDim2.new(1,0,0, KBContent.AbsoluteSize.Y + 40)
        KBContent.TextWrapped = true
    end)

    -- Key pill — TIDAK ClipsDescendants supaya tidak memotong text
    local InputFrame = Instance.new("Frame")
    InputFrame.AnchorPoint            = Vector2.new(1,0.5)
    InputFrame.BackgroundColor3       = Color3.fromRGB(255,255,255)
    InputFrame.BackgroundTransparency = 0.92
    InputFrame.BorderSizePixel        = 0
    InputFrame.Position               = UDim2.new(1,-7,0.5,0)
    InputFrame.Size                   = initSize
    InputFrame.Name                   = "InputFrame"
    InputFrame.Parent                 = KeybindFrame
    Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0,4)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color           = Color3.fromRGB(255,255,255)
    InputStroke.Thickness       = 1
    InputStroke.Transparency    = 0.82
    InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    InputStroke.Parent          = InputFrame

    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.AnchorPoint            = Vector2.new(0.5,0.5)
    KeyLabel.Font                   = Enum.Font.GothamBold
    KeyLabel.Text                   = initText
    KeyLabel.TextColor3             = hasKey and Color3.fromRGB(220,220,220) or Color3.fromRGB(100,100,100)
    KeyLabel.TextSize               = 11
    KeyLabel.TextXAlignment         = Enum.TextXAlignment.Center
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Position               = UDim2.new(0.5,0,0.5,0)
    KeyLabel.Size                   = UDim2.new(1,0,1,0)
    KeyLabel.Parent                 = InputFrame

    -- Label mode di bawah pill
    local ModeLbl = Instance.new("TextLabel")
    ModeLbl.Font               = Enum.Font.Gotham
    ModeLbl.Text               = curMode
    ModeLbl.TextColor3         = Color3.fromRGB(255,255,255)
    ModeLbl.TextSize           = 10
    ModeLbl.TextTransparency   = 0.65
    ModeLbl.TextXAlignment     = Enum.TextXAlignment.Right
    ModeLbl.BackgroundTransparency = 1
    ModeLbl.AnchorPoint        = Vector2.new(1,1)
    ModeLbl.Position           = UDim2.new(1,-7,1,-4)
    ModeLbl.Size               = UDim2.new(0,110,0,12)
    ModeLbl.Parent             = KeybindFrame

    -- Tombol transparan di atas pill untuk handle klik
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Text               = ""
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.AutoButtonColor    = false
    ClickBtn.ZIndex             = 5
    ClickBtn.Size               = UDim2.new(1,0,1,0)
    ClickBtn.Parent             = InputFrame

    -- Mode dropdown menu
    local ModeMenu = Instance.new("Frame")
    ModeMenu.Name               = "ModeMenu"
    ModeMenu.AnchorPoint        = Vector2.new(1,0)
    ModeMenu.BackgroundColor3   = Color3.fromRGB(16,16,22)
    ModeMenu.BackgroundTransparency = 0.04
    ModeMenu.BorderSizePixel    = 0
    ModeMenu.Size               = UDim2.new(0,112,0, #KeybindConfig.Modes * 26 + 10)
    ModeMenu.Position           = UDim2.new(1,-7,0,32)
    ModeMenu.ZIndex             = 50
    ModeMenu.Visible            = false
    ModeMenu.ClipsDescendants   = false
    ModeMenu.Parent             = KeybindFrame
    Instance.new("UICorner", ModeMenu).CornerRadius = UDim.new(0,6)

    local MMStroke = Instance.new("UIStroke", ModeMenu)
    MMStroke.Color = Color3.fromRGB(255,255,255)
    MMStroke.Thickness = 1; MMStroke.Transparency = 0.82

    local MML = Instance.new("UIListLayout", ModeMenu)
    MML.Padding = UDim.new(0,2); MML.SortOrder = Enum.SortOrder.LayoutOrder

    local MMP = Instance.new("UIPadding", ModeMenu)
    MMP.PaddingTop    = UDim.new(0,4); MMP.PaddingBottom = UDim.new(0,4)
    MMP.PaddingLeft   = UDim.new(0,4); MMP.PaddingRight  = UDim.new(0,4)

    -- ──────────────────────────────────────────────────────────────
    local ModeButtons = {}
    local updateLabel, updateTrigger

    updateLabel = function()
        local has = not isNone(curKey)
        KeyLabel.Text      = has and keyLabel(curKey) or "—"
        KeyLabel.TextColor3 = has
            and Color3.fromRGB(220,220,220)
            or  Color3.fromRGB(100,100,100)
        tw(InputFrame, 0.18, { Size = has and SZ_FULL or SZ_SMALL })
    end

    -- Hanya ubah visual ke listening, JANGAN panggil ini saat init
    local function setListeningVisual(on)
        if on then
            KeyLabel.Text       = "..."
            KeyLabel.TextColor3 = Color3.fromRGB(130,130,130)
            tw(InputFrame,  0.15, {Size=SZ_FULL, BackgroundTransparency=0.85})
            tw(InputStroke, 0.15, {Color=GuiConfig.Color, Transparency=0.2})
        else
            updateLabel()
            tw(InputFrame,  0.15, {BackgroundTransparency=0.92})
            tw(InputStroke, 0.15, {Color=Color3.fromRGB(255,255,255), Transparency=0.82})
        end
    end

    local function saveState()
        ConfigData[ck] = { Key = curKey, Mode = curMode }
        SaveConfig()
    end

    updateTrigger = function()
        if trigC    then trigC:Disconnect();    trigC    = nil end
        if trigEndC then trigEndC:Disconnect(); trigEndC = nil end
        if isNone(curKey) or curMode == "Always" then return end

        local function matches(input)
            if NAME_TO_MB[curKey] then
                return input.UserInputType == NAME_TO_MB[curKey]
            end
            return input.UserInputType == Enum.UserInputType.Keyboard
                and input.KeyCode.Name == curKey
        end

        trigC = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe or listening then return end
            if UserInputService:GetFocusedTextBox() then return end
            if not matches(input) then return end
            if curMode == "Toggle" then
                toggled = not toggled
                safeCall(KeybindConfig.Callback, curKey)
            elseif curMode == "Hold" then
                toggled = true
                safeCall(KeybindConfig.Callback, curKey)
            end
        end)

        if curMode == "Hold" then
            trigEndC = UserInputService.InputEnded:Connect(function(input)
                if UserInputService:GetFocusedTextBox() then return end
                if not matches(input) then return end
                toggled = false
                safeCall(KeybindConfig.Callback, curKey)
            end)
        end
    end

    -- Tombol per mode
    for i, modeName in ipairs(KeybindConfig.Modes) do
        local active = modeName == curMode

        local Btn = Instance.new("TextButton")
        Btn.Font               = Enum.Font.GothamBold
        Btn.Text               = modeName; Btn.TextSize = 12
        Btn.TextColor3         = Color3.fromRGB(220,220,220)
        Btn.TextTransparency   = active and 0 or 0.45
        Btn.TextXAlignment     = Enum.TextXAlignment.Left
        Btn.BackgroundColor3   = active and GuiConfig.Color or Color3.fromRGB(255,255,255)
        Btn.BackgroundTransparency = active and 0.68 or 1
        Btn.BorderSizePixel    = 0; Btn.AutoButtonColor = false
        Btn.Size               = UDim2.new(1,0,0,24)
        Btn.ZIndex             = 51; Btn.LayoutOrder = i
        Btn.Parent             = ModeMenu
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,4)
        Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0,8)

        local Dot = Instance.new("Frame", Btn)
        Dot.AnchorPoint        = Vector2.new(1,0.5)
        Dot.Position           = UDim2.new(1,-8,0.5,0)
        Dot.BackgroundColor3   = Color3.fromRGB(255,255,255)
        Dot.BackgroundTransparency = active and 0.2 or 1
        Dot.BorderSizePixel    = 0; Dot.ZIndex = 52
        Dot.Size               = active and UDim2.new(0,5,0,5) or UDim2.new(0,0,0,0)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

        ModeButtons[modeName] = { Btn=Btn, Dot=Dot }

        Btn.MouseEnter:Connect(function()
            if modeName == curMode then return end
            tw(Btn, 0.1, {BackgroundTransparency=0.86})
        end)
        Btn.MouseLeave:Connect(function()
            if modeName == curMode then return end
            tw(Btn, 0.1, {BackgroundTransparency=1})
        end)
        Btn.MouseButton1Click:Connect(function()
            for mn, mb in pairs(ModeButtons) do
                local a = mn == modeName
                tw(mb.Btn, 0.15, {
                    TextTransparency       = a and 0 or 0.45,
                    BackgroundColor3       = a and GuiConfig.Color or Color3.fromRGB(255,255,255),
                    BackgroundTransparency = a and 0.68 or 1,
                })
                tw(mb.Dot, 0.15, {
                    Size                   = a and UDim2.new(0,5,0,5) or UDim2.new(0,0,0,0),
                    BackgroundTransparency = a and 0.2 or 1,
                })
            end
            curMode = modeName; ModeLbl.Text = modeName
            ModeMenu.Visible = false
            saveState()
            safeCall(KeybindConfig.Changed, curKey, curMode)
            updateTrigger()
        end)
    end

    -- Hover
    ClickBtn.MouseEnter:Connect(function()
        if listening then return end
        tw(InputFrame,  0.15, {BackgroundTransparency=0.85})
        tw(InputStroke, 0.15, {Transparency=0.5})
    end)
    ClickBtn.MouseLeave:Connect(function()
        if listening then return end
        tw(InputFrame,  0.15, {BackgroundTransparency=0.92})
        tw(InputStroke, 0.15, {Transparency=0.82})
    end)

    local function cancelListening()
        if listenC then listenC:Disconnect(); listenC = nil end
        listening = false
        setListeningVisual(false)
    end

    -- Left click: mulai/batal listening
    ClickBtn.MouseButton1Click:Connect(function()
        if ModeMenu.Visible then ModeMenu.Visible = false return end
        if listening then cancelListening() return end

        listening = true
        setListeningVisual(true)

        listenC = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            local isKb = input.UserInputType == Enum.UserInputType.Keyboard
            local isMb = MB_TO_NAME[input.UserInputType] ~= nil
            if not isKb and not isMb then return end
            if isKb and MODIFIER_NAMES[input.KeyCode.Name] then return end

            if isKb and input.KeyCode == Enum.KeyCode.Escape then
                listenC:Disconnect(); listenC = nil
                listening = false; curKey = "None"
                setListeningVisual(false)
                saveState()
                safeCall(KeybindConfig.Changed, curKey, curMode)
                updateTrigger()
                return
            end

            curKey = isKb and input.KeyCode.Name or MB_TO_NAME[input.UserInputType]
            if not curKey then return end

            listenC:Disconnect(); listenC = nil
            listening = false
            setListeningVisual(false)
            saveState()
            safeCall(KeybindConfig.Changed, curKey, curMode)
            updateTrigger()
        end)
    end)

    -- Right click: buka mode menu
    local _menuJustOpened = false
    ClickBtn.MouseButton2Click:Connect(function()
        if #KeybindConfig.Modes <= 1 then return end
        ModeMenu.Visible = not ModeMenu.Visible
        if ModeMenu.Visible then
            ModeMenu.BackgroundTransparency = 0.5
            tw(ModeMenu, 0.15, {BackgroundTransparency=0.04})
            _menuJustOpened = true
            task.defer(function() _menuJustOpened = false end)
        end
    end)

    local globalMenuC = UserInputService.InputBegan:Connect(function(input)
        if not ModeMenu.Visible or _menuJustOpened then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.MouseButton2 then
            task.defer(function()
                if ModeMenu.Visible then ModeMenu.Visible = false end
            end)
        end
    end)

    local LockCtrl = makeLock(KeybindFrame, KeybindConfig.Locked)
    if KeybindConfig.LockMsg ~= "Locked" then
        LockCtrl:SetMessage(KeybindConfig.LockMsg)
    end

    updateTrigger()

    -- API
    local KeybindFunc = {}

    function KeybindFunc:Set(value, silent)
        curKey = (isNone(value) or type(value) ~= "string") and "None" or value
        updateLabel()
        updateTrigger()
        saveState()
        if not silent then safeCall(KeybindConfig.Changed, curKey, curMode) end
    end

    function KeybindFunc:Get()     return curKey  end
    function KeybindFunc:GetMode() return curMode end

    function KeybindFunc:SetMode(mode)
        if not table.find(KeybindConfig.Modes, mode) then return end
        for mn, mb in pairs(ModeButtons) do
            local a = mn == mode
            mb.Btn.TextTransparency        = a and 0 or 0.45
            mb.Btn.BackgroundColor3        = a and GuiConfig.Color or Color3.fromRGB(255,255,255)
            mb.Btn.BackgroundTransparency  = a and 0.68 or 1
            mb.Dot.Size                    = a and UDim2.new(0,5,0,5) or UDim2.new(0,0,0,0)
            mb.Dot.BackgroundTransparency  = a and 0.2 or 1
        end
        curMode = mode; ModeLbl.Text = mode
        saveState(); updateTrigger()
    end

    function KeybindFunc:GetState()
        if curMode == "Always" then return true end
        if curMode == "Hold" then
            if isNone(curKey) then return false end
            if NAME_TO_MB[curKey] then
                return UserInputService:IsMouseButtonPressed(NAME_TO_MB[curKey])
                    and not UserInputService:GetFocusedTextBox()
            end
            local ok, kc = pcall(function() return Enum.KeyCode[curKey] end)
            return ok and UserInputService:IsKeyDown(kc)
                       and not UserInputService:GetFocusedTextBox()
                       or false
        end
        return toggled
    end

    function KeybindFunc:Clear(silent)      KeybindFunc:Set("None", silent)         end
    function KeybindFunc:SetTitle(t)        KBTitle.Text = tostring(t or "Keybind") end
    function KeybindFunc:SetContent(t)      KBContent.Text = tostring(t or "")      end
    function KeybindFunc:SetLocked(s)       LockCtrl:SetLocked(s)                   end
    function KeybindFunc:GetLocked()        return LockCtrl:GetLocked()             end
    function KeybindFunc:SetLockMessage(m)  LockCtrl:SetMessage(m)                  end

    function KeybindFunc:Destroy()
        if listenC     then listenC:Disconnect()     end
        if trigC       then trigC:Disconnect()       end
        if trigEndC    then trigEndC:Disconnect()    end
        if globalMenuC then globalMenuC:Disconnect() end
        KeybindFrame:Destroy()
    end

    if KeybindConfig.Flag and KeybindConfig.Flag ~= "" and Elements then
        Elements[KeybindConfig.Flag] = KeybindFunc
    end

    return KeybindFunc
end

return KeybindModule
