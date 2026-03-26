-- // VilarisUi | Notify.lua | Standalone Notify Module

local function MakeNotifyModule(TweenService, CoreGui, getIconId)

    local NotifyModule = {}

    function NotifyModule:MakeNotify(NotifyConfig)
        NotifyConfig = NotifyConfig or {}
        NotifyConfig.Title       = NotifyConfig.Title or "Velaris UI"
        NotifyConfig.Description = NotifyConfig.Description or ""
        NotifyConfig.Content     = NotifyConfig.Content or ""
        
        -- Validasi Color
        if typeof(NotifyConfig.Color) ~= "Color3" then
            NotifyConfig.Color = Color3.fromRGB(0, 208, 255)
        end
        
        NotifyConfig.Time        = NotifyConfig.Time or 0.5
        NotifyConfig.Delay       = NotifyConfig.Delay or 5
        NotifyConfig.Buttons     = NotifyConfig.Buttons or {}

        local NotifyFunction = {}

        spawn(function()
            -- Inisialisasi GUI Utama
            if not CoreGui:FindFirstChild("NotifyGui") then
                local NotifyGui = Instance.new("ScreenGui")
                NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                NotifyGui.Name = "NotifyGui"
                NotifyGui.ResetOnSpawn = false
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

                -- Logika penataan ulang posisi saat ada notifikasi yang hilang
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

            -- Hitung posisi awal (berdasarkan notifikasi yang sudah ada)
            local NotifyPosHeigh = 0
            for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
                if v:IsA("Frame") then
                    NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 10
                end
            end

            --[[
                FRAME UTAMA (Place Holder)
                Berfungsi sebagai 'kotak' yang menentukan ruang di layout.
                Ukurannya akan di-Tween belakangan setelah konten selesai render.
            ]]
            local NotifyFrame = Instance.new("Frame")
            NotifyFrame.BackgroundTransparency = 1
            NotifyFrame.BorderSizePixel = 0
            NotifyFrame.Size = UDim2.new(1, 0, 0, 0) -- Mulai dari tinggi 0
            NotifyFrame.AnchorPoint = Vector2.new(0, 1)
            NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)
            NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
            NotifyFrame.ClipsDescendants = true

            --[[
                FRAME KONTEN (Card)
                Menggunakan AutomaticSize.Y untuk membesar otomatis.
            ]]
            local NotifyFrameReal = Instance.new("Frame")
            NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            NotifyFrameReal.BorderSizePixel = 0
            NotifyFrameReal.Position = UDim2.new(0, 320, 0, 0) -- Posisi awal di luar layar (kanan)
            NotifyFrameReal.Size = UDim2.new(1, 0, 0, 0) -- Ukuran dasar
            NotifyFrameReal.AutomaticSize = Enum.AutomaticSize.Y -- Otomatis membesar ke bawah
            NotifyFrameReal.Parent = NotifyFrame
            Instance.new("UICorner", NotifyFrameReal).CornerRadius = UDim.new(0, 10)

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Color3.fromRGB(50, 50, 62)
            CardStroke.Thickness = 1
            CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            CardStroke.Parent = NotifyFrameReal

            -- Ikon & Variabel
            local iconId = getIconId(NotifyConfig.Icon or "")
            local hasIcon = iconId ~= ""
            local hasButtons = #NotifyConfig.Buttons > 0

            --[[
                LAYOUT UTAMA
                UIListLayout menyusun Header, Content, dan Button secara vertikal otomatis.
            ]]
            local MainList = Instance.new("UIListLayout")
            MainList.FillDirection = Enum.FillDirection.Vertical
            MainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            MainList.VerticalAlignment = Enum.VerticalAlignment.Top
            MainList.Padding = UDim.new(0, 4) -- Jarak antar elemen
            MainList.Parent = NotifyFrameReal

            -- Padding tepi
            local Pad = Instance.new("UIPadding")
            Pad.PaddingTop = UDim.new(0, 10)
            Pad.PaddingBottom = UDim.new(0, 10)
            Pad.PaddingLeft = UDim.new(0, 12)
            Pad.PaddingRight = UDim.new(0, 12)
            Pad.Parent = NotifyFrameReal

            -- Ikon Samping Kiri (Jika ada dan bukan mode tombol)
            if hasIcon and not hasButtons then
                local LeftIcon = Instance.new("ImageLabel")
                LeftIcon.Image = iconId
                LeftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                LeftIcon.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                LeftIcon.BackgroundTransparency = 0
                LeftIcon.BorderSizePixel = 0
                LeftIcon.Position = UDim2.new(0, 0, 0, 0)
                LeftIcon.Size = UDim2.new(0, 50, 1, 0) -- Akan mengikuti tinggi parent
                LeftIcon.ScaleType = Enum.ScaleType.Fit
                LeftIcon.Parent = NotifyFrameReal
                Instance.new("UICorner", LeftIcon).CornerRadius = UDim.new(0, 10)
                
                -- Sesuaikan Padding Kiri agar teks tidak menimpa ikon
                Pad.PaddingLeft = UDim.new(0, 58)
            end

            --[[
                HEADER CONTAINER (Vertical Layout)
                Disusun vertikal agar teks panjang tidak bertabrakan.
            ]]
            local HeaderContainer = Instance.new("Frame")
            HeaderContainer.AutomaticSize = Enum.AutomaticSize.Y -- Tinggi otomatis
            HeaderContainer.Size = UDim2.new(1, 0, 0, 0)
            HeaderContainer.BackgroundTransparency = 1
            HeaderContainer.LayoutOrder = 1
            HeaderContainer.Parent = NotifyFrameReal

            local HeaderLayout = Instance.new("UIListLayout")
            HeaderLayout.FillDirection = Enum.FillDirection.Vertical -- Susun atas-bawah
            HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            HeaderLayout.Padding = UDim.new(0, 2) -- Jarak antar judul/desc
            HeaderLayout.Parent = HeaderContainer

            -- Baris 1: Icon Kecil + Title (Horizontal)
            local TitleRow = Instance.new("Frame")
            TitleRow.Size = UDim2.new(1, 0, 0, 16)
            TitleRow.AutomaticSize = Enum.AutomaticSize.Y
            TitleRow.BackgroundTransparency = 1
            TitleRow.Parent = HeaderContainer
            
            local TitleRowLayout = Instance.new("UIListLayout")
            TitleRowLayout.FillDirection = Enum.FillDirection.Horizontal
            TitleRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            TitleRowLayout.Padding = UDim.new(0, 6)
            TitleRowLayout.Parent = TitleRow

            -- Ikon Kecil di samping Title (jika ada tombol)
            if hasIcon and hasButtons then
                local IconImg = Instance.new("ImageLabel")
                IconImg.BackgroundTransparency = 1
                IconImg.Size = UDim2.new(0, 17, 0, 17)
                IconImg.Image = iconId
                IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
                IconImg.ScaleType = Enum.ScaleType.Fit
                IconImg.Parent = TitleRow
            end

            -- Title
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = NotifyConfig.Title
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Size = UDim2.new(1, 0, 0, 0) -- Lebar penuh
            TitleLabel.AutomaticSize = Enum.AutomaticSize.Y -- Tinggi mengikuti teks
            TitleLabel.TextWrapped = true -- Wrap jika judul super panjang
            TitleLabel.Parent = TitleRow

            -- Baris 2: Description (Di bawah Title)
            if NotifyConfig.Description ~= "" then
                local DescLabel = Instance.new("TextLabel")
                DescLabel.Font = Enum.Font.GothamMedium
                DescLabel.Text = NotifyConfig.Description
                DescLabel.TextColor3 = NotifyConfig.Color
                DescLabel.TextSize = 11
                DescLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescLabel.BackgroundTransparency = 1
                DescLabel.Size = UDim2.new(1, 0, 0, 0)
                DescLabel.AutomaticSize = Enum.AutomaticSize.Y
                DescLabel.TextWrapped = true -- Wrap jika deskripsi panjang
                DescLabel.Parent = HeaderContainer
            end

            --[[
                CONTENT (Body)
                Bagian ini yang paling sering panjang.
            ]]
            if NotifyConfig.Content ~= "" then
                local ContentLabel = Instance.new("TextLabel")
                ContentLabel.Font = Enum.Font.Gotham
                ContentLabel.TextColor3 = Color3.fromRGB(160, 160, 172)
                ContentLabel.TextSize = 12
                ContentLabel.Text = NotifyConfig.Content
                ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
                ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
                ContentLabel.BackgroundTransparency = 1
                
                -- PENTING: Ini membuat teks menjadi multi-line
                ContentLabel.TextWrapped = true 
                ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
                
                -- Lebar 100%, Tinggi 0 (otomatis)
                ContentLabel.Size = UDim2.new(1, 0, 0, 0)
                ContentLabel.LayoutOrder = 2
                ContentLabel.Parent = NotifyFrameReal
            end

            --[[
                BUTTONS
                Menggunakan LayoutOrder 3.
            ]]
            if hasButtons then
                local BtnRow = Instance.new("Frame")
                BtnRow.BackgroundTransparency = 1
                BtnRow.AutomaticSize = Enum.AutomaticSize.Y
                BtnRow.Size = UDim2.new(1, 0, 0, 0)
                BtnRow.LayoutOrder = 3
                BtnRow.Parent = NotifyFrameReal

                local BtnList = Instance.new("UIListLayout")
                BtnList.FillDirection = Enum.FillDirection.Horizontal
                BtnList.HorizontalAlignment = Enum.HorizontalAlignment.Left
                BtnList.VerticalAlignment = Enum.VerticalAlignment.Center
                BtnList.Padding = UDim.new(0, 6)
                BtnList.Parent = BtnRow

                for idx, btnCfg in ipairs(NotifyConfig.Buttons) do
                    local Btn = Instance.new("TextButton")
                    Btn.Font = Enum.Font.GothamBold
                    Btn.TextSize = 11
                    Btn.Text = ""
                    Btn.AutomaticSize = Enum.AutomaticSize.Y -- Tinggi tombol otomatis
                    Btn.Size = UDim2.new(1/#NotifyConfig.Buttons, -6, 0, 28) -- Lebar dibagi rata
                    Btn.BorderSizePixel = 0
                    Btn.LayoutOrder = idx

                    local isPrimary = btnCfg.Primary == true
                    Btn.BackgroundColor3 = isPrimary and Color3.fromRGB(45, 45, 58) or Color3.fromRGB(33, 33, 42)
                    Btn.TextColor3 = isPrimary and Color3.fromRGB(220, 220, 230) or Color3.fromRGB(160, 160, 175)

                    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

                    local BtnStroke = Instance.new("UIStroke")
                    BtnStroke.Color = isPrimary and Color3.fromRGB(70, 70, 88) or Color3.fromRGB(50, 50, 62)
                    BtnStroke.Thickness = 1
                    BtnStroke.Parent = Btn

                    -- Inner Button Content
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
            end

            -- Close Button
            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Text = ""
            CloseBtn.AnchorPoint = Vector2.new(1, 0)
            CloseBtn.BackgroundTransparency = 1
            CloseBtn.Position = UDim2.new(1, -6, 0, 6)
            CloseBtn.Size = UDim2.new(0, 18, 0, 18)
            CloseBtn.ZIndex = 10 -- Pastikan di atas
            CloseBtn.Parent = NotifyFrameReal

            local CloseImg = Instance.new("ImageLabel")
            CloseImg.Image = "rbxassetid://9886659671"
            CloseImg.ImageColor3 = Color3.fromRGB(120, 120, 135)
            CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
            CloseImg.BackgroundTransparency = 1
            CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            CloseImg.Size = UDim2.new(1, 0, 1, 0)
            CloseImg.Parent = CloseBtn

            --[[
                FUNGSI CLOSE
            ]]
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

            --[[
                LOGIKA RESIZE UTAMA
                1. Tunggu render (task.wait)
                2. Baca AbsoluteSize.Y dari NotifyFrameReal
                3. Tween NotifyFrame (container luar) ke ukuran tersebut
            ]]
            task.wait() -- Menunggu satu frame agar AutomaticSize bekerja
            if not NotifyFrame or not NotifyFrame.Parent then return end

            local targetHeight = NotifyFrameReal.AbsoluteSize.Y
            
            -- Tween ukuran placeholder agar layout notifikasi lain bergeser
            TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, targetHeight)
            }):Play()

            -- Animasi Slide In
            TweenService:Create(NotifyFrameReal, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()

            -- Auto Close Logic
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
