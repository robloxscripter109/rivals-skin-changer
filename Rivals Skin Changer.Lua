local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Window = Rayfield:CreateWindow({
    Name = "Rivals Skin Changer Window",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "suggested by boogerino_the2nd on discord",
    Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Create a custom folder for your hub/game
        FileName = "Big Hub"
    },
    Discord = {
        Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
        Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
        RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
        FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
        Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
})



-- Skin Changer Tab
local Tab = Window:CreateTab("Skin Changer", nil) -- Title, Image

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

-- Weapon Dropdown
local WeaponDropdown = Tab:CreateDropdown({
    Name = "Weapon Select",
    Options = guns,
    CurrentOption = {selectedWeapon}, -- Set default to the value of selectedWeapon
    MultipleOptions = false,
    Flag = "Dropdown1", -- Unique Flag
    Callback = function(Options)
        selectedWeapon = Options[1]
        local model = root:FindFirstChild(selectedWeapon)  -- Update selectedWeapon with the current selection
    end,
})

-- Wrap Dropdown
local wrapstring = plr.PlayerScripts.Assets.WrapTextures:GetChildren()
local wraps = {}

-- Populating the wraps
for _, wrap in ipairs(wrapstring) do
    table.insert(wraps, wrap.Name) -- Add all wrap textures without filtering
end

-- Ensure the wraps are correctly populated by checking this in the output if needed:
print("Wraps available:", wraps)

