local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Window = Rayfield:CreateWindow({
    Name = "Rivals Skin Changer Window",
    Icon = 0,
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "suggested by boogerino_the2nd on discord",
    Theme = "Amethyst",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Skin Changer Tab
local Tab = Window:CreateTab("Skin Changer", nil)
local root = plr.PlayerScripts.Assets.ViewModels
local Section = Tab:CreateSection("Skin Changer")
local weapons = root:GetChildren()

-- Make sure this script is a LocalScript
local guns = {}

-- Populating weapons into dropdown options
for _, gun in ipairs(weapons) do
    table.insert(guns, gun.Name) -- Assuming the "Name" property is what you want
end

local selectedWeapon = guns[1]  -- Default weapon

-- Transparent part finder
local invisPart = nil

local function findInvisiblePart(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency == 1 then
            invisPart = part
            break -- Exit once an invisible part is found
        end
    end
end

-- Weapon Dropdown
local WeaponDropdown = Tab:CreateDropdown({
    Name = "Weapon Select",
    Options = guns,
    CurrentOption = {selectedWeapon}, -- Set default to the value of selectedWeapon
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options)
        selectedWeapon = Options[1]
        local model = root:FindFirstChild(selectedWeapon)

        -- Check if the model is found and find an invisible part
        if model then
            findInvisiblePart(model)
        end
    end,
})

-- Wrap Dropdown
local wrapstring = plr.PlayerScripts.Assets.WrapTextures:GetChildren()
local wraps = {}

-- Populating the wraps
for _, wrap in ipairs(wrapstring) do
    table.insert(wraps, wrap.Name)
end

-- Function to clear existing textures
local function clearExistingTextures(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, decal in ipairs(part:GetChildren()) do
                if decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
        end
    end
end

-- Function to apply new textures
local function applyNewWrapTextures(model, wrapName)
    local wrap = plr.PlayerScripts.Assets.WrapTextures:FindFirstChild(wrapName)
    if wrap then
        for _, decal in ipairs(wrap:GetChildren()) do
            if decal:IsA("Texture") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if part.Transparency < 1 then
                            local textureClone = decal:Clone()
                            textureClone.Parent = part
                        end
                    end
                end
            end
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Selected wrap not found.",
            Duration = 6.5,
            Image = nil
        })
    end
end

-- Wrap select dropdown
local selectedWrap = wraps[1]

local WrapDropdown = Tab:CreateDropdown({
    Name = "Wrap Select",
    Options = wraps,
    CurrentOption = {selectedWrap}, -- Default to the first wrap
    MultipleOptions = false,
    Flag = "Dropdown2",
    Callback = function(Options)
        selectedWrap = Options[1]
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            clearExistingTextures(model)
            applyNewWrapTextures(model, selectedWrap)
        end
    end
})

-- Material Dropdown
local materialNames = {}
for _, materialEnum in ipairs(Enum.Material:GetEnumItems()) do
    table.insert(materialNames, materialEnum.Name)
end

-- Default selected material
local selectedMaterial1 = materialNames[1] or "Plastic"  -- Default to the first material or "Plastic"

local MaterialDropdown = Tab:CreateDropdown({
    Name = "Basic Material Select",
    Options = materialNames,
    CurrentOption = {selectedMaterial1}, -- Set default to the value of selectedMaterial
    MultipleOptions = false,
    Flag = "Dropdown3",
    Callback = function(Options)
        local selectedMaterialName = Options[1]
        local model = root:FindFirstChild(selectedWeapon)

        if model then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material[selectedMaterialName] or Enum.Material.Plastic
                end
            end
        end
    end
})

-- Reset Weapon Button
local function resetWeapon(model)
    if model then
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Skip resetting the invisible part
                if part ~= invisPart then
                    part.Color = Color3.fromRGB(255, 255, 255)  -- Reset to default white color
                    part.Transparency = 0
                    part.Material = Enum.Material.Plastic
                end
            end
        end
        clearExistingTextures(model)
    end
end

local ResetButton = Tab:CreateButton({
    Name = "Reset Weapon to Default",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            resetWeapon(model)
        end
    end,
})

-- Color Picker & Transparency Slider
local ColorSection = Tab:CreateSection("Color Control")

local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1",
    Callback = function(Value)
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- Skip the invisible part from changing its color
                    if part ~= invisPart then
                        part.Color = Value
                    end
                end
            end
        end
    end
})

