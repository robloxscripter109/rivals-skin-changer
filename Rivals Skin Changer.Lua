local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local p = game:GetService("Players").LocalPlayer
local w = p.PlayerScripts.Assets.ViewModels.Weapons:GetChildren()
local wraps = p.PlayerScripts.Assets.WrapTextures:GetChildren()
local wrapmats = game:GetService("MaterialService").Wraps:GetChildren()

local wn, wrapmatnames, filteredWraps = {}, {}, {}
local wrapVariantList = {}
local wrapTextureNames = {}

for _, v in ipairs(wraps) do wrapTextureNames[v.Name] = true end
for _, v in ipairs(w) do table.insert(wn, v.Name) end
for _, v in ipairs(wrapmats) do
	wrapmatnames[v.Name] = v
	if not wrapTextureNames[v.Name] then
		table.insert(wrapVariantList, v.Name)
	end
end
for _, v in ipairs(wraps) do
	if not wrapmatnames[v.Name] then
		table.insert(filteredWraps, v.Name)
	end
end

local mats = {}
for _, v in pairs(Enum.Material:GetEnumItems()) do table.insert(mats, v.Name) end

local Window = Fluent:CreateWindow({
	Title = "Rivals Weapon Customizer",
	SubTitle = "by toast",
	TabWidth = 160,
	Size = UDim2.fromOffset(700, 500),
	Acrylic = false,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main = Window:AddTab({ Title = "Weapon Customiser", Icon = "paintbrush" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Tabs.Main:AddParagraph({ Title = "Dropdowns", Content = "This has all of the Dropdowns" })

local weaponDrop = Tabs.Main:AddDropdown("WeaponDropdown", {
	Title = "Weapon",
	Description = "The weapon u want the changes to apply to",
	Values = wn,
	Multi = false,
	Default = 1,
})

local textureDrop = Tabs.Main:AddDropdown("TextureDrop", {
	Title = "Wrap Textures",
	Description = "normal textures/wraps",
	Values = filteredWraps,
	Multi = false,
	Default = #filteredWraps > 0 and 1 or nil,
	Callback = function(v)
		if wrapmatnames[v] then
			Options.WrapMaterialDropdown:SetValue(v)
			Options.UseWrapMat:SetValue(true)
		end
	end
})

local matDrop = Tabs.Main:AddDropdown("MaterialDropdown", {
	Title = "Base Material",
	Description = "The base material for weapon",
	Values = mats,
	Multi = false,
	Default = 1,
})

local variantDrop = Tabs.Main:AddDropdown("WrapMaterialDropdown", {
	Title = "Wrap MaterialVariants",
	Description = "basically other wraps",
	Values = wrapVariantList,
	Multi = false,
	Default = #wrapVariantList > 0 and 1 or nil
})

local cp = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
	Title = "Colorpicker",
	Description = "What color you want the weapon to be",
	Transparency = 0,
	Default = Color3.fromRGB(255, 255, 255)
})

Tabs.Main:AddParagraph({ Title = "Toggles", Content = "This has all of the toggles" })

Tabs.Main:AddToggle("UseColor", {
	Title = "Apply Color",
	Description = "Change the weapon color",
	Default = false
})

Tabs.Main:AddToggle("UseMaterial", {
	Title = "Apply Material",
	Description = "Change the base material",
	Default = false
})

Tabs.Main:AddToggle("UseTransparency", {
	Title = "Apply Transparency",
	Description = "Set part transparency",
	Default = false
})

Tabs.Main:AddToggle("UseWrapTexture", {
	Title = "Apply Wrap",
	Description = "Applies wraps",
	Default = false
})

Tabs.Main:AddToggle("UseWrapMat", {
	Title = "Use Wrap Material",
	Description = "pretty much other textures",
	Default = false
})

Tabs.Main:AddButton({
	Title = "Apply changes",
	Description = "Applies the changes that u have made",
	Callback = function()
		local sel = Options.WeaponDropdown.Value
		local col = cp.Value
		local trans = cp.Transparency
		local mat = Enum.Material[Options.MaterialDropdown.Value]
		local tex = Options.TextureDrop.Value
		local matVariant = wrapmatnames[Options.WrapMaterialDropdown.Value]
		if not matVariant and wrapmatnames[tex] then
			matVariant = wrapmatnames[tex]
		end

		for _, v in ipairs(w) do
			if v.Name == sel then
				for _, d in ipairs(v:GetDescendants()) do
					if d:IsA("BasePart") and d.Transparency ~= 1 then
						if Options.UseColor.Value then d.Color = col end
						if Options.UseTransparency.Value then d.Transparency = trans end

						if Options.UseWrapMat.Value and matVariant then
							d.Material = Enum.Material.Fabric
							d.MaterialVariant = matVariant.Name
							for _, t in ipairs(d:GetChildren()) do
								if t:IsA("Texture") or t:IsA("Decal") or t:IsA("SurfaceAppearance") then
									t:Destroy()
								end
							end
						else
							if Options.UseMaterial.Value then
								d.Material = mat
							end
							d.MaterialVariant = ""

							if Options.UseWrapTexture.Value and tex then
								for _, t in ipairs(d:GetChildren()) do
									if t:IsA("Texture") or t:IsA("Decal") or t:IsA("SurfaceAppearance") then
										t:Destroy()
									end
								end
								for _, w in ipairs(wraps) do
									if w.Name == tex then
										for _, c in ipairs(w:GetChildren()) do
											if c:IsA("Decal") or c:IsA("Texture") or c:IsA("SurfaceAppearance") then
												local clone = c:Clone()
												clone.Parent = d
											end
										end
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
})

Tabs.Main:AddButton({
	Title = "Remove Effects",
	Description = "Removes all wrap textures, material variants, surface appearances, and resets material (keeps color)",
	Callback = function()
		local sel = Options.WeaponDropdown.Value
		for _, v in ipairs(w) do
			if v.Name == sel then
				for _, d in ipairs(v:GetDescendants()) do
					if d:IsA("BasePart") then
						d.Material = Enum.Material.SmoothPlastic
						d.MaterialVariant = ""
						for _, t in ipairs(d:GetChildren()) do
							if t:IsA("Decal") or t:IsA("Texture") or t:IsA("SurfaceAppearance") then
								t:Destroy()
							end
						end
					end
				end
			end
		end
	end
})
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("weaponcustomiser")
SaveManager:SetFolder("weaponcustomiser/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