-- Function to clear existing textures
local function clearExistingTextures(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            for _, decal in ipairs(part:GetChildren()) do
                if decal:IsA("Texture") then
                    decal:Destroy()  -- Remove existing textures
                end
            end
        end
    end
end

-- Function to apply new textures
-- Function to apply new textures only if part is not fully transparent
local function applyNewWrapTextures(model, wrapName)
    local wrap = plr.PlayerScripts.Assets.WrapTextures:FindFirstChild(wrapName)
    if wrap then
        for _, decal in ipairs(wrap:GetChildren()) do
            if decal:IsA("Texture") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Check if part is fully transparent
                        if part.Transparency < 1 then
                            local textureClone = decal:Clone()
                            textureClone.Parent = part
                        end
                    end
                end
            end
        end
    end
end

-- Wrap select dropdown
local selectedWrap = wraps[1]

local WrapDropdown = Tab:CreateDropdown({
    Name = "Wrap Select",
    Options = wraps,
    CurrentOption = {selectedWrap}, -- Default to the first wrap
    MultipleOptions = false,
    Flag = "Dropdown2", -- A flag is the identifier for the configuration file
    Callback = function(Options)
        selectedWrap = Options[1]
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            clearExistingTextures(model)  -- Remove previous textures
            applyNewWrapTextures(model, selectedWrap)  -- Apply the new wrap
        end
    end
})

-- Material Dropdown
local materialNames = {}
for _, materialEnum in ipairs(Enum.Material:GetEnumItems()) do
    table.insert(materialNames, materialEnum.Name)
end

-- Ensure the materials are correctly populated by checking this in the output if needed:
print("Materials available:", materialNames)

-- Default selected material
local selectedMaterial1 = materialNames[1] or "Plastic"  -- Default to the first material or "Plastic"

-- Material Dropdown
local MaterialDropdown = Tab:CreateDropdown({
    Name = "Basic Material Select",
    Options = materialNames,
    CurrentOption = {selectedMaterial1}, -- Set default to the value of selectedMaterial
    MultipleOptions = false,
    Flag = "Dropdown3", -- A unique flag
    Callback = function(Options)
        local selectedMaterialName = Options[1]
        local model = root:FindFirstChild(selectedWeapon)

        if model then
            -- Apply the selected material to all parts of the selected weapon
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
        -- Restore original color (assuming it's the default color)
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255, 255, 255)  -- Reset to default white color
                part.Transparency = 0  -- Reset transparency to 0
            end
        end
        
        -- Restore default material (assuming it's "Plastic")
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
            end
        end

        -- Clear any existing wrap textures
        clearExistingTextures(model)
    end
end

-- Add reset functionality to the Skin Changer Tab
local ResetButton = Tab:CreateButton({
    Name = "Reset Weapon to Default",
    Callback = function()
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            resetWeapon(model)  -- Call the function to reset the weapon
        end
    end,
})

-- New section for color sliders and transparency
local ColorSection = Tab:CreateSection("Color Control")

local ColorPicker = Tab:CreateColorPicker({ 
    Name = "Color Picker",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1", -- A flag for the configuration
    Callback = function(Value)
        -- The callback function that is called every time the color is selected
        -- 'Value' will be the Color3 value selected from the color picker
        local model = root:FindFirstChild(selectedWeapon)
        if model then
            -- Apply the selected color to all parts of the selected weapon
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Value
                end
            end
        end
    end
})

-- Weapon Transparency Slider
local TransparencySlider = Tab:CreateSlider({
   Name = "Weapon Transparency",
   Range = {0, 1},
   Increment = 0.1,
   Suffix = "Transparency",
   CurrentValue = 0,
   Flag = "Slider1", -- A flag for the slider
   Callback = function(Value)
       local model = root:FindFirstChild(selectedWeapon)
       if model then
           -- Apply transparency to all parts
           for _, part in ipairs(model:GetDescendants()) do
               if part:IsA("BasePart") then
                   part.Transparency = Value
               end
           end
       end
   end,
})

-- Configuration Tab
local ConfigTab = Window:CreateTab("Configuration", nil)

local savedConfig = {}  -- Table to hold the saved configurations

-- Create Input for entering a custom name for the configuration
local ConfigNameInput = ConfigTab:CreateInput({
    Name = "Configuration Name",  -- Label for the input field
    PlaceholderText = "Enter a name for your config",  -- Placeholder text
    ClearTextOnFocus = true,  -- Clear text when focused
    Flag = "ConfigNameInput",  -- Unique flag for the input field
    Callback = function(Text)
        -- This function will be called whenever the user enters a name
        print("Entered config name: " ConfigNameInput.CurrentValue)
    end,
})

-- Function to save the current weapon's wrap, color, and transparency with a custom name
local function saveConfiguration()
    local configName = ConfigNameInput:GetText()  -- Get the name from the input
    if configName == "" then
    Rayfield:Notify({
   Title = "Error: Configuration name cannot be empty.",
   Content = "Notification Content",
   Duration = 6.5,
   Image = nil,

        return
    end

    local model = root:FindFirstChild(selectedWeapon)
    if model then
        local weaponConfig = {}

        -- Loop through all the parts in the model and save the color, transparency, and wrap info
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Save color and transparency for each part
                weaponConfig[part.Name] = {
                    color = part.Color,
                    transparency = part.Transparency,
                }

                -- Check if the part has a texture applied and save it
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

        savedConfig[configName] = weaponConfig  -- Save with the custom name
        print("Configuration saved for " .. configName)

        -- Update the dropdown with the new config name
        updateConfigDropdown()
    end
end

-- Save Configuration Button
local SaveConfigButton = ConfigTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        saveConfiguration()  -- Save the current configuration with a custom name
    end,
})

-- Function to apply a saved configuration to the model
local function applySavedConfiguration(weapon)
    local model = root:FindFirstChild(weapon)
    if model and savedConfig[weapon] then
        local config = savedConfig[weapon]

        -- Loop through all parts in the model and apply the saved configuration
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                local partConfig = config[part.Name]

                if partConfig then
                    -- Apply saved color and transparency
                    part.Color = partConfig.color
                    part.Transparency = partConfig.transparency

                    -- Apply wrap texture if available
                    if partConfig.wrap then
                        clearExistingTextures(model)  -- Remove any existing textures
                        applyNewWrapTextures(model, partConfig.wrap)  -- Apply the saved wrap texture
                    end
                end
            end
        end

        print("Configuration applied for " .. weapon)
    end
end

-- Apply Configuration Button
local ApplyConfigButton = ConfigTab:CreateButton({
    Name = "Apply Saved Configuration",
    Callback = function()
        local selectedConfig = SavedConfigDropdown:GetValue()
        if selectedConfig then
            applySavedConfiguration(selectedConfig)  -- Apply the selected saved configuration
        end
    end,
})

-- Dropdown for selecting previously saved configurations
local savedConfigNames = {}

-- Populate the dropdown with the names of previously saved configurations
for configName, _ in pairs(savedConfig) do
    table.insert(savedConfigNames, configName)
end

local SavedConfigDropdown = ConfigTab:CreateDropdown({
    Name = "Select Saved Configuration",
    Options = savedConfigNames,
    CurrentOption = {savedConfigNames[1]},  -- Set default to the first saved configuration
    MultipleOptions = false,
    Flag = "SavedConfigDropdown",  -- A unique flag for the dropdown
    Callback = function(Options)
        -- Handle any specific actions when the user selects a configuration
    end,
})

-- Update dropdown options when a new configuration is saved
local function updateConfigDropdown()
    savedConfigNames = {}
    for configName, _ in pairs(savedConfig) do
        table.insert(savedConfigNames, configName)
    end
    SavedConfigDropdown:SetOptions(savedConfigNames)
end

-- Trigger the dropdown update whenever a new config is saved
SaveConfigButton.Callback = function()
    saveConfiguration()
    updateConfigDropdown()  -- Update the dropdown after saving a new configuration
end

-- Optionally, you can display the saved config for easier tracking (Debugging)
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

-- Debugging: Show saved configurations (you can remove this later)
showSavedConfig()