local TransparencySlider = Tab:CreateSlider({
    Name = "Weapon Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "Transparency",
    CurrentValue = 0,
    Flag = "Slider1",
    Callback = function(Value)
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- Skip the invisible part from changing its transparency
                    if part ~= invisPart then
                        part.Transparency = Value
                    end
                end
            end
        end
    end,
})

-- Configuration Tab
local ConfigTab = Window:CreateTab("Configuration", nil)

local savedConfig = {}

local ConfigNameInput = ConfigTab:CreateInput({
    Name = "Configuration Name",
    PlaceholderText = "Enter a name for your config",
    ClearTextOnFocus = true,
    Flag = "ConfigNameInput",
    Callback = function(Text)
        print("Entered config name: " .. Text)
    end,
})

local function saveConfiguration()
    local configName = ConfigNameInput.CurrentValue
    if configName == "" then
        Rayfield:Notify({
            Title = "Error: Configuration name cannot be empty.",
            Content = "Please enter a valid name.",
            Duration = 6.5,
            Image = nil
        })
        return
    end

    local model = root:FindFirstChild(selectedWeapon)
    if model then
        local weaponConfig = {}

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                weaponConfig[part.Name] = {
                    color = part.Color,
                    transparency = part.Transparency,
                }

                local textureApplied = false
                for _, decal in ipairs(part:GetChildren()) do
                    if decal:IsA("Texture") then
                        textureApplied = true
                        break
                    end
                end
                weaponConfig[part.Name].wrap = textureApplied and selectedWrap or nil
            end
        end

        savedConfig[configName] = weaponConfig
        print("Configuration saved for " .. configName)
        updateConfigDropdown()
    end
end

local SaveConfigButton = ConfigTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        saveConfiguration()
    end,
})

local function applySavedConfiguration(weapon)
    local model = root:FindFirstChild(weapon)
    if model and savedConfig[weapon] then
        local config = savedConfig[weapon]

        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                local partConfig = config[part.Name]

                if partConfig then
                    part.Color = partConfig.color
                    part.Transparency = partConfig.transparency

                    if partConfig.wrap then
                        clearExistingTextures(model)
                        applyNewWrapTextures(model, partConfig.wrap)
                    end
                end
            end
        end

        print("Configuration applied for " .. weapon)
    end
end

local ApplyConfigButton = ConfigTab:CreateButton({
    Name = "Apply Saved Configuration",
    Callback = function()
        local selectedConfig = SavedConfigDropdown.CurrentValue
        if selectedConfig and #selectedConfig > 0 then
            applySavedConfiguration(selectedConfig[1]) -- Assuming it's a list with one selected option
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No configuration selected.",
                Duration = 6.5,
                Image = nil
            })
        end
    end,
})

local savedConfigNames = {}

for configName, _ in pairs(savedConfig) do
    table.insert(savedConfigNames, configName)
end

local SavedConfigDropdown = ConfigTab:CreateDropdown({
    Name = "Select Saved Configuration",
    Options = savedConfigNames,
    CurrentOption = {savedConfigNames[1]},
    MultipleOptions = false,
    Flag = "SavedConfigDropdown",
    Callback = function(Options)
    end,
})

local function updateConfigDropdown()
    savedConfigNames = {}
    for configName, _ in pairs(savedConfig) do
        table.insert(savedConfigNames, configName)
    end
    SavedConfigDropdown:SetOptions(savedConfigNames)
end

SaveConfigButton.Callback = function()
    saveConfiguration()
    updateConfigDropdown()
end

-- Debugging (optional)
local function showSavedConfig()
    for configName, config in pairs(savedConfig) do
        print("Config Name: " .. configName)
        for partName, partConfig in pairs(config) do
            print("  Part: " .. partName)
            print("    Color: " .. tostring(partConfig.color))
            print("    Transparency: " .. partConfig.transparency)
            print("    Wrap: " .. tostring(partConfig.wrap))
        end
    end
end

-- Debug Button to show saved configurations
local DebugButton = ConfigTab:CreateButton({
    Name = "Show Saved Configurations",
    Callback = function()
        showSavedConfig()
    end,
})
