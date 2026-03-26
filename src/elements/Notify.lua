-- // VelarisUI | Notify.lua | WindUI-Style Notify Module

local function MakeNotifyModule(TweenService, CoreGui, getIconId)

    local NotifyModule = {}

    -- ─── Internal helpers ────────────────────────────────────────────────────

    local function validateColor(val)
        return typeof(val) == "Color3" and val or Color3.fromRGB(0, 208, 255)
    end

    local function ensureGui()
        if not CoreGui:FindFirstChild("NotifyGui") then
            local gui = Instance.new("ScreenGui")
            gui.Name           = "NotifyGui"
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.ResetOnSpawn   = false
            gui.Parent         = CoreGui
        end

        if not CoreGui.NotifyGui:FindFirstChild("NotifyHolder") then
            local holder = Instance.new("Frame")
            holder.Name                 = "NotifyHolder"
            holder.AnchorPoint          = Vector2.new(1, 1)
            holder.BackgroundTransparency = 1
            holder.BorderSizePixel      = 0
            holder.Position             = UDim2.new(1, -16, 1, -16)
            holder.Size                 = UDim2.new(0, 320, 1, 0)
            holder.Parent               = CoreGui.NotifyGui

            -- Auto-restack on child removed
            holder.ChildRemoved:Connect(function()
                local count = 0
                for _, child in holder:GetChildren() do
                    if child:IsA("Frame") then
                        TweenService:Create(child, TweenInfo.new(
                            0.35,
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out
                        ), {
                            Position = UDim2.new(0, 0, 1, -((child.Size.Y.Offset + 10) * count))
                        }):Play()
                        count += 1
                    end
                end
            end)
        end
    end

    local function getStackOffset()
        local offset = 0
        for _, child in CoreGui.NotifyGui.NotifyHolder:GetChildren() do
            if child:IsA("Frame") then
                offset = -(child.Position.Y.Offset) + child.Size.Y.Offset + 10
            end
        end
        return offset
    end

    -- ─── Duration bar ────────────────────────────────────────────────────────

    local function makeDurationBar(parent, accentColor)
        local barBg = Instance.new("Frame")
        barBg.Name                  = "DurationBg"
        barBg.BackgroundColor3      = Color3.fromRGB(30, 30, 38)
        barBg.BorderSizePixel       = 0
        barBg.Size                  = UDim2.new(1, 0, 0, 2)
        barBg.AnchorPoint           = Vector2.new(0, 1)
        barBg.Position              = UDim2.new(0, 0, 1, 0)
        barBg.ClipsDescendants      = true
        barBg.Parent                = parent

        local fill = Instance.new("Frame")
        fill.Name                   = "Fill"
        fill.BackgroundColor3       = accentColor
        fill.BorderSizePixel        = 0
        fill.Size                   = UDim2.new(1, 0, 1, 0)
        fill.Parent                 = barBg

        return barBg, fill
    end

    -- ─── Button row ──────────────────────────────────────────────────────────

    local function makeButtons(parent, buttons, accentColor, onClose)
        local btnCount = #buttons
        if btnCount == 0 then return end

        local gap      = 6
        local totalGap = gap * (btnCount - 1)

        local row = Instance.new("Frame")
        row.Name                  = "ButtonRow"
        row.BackgroundTransparency = 1
        row.BorderSizePixel       = 0
        row.Size                  = UDim2.new(1, -24, 0, 28)
        row.Position              = UDim2.new(0, 12, 0, 0)   -- Y set after defer
        row.Parent                = parent

        local list = Instance.new("UIListLayout")
        list.FillDirection        = Enum.FillDirection.Horizontal
        list.HorizontalAlignment  = Enum.HorizontalAlignment.Left
        list.VerticalAlignment    = Enum.VerticalAlignment.Center
        list.Padding              = UDim.new(0, gap)
        list.Parent               = row

        for idx, btnCfg in ipairs(buttons) do
            local isPrimary = btnCfg.Primary == true

            local btn = Instance.new("TextButton")
            btn.Text             = ""
            btn.AutomaticSize    = Enum.AutomaticSize.None
            btn.Size             = UDim2.new(1 / btnCount, -(totalGap / btnCount), 1, 0)
            btn.BorderSizePixel  = 0
            btn.LayoutOrder      = idx
            btn.BackgroundColor3 = isPrimary
                and Color3.fromRGB(45, 45, 58)
                or  Color3.fromRGB(33, 33, 42)
            btn.Parent = row

            Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

            local stroke = Instance.new("UIStroke")
            stroke.Color     = isPrimary
                and Color3.fromRGB(70, 70, 88)
                or  Color3.fromRGB(50, 50, 62)
            stroke.Thickness = 1
            stroke.Parent    = btn

            -- Inner content frame (icon + label, centered)
            local inner = Instance.new("Frame")
            inner.BackgroundTransparency = 1
            inner.AutomaticSize          = Enum.AutomaticSize.X
            inner.AnchorPoint            = Vector2.new(0.5, 0.5)
            inner.Position               = UDim2.new(0.5, 0, 0.5, 0)
            inner.Size                   = UDim2.new(0, 0, 1, 0)
            inner.Parent                 = btn

            local innerList = Instance.new("UIListLayout")
            innerList.FillDirection      = Enum.FillDirection.Horizontal
            innerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            innerList.VerticalAlignment  = Enum.VerticalAlignment.Center
            innerList.Padding            = UDim.new(0, 4)
            innerList.Parent             = inner

            -- Optional icon on button
            local btnIconId = getIconId(btnCfg.Icon or "")
            if btnIconId ~= "" then
                local ic = Instance.new("ImageLabel")
                ic.BackgroundTransparency = 1
                ic.Size        = UDim2.new(0, 11, 0, 11)
                ic.Image       = btnIconId
                ic.ImageColor3 = isPrimary
                    and Color3.fromRGB(220, 220, 230)
                    or  Color3.fromRGB(160, 160, 175)
                ic.ScaleType   = Enum.ScaleType.Fit
                ic.LayoutOrder = 0
                ic.Parent      = inner
            end

            local label = Instance.new("TextLabel")
            label.Font                = Enum.Font.GothamBold
            label.Text                = btnCfg.Name or ("Btn" .. idx)
            label.TextSize            = 11
            label.TextColor3          = isPrimary
                and Color3.fromRGB(220, 220, 230)
                or  Color3.fromRGB(160, 160, 175)
            label.BackgroundTransparency = 1
            label.AutomaticSize       = Enum.AutomaticSize.X
            label.Size                = UDim2.new(0, 0, 1, 0)
            label.LayoutOrder         = 1
            label.Parent              = inner

            btn.MouseButton1Click:Connect(function()
                if btnCfg.Callback then pcall(btnCfg.Callback) end
                onClose()
            end)
        end

        return row
    end

    -- ─── Main API ────────────────────────────────────────────────────────────

    function NotifyModule:MakeNotify(cfg)
        cfg             = cfg or {}
        cfg.Title       = cfg.Title       or "VelarisUI"
        cfg.Description = cfg.Description or ""
        cfg.Content     = cfg.Content     or ""
        cfg.Color       = validateColor(cfg.Color)
        cfg.Time        = cfg.Time        or 0.45
        cfg.Delay       = cfg.Delay       or 5
        cfg.Buttons     = cfg.Buttons     or {}

        local NotifyHandle = {}
        local closed       = false

        task.spawn(function()
            ensureGui()

            local stackY   = getStackOffset()
            local iconId   = getIconId(cfg.Icon or "")
            local hasIcon  = iconId ~= ""
            local hasBtns  = #cfg.Buttons > 0

            -- ── Outer container (drives restack layout) ──────────────────
            local container = Instance.new("Frame")
            container.BackgroundTransparency = 1
            container.BorderSizePixel        = 0
            container.Size                   = UDim2.new(1, 0, 0, 70)
            container.AnchorPoint            = Vector2.new(0, 1)
            container.Position               = UDim2.new(0, 0, 1, -stackY)
            container.Parent                 = CoreGui.NotifyGui.NotifyHolder

            -- ── Card surface ─────────────────────────────────────────────
            local card = Instance.new("Frame")
            card.BackgroundColor3  = Color3.fromRGB(24, 24, 30)
            card.BorderSizePixel   = 0
            card.ClipsDescendants  = false
            card.Position          = UDim2.new(0, 340, 0, 0)   -- starts off-screen
            card.Size              = UDim2.new(1, 0, 1, 0)
            card.Parent            = container
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color           = Color3.fromRGB(45, 45, 58)
            cardStroke.Thickness       = 0.8
            cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            cardStroke.Parent          = card

            -- ── Icon handling ─────────────────────────────────────────────
            local titleOffsetX = 12

            if hasIcon then
                if hasBtns then
                    -- Small inline icon beside title
                    local ic = Instance.new("ImageLabel")
                    ic.BackgroundTransparency = 1
                    ic.BorderSizePixel        = 0
                    ic.AnchorPoint            = Vector2.new(0, 0)
                    ic.Position               = UDim2.new(0, 12, 0, 12)
                    ic.Size                   = UDim2.new(0, 16, 0, 16)
                    ic.Image                  = iconId
                    ic.ImageColor3            = cfg.Color
                    ic.ScaleType              = Enum.ScaleType.Fit
                    ic.Parent                 = card
                    titleOffsetX = 12 + 16 + 6
                else
                    -- Large left-panel icon
                    local panel = Instance.new("ImageLabel")
                    panel.BackgroundColor3    = Color3.fromRGB(28, 28, 35)
                    panel.BackgroundTransparency = 0
                    panel.BorderSizePixel     = 0
                    panel.Image               = iconId
                    panel.ImageColor3         = cfg.Color
                    panel.ScaleType           = Enum.ScaleType.Fit
                    panel.Position            = UDim2.new(0, 0, 0, 0)
                    panel.Size                = UDim2.new(0, 50, 1, 0)
                    panel.Parent              = card
                    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
                    -- mask right corners of panel so they don't round against card
                    local mask = Instance.new("Frame")
                    mask.BackgroundColor3        = Color3.fromRGB(28, 28, 35)
                    mask.BorderSizePixel         = 0
                    mask.Size                    = UDim2.new(0, 12, 1, 0)
                    mask.Position                = UDim2.new(0, 38, 0, 0)
                    mask.Parent                  = panel
                    titleOffsetX = 62
                end
            end

            -- ── Title ─────────────────────────────────────────────────────
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Font              = Enum.Font.GothamBold
            titleLabel.Text              = cfg.Title
            titleLabel.TextColor3        = Color3.fromRGB(235, 235, 242)
            titleLabel.TextSize          = 13
            titleLabel.TextXAlignment    = Enum.TextXAlignment.Left
            titleLabel.BackgroundTransparency = 1
            titleLabel.Position          = UDim2.new(0, titleOffsetX, 0, 11)
            titleLabel.Size              = UDim2.new(1, -(titleOffsetX + 28), 0, 16)
            titleLabel.Parent            = card

            -- ── Description (colored badge text beside title) ─────────────
            if cfg.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Font           = Enum.Font.GothamMedium
                descLabel.Text           = cfg.Description
                descLabel.TextColor3     = cfg.Color
                descLabel.TextSize       = 11
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.BackgroundTransparency = 1
                descLabel.TextTruncate   = Enum.TextTruncate.AtEnd
                descLabel.Position       = UDim2.new(
                    0,
                    titleOffsetX + titleLabel.TextBounds.X + 6,
                    0,
                    12
                )
                descLabel.Size = UDim2.new(
                    1,
                    -(titleOffsetX + titleLabel.TextBounds.X + 28),
                    0,
                    14
                )
                descLabel.Parent = card
            end

            -- ── Content body ──────────────────────────────────────────────
            local contentH = 0

            if cfg.Content ~= "" then
                local contentLabel = Instance.new("TextLabel")
                contentLabel.Font            = Enum.Font.Gotham
                contentLabel.Text            = cfg.Content
                contentLabel.TextColor3      = Color3.fromRGB(155, 155, 168)
                contentLabel.TextSize        = 12
                contentLabel.TextXAlignment  = Enum.TextXAlignment.Left
                contentLabel.TextYAlignment  = Enum.TextYAlignment.Top
                contentLabel.TextWrapped     = true
                contentLabel.BackgroundTransparency = 1
                contentLabel.Position        = UDim2.new(0, titleOffsetX, 0, 32)
                contentLabel.Size            = UDim2.new(1, -(titleOffsetX + 10), 0, 14)
                contentLabel.Parent          = card

                task.defer(function()
                    if not contentLabel or not contentLabel.Parent then return end
                    local lineH  = 14
                    local maxW   = contentLabel.AbsoluteSize.X
                    local lines  = 1
                    if maxW > 0 then
                        lines = math.max(1, math.ceil(contentLabel.TextBounds.X / maxW))
                    end
                    contentH = lineH * lines
                    contentLabel.Size = UDim2.new(1, -(titleOffsetX + 10), 0, contentH)

                    task.wait()
                    if not container or not container.Parent then return end
                    local totalH = 32 + contentH + 14
                    if not hasBtns then
                        container.Size = UDim2.new(1, 0, 0, math.max(64, totalH))
                    end
                end)
            end

            -- ── Buttons ───────────────────────────────────────────────────
            local btnRow

            if hasBtns then
                local contentEst = (cfg.Content ~= "") and (32 + 14) or 32
                btnRow = makeButtons(card, cfg.Buttons, cfg.Color, function()
                    NotifyHandle:Close()
                end)

                task.defer(function()
                    task.wait()
                    if not container or not container.Parent then return end
                    local btnY = contentEst + 6
                    if btnRow then
                        btnRow.Position = UDim2.new(0, 12, 0, btnY)
                    end
                    local totalH = btnY + 28 + 12
                    container.Size = UDim2.new(1, 0, 0, math.max(72, totalH))
                end)
            end

            -- ── Duration bar ──────────────────────────────────────────────
            local _, durationFill = makeDurationBar(card, cfg.Color)

            -- ── Close button ──────────────────────────────────────────────
            local closeBtn = Instance.new("TextButton")
            closeBtn.Text                   = ""
            closeBtn.AnchorPoint            = Vector2.new(1, 0)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Position               = UDim2.new(1, -6, 0, 5)
            closeBtn.Size                   = UDim2.new(0, 20, 0, 20)
            closeBtn.ZIndex                 = 5
            closeBtn.Parent                 = card

            local closeImg = Instance.new("ImageLabel")
            closeImg.Image                  = "rbxassetid://9886659671"
            closeImg.ImageColor3            = Color3.fromRGB(110, 110, 128)
            closeImg.AnchorPoint            = Vector2.new(0.5, 0.5)
            closeImg.BackgroundTransparency = 1
            closeImg.Position               = UDim2.new(0.5, 0, 0.5, 0)
            closeImg.Size                   = UDim2.new(0.8, 0, 0.8, 0)
            closeImg.Parent                 = closeBtn

            -- Hover effect on close btn
            closeBtn.MouseEnter:Connect(function()
                closeImg.ImageColor3 = Color3.fromRGB(210, 210, 220)
            end)
            closeBtn.MouseLeave:Connect(function()
                closeImg.ImageColor3 = Color3.fromRGB(110, 110, 128)
            end)

            -- ── Close function ────────────────────────────────────────────
            function NotifyHandle:Close()
                if closed then return false end
                closed = true

                TweenService:Create(card, TweenInfo.new(
                    0.35,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.In
                ), { Position = UDim2.new(0, 340, 0, 0) }):Play()

                TweenService:Create(container, TweenInfo.new(
                    0.45,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ), { Size = UDim2.new(1, 0, 0, -8) }):Play()

                task.wait(0.45)
                if container and container.Parent then
                    container:Destroy()
                end
            end

            closeBtn.Activated:Connect(function()
                NotifyHandle:Close()
            end)

            -- ── Slide in ──────────────────────────────────────────────────
            TweenService:Create(card, TweenInfo.new(
                0.45,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ), { Position = UDim2.new(0, 0, 0, 0) }):Play()

            -- ── Duration countdown ────────────────────────────────────────
            local delay = tonumber(cfg.Delay) or 0

            if delay > 0 then
                -- Animate duration fill
                task.spawn(function()
                    task.wait(0.45) -- wait for slide-in
                    TweenService:Create(durationFill, TweenInfo.new(
                        delay,
                        Enum.EasingStyle.Linear,
                        Enum.EasingDirection.InOut
                    ), { Size = UDim2.new(0, 0, 1, 0) }):Play()
                end)

                task.wait(delay + 0.45)
                NotifyHandle:Close()
            end
        end)

        return NotifyHandle
    end

    -- ─── Shorthand ───────────────────────────────────────────────────────────

    ---@param msg     string   Body content
    ---@param delay   number   Auto-dismiss seconds (0 = no auto-dismiss)
    ---@param color   Color3   Accent color
    ---@param title   string   Title text
    ---@param desc    string   Small subtitle beside title
    function NotifyModule:Nt(msg, delay, color, title, desc)
        return self:MakeNotify({
            Title       = title or "VelarisUI",
            Description = desc  or "Notification",
            Content     = msg   or "",
            Color       = color or Color3.fromRGB(0, 208, 255),
            Delay       = delay or 4,
        })
    end

    return NotifyModule
end

return MakeNotifyModule
