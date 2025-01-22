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

-- Wrap Dropdown
local wrapstring = plr.PlayerScripts.Assets.WrapTextures:GetChildren()
local wraps = {}

-- No longer filtering out .exe or .dll files
for _, wrap in ipairs(wrapstring) do
    table.insert(wraps, wrap.Name) -- Add all wrap textures without filtering
end

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

-- Theme Tab for Rayfield themes
local ThemeTab = Window:CreateTab("Themes", nil)

-- List of available Rayfield themes
local themeOptions = {
    "Amethyst", "Amber Glow", "Default", "Bloom", "Dark Blue", 
    "Green", "Light", "Ocean", "Serenity"
}

-- Current selected theme
local selectedTheme = themeOptions[1] -- Default to Amethyst

-- Theme Dropdown
local ThemeDropdown = ThemeTab:CreateDropdown({
    Name = "Select Rayfield Theme",
    Options = themeOptions,
    CurrentOption = {selectedTheme}, -- Set default to Amethyst
    MultipleOptions = false,
    Flag = "ThemeDropdown", -- A unique flag
    Callback = function(Options)
        selectedTheme = Options[1]
        -- Change Rayfield window theme
        Window:ChangeTheme(selectedTheme)
    end,
})

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

-- Red Color Slider
local RedSlider = Tab:CreateSlider({
   Name = "Red Color",
   Range = {0, 255},
   Increment = 1,
   Suffix = "Red",
   CurrentValue = 255,
   Flag = "Slider2", -- A flag for the slider
   Callback = function(Value)
       local model = root:FindFirstChild(selectedWeapon)
       if model then
           -- Update the Red component of all parts of the selected weapon
           for _, part in ipairs(model:GetDescendants()) do
               if part:IsA("BasePart") then
                   local currentColor = part.Color
                   part.Color = Color3.fromRGB(Value, currentColor.G, currentColor.B)
               end
           end
       end
   end,
})

-- Green Color Slider
local GreenSlider = Tab:CreateSlider({
   Name = "Green Color",
   Range = {0, 255},
   Increment = 1,
   Suffix = "Green",
   CurrentValue = 255,
   Flag = "Slider3", -- A flag for the slider
   Callback = function(Value)
       local model = root:FindFirstChild(selectedWeapon)
       if model then
           -- Update the Green component of all parts of the selected weapon
           for _, part in ipairs(model:GetDescendants()) do
               if part:IsA("BasePart") then
                   local currentColor = part.Color
                   part.Color = Color3.fromRGB(currentColor.R, Value, currentColor.B)
               end
           end
       end
   end,
})

-- Blue Color Slider
local BlueSlider = Tab:CreateSlider({
   Name = "Blue Color",
   Range = {0, 255},
   Increment = 1,
   Suffix = "Blue",
   CurrentValue = 255,
   Flag = "Slider4", -- A flag for the slider
   Callback = function(Value)
       local model = root:FindFirstChild(selectedWeapon)
       if model then
           -- Update the Blue component of all parts of the selected weapon
           for _, part in ipairs(model:GetDescendants()) do
               if part:IsA("BasePart") then
                   local currentColor = part.Color
                   part.Color = Color3.fromRGB(currentColor.R, currentColor.G, Value)
               end
           end
       end
   end,
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
