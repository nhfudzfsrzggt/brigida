-- Velaris UI | KeySystem | Type = "pandadeveloper"

local function PandaDeveloperKeySystem(ks, GuiConfig, CoreGui, TweenService, getIconId, ConfigFolder)
    local accentColor = typeof(GuiConfig.Color) == "Color3" and GuiConfig.Color or Color3.fromRGB(0, 208, 255)

    local function getPandaObj()
        if type(_G.PandaDeveloper) == "table" then return _G.PandaDeveloper end
        if type(_G.pandaDeveloper) == "table" then return _G.pandaDeveloper end
        if type(_G.PandaKey)       == "table" then return _G.PandaKey       end
        if type(_G.pandakey)       == "table" then return _G.pandakey       end
        if type(_G.Panda)          == "table" then return _G.Panda          end
        local ok, env = pcall(getfenv)
        if ok and type(env) == "table" then
            if type(env.PandaDeveloper) == "table" then return env.PandaDeveloper end
            if type(env.PandaKey)       == "table" then return env.PandaKey       end
        end
        return nil
    end

    local function checkKey(key)
        local pd = getPandaObj()
        if not pd then warn("[VelarisUI/PandaDeveloper] Object tidak ditemukan di _G.") return false end
        local fn = pd.CheckKey or pd.checkKey or pd.check or pd.Validate or pd.validate or pd.VerifyKey or pd.verifyKey
        if type(fn) ~= "function" then warn("[VelarisUI/PandaDeveloper] Method CheckKey tidak ditemukan.") return false end
        local ok, result = pcall(fn, pd, key)
        return ok and result == true
    end

    local keyFileName = (type(ks.KeyFile) == "string" and ks.KeyFile ~= "") and ks.KeyFile or "CHX_panda_key"
    local keyFilePath = ConfigFolder .. "/Config/" .. keyFileName .. ".txt"

    local function saveKey(key)
        if writefile then pcall(writefile, keyFilePath, key) end
    end

    local function loadKey()
        if isfile and readfile and isfile(keyFilePath) then
            local ok, val = pcall(readfile, keyFilePath)
            if ok and type(val) == "string" and #val > 0 then return val end
        end
        return nil
    end

    if ks.SaveKey then
        local saved = loadKey()
        if saved and checkKey(saved) then return true end
    end

    local resolved = false
    local thread = coroutine.running()

    local KsGui = Instance.new("ScreenGui")
    KsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    KsGui.Name = "KeySystemGui"
    KsGui.ResetOnSpawn = false
    KsGui.Parent = CoreGui

    local Card = Instance.new("Frame")
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.new(0.5, 0, 0.45, 0)
    Card.Size = UDim2.new(0, 300, 0, 184)
    Card.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.ZIndex = 101
    Card.Parent = KsGui
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(38, 38, 48)
    CardStroke.Thickness = 1
    CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local IconBox = Instance.new("Frame")
    IconBox.Size = UDim2.new(0, 24, 0, 24)
    IconBox.Position = UDim2.new(0, 14, 0, 16)
    IconBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    IconBox.BorderSizePixel = 0
    IconBox.ZIndex = 102
    IconBox.Parent = Card
    Instance.new("UICorner", IconBox).CornerRadius = UDim.new(0, 6)
    local IBS = Instance.new("UIStroke", IconBox)
    IBS.Color = Color3.fromRGB(50, 50, 62)
    IBS.Thickness = 1

    local ksIconId = getIconId(ks.Icon or "")
    local KsIconImg = Instance.new("ImageLabel")
    KsIconImg.AnchorPoint = Vector2.new(0.5, 0.5)
    KsIconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    KsIconImg.Size = UDim2.new(0, 13, 0, 13)
    KsIconImg.BackgroundTransparency = 1
    KsIconImg.BorderSizePixel = 0
    KsIconImg.Image = ksIconId ~= "" and ksIconId or "rbxassetid://6031094678"
    KsIconImg.ImageColor3 = Color3.fromRGB(180, 180, 190)
    KsIconImg.ScaleType = Enum.ScaleType.Fit
    KsIconImg.ZIndex = 103
    KsIconImg.Parent = IconBox

    local Badge = Instance.new("Frame")
    Badge.AnchorPoint = Vector2.new(1, 0)
    Badge.Position = UDim2.new(1, -10, 0, 10)
    Badge.Size = UDim2.new(0, 0, 0, 18)
    Badge.AutomaticSize = Enum.AutomaticSize.X
    Badge.BackgroundColor3 = Color3.fromRGB(30, 120, 60)
    Badge.BorderSizePixel = 0
    Badge.ZIndex = 104
    Badge.Parent = Card
    Instance.new("UICorner", Badge).CornerRadius = UDim.new(1, 0)
    local BP = Instance.new("UIPadding", Badge)
    BP.PaddingLeft = UDim.new(0, 6)
    BP.PaddingRight = UDim.new(0, 6)
    local BadgeLabel = Instance.new("TextLabel", Badge)
    BadgeLabel.Font = Enum.Font.GothamBold
    BadgeLabel.Text = "PANDA"
    BadgeLabel.TextColor3 = Color3.fromRGB(180, 240, 200)
    BadgeLabel.TextSize = 9
    BadgeLabel.BackgroundTransparency = 1
    BadgeLabel.BorderSizePixel = 0
    BadgeLabel.Size = UDim2.new(0, 0, 1, 0)
    BadgeLabel.AutomaticSize = Enum.AutomaticSize.X
    BadgeLabel.ZIndex = 105

    local KsTitle = Instance.new("TextLabel")
    KsTitle.Font = Enum.Font.GothamBold
    KsTitle.Text = ks.Title or GuiConfig.Title or "Key System"
    KsTitle.TextColor3 = Color3.fromRGB(232, 232, 238)
    KsTitle.TextSize = 14
    KsTitle.TextXAlignment = Enum.TextXAlignment.Left
    KsTitle.BackgroundTransparency = 1
    KsTitle.BorderSizePixel = 0
    KsTitle.AnchorPoint = Vector2.new(0, 0.5)
    KsTitle.Position = UDim2.new(0, 44, 0, 28)
    KsTitle.Size = UDim2.new(1, -58, 0, 18)
    KsTitle.ZIndex = 102
    KsTitle.Parent = Card

    local HDivider = Instance.new("Frame")
    HDivider.Size = UDim2.new(1, 0, 0, 1)
    HDivider.Position = UDim2.new(0, 0, 0, 50)
    HDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
    HDivider.BorderSizePixel = 0
    HDivider.ZIndex = 102
    HDivider.Parent = Card

    local KsNote = Instance.new("TextLabel")
    KsNote.Font = Enum.Font.Gotham
    KsNote.Text = ks.Note or ""
    KsNote.TextColor3 = Color3.fromRGB(95, 95, 108)
    KsNote.TextSize = 12
    KsNote.TextXAlignment = Enum.TextXAlignment.Left
    KsNote.BackgroundTransparency = 1
    KsNote.BorderSizePixel = 0
    KsNote.Position = UDim2.new(0, 14, 0, 60)
    KsNote.Size = UDim2.new(1, -28, 0, 14)
    KsNote.ZIndex = 102
    KsNote.Parent = Card

    local InputBg = Instance.new("Frame")
    InputBg.Position = UDim2.new(0, 14, 0, 84)
    InputBg.Size = UDim2.new(1, -28, 0, 32)
    InputBg.BackgroundColor3 = Color3.fromRGB(22, 22, 29)
    InputBg.BorderSizePixel = 0
    InputBg.ZIndex = 102
    InputBg.Parent = Card
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 7)
    local InputBgStroke = Instance.new("UIStroke", InputBg)
    InputBgStroke.Color = Color3.fromRGB(44, 44, 56)
    InputBgStroke.Thickness = 1

    local InputIcon = Instance.new("ImageLabel")
    InputIcon.AnchorPoint = Vector2.new(0, 0.5)
    InputIcon.Position = UDim2.new(0, 9, 0.5, 0)
    InputIcon.Size = UDim2.new(0, 13, 0, 13)
    InputIcon.BackgroundTransparency = 1
    InputIcon.Image = "rbxassetid://6031094678"
    InputIcon.ImageColor3 = Color3.fromRGB(75, 75, 88)
    InputIcon.ScaleType = Enum.ScaleType.Fit
    InputIcon.ZIndex = 103
    InputIcon.Parent = InputBg

    local KsInput = Instance.new("TextBox")
    KsInput.Font = Enum.Font.Gotham
    KsInput.PlaceholderText = ks.Placeholder or "Enter Key"
    KsInput.PlaceholderColor3 = Color3.fromRGB(65, 65, 78)
    KsInput.Text = ks.Default or ""
    KsInput.TextColor3 = Color3.fromRGB(210, 210, 222)
    KsInput.TextSize = 12
    KsInput.TextXAlignment = Enum.TextXAlignment.Left
    KsInput.BackgroundTransparency = 1
    KsInput.BorderSizePixel = 0
    KsInput.ClearTextOnFocus = false
    KsInput.Position = UDim2.new(0, 28, 0, 0)
    KsInput.Size = UDim2.new(1, -34, 1, 0)
    KsInput.ZIndex = 103
    KsInput.Parent = InputBg

    KsInput.Focused:Connect(function()
        TweenService:Create(InputBgStroke, TweenInfo.new(0.18), { Color = accentColor, Transparency = 0.45 }):Play()
    end)
    KsInput.FocusLost:Connect(function()
        TweenService:Create(InputBgStroke, TweenInfo.new(0.18), { Color = Color3.fromRGB(44, 44, 56), Transparency = 0 }):Play()
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(95, 95, 108)
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Position = UDim2.new(0, 14, 0, 118)
    StatusLabel.Size = UDim2.new(1, -28, 0, 12)
    StatusLabel.ZIndex = 103
    StatusLabel.Parent = Card

    local BDivider = Instance.new("Frame")
    BDivider.Size = UDim2.new(1, 0, 0, 1)
    BDivider.Position = UDim2.new(0, 0, 0, 134)
    BDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
    BDivider.BorderSizePixel = 0
    BDivider.ZIndex = 102
    BDivider.Parent = Card

    local BtnRow = Instance.new("Frame")
    BtnRow.BackgroundTransparency = 1
    BtnRow.BorderSizePixel = 0
    BtnRow.Position = UDim2.new(0, 14, 0, 142)
    BtnRow.Size = UDim2.new(1, -28, 0, 30)
    BtnRow.ZIndex = 102
    BtnRow.Parent = Card
    local BtnList = Instance.new("UIListLayout", BtnRow)
    BtnList.FillDirection = Enum.FillDirection.Horizontal
    BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnList.Padding = UDim.new(0, 6)
    BtnList.SortOrder = Enum.SortOrder.LayoutOrder

    local function shakeCard()
        local orig = Card.Position
        for _, ox in ipairs({7, -7, 5, -5, 3, -3, 0}) do
            Card.Position = UDim2.new(orig.X.Scale, orig.X.Offset + ox, orig.Y.Scale, orig.Y.Offset)
            task.wait(0.04)
        end
        Card.Position = orig
    end

    local closing = false
    local function closeUI(success)
        if closing then return end
        closing = true
        resolved = success
        TweenService:Create(Card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0.56, 0), BackgroundTransparency = 1,
        }):Play()
        task.delay(0.25, function()
            pcall(function() KsGui:Destroy() end)
            if coroutine.status(thread) == "suspended" then coroutine.resume(thread) end
        end)
    end

    local checking = false
    local function submitKey(key)
        if checking or closing then return end
        if key == "" then task.spawn(shakeCard) return end
        checking = true
        StatusLabel.Text = "Checking key..."
        StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
        task.spawn(function()
            local valid = checkKey(key)
            checking = false
            if valid then
                StatusLabel.Text = "✓ Key valid!"
                StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
                TweenService:Create(InputBgStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(80, 200, 120), Transparency = 0.3 }):Play()
                if ks.SaveKey then saveKey(key) end
                task.wait(0.5)
                closeUI(true)
            else
                StatusLabel.Text = "✗ Key tidak valid"
                StatusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
                TweenService:Create(InputBgStroke, TweenInfo.new(0.1), { Color = Color3.fromRGB(220, 55, 55), Transparency = 0 }):Play()
                task.delay(1, function()
                    TweenService:Create(InputBgStroke, TweenInfo.new(0.3), { Color = Color3.fromRGB(44, 44, 56), Transparency = 0 }):Play()
                    StatusLabel.Text = ""
                end)
                task.spawn(shakeCard)
            end
        end)
    end

    KsInput.FocusLost:Connect(function(enter)
        if enter then submitKey(KsInput.Text) end
    end)

    local buttons = (type(ks.Buttons) == "table" and #ks.Buttons > 0) and ks.Buttons or {
        { Name = "Exit", Close = true },
        { Name = "Submit", Style = "primary" },
    }

    for i, btnCfg in ipairs(buttons) do
        local isPrimary = (btnCfg.Style == "primary") or (btnCfg.Name == "Submit") or (i == #buttons and not btnCfg.Close)

        local Btn = Instance.new("TextButton")
        Btn.Font = Enum.Font.GothamBold
        Btn.Text = ""
        Btn.AutomaticSize = Enum.AutomaticSize.X
        Btn.Size = UDim2.new(0, 0, 1, 0)
        Btn.BorderSizePixel = 0
        Btn.LayoutOrder = i
        Btn.ZIndex = 103
        Btn.BackgroundColor3 = isPrimary and Color3.fromRGB(50, 50, 62) or Color3.fromRGB(26, 26, 34)
        Btn.Parent = BtnRow
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)
        local BS2 = Instance.new("UIStroke", Btn)
        BS2.Color = isPrimary and Color3.fromRGB(65, 65, 80) or Color3.fromRGB(44, 44, 56)
        BS2.Thickness = 1
        local BPad = Instance.new("UIPadding", Btn)
        BPad.PaddingLeft = UDim.new(0, 10)
        BPad.PaddingRight = UDim.new(0, 10)

        local BInner = Instance.new("Frame", Btn)
        BInner.BackgroundTransparency = 1
        BInner.BorderSizePixel = 0
        BInner.AutomaticSize = Enum.AutomaticSize.X
        BInner.Size = UDim2.new(0, 0, 1, 0)
        BInner.ZIndex = 103
        local BIL = Instance.new("UIListLayout", BInner)
        BIL.FillDirection = Enum.FillDirection.Horizontal
        BIL.VerticalAlignment = Enum.VerticalAlignment.Center
        BIL.Padding = UDim.new(0, 5)

        local bIconId = getIconId(btnCfg.Icon or "")
        if bIconId ~= "" then
            local BI = Instance.new("ImageLabel", BInner)
            BI.BackgroundTransparency = 1
            BI.BorderSizePixel = 0
            BI.Size = UDim2.new(0, 12, 0, 12)
            BI.Image = bIconId
            BI.ImageColor3 = Color3.fromRGB(180, 180, 195)
            BI.ScaleType = Enum.ScaleType.Fit
            BI.LayoutOrder = 0
            BI.ZIndex = 104
        end

        local BLabel = Instance.new("TextLabel", BInner)
        BLabel.Font = Enum.Font.GothamBold
        BLabel.Text = btnCfg.Name or "Button"
        BLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
        BLabel.TextSize = 12
        BLabel.BackgroundTransparency = 1
        BLabel.BorderSizePixel = 0
        BLabel.AutomaticSize = Enum.AutomaticSize.X
        BLabel.Size = UDim2.new(0, 0, 1, 0)
        BLabel.LayoutOrder = 1
        BLabel.ZIndex = 104

        local normBg = isPrimary and Color3.fromRGB(50,50,62) or Color3.fromRGB(26,26,34)
        local hovBg  = isPrimary and Color3.fromRGB(62,62,78) or Color3.fromRGB(34,34,44)
        Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = hovBg }):Play() end)
        Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = normBg }):Play() end)
        Btn.MouseButton1Click:Connect(function()
            if type(btnCfg.Callback) == "function" then pcall(btnCfg.Callback, KsInput.Text) end
            local isClose = btnCfg.Close == true or btnCfg.Name == "Exit" or btnCfg.Name == "Close" or btnCfg.Name == "Cancel"
            local isSubmit = (btnCfg.Name == "Submit" or btnCfg.Style == "primary") and not isClose
            if isSubmit then submitKey(KsInput.Text)
            elseif isClose then closeUI(false) end
        end)
    end

    TweenService:Create(Card, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0,
    }):Play()

    coroutine.yield()
    return resolved
end

return PandaDeveloperKeySystem
