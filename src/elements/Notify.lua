-- // VilarisUi | Notify.lua | Standalone Notify Module

local function MakeNotifyModule(TweenService, CoreGui, getIconId)

    local NotifyModule = {}

    function NotifyModule:MakeNotify(NotifyConfig)
        NotifyConfig = NotifyConfig or {}
        NotifyConfig.Title       = NotifyConfig.Title or "Velaris UI"
        NotifyConfig.Description = NotifyConfig.Description or ""
        NotifyConfig.Content     = NotifyConfig.Content or ""
        NotifyConfig.Color       = NotifyConfig.Color or Color3.fromRGB(0, 208, 255)
        NotifyConfig.Time        = NotifyConfig.Time or 0.5
        NotifyConfig.Delay       = NotifyConfig.Delay or 5
        NotifyConfig.Buttons     = NotifyConfig.Buttons or {}

        local NotifyFunction = {}

        spawn(function()
            if not CoreGui:FindFirstChild("NotifyGui") then
                local NotifyGui = Instance.new("ScreenGui")
                NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                NotifyGui.Name = "NotifyGui"
                NotifyGui.Parent = CoreGui
            end

            if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
                local NotifyLayout = Instance.new("Frame")
                NotifyLayout.AnchorPoint = Vector2.new(1, 1)
                NotifyLayout.BackgroundTransparency = 1
                NotifyLayout.BorderSizePixel = 0
                NotifyLayout.Position = UDim2.new(1, -16, 1, -16)
                NotifyLayout.Size = UDim2.new(0, 300, 1, 0)
                NotifyLayout.Name = "NotifyLayout"
                NotifyLayout.Parent = CoreGui.NotifyGui

                local Count = 0
                CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
                    Count = 0
                    for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                        if v:IsA("Frame") then
                            TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                                Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 10) * Count))
                            }):Play()
                            Count = Count + 1
                        end
                    end
                end)
            end

            local NotifyPosHeigh = 0
            for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                if v:IsA("Frame") then
                    NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 10
                end
            end

            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.BackgroundTransparency = 1
            NotifyFrame.BorderSizePixel = 0
            NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
            NotifyFrame.AnchorPoint = Vector2.new(0, 1)
            NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)
            NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout

            local NotifyFrameReal = Instance.new("Frame")
            NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            NotifyFrameReal.BorderSizePixel = 0
            NotifyFrameReal.Position = UDim2.new(0, 320, 0, 0)
            NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
            NotifyFrameReal.ClipsDescendants = false
            NotifyFrameReal.Parent = NotifyFrame
            Instance.new("UICorner", NotifyFrameReal).CornerRadius = UDim.new(0, 10)

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Color3.fromRGB(50, 50, 62)
            CardStroke.Thickness = 1
            CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            CardStroke.Parent = NotifyFrameReal

            local iconId = getIconId(NotifyConfig.Icon or "")
            local hasIcon = iconId ~= ""
            local hasButtons = #NotifyConfig.Buttons > 0

            local titleOffsetX = 12

            if hasIcon then
                if hasButtons then
                    local IconImg = Instance.new("ImageLabel")
                    IconImg.BackgroundTransparency = 1
                    IconImg.BorderSizePixel = 0
                    IconImg.AnchorPoint = Vector2.new(0, 0)
                    IconImg.Position = UDim2.new(0, 12, 0, 10)
                    IconImg.Size = UDim2.new(0, 17, 0, 17)
                    IconImg.Image = iconId
                    IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    IconImg.ScaleType = Enum.ScaleType.Fit
                    IconImg.Parent = NotifyFrameReal
                    titleOffsetX = 12 + 17 + 5
                else
                    local LeftIcon = Instance.new("ImageLabel")
                    LeftIcon.Image = iconId
                    LeftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    LeftIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                    LeftIcon.BackgroundTransparency = 0
                    LeftIcon.BorderSizePixel = 0
                    LeftIcon.Position = UDim2.new(0, 0, 0, 0)
                    LeftIcon.Size = UDim2.new(0, 50, 1, 0)
                    LeftIcon.ScaleType = Enum.ScaleType.Fit
                    LeftIcon.Parent = NotifyFrameReal
                    Instance.new("UICorner", LeftIcon).CornerRadius = UDim.new(0, 10)
                    titleOffsetX = 58
                end
            end

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = NotifyConfig.Title
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, titleOffsetX, 0, 10)
            TitleLabel.Size = UDim2.new(1, -titleOffsetX - 10, 0, 16)
            TitleLabel.Parent = NotifyFrameReal

            if NotifyConfig.Description ~= "" then
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Font = Enum.Font.GothamMedium
                DescLabel.Text = NotifyConfig.Description
                DescLabel.TextColor3 = NotifyConfig.Color
                DescLabel.TextSize = 11
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.BackgroundTransparency = 1
                DescLabel.Position = UDim2.new(0, titleOffsetX + TitleLabel.TextBounds.X + 6, 0, 11)
                DescLabel.Size = UDim2.new(1, -(titleOffsetX + TitleLabel.TextBounds.X + 16), 0, 14)
                DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
                DescLabel.Parent = NotifyFrameReal
            end

            if NotifyConfig.Content ~= "" then
                local ContentLabel = Instance.new("TextLabel")
                ContentLabel.Font = Enum.Font.Gotham
                ContentLabel.TextColor3 = Color3.fromRGB(160, 160, 172)
                ContentLabel.TextSize = 12
                ContentLabel.Text = NotifyConfig.Content
                ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
                ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
                ContentLabel.BackgroundTransparency = 1
                ContentLabel.TextWrapped = true
                ContentLabel.Position = UDim2.new(0, titleOffsetX, 0, 30)
                ContentLabel.Size = UDim2.new(1, -(titleOffsetX + 10), 0, 14)
                ContentLabel.Parent = NotifyFrameReal

                task.defer(function()
                    if not ContentLabel or not ContentLabel.Parent then return end
                    local lineH = 14
                    local maxW  = ContentLabel.AbsoluteSize.X
                    local lines = 1
                    if maxW > 0 then
                        lines = math.max(1, math.ceil(ContentLabel.TextBounds.X / maxW))
                    end
                    local contentH = lineH * lines
                    ContentLabel.Size = UDim2.new(1, -(titleOffsetX + 10), 0, contentH)

                    task.wait()
                    if not NotifyFrame or not NotifyFrame.Parent then return end
                    local totalH = 30 + contentH + 12
                    NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(70, totalH))
                end)
            end

            if hasButtons then
                local contentEstH = 14
                if NotifyConfig.Content ~= "" then
                    contentEstH = 30
                end
                local btnAreaY   = 30 + contentEstH + 4
                local gap        = 6
                local btnCount   = #NotifyConfig.Buttons
                local totalGap   = gap * (btnCount - 1)

                local BtnRow = Instance.new("Frame")
                BtnRow.BackgroundTransparency = 1
                BtnRow.BorderSizePixel = 0
                BtnRow.Position = UDim2.new(0, 12, 0, btnAreaY)
                BtnRow.Size = UDim2.new(1, -24, 0, 28)
                BtnRow.Parent = NotifyFrameReal

                local BtnList = Instance.new("UIListLayout")
                BtnList.FillDirection = Enum.FillDirection.Horizontal
                BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Left
                BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
                BtnList.Padding = UDim.new(0, gap)
                BtnList.Parent = BtnRow

                for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                    local Btn = Instance.new("TextButton")
                    Btn.Font = Enum.Font.GothamBold
                    Btn.TextSize = 11
                    Btn.Text = ""
                    Btn.AutomaticSize = Enum.AutomaticSize.None
                    Btn.Size = UDim2.new(1/btnCount, -(totalGap/btnCount), 1, 0)
                    Btn.BorderSizePixel = 0
                    Btn.LayoutOrder = idx

                    local isPrimary = btnCfg.Primary == true
                    if isPrimary then
                        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
                        Btn.TextColor3 = Color3.fromRGB(220, 220, 230)
                    else
                        Btn.BackgroundColor3 = Color3.fromRGB(33, 33, 42)
                        Btn.TextColor3 = Color3.fromRGB(160, 160, 175)
                    end

                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

                    local BtnStroke = Instance.new("UIStroke")
                    BtnStroke.Color = isPrimary and Color3.fromRGB(70, 70, 88) or Color3.fromRGB(50, 50, 62)
                    BtnStroke.Thickness = 1
                    BtnStroke.Parent = Btn

                    local BtnInner = Instance.new("Frame")
                    BtnInner.BackgroundTransparency = 1
                    BtnInner.AutomaticSize = Enum.AutomaticSize.X
                    BtnInner.AnchorPoint = Vector2.new(0.5, 0.5)
                    BtnInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                    BtnInner.Size = UDim2.new(0, 0, 1, 0)
                    BtnInner.Parent = Btn

                    local BtnInnerList = Instance.new("UIListLayout")
                    BtnInnerList.FillDirection = Enum.FillDirection.Horizontal
                    BtnInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    BtnInnerList.VerticalAlignment = Enum.VerticalAlignment.Center
                    BtnInnerList.Padding = UDim.new(0, 4)
                    BtnInnerList.Parent = BtnInner

                    local btnIconId = getIconId(btnCfg.Icon or "")
                    if btnIconId ~= "" then
                        local BtnIcon = Instance.new("ImageLabel")
                        BtnIcon.BackgroundTransparency = 1
                        BtnIcon.Size = UDim2.new(0, 11, 0, 11)
                        BtnIcon.Image = btnIconId
                        BtnIcon.ImageColor3 = isPrimary and Color3.fromRGB(220,220,230) or Color3.fromRGB(160,160,175)
                        BtnIcon.ScaleType = Enum.ScaleType.Fit
                        BtnIcon.LayoutOrder = 0
                        BtnIcon.Parent = BtnInner
                    end

                    local BtnLabel = Instance.new("TextLabel")
                    BtnLabel.Font = Enum.Font.GothamBold
                    BtnLabel.Text = btnCfg.Name or ("Btn" .. idx)
                    BtnLabel.TextSize = 11
                    BtnLabel.TextColor3 = isPrimary and Color3.fromRGB(220,220,230) or Color3.fromRGB(160,160,175)
                    BtnLabel.BackgroundTransparency = 1
                    BtnLabel.AutomaticSize = Enum.AutomaticSize.X
                    BtnLabel.Size = UDim2.new(0, 0, 1, 0)
                    BtnLabel.LayoutOrder = 1
                    BtnLabel.Parent = BtnInner

                    Btn.Parent = BtnRow

                    Btn.MouseButton1Click:Connect(function()
                        if btnCfg.Callback then pcall(btnCfg.Callback) end
                        NotifyFunction:Close()
                    end)
                end

                task.defer(function()
                    task.wait()
                    if not NotifyFrame or not NotifyFrame.Parent then return end
                    NotifyFrame.Size = UDim2.new(1, 0, 0, btnAreaY + 28 + 12)
                    BtnRow.Position = UDim2.new(0, 12, 0, btnAreaY)
                end)
            end

            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Text = ""
            CloseBtn.AnchorPoint = Vector2.new(1, 0)
            CloseBtn.BackgroundTransparency = 1
            CloseBtn.Position = UDim2.new(1, -6, 0, 6)
            CloseBtn.Size = UDim2.new(0, 18, 0, 18)
            CloseBtn.Parent = NotifyFrameReal

            local CloseImg = Instance.new("ImageLabel")
            CloseImg.Image = "rbxassetid://9886659671"
            CloseImg.ImageColor3 = Color3.fromRGB(120, 120, 135)
            CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
            CloseImg.BackgroundTransparency = 1
            CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            CloseImg.Size = UDim2.new(1, 0, 1, 0)
            CloseImg.Parent = CloseBtn

            local waitbruh = false
            function NotifyFunction:Close()
                if waitbruh then return false end
                waitbruh = true
                TweenService:Create(NotifyFrameReal, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(0, 320, 0, 0)
                }):Play()
                task.wait(0.3)
                NotifyFrame:Destroy()
            end

            CloseBtn.Activated:Connect(function() NotifyFunction:Close() end)

            TweenService:Create(NotifyFrameReal, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()

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
