-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   CONFIG SECTION — Velaris UI                                   ║
-- ║   Fitur: Create, Load, Overwrite, Delete, Autoload, Refresh     ║
-- ║   Cara pakai: lihat contoh di bawah (bagian USAGE)             ║
-- ╚══════════════════════════════════════════════════════════════════╝

--[[
USAGE — tambahkan di Main.lua kamu setelah membuat Tab & Section:

    local ConfigSection = loadstring(game:HttpGet("URL_CONFIG_SECTION"))()
    
    local cfgTab = Window:AddTab({ Name = "Configuration", Icon = "settings" })
    local cfgSection = cfgTab:AddSection({ Name = "Configuration" })
    
    ConfigSection(cfgSection, {
        FolderName  = "VelarisUI/Config",   -- folder tempat config disimpan
        Elements    = Elements,             -- table Elements dari Velaris UI
        ConfigData  = ConfigData,           -- table ConfigData dari Velaris UI
        SaveConfig  = SaveConfig,           -- fungsi SaveConfig dari Velaris UI
        LoadConfig  = LoadConfigElements,  -- fungsi LoadConfigElements dari Velaris UI
        Version     = CURRENT_VERSION,
        HttpService = game:GetService("HttpService"),
    })
]]

local function ConfigSection(Section, Options)
    Options = Options or {}

    local FolderName  = Options.FolderName  or "VelarisUI/Config"
    local Elements    = Options.Elements    or {}
    local ConfigData  = Options.ConfigData  or {}
    local SaveConfig  = Options.SaveConfig  or function() end
    local LoadConfig  = Options.LoadConfig  or function() end
    local Version     = Options.Version     or 1
    local HttpService = Options.HttpService or game:GetService("HttpService")

    -- ── Pastikan folder ada ─────────────────────────────────────────
    local function EnsureFolder(path)
        if not (isfolder and makefolder) then return end
        local parts = string.split(path, "/")
        local cur = ""
        for i, seg in ipairs(parts) do
            cur = (i == 1) and seg or (cur .. "/" .. seg)
            if not isfolder(cur) then
                makefolder(cur)
            end
        end
    end
    EnsureFolder(FolderName)

    -- ── Helpers file ────────────────────────────────────────────────
    local function GetConfigPath(name)
        return FolderName .. "/" .. name .. ".json"
    end

    local function GetConfigList()
        local list = {}
        if not listfiles then return list end
        local ok, files = pcall(listfiles, FolderName)
        if not ok then return list end
        for _, path in ipairs(files) do
            local name = path:match("([^/\\]+)%.json$")
            if name then
                table.insert(list, name)
            end
        end
        table.sort(list)
        return list
    end

    local function ReadConfig(name)
        local path = GetConfigPath(name)
        if not (isfile and isfile(path)) then return nil end
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        return ok and data or nil
    end

    local function WriteConfig(name, data)
        if not writefile then return false end
        data._version = Version
        local ok = pcall(writefile, GetConfigPath(name), HttpService:JSONEncode(data))
        return ok
    end

    local function DeleteFile(name)
        if not delfile then return false end
        local path = GetConfigPath(name)
        if isfile and isfile(path) then
            local ok = pcall(delfile, path)
            return ok
        end
        return false
    end

    -- ── Autoload state ───────────────────────────────────────────────
    local AutoloadFile = FolderName .. "/_autoload.txt"
    local function GetAutoload()
        if not (isfile and isfile(AutoloadFile)) then return nil end
        local ok, v = pcall(readfile, AutoloadFile)
        return ok and v ~= "" and v or nil
    end
    local function SetAutoload(name)
        if not writefile then return end
        writefile(AutoloadFile, name or "")
    end

    -- Jalankan autoload saat startup
    do
        local auto = GetAutoload()
        if auto then
            local data = ReadConfig(auto)
            if data then
                for k, v in pairs(data) do
                    ConfigData[k] = v
                end
                pcall(LoadConfig)
            end
        end
    end

    -- ── State UI ────────────────────────────────────────────────────
    local selectedConfig = nil
    local configList     = GetConfigList()
    local autoloadName   = GetAutoload()

    -- ══════════════════════════════════════════════════════════════
    -- Tambahkan elemen UI ke Section (Velaris UI AddInput, AddButton)
    -- ══════════════════════════════════════════════════════════════

    -- [Config name input]
    local nameInput = Section:AddInput("ConfigName", {
        Title       = "Config name",
        Default     = "",
        Placeholder = "Enter config name...",
        Callback    = function() end,
    })

    -- [Create config]
    Section:AddButton({
        Title    = "Create config",
        Callback = function()
            local name = (nameInput and nameInput.Value) or ""
            name = name:match("^%s*(.-)%s*$")
            if name == "" then
                if Notify then Notify("Enter a config name first.", 3) end
                return
            end
            if isfile and isfile(GetConfigPath(name)) then
                if Notify then Notify('Config "' .. name .. '" already exists.', 3) end
                return
            end
            -- Snapshot nilai elemen saat ini
            local snap = {}
            for key, el in pairs(Elements) do
                if el.GetValue then
                    snap[key] = el:GetValue()
                elseif el.Value ~= nil then
                    snap[key] = el.Value
                end
            end
            WriteConfig(name, snap)
            configList = GetConfigList()
            if listDropdown then listDropdown:SetValues(configList) end
            if Notify then Notify('Config "' .. name .. '" created.', 3) end
        end,
    })

    -- Divider
    Section:AddDivider and Section:AddDivider("Config list")

    -- [Dropdown daftar config]
    local listDropdown = Section:AddDropdown("ConfigList", {
        Title   = "",
        Values  = configList,
        Default = configList[1],
        Callback = function(v)
            selectedConfig = v
        end,
    })
    selectedConfig = listDropdown and listDropdown.Value or configList[1]

    -- [Load config]
    Section:AddButton({
        Title    = "Load config",
        Callback = function()
            if not selectedConfig or selectedConfig == "" then
                if Notify then Notify("Select a config first.", 3) end
                return
            end
            local data = ReadConfig(selectedConfig)
            if not data then
                if Notify then Notify('Config "' .. selectedConfig .. '" not found.', 3) end
                return
            end
            for k, v in pairs(data) do
                ConfigData[k] = v
            end
            pcall(LoadConfig)
            if Notify then Notify('Config "' .. selectedConfig .. '" loaded.', 4) end
        end,
    })

    -- [Overwrite config]
    Section:AddButton({
        Title    = "Overwrite config",
        Callback = function()
            if not selectedConfig or selectedConfig == "" then
                if Notify then Notify("Select a config first.", 3) end
                return
            end
            local snap = {}
            for key, el in pairs(Elements) do
                if el.GetValue then
                    snap[key] = el:GetValue()
                elseif el.Value ~= nil then
                    snap[key] = el.Value
                end
            end
            WriteConfig(selectedConfig, snap)
            if Notify then Notify('Config "' .. selectedConfig .. '" overwritten.', 3) end
        end,
    })

    -- [Delete config]
    Section:AddButton({
        Title    = "Delete config",
        Callback = function()
            if not selectedConfig or selectedConfig == "" then
                if Notify then Notify("Select a config first.", 3) end
                return
            end
            local deleted = DeleteFile(selectedConfig)
            if deleted then
                if autoloadName == selectedConfig then
                    SetAutoload(nil)
                    autoloadName = nil
                end
                configList = GetConfigList()
                if listDropdown then listDropdown:SetValues(configList) end
                selectedConfig = configList[1] or nil
                if Notify then Notify('Config "' .. (selectedConfig or "?") .. '" deleted.', 3) end
            else
                if Notify then Notify("Failed to delete config.", 3) end
            end
        end,
    })

    -- [Refresh list]
    Section:AddButton({
        Title    = "Refresh list",
        Callback = function()
            configList = GetConfigList()
            if listDropdown then listDropdown:SetValues(configList) end
            if Notify then Notify("Config list refreshed.", 2) end
        end,
    })

    -- Divider
    Section:AddDivider and Section:AddDivider()

    -- [Set as autoload]
    Section:AddButton({
        Title    = "Set as autoload",
        Callback = function()
            if not selectedConfig or selectedConfig == "" then
                if Notify then Notify("Select a config first.", 3) end
                return
            end
            SetAutoload(selectedConfig)
            autoloadName = selectedConfig
            if autoloadLabel then
                autoloadLabel:SetText("Current autoload config: " .. selectedConfig)
            end
            if Notify then Notify('"' .. selectedConfig .. '" set as autoload.', 3) end
        end,
    })

    -- [Reset autoload]
    Section:AddButton({
        Title    = "Reset autoload",
        Callback = function()
            SetAutoload(nil)
            autoloadName = nil
            if autoloadLabel then
                autoloadLabel:SetText("Current autoload config: none")
            end
            if Notify then Notify("Autoload config reset.", 3) end
        end,
    })

    -- Divider
    Section:AddDivider and Section:AddDivider()

    -- [Label autoload aktif]
    local autoloadLabelText = "Current autoload config: " .. (autoloadName or "none")
    local autoloadLabel = Section:AddLabel and Section:AddLabel({
        Title    = autoloadLabelText,
        DoesWrap = false,
    })
    -- Fallback jika Velaris pakai Title bukan Text
    if autoloadLabel and autoloadLabel.SetText == nil then
        function autoloadLabel:SetText(t) end
    end

    -- Return API kecil jika perlu update dari luar
    return {
        Refresh = function()
            configList = GetConfigList()
            if listDropdown then listDropdown:SetValues(configList) end
        end,
        GetSelected = function() return selectedConfig end,
    }
end

return ConfigSection
