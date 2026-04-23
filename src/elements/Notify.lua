-- VelarisUI | Notify.lua | Neverlose Style
-- Menggunakan BuiltIn Roblox Icon Font (BuilderIcons)

local function MakeNotifyModule(NeverLose, TweenService, CoreGui)
    local TextService  = game:GetService("TextService")
    local UserInputService = game:GetService("UserInputService")

    -- Tween preset (sama seperti NeverLose)
    local SlowyTween  = TweenInfo.new(0.175)
    local VSlowTween  = TweenInfo.new(0.5, Enum.EasingStyle.Quint)
    local BackTween   = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local function PlayAnim(obj, info, props)
        TweenService:Create(obj, info, props):Play()
    end

    local function Create(class, props, parent)
        local inst = Instance.new(class)
        for k, v in pairs(props) do inst[k] = v end
        if parent then inst.Parent = parent end
        return inst
    end

    -- Warna per type
    local TypeColors = {
        default = Color3.fromRGB(78,  127, 252),
        success = Color3.fromRGB(68,  189, 50),
        error   = Color3.fromRGB(230, 74,  25),
        warning = Color3.fromRGB(255, 184, 0),
        info    = Color3.fromRGB(0,   184, 212),
    }

    -- Icon per type (menggunakan BuilderIcons font bawaan Roblox)
    local TypeIcons = {
        default = "bell",
        success = "circle-check",
        error   = "circle-x",
        warning = "triangle-exclamation",
        info    = "circle-i",
    }

    local BuiltInBold = Font.new(
        "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    )

    -- ============================================================
    --  Shadow helper (sama persis NeverLose)
    -- ============================================================
    local function CreateShadow(parent)
        local strokes = {}
        for _, thick in ipairs({6, 5, 4, 3}) do
            local s = Create("UIStroke", {
                Thickness    = thick,
                Transparency = 1,
                Color        = Color3.fromRGB(0, 0, 0),
            }, parent)
            table.insert(strokes, s)
        end
        return {
            Render = function(_, visible)
                local t = visible and 0.9 or 1
                for _, s in ipairs(strokes) do
                    PlayAnim(s, SlowyTween, { Transparency = t })
                end
            end
        }
    end

    -- ============================================================
    --  Root GUI
    -- ============================================================
    local notifyGui = CoreGui:FindFirstChild("VelarisNotifyGui")
    if not notifyGui then
        notifyGui = Create("ScreenGui", {
            Name            = "VelarisNotifyGui",
            ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn    = false,
            IgnoreGuiInset  = true,
        }, CoreGui)
    end

    -- Stack container (kanan atas, seperti NeverLose)
    local stackFrame = notifyGui:FindFirstChild("VelarisStack")
    if not stackFrame then
        stackFrame = Create("Frame", {
            Name               = "VelarisStack",
            AnchorPoint        = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel    = 0,
            Position           = UDim2.new(1, -15, 0, 15),
            Size               = UDim2.new(0, 310, 1, 0),
        }, notifyGui)
    end

    -- Auto-restack semua notify saat ada yang masuk/keluar
    local function Restack()
        local yOff = 0
        local children = {}
        for _, v in ipairs(stackFrame:GetChildren()) do
            if v:IsA("Frame") and v:GetAttribute("VNotify") then
                table.insert(children, v)
            end
        end
        -- stack dari atas ke bawah (terbaru di atas)
        for i = #children, 1, -1 do
            local v = children[i]
            PlayAnim(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, yOff)
            })
            yOff = yOff + v.Size.Y.Offset + 8
        end
    end

    stackFrame.ChildAdded:Connect(Restack)
    stackFrame.ChildRemoved:Connect(Restack)

    -- ============================================================
    --  Module
    -- ============================================================
    local NotifyModule = {}

    function NotifyModule:MakeNotify(cfg)
        cfg = cfg or {}
        local title   = cfg.Title       or "VelarisUI"
        local desc    = cfg.Description or ""
        local content = cfg.Content     or ""
        local icon    = cfg.Icon        or TypeIcons[cfg.Type] or TypeIcons.default
        local ntype   = cfg.Type        or "default"
        local delay   = tonumber(cfg.Delay) or 5
        local animT   = tonumber(cfg.Time)  or 0.35
        local buttons = cfg.Buttons         or {}
        local color   = cfg.Color

        if typeof(color) ~= "Color3" then
            color = TypeColors[ntype] or TypeColors.default
        end

        -- -------------------------------------------------------
        --  Hitung tinggi total
        -- -------------------------------------------------------
        local headerH  = desc ~= "" and 52 or 38
        local contentH = 0
        if content ~= "" then
            local sz = TextService:GetTextSize(content, 11,
                Enum.Font.GothamMedium, Vector2.new(270, math.huge))
            contentH = sz.Y + 14
        end
        local btnsH   = #buttons > 0 and 36 or 0
        local timerH  = 2
        local totalH  = headerH + contentH + btnsH + timerH + 8

        -- -------------------------------------------------------
        --  Container (untuk animasi slide dan restack)
        -- -------------------------------------------------------
        local container = Create("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size     = UDim2.new(0, 305, 0, totalH),
            Position = UDim2.new(0, 0, 0, 0),
            ClipsDescendants = false,
        }, stackFrame)
        container:SetAttribute("VNotify", true)

        -- -------------------------------------------------------
        --  Card utama
        -- -------------------------------------------------------
        local card = Create("Frame", {
            BackgroundColor3    = Color3.fromRGB(20, 22, 27),
            BackgroundTransparency = 0.035,
            BorderSizePixel     = 0,
            Size                = UDim2.new(0, 305, 0, totalH),
            Position            = UDim2.new(0, 370, 0, 0),  -- mulai dari luar (kanan)
            ClipsDescendants    = true,
        }, container)

        Create("UICorner", { CornerRadius = UDim.new(0, 12) }, card)

        -- Border tipis (NeverLose style)
        Create("UIStroke", {
            Color        = Color3.fromRGB(45, 48, 58),
            Thickness    = 1,
            Transparency = 0.65,
        }, card)

        -- Shadow
        local shadow = CreateShadow(card)
        shadow:Render(true)

        -- Accent bar kiri
        local accentBar = Create("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel  = 0,
            Size             = UDim2.new(0, 4, 1, 0),
            Position         = UDim2.new(0, 0, 0, 0),
        }, card)
        Create("UICorner", { CornerRadius = UDim.new(0, 2) }, accentBar)

        -- -------------------------------------------------------
        --  Header (icon + title + close)
        -- -------------------------------------------------------
        local topFrame = Create("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Size                   = UDim2.new(1, 0, 0, 38),
        }, card)

        -- Icon (BuilderIcons font)
        local iconLabel = Create("TextLabel", {
            Text                 = icon,
            FontFace             = BuiltInBold,
            TextColor3           = color,
            TextSize             = 18,
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            AnchorPoint          = Vector2.new(0, 0.5),
            Position             = UDim2.new(0, 12, 0.5, 0),
            Size                 = UDim2.new(0, 22, 0, 22),
            TextWrapped          = true,
        }, topFrame)

        -- Title
        Create("TextLabel", {
            Text                 = title,
            Font                 = Enum.Font.GothamBold,
            TextColor3           = Color3.fromRGB(255, 255, 255),
            TextSize             = 13,
            TextXAlignment       = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Position             = UDim2.new(0, 42, 0, 10),
            Size                 = UDim2.new(1, -74, 0, 18),
        }, topFrame)

        -- Close button
        local closeBg = Create("Frame", {
            AnchorPoint          = Vector2.new(1, 0.5),
            Position             = UDim2.new(1, -8, 0.5, 0),
            Size                 = UDim2.new(0, 22, 0, 22),
            BackgroundColor3     = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
        }, topFrame)
        Create("UICorner", { CornerRadius = UDim.new(0, 5) }, closeBg)

        local closeIcon = Create("TextLabel", {
            Text                 = "x",
            FontFace             = BuiltInBold,
            TextColor3           = Color3.fromRGB(140, 140, 140),
            TextSize             = 14,
            BackgroundTransparency = 1,
            Size                 = UDim2.fromScale(1, 1),
            TextWrapped          = true,
        }, closeBg)

        local closeBtn = Create("TextButton", {
            Text                 = "",
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Size                 = UDim2.fromScale(1, 1),
            ZIndex               = card.ZIndex + 5,
        }, closeBg)

        -- Hover close
        closeBtn.MouseEnter:Connect(function()
            PlayAnim(closeIcon, SlowyTween, { TextColor3 = color })
            PlayAnim(closeBg,   SlowyTween, { BackgroundTransparency = 0.8 })
        end)
        closeBtn.MouseLeave:Connect(function()
            PlayAnim(closeIcon, SlowyTween, { TextColor3 = Color3.fromRGB(140, 140, 140) })
            PlayAnim(closeBg,   SlowyTween, { BackgroundTransparency = 1 })
        end)

        -- -------------------------------------------------------
        --  Description (opsional, warna accent)
        -- -------------------------------------------------------
        if desc ~= "" then
            Create("TextLabel", {
                Text                 = desc,
                Font                 = Enum.Font.GothamBold,
                TextColor3           = color,
                TextSize             = 11,
                TextXAlignment       = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                Position             = UDim2.new(0, 42, 0, 28),
                Size                 = UDim2.new(1, -60, 0, 14),
            }, topFrame)
        end

        -- -------------------------------------------------------
        --  Content text
        -- -------------------------------------------------------
        if content ~= "" then
            Create("TextLabel", {
                Text                 = content,
                Font                 = Enum.Font.GothamMedium,
                TextColor3           = Color3.fromRGB(175, 175, 175),
                TextSize             = 11,
                TextXAlignment       = Enum.TextXAlignment.Left,
                TextYAlignment       = Enum.TextYAlignment.Top,
                TextWrapped          = true,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                Position             = UDim2.new(0, 12, 0, headerH),
                Size                 = UDim2.new(1, -24, 0, contentH),
            }, card)
        end

        -- -------------------------------------------------------
        --  Timer bar (bawah card)
        -- -------------------------------------------------------
        local timerBg = Create("Frame", {
            BackgroundColor3     = Color3.fromRGB(35, 37, 45),
            BorderSizePixel      = 0,
            AnchorPoint          = Vector2.new(0, 1),
            Position             = UDim2.new(0, 0, 1, 0),
            Size                 = UDim2.new(1, 0, 0, 2),
        }, card)

        local timerBar = Create("Frame", {
            BackgroundColor3     = color,
            BorderSizePixel      = 0,
            Size                 = UDim2.new(1, 0, 1, 0),
        }, timerBg)

        -- -------------------------------------------------------
        --  Buttons (opsional)
        -- -------------------------------------------------------
        if #buttons > 0 then
            local btnFrame = Create("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Position               = UDim2.new(0, 8, 0, headerH + contentH + 4),
                Size                   = UDim2.new(1, -16, 0, 28),
            }, card)

            Create("UIListLayout", {
                FillDirection        = Enum.FillDirection.Horizontal,
                HorizontalAlignment  = Enum.HorizontalAlignment.Right,
                VerticalAlignment    = Enum.VerticalAlignment.Center,
                Padding              = UDim.new(0, 6),
            }, btnFrame)

            for idx, bcfg in ipairs(buttons) do
                local isPrimary = bcfg.Primary == true
                local bname     = bcfg.Name or ("Button "..idx)
                local bSize     = TextService:GetTextSize(bname, 11,
                    Enum.Font.GothamBold, Vector2.new(math.huge, math.huge))

                local btn = Create("TextButton", {
                    Text                 = bname,
                    Font                 = Enum.Font.GothamBold,
                    TextSize             = 11,
                    TextColor3           = isPrimary and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200),
                    BackgroundColor3     = isPrimary and color or Color3.fromRGB(35, 37, 45),
                    BackgroundTransparency = isPrimary and 0.15 or 0,
                    BorderSizePixel      = 0,
                    Size                 = UDim2.new(0, bSize.X + 20, 1, 0),
                    AutoButtonColor      = false,
                }, btnFrame)
                Create("UICorner", { CornerRadius = UDim.new(0, 5) }, btn)
                Create("UIStroke", {
                    Color        = isPrimary and color or Color3.fromRGB(55, 57, 68),
                    Transparency = 0.5,
                    Thickness    = 1,
                }, btn)

                btn.MouseEnter:Connect(function()
                    PlayAnim(btn, SlowyTween, { BackgroundTransparency = isPrimary and 0.05 or 0.6 })
                end)
                btn.MouseLeave:Connect(function()
                    PlayAnim(btn, SlowyTween, { BackgroundTransparency = isPrimary and 0.15 or 0 })
                end)

                local cb = bcfg.Callback
                btn.Activated:Connect(function()
                    if cb then pcall(cb) end
                end)
            end
        end

        -- -------------------------------------------------------
        --  Animasi masuk (slide dari kanan, Back easing)
        -- -------------------------------------------------------
        local NotifyRef  = {}
        local isClosing  = false
        local autoThread

        PlayAnim(card, TweenInfo.new(animT, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        })

        -- Timer countdown visual
        if delay > 0 then
            task.delay(0.05, function()
                PlayAnim(timerBar,
                    TweenInfo.new(delay, Enum.EasingStyle.Linear),
                    { Size = UDim2.new(0, 0, 1, 0) }
                )
            end)
        end

        -- -------------------------------------------------------
        --  Fungsi tutup
        -- -------------------------------------------------------
        function NotifyRef:Close()
            if isClosing then return false end
            isClosing = true
            if autoThread then task.cancel(autoThread) end

            shadow:Render(false)
            PlayAnim(card,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Position = UDim2.new(0, 370, 0, 0) }
            )
            task.delay(0.26, function()
                if container and container.Parent then
                    container:Destroy()
                end
            end)
            return true
        end

        closeBtn.Activated:Connect(function() NotifyRef:Close() end)

        if delay > 0 then
            autoThread = task.delay(delay, function()
                if not isClosing then NotifyRef:Close() end
            end)
        end

        return NotifyRef
    end

    -- ============================================================
    --  Shortcut methods
    -- ============================================================
    function NotifyModule:Notify(msg, delay, ntype, title)
        return self:MakeNotify({
            Title   = title or "Notification",
            Content = msg or "",
            Delay   = delay or 4,
            Type    = ntype or "default",
        })
    end

    function NotifyModule:Success(msg, delay, title)
        return self:MakeNotify({
            Title   = title or "Success",
            Content = msg or "",
            Delay   = delay or 3.5,
            Type    = "success",
        })
    end

    function NotifyModule:Error(msg, delay, title)
        return self:MakeNotify({
            Title   = title or "Error",
            Content = msg or "",
            Delay   = delay or 5,
            Type    = "error",
        })
    end

    function NotifyModule:Warning(msg, delay, title)
        return self:MakeNotify({
            Title   = title or "Warning",
            Content = msg or "",
            Delay   = delay or 4,
            Type    = "warning",
        })
    end

    function NotifyModule:Info(msg, delay, title)
        return self:MakeNotify({
            Title   = title or "Info",
            Content = msg or "",
            Delay   = delay or 4,
            Type    = "info",
        })
    end

    -- ============================================================
    --  Method lama "Nt" — dipertahankan agar backward compatible
    --  Signature asli: Nt(Title, Description, Content, Icon, Time, Delay, Buttons, Type, Color)
    -- ============================================================
    function NotifyModule:Nt(Title, Description, Content, Icon, Time, Delay, Buttons, Type, Color)
        return self:MakeNotify({
            Title       = Title,
            Description = Description,
            Content     = Content,
            Icon        = Icon,
            Time        = Time,
            Delay       = Delay,
            Buttons     = Buttons,
            Type        = Type,
            Color       = Color,
        })
    end

    return NotifyModule
end

return MakeNotifyModule
