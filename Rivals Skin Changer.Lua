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

-- Wait until the LocalPlayer is available

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
   MultipleOptions = true,
   Flag = "Dropdown1", -- Unique Flag
   Callback = function(Options)
      selectedWeapon = Options[1]
      local model = root:FindFirstChild(selectedWeapon)  -- Update selectedWeapon with the current selection
   end,
})

-- Wrap Dropdown
local wrapstring = plr.PlayerScripts.Assets.WrapTextures:GetChildren()
local wraps = {}

-- Filter out wraps with ".exe" or ".dll" in their name
for _, wrap in ipairs(wrapstring) do
    local wrapName = wrap.Name
    if not (wrapName:match("%.exe$") or wrapName:match("%.dll$")) then
        table.insert(wraps, wrapName) -- Only add to wraps if not .exe or .dll
    end
end

-- To store applied decals
local appliedDecals = {}

-- Function to apply the decals from a selected wrap
local function applyWrapDecals(wrap)
    -- Clear previous decals
    for _, decal in ipairs(appliedDecals) do
        decal:Destroy()
    end
    appliedDecals = {} -- Reset the applied decals table

    -- Apply textures for the new wrap
    for _, textures in ipairs(wrap:GetChildren()) do
        if textures:IsA("Texture") then
            -- Find the model for the selected weapon
            local model = root:FindFirstChild(selectedWeapon)
            if model then
                -- Loop through parts of the model (filtering parts based on name, type, etc.)
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Only apply the wrap to parts that match your criteria (e.g., "handle", "stock")
                        if part.Name == "Handle" or part.Name == "Stock" then
                            -- Clone the decal and apply it to the part
                            local newDecal = textures:Clone()
                            newDecal.Parent = part
                            table.insert(appliedDecals, newDecal)
                        end
                    end
                end
            end
        end
    end
end

-- Materials Root: This is where you can define all available materials
local materialRoot = game.MaterialService.Wraps

-- Materials Dropdown Population
local materials = {}

-- Function to populate the materials dropdown with all available materials
local function populateMaterialsDropdown(model)
    materials = {}  -- Clear previous materials

    -- Iterate through Enum.Material and add all material names to the list
    for _, material in pairs(materialRoot:GetChildren)) do
        table.insert(materials, material)  -- Add material to the dropdown list
    end

    -- Update the materials dropdown with the collected materials
    if #materials > 0 then
        MaterialDropdown:UpdateOptions(materials)
    end
end

-- Material Dropdown
local MaterialDropdown = Tab:CreateDropdown({
   Name = "Material Select",
   Options = materials,
   CurrentOption = {materials[1] or "Plastic"}, -- Default to the first material or "Plastic"
   MultipleOptions = false,
   Flag = "Dropdown3", -- Unique Flag
   Callback = function(Options)
      local selectedMaterial = Options[1]
      -- Apply the selected material to all parts of the selected weapon
      local model = root:FindFirstChild(selectedWeapon)
      if model then
         for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
               part.Material = Enum.Material[selectedMaterial] or Enum.Material.Plastic
            end
         end
      end
   end,
})
