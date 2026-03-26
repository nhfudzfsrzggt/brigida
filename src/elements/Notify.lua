-- // VelarisUi | Notify.lua 

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
        local isClosing = false

        spawn(function()
            -- [FIX] ScreenGui Setup
            local notifyGui = CoreGui:FindFirstChild("NotifyGui")
            if not notifyGui then
                notifyGui = Instance.new("ScreenGui")
                notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                notifyGui.Name = "NotifyGui"
                notifyGui.ResetOnSpawn = false
                notifyGui.Parent = CoreGui
            end

            -- [FIX] Layout Management
            local notifyLayout = notifyGui:FindFirstChild("NotifyLayout")
            if not notifyLayout then
                notifyLayout = Instance.new("Frame")
                notifyLayout.AnchorPoint = Vector2.new(1, 1)
                notifyLayout.BackgroundTransparency = 1
                notifyLayout.BorderSizePixel = 0
                notifyLayout.Position = UDim2.new(1, -30, 1, -30)
                notifyLayout.Size = UDim2.new(0, 320, 1, 0)
                notifyLayout.Name = "NotifyLayout"
                notifyLayout.Parent = notifyGui

                local function reorganizeStack()
                    task.wait()
                    local frames = {}
                    for _, v in ipairs(notifyLayout:GetChildren()) do
                        if v:IsA("Frame") and v.Name == "NotifyFrame" then
                            table.insert(frames, v)
                        end
                    end
                    
                    table.sort(frames, function(a, b)
                        return a.LayoutOrder < b.LayoutOrder
                    end)
                    
                    local currentY = 0
                    for i, frame in ipairs(frames) do
                        if frame and frame.Parent then
                            -- Gunakan AbsoluteSize untuk akurasi stack
                            local h = frame.AbsoluteSize.Y > 0 and frame.AbsoluteSize.Y or 70
                            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                Position = UDim2.new(0, 0, 1, -(currentY + h + 12))
                            }):Play()
                            currentY = currentY + h + 12
                        end
                    end
                end

                notifyLayout.ChildRemoved:Connect(reorganizeStack)
                notifyLayout.ChildAdded:Connect(reorganizeStack)
            end

            -- ========================
            -- FRAME UTAMA
            -- ========================
            local notifyFrame = Instance.new("Frame")
            notifyFrame.BackgroundTransparency = 1
            notifyFrame.BorderSizePixel = 0
            notifyFrame.Size = UDim2.new(1, 0, 0, 70) -- Awal, akan di-resize
            notifyFrame.AnchorPoint = Vector2.new(0, 1)
            notifyFrame.Position = UDim2.new(0, 0, 1, 0) -- Spawn dari luar bawah
            notifyFrame.Name = "NotifyFrame"
            notifyFrame.LayoutOrder = tick()
            notifyFrame.Parent = notifyLayout

            local notifyFrameReal = Instance.new("Frame")
            notifyFrameReal.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
            notifyFrameReal.BorderSizePixel = 0
            notifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
            notifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
            notifyFrameReal.Name = "NotifyFrameReal"
            notifyFrameReal.Parent = notifyFrame
            
            local corner = Instance.new("UICorner", notifyFrameReal)
            corner.CornerRadius = UDim.new(0, 10)

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = Color3.fromRGB(40, 40, 45)
            cardStroke.Thickness = 1
            cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            cardStroke.Parent = notifyFrameReal

            -- ========================
            -- ICON
            -- ========================
            local iconId = getIconId(NotifyConfig.Icon)
            local hasIcon = iconId ~= ""

            local leftIcon = Instance.new("ImageLabel")
            leftIcon.Image = hasIcon and iconId or "rbxassetid://17495379799"
            leftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            leftIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            leftIcon.BackgroundTransparency = 0
            leftIcon.BorderSizePixel = 0
            leftIcon.Size = UDim2.new(0, 55, 1, 0) -- Full Height
            leftIcon.ScaleType = Enum.ScaleType.Fit
            leftIcon.Name = "LeftIcon"
            leftIcon.Parent = notifyFrameReal
            
            local iconCorner = Instance.new("UICorner", leftIcon)
            iconCorner.CornerRadius = UDim.new(0, 10)
            
            -- Fix overlap corner kiri bawah/atas
            local iconFixer = Instance.new("Frame")
            iconFixer.BackgroundTransparency = 1
            iconFixer.Size = UDim2.new(0, 10, 1, 0)
            iconFixer.Position = UDim2.new(1, -10, 0, 0)
            iconFixer.Name = "IconFix"
            iconFixer.Parent = leftIcon

            -- ========================
            -- CONTENT FRAME
            -- ========================
            local contentFrame = Instance.new("Frame")
            contentFrame.BackgroundTransparency = 1
            contentFrame.BorderSizePixel = 0
            contentFrame.Position = UDim2.new(0, 55, 0, 0)
            contentFrame.Size = UDim2.new(1, -55, 1, 0)
            contentFrame.Name = "ContentFrame"
            contentFrame.Parent = notifyFrameReal

            -- ========================
            -- TOP BAR (Title + Desc)
            -- ========================
            local topBar = Instance.new("Frame")
            topBar.BackgroundTransparency = 1
            topBar.BorderSizePixel = 0
            topBar.Size = UDim2.new(1, 0, 0, 36)
            topBar.Name = "TopBar"
            topBar.Parent = contentFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.Text = NotifyConfig.Title
            titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
            titleLabel.TextSize = 14
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.BackgroundTransparency = 1
            titleLabel.Size = UDim2.new(1, -50, 1, 0)
            titleLabel.Position = UDim2.new(0, 10, 0, 0)
            titleLabel.Name = "TitleLabel"
            titleLabel.Parent = topBar

            local descLabel = nil
            if NotifyConfig.Description ~= "" then
                descLabel = Instance.new("TextLabel")
                descLabel.Font = Enum.Font.GothamMedium
                descLabel.Text = NotifyConfig.Description
                descLabel.TextColor3 = NotifyConfig.Color
                descLabel.TextSize = 13
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.BackgroundTransparency = 1
                descLabel.Size = UDim2.new(1, 0, 1, 0)
                descLabel.Name = "DescLabel"
                descLabel.Parent = topBar
                
                task.defer(function()
                    if titleLabel and titleLabel.Parent then
                        task.wait()
                        if titleLabel and titleLabel.Parent then
                            descLabel.Position = UDim2.new(0, titleLabel.TextBounds.X + 15, 0, 0)
                        end
                    end
                end)
            end

            -- Close Button
            local closeBtn = Instance.new("TextButton")
            closeBtn.Text = ""
            closeBtn.AnchorPoint = Vector2.new(1, 0.5)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
            closeBtn.Size = UDim2.new(0, 24, 0, 24)
            closeBtn.Name = "CloseBtn"
            closeBtn.Parent = topBar

            local closeImg = Instance.new("ImageLabel")
            closeImg.Image = "rbxassetid://9886659671"
            closeImg.ImageColor3 = Color3.fromRGB(160, 160, 165)
            closeImg.AnchorPoint = Vector2.new(0.5, 0.5)
            closeImg.BackgroundTransparency = 1
            closeImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            closeImg.Size = UDim2.new(0.7, 0, 0.7, 0)
            closeImg.Parent = closeBtn

            -- ========================
            -- CONTENT TEXT & RESIZE LOGIC
            -- ========================
            local hasButtons = #NotifyConfig.Buttons > 0
            local contentHeight = 0
            local textLabel = nil
            
            -- Konstanta Ukuran
            local PADDING_Y = 10 -- Padding atas/bawah symmetrical
            local MIN_HEIGHT = 55 -- Tinggi minimal (lebih kecil agar simetris)
            local TOPBAR_H = 36
            
            if NotifyConfig.Content ~= "" then
                textLabel = Instance.new("TextLabel")
                textLabel.Font = Enum.Font.Gotham
                textLabel.TextColor3 = Color3.fromRGB(160, 160, 165)
                textLabel.TextSize = 13
                textLabel.Text = NotifyConfig.Content
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.TextYAlignment = Enum.TextYAlignment.Top
                textLabel.BackgroundTransparency = 1
                textLabel.TextWrapped = true
                textLabel.Size = UDim2.new(1, -20, 0, 1000)
                textLabel.Position = UDim2.new(0, 10, 0, TOPBAR_H) -- Sementara
                textLabel.Name = "ContentText"
                textLabel.Parent = contentFrame
            end

            local btnRow = nil
            if hasButtons then
                btnRow = Instance.new("Frame")
                btnRow.BackgroundTransparency = 1
                btnRow.BorderSizePixel = 0
                btnRow.Size = UDim2.new(1, -20, 0, 28)
                btnRow.Name = "BtnRow"
                btnRow.Parent = notifyFrameReal -- Note: Parent ke RealFrame agar bisa di-swap posisi

                local btnList = Instance.new("UIListLayout")
                btnList.FillDirection = Enum.FillDirection.Horizontal
                btnList.HorizontalAlignment = Enum.HorizontalAlignment.Left
                btnList.VerticalAlignment = Enum.VerticalAlignment.Center
                btnList.Padding = UDim.new(0, 6)
                btnList.Parent = btnRow

                for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                    local isPrimary = btnCfg.Primary == true
                    local btn = Instance.new("TextButton")
                    btn.Font = Enum.Font.GothamBold
                    btn.Text = btnCfg.Name or ("Button " .. idx)
                    btn.TextSize = 12
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.TextTransparency = isPrimary and 0.1 or 0.3
                    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    btn.BackgroundTransparency = 0.935
                    btn.BorderSizePixel = 0
                    btn.LayoutOrder = idx
                    btn.Size = UDim2.new(1 / #NotifyConfig.Buttons, -((6 * (#NotifyConfig.Buttons - 1)) / #NotifyConfig.Buttons), 1, 0)
                    btn.Parent = btnRow
                    
                    local btnCorner = Instance.new("UICorner", btn)
                    btnCorner.CornerRadius = UDim.new(0, 6)

                    if isPrimary then
                        local btnStroke = Instance.new("UIStroke")
                        btnStroke.Color = NotifyConfig.Color
                        btnStroke.Thickness = 1
                        btnStroke.Transparency = 0.4
                        btnStroke.Parent = btn
                    end

                    btn.MouseButton1Click:Connect(function()
                        if btnCfg.Callback then
                            pcall(btnCfg.Callback)
                        end
                        NotifyFunction:Close()
                    end)
                end
            end

            -- [FIX] KALKULASI UKURAN FINAL & CENTERING
            task.defer(function()
                if not notifyFrame or not notifyFrame.Parent then return end
                
                -- 1. Hitung Tinggi Konten
                local textBounds = textLabel and textLabel.TextBounds.Y or 0
                contentHeight = math.max(textBounds, 0)
                
                -- 2. Hitung Total Tinggi yang Dibutuhkan
                local neededHeight = TOPBAR_H + contentHeight + PADDING_Y
                if btnRow then
                    neededHeight = neededHeight + 4 + 28 -- Gap + Button Height
                end
                
                -- 3. Terapkan Minimal Height (Simetris)
                local finalHeight = math.max(MIN_HEIGHT, neededHeight)
                
                -- 4. Update Frame Size
                notifyFrame.Size = UDim2.new(1, 0, 0, finalHeight)
                
                -- 5. [SYMMENTRY FIX] Posisikan Elemen Secara Dinamis
                -- Jika tinggi final > yang dibutuhkan (karena min height), kita centerkan konten
                local extraSpace = finalHeight - neededHeight
                local topOffset = PADDING_Y + (extraSpace / 2) -- Bagi rata sisa ruang
                
                -- Update TopBar Position
                topBar.Position = UDim2.new(0, 0, 0, topOffset)
                
                -- Update Content Position
                if textLabel then
                    textLabel.Position = UDim2.new(0, 10, 0, topOffset + TOPBAR_H)
                end
                
                -- Update Button Position
                if btnRow then
                    btnRow.Position = UDim2.new(0, 65, 0, topOffset + TOPBAR_H + contentHeight + 4) -- 55 (icon) + 10 (padding)
                end
                
                -- 6. Update Stack (Trigger reorganize)
                -- Kita bisa paksa update posisi jika sudah ada di stack
                 local currentChildren = notifyLayout:GetChildren()
                 local count = 0
                 for _, v in pairs(currentChildren) do
                     if v.Name == "NotifyFrame" then count = count + 1 end
                 end
                 -- Jika ini notif pertama, posisi handle by ChildAdded, jika tidak perlu manual
            end)

            -- ========================
            -- CLOSE FUNCTION
            -- ========================
            function NotifyFunction:Close()
                if isClosing then return false end
                isClosing = true
                
                local tweenTime = tonumber(NotifyConfig.Time) or 0.5
                
                local closeTween = TweenService:Create(notifyFrameReal, TweenInfo.new(
                    tweenTime,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.In
                ), { Position = UDim2.new(0, 400, 0, 0) })
                
                closeTween:Play()
                
                task.delay(tweenTime + 0.1, function()
                    if notifyFrame and notifyFrame.Parent then
                        notifyFrame:Destroy()
                    end
                end)
                
                return true
            end

            closeBtn.Activated:Connect(function() NotifyFunction:Close() end)

            -- ========================
            -- ANIMASI MASUK
            -- ========================
            TweenService:Create(notifyFrameReal, TweenInfo.new(
                tonumber(NotifyConfig.Time) or 0.5,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ), { Position = UDim2.new(0, 0, 0, 0) }):Play()

            if tonumber(NotifyConfig.Delay) > 0 then
                task.delay(NotifyConfig.Delay, function()
                    NotifyFunction:Close()
                end)
            end
        end)

        return NotifyFunction
    end

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
