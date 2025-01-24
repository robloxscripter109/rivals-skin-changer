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
local invisParts = {}

local function findInvisiblePart(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency == 1 then
            invisPart = part
            print(_ .. " Found invisible part:", part.Name)  -- Debugging
            table.insert(invisParts, invisPart)
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
                            local textureClone = decal:Clone()
                            textureClone.Parent = part
                        end
                    end
                end
            end
        end
    end
        Rayfield:Notify({
            Title = "Error",
            Content = "Selected wrap not found.",
            Duration = 6.5,
            Image = nil
        })

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
                if part:IsA("BasePart") and part ~= invisParts then -- Skip invisible part
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
                if part:IsA("BasePart") and part ~= invisPart then -- Skip invisible part
                    part.Color = ColorPicker.Value  -- Apply color from the color picker
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

-- tab for other exploits
local Tab2 = Window:CreateTab("Other Exploits", nil)

-- ESP Settings
local espEnabled = false  -- Initially, ESP is off
local useRGB = false  -- Initially, RGB toggle is off
local espColor = Color3.fromRGB(255, 0, 0)  -- Default color is red
local espRange = 100  -- Default range (in studs)

-- Define screenGui for drawing UI elements
local screenGui = Instance.new("ScreenGui", plr.PlayerGui)
if not screenGui.Parent then
    screenGui.Parent = plr.PlayerGui
end

-- Tables to store ESP elements
local espHighlights = {}
local espTextLabels = {}

-- Function to convert world position to screen position
local function worldToScreenPosition(worldPosition)
    local camera = workspace.CurrentCamera
    if camera then
        local screenPosition, onScreen = camera:WorldToScreenPoint(worldPosition)
        return screenPosition, onScreen
    else
        warn("CurrentCamera is not available.")
        return Vector2.new(0, 0), false  -- Return a fallback value
    end
end

-- Function to calculate the distance between two positions
local function calculateDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Function to draw a highlight around an object
local function drawHighlight(character, color)
    -- Create the highlight effect for the character
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = color
    highlight.OutlineTransparency = 0.7  -- Slight transparency for outline
    highlight.OutlineColor = color
    return highlight
end

-- Function to draw text on the screen with dynamic Y offset based on font size
local function drawText(position, text, fontSize, color)
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.TextSize = fontSize
    textLabel.TextColor3 = color
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, position.X, 0, position.Y)
    textLabel.Parent = screenGui
    return textLabel  -- Return the text label so it can be tracked for removal
end

-- Function to check and display ESP for nearby players
local function displayESP()
    -- Clear old ESP highlights
    for _, highlight in pairs(espHighlights) do
        highlight:Destroy()  -- Destroy the old highlights
    end
    espHighlights = {}  -- Reset the highlight table

    -- Clear old ESP text labels
    for _, label in pairs(espTextLabels) do
        label:Destroy()  -- Destroy the old text labels
    end
    espTextLabels = {}  -- Reset the text table

    -- Iterate over all players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= plr then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = character.HumanoidRootPart
                local screenPosition, onScreen = worldToScreenPosition(humanoidRootPart.Position)

                if onScreen then
                    -- Calculate the distance between the local player and the other player
                    local distance = calculateDistance(plr.Character.HumanoidRootPart.Position, humanoidRootPart.Position)

                    if distance <= espRange then  -- Check if within the selected range
                        -- Display the highlight around the player
                        local highlight = drawHighlight(character, espColor)  -- Use the current color for the ESP highlight
                        -- Store the highlight in the espHighlights table
                        table.insert(espHighlights, highlight)

                        -- Scale font size based on distance
                        local fontSize = math.max(14, 100 / distance)  -- Adjust size based on distance

                        -- Dynamic vertical offset based on font size
                        local offsetY = 40 - (fontSize + 14)  -- As font size increases, text moves further down
                        local healthOffsetY = 60 - (fontSize + 14)  -- Apply similar logic for health text

                        -- Display the distance text above the highlight
                        local distanceText = drawText(Vector2.new(screenPosition.X, screenPosition.Y - offsetY), "Distance: " .. math.floor(distance) .. "m", fontSize, Color3.fromRGB(255, 255, 255))

                        -- Store the distance label in the espTextLabels table
                        table.insert(espTextLabels, distanceText)

                        -- Display the health text with fixed vertical offset
                        if character:FindFirstChild("Humanoid") then
                            local health = math.floor(character.Humanoid.Health)
                            local healthText = drawText(Vector2.new(screenPosition.X, screenPosition.Y - healthOffsetY), "Health: " .. health, fontSize, Color3.fromRGB(255, 255, 255))

                            -- Store the health label in the espTextLabels table
                            table.insert(espTextLabels, healthText)
                        end
                    end
                end
            end
        end
    end
end

-- Add the ESP toggle button to the Rayfield UI
local espToggle = Tab2:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = espEnabled,
    Flag = "espToggle",
    Callback = function(value)
        espEnabled = value  -- Update the ESP status based on the toggle
    end,
})

-- Add RGB toggle for ESP color
local rgbToggle = Tab2:CreateToggle({
    Name = "Enable RGB",
    CurrentValue = useRGB,
    Flag = "rgbToggle",
    Callback = function(value)
        useRGB = value  -- Update the RGB toggle status
    end,
})

-- Add the color picker for ESP color
local espColorPicker = Tab2:CreateColorPicker({
    Name = "ESP Color",
    Color = espColor,
    Flag = "espColorPicker",
    Callback = function(color)
        espColor = color  -- Update ESP color based on selection
    end,
})

-- Add range slider for ESP distance
local rangeSlider = Tab2:CreateSlider({
    Name = "ESP Range",
    Range = {0, 200},  -- Range from 0 to 200 studs
    Increment = 5,  -- Increment by 5 studs
    Suffix = "Studs",  -- Display "Studs" after the value
    CurrentValue = espRange,
    Flag = "espRangeSlider",
    Callback = function(value)
        espRange = value  -- Update ESP range based on slider value
    end,
})

-- RGB effect for ESP color
local function getRGBColor()
    local time = tick()
    local r = math.floor(255 * (math.sin(time / 2) + 1) / 2)
    local g = math.floor(255 * (math.sin(time / 2 + math.pi / 3) + 1) / 2)
    local b = math.floor(255 * (math.sin(time / 2 + math.pi / 1.5) + 1) / 2)
    return Color3.fromRGB(r, g, b)
end

-- Run ESP every frame if enabled
game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        -- If RGB is enabled, use RGB color; otherwise, use the selected color
        if useRGB then
            espColor = getRGBColor()
        else
            espColor = espColorPicker.Color  -- Revert to the selected ESP color
        end
        displayESP()
    else
        -- If ESP is disabled, clear highlights and text immediately
        for _, highlight in pairs(espHighlights) do
            highlight:Destroy()
        end
        espHighlights = {}

        for _, label in pairs(espTextLabels) do
            label:Destroy()
        end
        espTextLabels = {}
    end
end)

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
