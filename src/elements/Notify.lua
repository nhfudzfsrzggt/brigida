-- // VelarisUi | Notify.lua | Lexs Style

local function MakeNotifyModule(TweenService, CoreGui, getIconId)

    local NotifyModule = {}

    function NotifyModule:MakeNotify(NotifyConfig)
        NotifyConfig             = NotifyConfig or {}
        NotifyConfig.Title       = NotifyConfig.Title or "Velaris UI"
        NotifyConfig.Description = NotifyConfig.Description or ""
        NotifyConfig.Content     = NotifyConfig.Content or ""
        NotifyConfig.Icon        = NotifyConfig.Icon or ""
        NotifyConfig.Time        = NotifyConfig.Time or 0.5
        NotifyConfig.Delay       = NotifyConfig.Delay or 5
        NotifyConfig.Buttons     = NotifyConfig.Buttons or {}

        if typeof(NotifyConfig.Color) ~= "Color3" then
            NotifyConfig.Color = Color3.fromRGB(0, 208, 255)
        end

        local NotifyFunction = {}

        spawn(function()
            -- Buat ScreenGui jika belum ada
            if not CoreGui:FindFirstChild("NotifyGui") then
                local NotifyGui = Instance.new("ScreenGui")
                NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                NotifyGui.Name = "NotifyGui"
                NotifyGui.ResetOnSpawn = false
                NotifyGui.Parent = CoreGui
            end

            -- Buat NotifyLayout jika belum ada
            if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
                local NotifyLayout = Instance.new("Frame")
                NotifyLayout.AnchorPoint = Vector2.new(1, 1)
                NotifyLayout.BackgroundTransparency = 1
                NotifyLayout.BorderSizePixel = 0
                NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
                NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
                NotifyLayout.Name = "NotifyLayout"
                NotifyLayout.Parent = CoreGui.NotifyGui

                local Count = 0
                CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                    Count = 0
                    for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                        if v:IsA("Frame") then
                            TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))
                            }):Play()
                            Count = Count + 1
                        end
                    end
                end)
            end

            -- Hitung posisi stack notifikasi
            local NotifyPosHeigh = 0
            for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                if v:IsA("Frame") then
                    NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
                end
            end

            -- ========================
            -- FRAME UTAMA (wrapper)
            -- ========================
            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.BackgroundTransparency = 1
            NotifyFrame.BorderSizePixel = 0
            NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
            NotifyFrame.AnchorPoint = Vector2.new(0, 1)
            NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)
            NotifyFrame.Name = "NotifyFrame"
            NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout

            -- ========================
            -- FRAME REAL (background card)
            -- ========================
            local NotifyFrameReal = Instance.new("Frame")
            NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            NotifyFrameReal.BorderSizePixel = 0
            NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
            NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
            NotifyFrameReal.Name = "NotifyFrameReal"
            NotifyFrameReal.Parent = NotifyFrame
            Instance.new("UICorner", NotifyFrameReal).CornerRadius = UDim.new(0, 10)

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Color3.fromRGB(40, 40, 45)
            CardStroke.Thickness = 1
            CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            CardStroke.Parent = NotifyFrameReal

            -- ========================
            -- LEFT ICON (panel penuh sisi kiri, Lexs style)
            -- ========================
            local iconId = getIconId(NotifyConfig.Icon)
            local hasIcon = iconId ~= ""

            local LeftIcon = Instance.new("ImageLabel")
            LeftIcon.Image = hasIcon and iconId or "rbxassetid://17495379799"
            LeftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            LeftIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            LeftIcon.BackgroundTransparency = 0
            LeftIcon.BorderSizePixel = 0
            LeftIcon.Position = UDim2.new(0, 0, 0, 0)
            LeftIcon.Size = UDim2.new(0, 55, 1, 0)
            LeftIcon.ScaleType = Enum.ScaleType.Fit
            LeftIcon.Name = "LeftIcon"
            LeftIcon.Parent = NotifyFrameReal
            Instance.new("UICorner", LeftIcon).CornerRadius = UDim.new(0, 10)

            -- ========================
            -- CONTENT FRAME (area kanan icon)
            -- ========================
            local ContentFrame = Instance.new("Frame")
            ContentFrame.BackgroundTransparency = 1
            ContentFrame.BorderSizePixel = 0
            ContentFrame.Position = UDim2.new(0, 55, 0, 0)
            ContentFrame.Size = UDim2.new(1, -55, 1, 0)
            ContentFrame.Name = "ContentFrame"
            ContentFrame.Parent = NotifyFrameReal

            -- ========================
            -- TOP BAR (title + desc + close)
            -- ========================
            local Top = Instance.new("Frame")
            Top.BackgroundTransparency = 1
            Top.BorderSizePixel = 0
            Top.Size = UDim2.new(1, 0, 0, 36)
            Top.Name = "Top"
            Top.Parent = ContentFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = NotifyConfig.Title
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Size = UDim2.new(1, -50, 1, 0)
            TitleLabel.Position = UDim2.new(0, 10, 0, 0)
            TitleLabel.Name = "TitleLabel"
            TitleLabel.Parent = Top

            -- Description sejajar kanan title (Lexs style)
            if NotifyConfig.Description ~= "" then
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Font = Enum.Font.GothamMedium
                DescLabel.Text = NotifyConfig.Description
                DescLabel.TextColor3 = NotifyConfig.Color
                DescLabel.TextSize = 13
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.BackgroundTransparency = 1
                DescLabel.Size = UDim2.new(1, 0, 1, 0)
                -- Posisi: mulai setelah TextBounds title + margin 15px
                DescLabel.Position = UDim2.new(0, TitleLabel.TextBounds.X + 15, 0, 0)
                DescLabel.Name = "DescLabel"
                DescLabel.Parent = Top
            end

            -- Tombol Close
            local Close = Instance.new("TextButton")
            Close.Text = ""
            Close.AnchorPoint = Vector2.new(1, 0.5)
            Close.BackgroundTransparency = 1
            Close.Position = UDim2.new(1, -8, 0.5, 0)
            Close.Size = UDim2.new(0, 24, 0, 24)
            Close.Name = "Close"
            Close.Parent = Top

            local CloseImg = Instance.new("ImageLabel")
            CloseImg.Image = "rbxassetid://9886659671"
            CloseImg.ImageColor3 = Color3.fromRGB(160, 160, 165)
            CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
            CloseImg.BackgroundTransparency = 1
            CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            CloseImg.Size = UDim2.new(0.7, 0, 0.7, 0)
            CloseImg.Parent = Close

            -- ========================
            -- CONTENT TEXT (multi-line fix)
            -- ========================
            local hasButtons = #NotifyConfig.Buttons > 0

            if NotifyConfig.Content ~= "" then
                local TextLabel2 = Instance.new("TextLabel")
                TextLabel2.Font = Enum.Font.Gotham
                TextLabel2.TextColor3 = Color3.fromRGB(160, 160, 165)
                TextLabel2.TextSize = 13
                TextLabel2.Text = NotifyConfig.Content
                TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
                TextLabel2.BackgroundTransparency = 1
                TextLabel2.TextWrapped = true
                -- [FIX] Size awal tinggi agar TextBounds.Y bisa terhitung, width dikurangi 20 (margin kiri 10 + kanan 10)
                TextLabel2.Size = UDim2.new(1, -20, 0, 400)
                TextLabel2.Position = UDim2.new(0, 10, 0, 30)
                TextLabel2.Name = "TextLabel2"
                TextLabel2.Parent = ContentFrame

                task.defer(function()
                    if not TextLabel2 or not TextLabel2.Parent then return end
                    task.wait() -- tunggu 1 frame agar engine render TextBounds
                    if not TextLabel2 or not TextLabel2.Parent then return end

                    -- [FIX] Pakai TextBounds.Y untuk tinggi konten yang akurat (multi-line)
                    local contentH = TextLabel2.TextBounds.Y
                    if contentH <= 0 then contentH = 13 end

                    TextLabel2.Size = UDim2.new(1, -20, 0, contentH)

                    task.wait() -- tunggu 1 frame lagi setelah resize
                    if not NotifyFrame or not NotifyFrame.Parent then return end

                    if hasButtons then
                        local BtnRow = NotifyFrameReal:FindFirstChild("BtnRow")
                        if BtnRow then
                            local btnAreaY = 36 + contentH + 4
                            BtnRow.Position = UDim2.new(0, 10, 0, btnAreaY)
                            NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(70, btnAreaY + 32 + 10))
                        end
                    else
                        -- Top(36) + contentH + padding bawah(12)
                        local totalH = 36 + contentH + 12
                        NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(70, totalH))
                    end
                end)
            end

            -- ========================
            -- BUTTONS (opsional)
            -- ========================
            if hasButtons then
                local contentEstH = NotifyConfig.Content ~= "" and 28 or 0
                local btnAreaY = 36 + contentEstH + 4
                local gap = 6
                local btnCount = #NotifyConfig.Buttons
                local totalGap = gap * (btnCount - 1)

                local BtnRow = Instance.new("Frame")
                BtnRow.BackgroundTransparency = 1
                BtnRow.BorderSizePixel = 0
                BtnRow.Position = UDim2.new(0, 10, 0, btnAreaY)
                BtnRow.Size = UDim2.new(1, -20, 0, 28)
                BtnRow.Name = "BtnRow"
                BtnRow.Parent = NotifyFrameReal

                local BtnList = Instance.new("UIListLayout")
                BtnList.FillDirection = Enum.FillDirection.Horizontal
                BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Left
                BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
                BtnList.Padding = UDim.new(0, gap)
                BtnList.Parent = BtnRow

                for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                    local isPrimary = btnCfg.Primary == true

                    local Btn = Instance.new("TextButton")
                    Btn.Font = Enum.Font.GothamBold
                    Btn.Text = btnCfg.Name or ("Btn" .. idx)
                    Btn.TextSize = 12
                    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Btn.TextTransparency = isPrimary and 0.1 or 0.3
                    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Btn.BackgroundTransparency = 0.935
                    Btn.BorderSizePixel = 0
                    Btn.LayoutOrder = idx
                    Btn.Size = UDim2.new(1/btnCount, -(totalGap/btnCount), 1, 0)
                    Btn.Parent = BtnRow
                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

                    if isPrimary then
                        local BtnStroke = Instance.new("UIStroke")
                        BtnStroke.Color = NotifyConfig.Color
                        BtnStroke.Thickness = 1
                        BtnStroke.Transparency = 0.4
                        BtnStroke.Parent = Btn
                    end

                    Btn.MouseButton1Click:Connect(function()
                        if btnCfg.Callback then pcall(btnCfg.Callback) end
                        NotifyFunction:Close()
                    end)
                end

                -- Kalau tidak ada content, resize langsung
                if NotifyConfig.Content == "" then
                    task.defer(function()
                        task.wait()
                        if not NotifyFrame or not NotifyFrame.Parent then return end
                        NotifyFrame.Size = UDim2.new(1, 0, 0, btnAreaY + 28 + 10)
                    end)
                end
            end

            -- ========================
            -- CLOSE FUNCTION
            -- ========================
            local waitbruh = false
            function NotifyFunction:Close()
                if waitbruh then return false end
                waitbruh = true
                TweenService:Create(NotifyFrameReal, TweenInfo.new(
                    tonumber(NotifyConfig.Time),
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.In
                ), { Position = UDim2.new(0, 400, 0, 0) }):Play()
                task.wait(tonumber(NotifyConfig.Time) / 1.2)
                NotifyFrame:Destroy()
            end

            Close.Activated:Connect(function() NotifyFunction:Close() end)

            -- ========================
            -- SLIDE IN ANIMASI
            -- ========================
            TweenService:Create(NotifyFrameReal, TweenInfo.new(
                tonumber(NotifyConfig.Time),
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ), { Position = UDim2.new(0, 0, 0, 0) }):Play()

            -- ========================
            -- AUTO CLOSE
            -- ========================
            local delay = tonumber(NotifyConfig.Delay) or 0
            if not hasButtons then
                task.wait(delay)
                NotifyFunction:Close()
            elseif delay > 0 then
                task.wait(delay)
                NotifyFunction:Close()
            end
        end)

        return NotifyFunction
    end

    -- Shortcut function, sama seperti Lexs() di lexs.lua
    function NotifyModule:Nt(msg, delay, color, title, desc)
        return self:MakeNotify({
            Title       = title or "VelarisUI",
            Description = desc or "Notification",
            Content     = msg or "Content",
            Color       = color or Color3.fromRGB(0, 208, 255),
            Delay       = delay or 4,
        })
    end

    return NotifyModule
end

return MakeNotifyModule
