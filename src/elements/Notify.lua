-- // VelarisUI | Notify.lua | SpeedHubX Style
-- // Support: Icon, Color, Buttons

local function MakeNotifyModule(TweenService, CoreGui, getIconId)

    -- /// Helper: buat instance dengan properties
    local function Create(Name, Properties, Parent)
        local inst = Instance.new(Name)
        for i, v in pairs(Properties) do
            inst[i] = v
        end
        if Parent then inst.Parent = Parent end
        return inst
    end

    local NotifyModule = {}

    function NotifyModule:MakeNotify(NotifyConfig)
        NotifyConfig             = NotifyConfig or {}
        NotifyConfig.Title       = NotifyConfig.Title or "VelarisUI"
        NotifyConfig.Description = NotifyConfig.Description or ""
        NotifyConfig.Content     = NotifyConfig.Content or ""
        NotifyConfig.Icon        = NotifyConfig.Icon or ""
        NotifyConfig.Time        = tonumber(NotifyConfig.Time) or 0.5
        NotifyConfig.Delay       = tonumber(NotifyConfig.Delay) or 5
        NotifyConfig.Buttons     = NotifyConfig.Buttons or {}

        if typeof(NotifyConfig.Color) ~= "Color3" then
            NotifyConfig.Color = Color3.fromRGB(250, 7, 7)
        end

        local NotifyFunction = {}
        local isClosing = false

        spawn(function()
            -- /// Setup ScreenGui & Layout (shared, satu instance)
            local notifyGui = CoreGui:FindFirstChild("VelarisNotifyGui")
            if not notifyGui then
                notifyGui = Create("ScreenGui", {
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                    Name           = "VelarisNotifyGui",
                    ResetOnSpawn   = false,
                }, CoreGui)
            end

            local notifyLayout = notifyGui:FindFirstChild("NotifyLayout")
            if not notifyLayout then
                notifyLayout = Create("Frame", {
                    AnchorPoint          = Vector2.new(1, 1),
                    BackgroundColor3     = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel      = 0,
                    Position             = UDim2.new(1, -30, 1, -30),
                    Size                 = UDim2.new(0, 320, 1, 0),
                    Name                 = "NotifyLayout",
                }, notifyGui)

                -- Stack reorganize saat child ditambah/dihapus
                local function reorganizeStack()
                    local Count = 0
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

                    for _, v in ipairs(notifyLayout:GetChildren()) do
                        if v:IsA("Frame") and v.Name == "NotifyFrame" then
                            local NewPOS = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))
                            TweenService:Create(v, tweenInfo, { Position = NewPOS }):Play()
                            Count += 1
                        end
                    end
                end

                notifyLayout.ChildRemoved:Connect(reorganizeStack)
                notifyLayout.ChildAdded:Connect(reorganizeStack)
            end

            -- Hitung offset stack saat ini
            local _Count = 0
            for _, v in ipairs(notifyLayout:GetChildren()) do
                if v:IsA("Frame") and v.Name == "NotifyFrame" then
                    _Count = -v.Position.Y.Offset + v.Size.Y.Offset + 12
                end
            end

            -- ========================
            -- FRAME WRAPPER
            -- ========================
            local notifyFrame = Create("Frame", {
                BackgroundColor3     = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                Size                 = UDim2.new(1, 0, 0, 70),
                AnchorPoint          = Vector2.new(0, 1),
                Position             = UDim2.new(0, 0, 1, -_Count),
                Name                 = "NotifyFrame",
            }, notifyLayout)

            -- ========================
            -- FRAME REAL (card background)
            -- ========================
            local notifyFrameReal = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                BorderSizePixel  = 0,
                Position         = UDim2.new(0, 400, 0, 0),
                Size             = UDim2.new(1, 0, 1, 0),
                Name             = "NotifyFrameReal",
            }, notifyFrame)

            Create("UICorner", { CornerRadius = UDim.new(0, 8) }, notifyFrameReal)

            Create("UIStroke", {
                Color     = Color3.fromRGB(50, 50, 50),
                Thickness = 1.6,
            }, notifyFrameReal)

            -- Drop Shadow
            local shadowHolder = Create("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                ZIndex                 = 0,
                Name                   = "DropShadowHolder",
            }, notifyFrameReal)

            Create("ImageLabel", {
                Image              = "",
                ImageColor3        = Color3.fromRGB(0, 0, 0),
                ImageTransparency  = 0.5,
                ScaleType          = Enum.ScaleType.Slice,
                SliceCenter        = Rect.new(49, 49, 450, 450),
                AnchorPoint        = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                BorderSizePixel    = 0,
                Position           = UDim2.new(0.5, 0, 0.5, 0),
                Size               = UDim2.new(1, 47, 1, 47),
                ZIndex             = 0,
                Name               = "DropShadow",
            }, shadowHolder)

            -- ========================
            -- TOP BAR
            -- ========================
            local Top = Create("Frame", {
                BackgroundColor3     = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.999,
                BorderSizePixel      = 0,
                Size                 = UDim2.new(1, 0, 0, 36),
                Name                 = "Top",
            }, notifyFrameReal)

            Create("UICorner", { CornerRadius = UDim.new(0, 5) }, Top)

            -- Icon kiri
            local iconId = getIconId(NotifyConfig.Icon)
            local hasIcon = iconId ~= ""

            if hasIcon then
                Create("ImageLabel", {
                    Image              = iconId,
                    ImageColor3        = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel    = 0,
                    Position           = UDim2.new(0, 8, 0.5, -6),
                    Size               = UDim2.new(0, 12, 0, 12),
                    ScaleType          = Enum.ScaleType.Fit,
                    Name               = "IconImg",
                }, Top)
            end

            local titleOffsetX = hasIcon and 26 or 10

            -- Title
            local titleLabel = Create("TextLabel", {
                Font               = Enum.Font.GothamBold,
                Text               = NotifyConfig.Title,
                TextColor3         = Color3.fromRGB(255, 255, 255),
                TextSize           = 14,
                TextXAlignment     = Enum.TextXAlignment.Left,
                BackgroundColor3   = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.999,
                BorderSizePixel    = 0,
                Size               = UDim2.new(1, 0, 1, 0),
                Position           = UDim2.new(0, titleOffsetX, 0, 0),
                Name               = "TitleLabel",
            }, Top)

            Create("UIStroke", {
                Color     = Color3.fromRGB(255, 255, 255),
                Thickness = 0.3,
            }, titleLabel)

            -- Description (colored, di sebelah title)
            if NotifyConfig.Description ~= "" then
                local descLabel = Create("TextLabel", {
                    Font               = Enum.Font.GothamBold,
                    Text               = NotifyConfig.Description,
                    TextColor3         = NotifyConfig.Color,
                    TextSize           = 14,
                    TextXAlignment     = Enum.TextXAlignment.Left,
                    BackgroundColor3   = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.999,
                    BorderSizePixel    = 0,
                    Size               = UDim2.new(1, 0, 1, 0),
                    Position           = UDim2.new(0, titleOffsetX + titleLabel.TextBounds.X + 10, 0, 0),
                    Name               = "DescLabel",
                }, Top)

                Create("UIStroke", {
                    Color     = NotifyConfig.Color,
                    Thickness = 0.4,
                }, descLabel)
            end

            -- Tombol Close (X)
            local closeBtn = Create("TextButton", {
                Font               = Enum.Font.SourceSans,
                Text               = "X",
                TextColor3         = Color3.fromRGB(255, 255, 255),
                TextSize           = 18,
                AnchorPoint        = Vector2.new(1, 0.5),
                BackgroundColor3   = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.999,
                BorderSizePixel    = 0,
                Position           = UDim2.new(1, -5, 0.5, 0),
                Size               = UDim2.new(0, 25, 0, 25),
                Name               = "CloseBtn",
            }, Top)

            -- ========================
            -- CONTENT TEXT
            -- ========================
            local hasButtons = #NotifyConfig.Buttons > 0

            local textLabel = Create("TextLabel", {
                Font               = Enum.Font.GothamBold,
                Text               = NotifyConfig.Content,
                TextColor3         = Color3.fromRGB(150, 150, 150),
                TextSize           = 13,
                TextXAlignment     = Enum.TextXAlignment.Left,
                TextYAlignment     = Enum.TextYAlignment.Top,
                BackgroundColor3   = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.999,
                BorderSizePixel    = 0,
                Position           = UDim2.new(0, 10, 0, 27),
                Size               = UDim2.new(1, -20, 0, 13),
                Name               = "ContentText",
            }, notifyFrameReal)

            -- Hitung tinggi konten (SpeedHubX style)
            textLabel.Size = UDim2.new(1, -20, 0, 13 + (13 * (textLabel.TextBounds.X // textLabel.AbsoluteSize.X)))
            textLabel.TextWrapped = true

            local contentH = textLabel.AbsoluteSize.Y

            if contentH < 27 then
                notifyFrame.Size = UDim2.new(1, 0, 0, 65)
            else
                notifyFrame.Size = UDim2.new(1, 0, 0, contentH + 40)
            end

            -- ========================
            -- BUTTONS
            -- ========================
            if hasButtons then
                local frameH = notifyFrame.Size.Y.Offset

                local btnRow = Create("Frame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel        = 0,
                    Position               = UDim2.new(0, 10, 0, frameH - 4),
                    Size                   = UDim2.new(1, -20, 0, 28),
                    Name                   = "BtnRow",
                }, notifyFrameReal)

                Create("UIListLayout", {
                    FillDirection      = Enum.FillDirection.Horizontal,
                    HorizontalAlignment= Enum.HorizontalAlignment.Left,
                    VerticalAlignment  = Enum.VerticalAlignment.Center,
                    Padding            = UDim.new(0, 6),
                }, btnRow)

                notifyFrame.Size = UDim2.new(1, 0, 0, frameH + 34)

                for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                    local isPrimary = btnCfg.Primary == true

                    local btn = Create("TextButton", {
                        Font               = Enum.Font.GothamBold,
                        Text               = btnCfg.Name or ("Button " .. idx),
                        TextSize           = 12,
                        TextColor3         = Color3.fromRGB(255, 255, 255),
                        TextTransparency   = isPrimary and 0.1 or 0.3,
                        BackgroundColor3   = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.935,
                        BorderSizePixel    = 0,
                        LayoutOrder        = idx,
                        Size               = UDim2.new(1 / #NotifyConfig.Buttons, -((6 * (#NotifyConfig.Buttons - 1)) / #NotifyConfig.Buttons), 1, 0),
                    }, btnRow)

                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }, btn)

                    if isPrimary then
                        Create("UIStroke", {
                            Color        = NotifyConfig.Color,
                            Thickness    = 1,
                            Transparency = 0.4,
                        }, btn)
                    end

                    btn.Activated:Connect(function()
                        if btnCfg.Callback then
                            local ok, err = pcall(btnCfg.Callback)
                            if not ok then warn("Notify Button Error: " .. tostring(err)) end
                        end
                        NotifyFunction:Close()
                    end)
                end
            end

            -- ========================
            -- CLOSE FUNCTION
            -- ========================
            function NotifyFunction:Close()
                if isClosing then return false end
                isClosing = true

                local tween = TweenService:Create(
                    notifyFrameReal,
                    TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                    { Position = UDim2.new(0, 400, 0, 0) }
                )
                tween:Play()

                task.wait(NotifyConfig.Time / 1.2)
                if notifyFrame and notifyFrame.Parent then
                    notifyFrame:Destroy()
                end

                isClosing = false
                return true
            end

            closeBtn.Activated:Connect(function() NotifyFunction:Close() end)

            -- ========================
            -- SLIDE IN
            -- ========================
            TweenService:Create(
                notifyFrameReal,
                TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
                { Position = UDim2.new(0, 0, 0, 0) }
            ):Play()

            -- ========================
            -- AUTO CLOSE
            -- ========================
            if NotifyConfig.Delay > 0 then
                task.wait(NotifyConfig.Delay)
                NotifyFunction:Close()
            end
        end)

        return NotifyFunction
    end

    -- /// Shortcut
    function NotifyModule:Nt(msg, delay, color, title, desc)
        return self:MakeNotify({
            Title       = title or "VelarisUI",
            Description = desc  or "Notification",
            Content     = msg   or "",
            Color       = color or Color3.fromRGB(250, 7, 7),
            Delay       = delay or 4,
        })
    end

    return NotifyModule
end

return MakeNotifyModule
