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

-- Function to apply new textures
local function applyNewWrapTextures(model, wrapName)
    local wrap = plr.PlayerScripts.Assets.WrapTextures:FindFirstChild(wrapName)
    if wrap then
        for _, decal in ipairs(wrap:GetChildren()) do
            if decal:IsA("Texture") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local textureClone = decal:Clone()
                        textureClone.Parent = part
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
              -- Remove previous textures
            applyNewWrapTextures(model, selectedWrap)  -- Apply the new wrap
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

local Button = Tab:CreateButton({
   Name = "Clear all equipped wraps on equipped gun",
   Callback = function()
       local model = root:FindFirstChild(selectedWeapon) -- Find the model again based on the selected weapon
       if model then
           clearExistingTextures(model) -- Call the function to clear existing textures
       end
   end,
})

-- New section for color sliders and transparency
local ColorSection = Tab:CreateSection("Color Control")

-- Toggle for Color Sliders
local ColorToggle = Tab:CreateToggle({
    Name = "Enable Color Sliders",
    CurrentValue = true,
    Flag = "ColorToggle", 
    Callback = function(Value)
        -- Enable or disable color sliders
        RedSlider.Enabled = Value
        GreenSlider.Enabled = Value
        BlueSlider.Enabled = Value
    end
})

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

-- Toggle for Transparency Slider
