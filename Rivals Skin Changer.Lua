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
            print("Found invisible part:", part.Name)  -- Debugging
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
            print("Selected model:", model.Name)  -- Debugging
            findInvisiblePart(model)
        else
            print("Model not found:", selectedWeapon)  -- Debugging
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
                    if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
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
                if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
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
            if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
                part.Color = Color3.fromRGB(255, 255, 255)  -- Reset to default white color
                part.Transparency = 0
                part.Material = Enum.Material.Plastic
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
                if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
                    part.Color = Value
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
                if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
                    part.Transparency = Value
                end
            end
        end
    end,
})

-- Apply Buttons for Transparency, Wrap, and Color

-- Apply Transparency Button
local ApplyTransparencyButton = Tab:CreateButton({
    Name = "Apply Transparency",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part ~= invisPart then
                    part.Transparency = TransparencySlider.CurrentValue
                end
            end
        end
    end
})

-- Apply Wrap Button
local ApplyWrapButton = Tab:CreateButton({
    Name = "Apply Wrap",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            applyNewWrapTextures(model, selectedWrap)
        end
    end
})

-- Apply Material Button
local ApplyMaterialButton = Tab:CreateButton({
    Name = "Apply Material",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            -- Ensure MaterialDropdown.CurrentValue is valid
            local selectedMaterialName = MaterialDropdown.CurrentOption and MaterialDropdown.CurrentOption[1] or nil

            if selectedMaterialName then
                -- Print out the selected material for debugging
                print("Selected Material: " .. selectedMaterialName)

                local selectedMaterial = Enum.Material[selectedMaterialName]

                -- Ensure the material is valid
                if selectedMaterial then
                    -- Loop through all the parts of the selected weapon model
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
                            part.Material = selectedMaterial  -- Apply the material to the part
                        end
                    end
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Invalid material selected.",
                        Duration = 6.5,
                        Image = nil
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "No material selected.",
                    Duration = 6.5,
                    Image = nil
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Selected weapon model not found.",
                Duration = 6.5,
                Image = nil
            })
        end
    end
})

-- Apply Color Button
local ApplyColorButton = Tab:CreateButton({
    Name = "Apply Color",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            -- Loop through all the parts of the selected weapon model
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and not part == invisPart then -- Skip invisible part
                    part.Color = ColorPicker:GetColor()  -- Apply color from the color picker
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Selected weapon model not found.",
                Duration = 6.5,
                Image = nil
            })
        end
    end
})


-- Remove Wrap Button
local RemoveWrapButton = Tab:CreateButton({
    Name = "Remove Wrap",
    Callback = function()
        -- Get the model for the selected weapon
        local model = root:FindFirstChild(selectedWeapon)
        
        if model then
            -- Loop through all the parts of the model
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- Loop through all the children of the part (to find textures)
                    for _, decal in ipairs(part:GetChildren()) do
                        if decal:IsA("Texture") then
                            decal:Destroy()  -- Remove the texture (wrap)
                        end
                    end
                end
            end

            -- Notify user that wraps have been removed
            Rayfield:Notify({
                Title = "Wrap Removed",
                Content = "All wraps have been successfully removed from the weapon.",
                Duration = 6.5,
                Image = nil
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Weapon model not found.",
                Duration = 6.5,
                Image = nil
            })
        end
    end
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
