-- SCRIPTER BRO HUB V2 | Yokudo-inspired Roblox UI
-- UI-only rebuild: tabs, draggable window, floating toggle, toggles, dropdown, and buttons.
-- Connect the callback functions below to your own authorized game logic.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Theme = {
 Background = Color3.fromRGB(16, 17, 23),
 Sidebar = Color3.fromRGB(20, 21, 28),
 TopBar = Color3.fromRGB(23, 24, 32),
 Accent = Color3.fromRGB(105, 90, 190),
 Text = Color3.fromRGB(255, 255, 255),
 SubText = Color3.fromRGB(145, 145, 165),
 Row = Color3.fromRGB(25, 26, 35),
 Stroke = Color3.fromRGB(65, 65, 85),
}

local function getGuiParent()
 local parent = CoreGui
 pcall(function()
 if type(gethui) == "function" then
 local hui = gethui()
 if hui then parent = hui end
 end
 end)
 if not parent then
 parent = LocalPlayer:WaitForChild("PlayerGui")
 end
 return parent
end

local GuiParent = getGuiParent()
pcall(function()
 local old = GuiParent:FindFirstChild("SCRIPTER_BRO_HUB_V2")
 if old then old:Destroy() end
 local oldToggle = GuiParent:FindFirstChild("SCRIPTER_BRO_HUB_V2_TOGGLE")
 if oldToggle then oldToggle:Destroy() end
end)

local function addCorner(object, radius)
 local corner = Instance.new("UICorner")
 corner.CornerRadius = UDim.new(0, radius or 6)
 corner.Parent = object
 return corner
end

local function addStroke(object, color, thickness, transparency)
 local stroke = Instance.new("UIStroke")
 stroke.Color = color or Theme.Stroke
 stroke.Thickness = thickness or 1
 stroke.Transparency = transparency or 0
 stroke.Parent = object
 return stroke
end

local function make(className, props, parent)
 local object = Instance.new(className)
 for key, value in pairs(props or {}) do
 object[key] = value
 end
 object.Parent = parent
 return object
end

-- Floating open/close button
local ToggleGui = make("ScreenGui", {
 Name = "SCRIPTER_BRO_HUB_V2_TOGGLE",
 ResetOnSpawn = false,
 IgnoreGuiInset = true,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
 DisplayOrder = 1001,
}, GuiParent)

local FloatingToggle = make("TextButton", {
 Name = "Toggle",
 Size = UDim2.fromOffset(55, 55),
 Position = UDim2.new(0.02, 0, 0.5, -27),
 BackgroundColor3 = Theme.Sidebar,
 Text = "S",
 TextColor3 = Theme.Text,
 TextSize = 25,
 Font = Enum.Font.GothamBold,
 AutoButtonColor = true,
 ZIndex = 1002,
}, ToggleGui)
addCorner(FloatingToggle, 28)
addStroke(FloatingToggle, Theme.Accent, 1.5, 0.1)

-- Main window
local ScreenGui = make("ScreenGui", {
 Name = "SCRIPTER_BRO_HUB_V2",
 ResetOnSpawn = false,
 IgnoreGuiInset = true,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
 DisplayOrder = 1000,
}, GuiParent)

local Main = make("Frame", {
 Name = "Main",
 Size = UDim2.fromOffset(480, 340),
 Position = UDim2.new(0.5, -240, 0.5, -170),
 BackgroundColor3 = Theme.Background,
 BorderSizePixel = 0,
 ClipsDescendants = true,
 Active = true,
}, ScreenGui)
addStroke(Main, Color3.fromRGB(200, 200, 220), 1.5, 0.2)

local TopBar = make("Frame", {
 Name = "TopBar",
 Size = UDim2.new(1, 0, 0, 58),
 BackgroundColor3 = Theme.TopBar,
 BorderSizePixel = 0,
 Active = true,
}, Main)
make("UIGradient", {
 Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 38, 53)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 23, 30)),
 }),
 Rotation = 0,
}, TopBar)

make("TextLabel", {
 Name = "Title",
 Position = UDim2.fromOffset(17, 7),
 Size = UDim2.new(1, -70, 0, 25),
 BackgroundTransparency = 1,
 Text = "SCRIPTER BRO HUB V2",
 TextColor3 = Theme.Text,
 TextSize = 18,
 Font = Enum.Font.GothamBold,
 TextXAlignment = Enum.TextXAlignment.Left,
}, TopBar)

make("TextLabel", {
 Name = "Subtitle",
 Position = UDim2.fromOffset(18, 32),
 Size = UDim2.new(1, -70, 0, 15),
 BackgroundTransparency = 1,
 Text = "Steal An Egg • Feature UI",
 TextColor3 = Theme.SubText,
 TextSize = 10,
 Font = Enum.Font.Gotham,
 TextXAlignment = Enum.TextXAlignment.Left,
}, TopBar)

local Close = make("TextButton", {
 Name = "Close",
 Size = UDim2.fromOffset(28, 28),
 Position = UDim2.new(1, -38, 0, 15),
 BackgroundColor3 = Color3.fromRGB(45, 35, 48),
 Text = "×",
 TextColor3 = Theme.Text,
 TextSize = 23,
 Font = Enum.Font.Gotham,
 AutoButtonColor = true,
}, TopBar)
addCorner(Close, 7)

local Sidebar = make("Frame", {
 Name = "Sidebar",
 Position = UDim2.fromOffset(0, 58),
 Size = UDim2.new(0, 115, 1, -58),
 BackgroundColor3 = Theme.Sidebar,
 BorderSizePixel = 0,
}, Main)

local Content = make("Frame", {
 Name = "Content",
 Position = UDim2.fromOffset(115, 58),
 Size = UDim2.new(1, -115, 1, -58),
 BackgroundTransparency = 1,
 BorderSizePixel = 0,
}, Main)

local TabList = make("Frame", {
 Name = "TabList",
 Position = UDim2.fromOffset(8, 12),
 Size = UDim2.new(1, -16, 1, -24),
 BackgroundTransparency = 1,
}, Sidebar)
make("UIListLayout", {
 Padding = UDim.new(0, 7),
 SortOrder = Enum.SortOrder.LayoutOrder,
}, TabList)

local PageHolder = make("Frame", {
 Name = "PageHolder",
 Position = UDim2.fromOffset(12, 12),
 Size = UDim2.new(1, -24, 1, -24),
 BackgroundTransparency = 1,
 ClipsDescendants = true,
}, Content)

local Pages = {}
local TabButtons = {}
local ActiveTab = nil

local function createPage(name)
 local page = make("ScrollingFrame", {
 Name = name .. "Page",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 BorderSizePixel = 0,
 ScrollBarThickness = 3,
 ScrollBarImageColor3 = Theme.Accent,
 CanvasSize = UDim2.new(0, 0, 0, 0),
 AutomaticCanvasSize = Enum.AutomaticSize.Y,
 Visible = false,
 }, PageHolder)

 make("UIListLayout", {
 Padding = UDim.new(0, 8),
 SortOrder = Enum.SortOrder.LayoutOrder,
 }, page)

 make("UIPadding", {
 PaddingBottom = UDim.new(0, 4),
 PaddingRight = UDim.new(0, 4),
 }, page)

 Pages[name] = page
 return page
end

local function selectTab(name)
 ActiveTab = name
 for tabName, page in pairs(Pages) do
 page.Visible = (tabName == name)
 end
 for tabName, button in pairs(TabButtons) do
 local selected = tabName == name
 button.BackgroundColor3 = selected and Theme.Accent or Theme.Sidebar
 button.TextColor3 = selected and Theme.Text or Theme.SubText
 end
end

local function createTab(name, label)
 local button = make("TextButton", {
 Name = name .. "Tab",
 Size = UDim2.new(1, 0, 0, 32),
 BackgroundColor3 = Theme.Sidebar,
 BorderSizePixel = 0,
 Text = label,
 TextColor3 = Theme.SubText,
 TextSize = 12,
 Font = Enum.Font.GothamMedium,
 AutoButtonColor = false,
 }, TabList)
 addCorner(button, 6)
 TabButtons[name] = button
 local page = createPage(name)
 button.Activated:Connect(function()
 selectTab(name)
 end)
 return page
end

local function createSection(page, title)
 return make("TextLabel", {
 Name = "Section_" .. title:gsub("%W", ""),
 Size = UDim2.new(1, -2, 0, 22),
 BackgroundTransparency = 1,
 Text = title,
 TextColor3 = Theme.Text,
 TextSize = 13,
 Font = Enum.Font.GothamBold,
 TextXAlignment = Enum.TextXAlignment.Left,
 }, page)
end

local function createToggle(page, title, description, defaultValue, callback)
 local row = make("Frame", {
 Name = title:gsub("%W", "") .. "Toggle",
 Size = UDim2.new(1, -2, 0, description and 54 or 42),
 BackgroundColor3 = Theme.Row,
 BorderSizePixel = 0,
 }, page)
 addCorner(row, 6)

 make("TextLabel", {
 Position = UDim2.fromOffset(10, description and 7 or 0),
 Size = UDim2.new(1, -70, 0, 19),
 BackgroundTransparency = 1,
 Text = title,
 TextColor3 = Theme.Text,
 TextSize = 11,
 Font = Enum.Font.GothamMedium,
 TextXAlignment = Enum.TextXAlignment.Left,
 }, row)

 if description then
 make("TextLabel", {
 Position = UDim2.fromOffset(10, 27),
 Size = UDim2.new(1, -72, 0, 17),
 BackgroundTransparency = 1,
 Text = description,
 TextColor3 = Theme.SubText,
 TextSize = 9,
 Font = Enum.Font.Gotham,
 TextXAlignment = Enum.TextXAlignment.Left,
 TextTruncate = Enum.TextTruncate.AtEnd,
 }, row)
 end

 local switch = make("TextButton", {
 Name = "Switch",
 Size = UDim2.fromOffset(34, 19),
 Position = UDim2.new(1, -45, 0.5, -9),
 BackgroundColor3 = defaultValue and Theme.Accent or Color3.fromRGB(55, 56, 68),
 Text = "",
 AutoButtonColor = false,
 }, row)
 addCorner(switch, 10)

 local knob = make("Frame", {
 Name = "Knob",
 Size = UDim2.fromOffset(13, 13),
 Position = defaultValue and UDim2.new(1, -16, 0.5, -6) or UDim2.fromOffset(3, 3),
 BackgroundColor3 = Color3.fromRGB(255, 255, 255),
 BorderSizePixel = 0,
 }, switch)
 addCorner(knob, 8)

 local enabled = defaultValue == true
 local function setValue(value)
 enabled = value == true
 TweenService:Create(switch, TweenInfo.new(0.12), {
 BackgroundColor3 = enabled and Theme.Accent or Color3.fromRGB(55, 56, 68),
 }):Play()
 TweenService:Create(knob, TweenInfo.new(0.12), {
 Position = enabled and UDim2.new(1, -16, 0.5, -6) or UDim2.fromOffset(3, 3),
 }):Play()
 if callback then
 local ok, err = pcall(callback, enabled)
 if not ok then warn("[SCRIPTER BRO HUB V2] Toggle callback failed:", err) end
 end
 end
 switch.Activated:Connect(function()
 setValue(not enabled)
 end)
 return {
 Set = setValue,
 Get = function() return enabled end,
 }
end

local function createButton(page, title, callback)
 local button = make("TextButton", {
 Name = title:gsub("%W", "") .. "Button",
 Size = UDim2.new(1, -2, 0, 36),
 BackgroundColor3 = Theme.Accent,
 BorderSizePixel = 0,
 Text = title,
 TextColor3 = Theme.Text,
 TextSize = 11,
 Font = Enum.Font.GothamBold,
 AutoButtonColor = true,
 }, page)
 addCorner(button, 6)
 button.Activated:Connect(function()
 if callback then
 local ok, err = pcall(callback)
 if not ok then warn("[SCRIPTER BRO HUB V2] Button callback failed:", err) end
 end
 end)
 return button
end

local function createInfo(page, text)
 return make("TextLabel", {
 Size = UDim2.new(1, -2, 0, 34),
 BackgroundTransparency = 1,
 Text = text,
 TextColor3 = Theme.SubText,
 TextSize = 10,
 Font = Enum.Font.Gotham,
 TextWrapped = true,
 TextXAlignment = Enum.TextXAlignment.Left,
 TextYAlignment = Enum.TextYAlignment.Top,
 }, page)
end

-- Pages / feature catalogue.
-- These controls mirror features identified in the supplied original source.
-- They are UI entries only until each callback is connected to its original feature logic.
local function addFeatureList(page, sectionName, features)
 createSection(page, sectionName)
 for _, item in ipairs(features) do
  createToggle(page, item[1], item[2] or "UI entry only — original feature logic is not connected.", false, function(on)
   print("[SCRIPTER BRO HUB V2] " .. item[1] .. ": " .. tostring(on) .. " (UI only)")
  end)
 end
end

local home = createTab("Home", "⌂ Home")
createSection(home, "SCRIPTER BRO HUB V2")
createInfo(home, "Yokudo-style UI with a Steal Panel and feature categories identified in the supplied sources.")
createInfo(home, "Important: feature switches are currently UI placeholders. They do not run the original farming, stealing, selling, or event logic.")
createButton(home, "Print UI status", function()
 print("[SCRIPTER BRO HUB V2] UI is running for", LocalPlayer and LocalPlayer.Name or "player")
end)

local farm = createTab("StealPanel", "♢ Steal Panel")
addFeatureList(farm, "Stealing & farming", {
 {"Auto Steal", "Automatically target eggs — original logic not connected."},
 {"Instant Steal", "Fast delivery mode — original logic not connected."},
 {"Instant Steal V2", "Alternative fast-tween mode — original logic not connected."},
 {"Instant Steal V3", "Event/minigame stealing mode — original logic not connected."},
 {"Steal Missing Index Eggs", "Target eggs missing from the index."},
 {"Steal Filter Eggs", "Use egg filters when selecting targets."},
 {"Auto Return", "Return carried eggs — original logic not connected."},
 {"Drop Eggs At Safe Zone", "Drop rather than deliver to base."},
 {"Auto Use Admin Treadmill", "Use the admin treadmill when available."},
 {"Auto Save Config", "Configuration-saving entry from the original source."},
 {"Auto Load Config", "Load a saved configuration entry."},
 {"Auto Treadmill", "Use the treadmill automatically."},
 {"Auto Capture Event Egg", "Capture the event egg when available."},
 {"Auto Steal Minigame Egg", "Target minigame eggs."},
 {"Auto Steal Halloween Eggs", "Target Halloween eggs."},
 {"Auto Steal Wisp Quest Eggs", "Target eggs needed for the Wisp quest."},
 {"Auto Place", "Prioritize placing eggs when configured."},
})

local eggs = createTab("Eggs", "🥚 Eggs")
addFeatureList(eggs, "Egg & pet management", {
 {"Auto Place Egg", "Place matching eggs on nests."},
 {"Auto Hatch", "Hatch selected eggs."},
 {"Auto Hatch & Equip", "Hatch eggs and equip the resulting pet."},
 {"Auto Equip Best", "Equip the best available pet."},
 {"Auto Sell", "Sell eggs matching configured filters."},
 {"Auto Sell Pet", "Sell pets matching configured filters."},
 {"Auto Sell Lab Egg", "Sell matching Lab eggs."},
 {"Auto Fuse Machine", "Fuse matching pets."},
 {"Auto Favorite", "Favorite matching pets."},
 {"Auto Favorite Equipped", "Keep equipped pets favorited."},
 {"Auto Unfavorite Equipped", "Unfavorite equipped pets that do not match rules."},
 {"Auto Mutation", "Apply mutations to matching eggs."},
 {"Auto Mutate", "Mutate matching target eggs."},
 {"Auto Buy Nitro", "Buy Nitro for the Racing Event."},
 {"Auto Sell Lab Egg", "Sell Lab eggs matching configured filters."},
 {"Auto Lab Trade-In", "Trade in matching Lab pets/eggs."},
 {"Auto Reroll Lab Recipe", "Reroll the Lab recipe automatically."},
 {"Auto Place Lab Reward Eggs", "Place Lab reward eggs."},
 {"Skip Owned Lab Eggs", "Avoid Lab eggs already owned."},
})

local events = createTab("Events", "✦ Events")
addFeatureList(events, "Events & quests", {
 {"Auto Butterfly Bloom", "Catch butterflies during Butterfly Bloom."},
 {"Auto Trade Up", "Trade up butterfly/event items."},
 {"Auto Craft Essence", "Craft essence automatically."},
 {"Auto Farm Monsters", "Farm Halloween monsters for Candy Corn."},
 {"Auto Pumpkin Moon", "Run the Pumpkin Moon activity."},
 {"Auto Buy Halloween Dimension Egg", "Buy Halloween Dimension eggs."},
 {"Auto Ghost Dog Quest", "Progress the Ghost Dog quest."},
 {"Auto Fishing", "Fish in the Halloween Dimension."},
 {"Halloween Monsters", "Halloween monster activity entry."},
 {"Halloween Dimension", "Halloween Dimension activity entry."},
 {"Auto Wisp", "Progress the Wisp quest."},
 {"Auto Banjo Cricket", "Handle the Banjo Cricket objective."},
 {"Halloween Fishing", "Fish during the Halloween event."},
 {"Capture The Egg", "Enable Capture The Egg event support."},
 {"Racing Event", "Racing Event support entry."},
 {"Butterfly Bloom", "Butterfly Bloom event support entry."},
})

local player = createTab("Player", "♙ Player")
addFeatureList(player, "Movement & player", {
 {"Speed Boost", "Movement speed option from the source."},
 {"Walk Speed", "Walk-speed control entry."},
 {"Jump Boost", "Jump boost option."},
 {"Teleport To Egg", "Move to the selected egg."},
 {"Move To Egg", "Walk/tween toward a selected egg."},
 {"Steal Speed", "Speed setting for stealing."},
 {"Carry Speed", "Carry movement speed setting."},
 {"V2 Tween Speed", "Tween speed setting for Instant Steal V2."},
 {"Tween Speed", "General tween speed setting."},
 {"Egg Size Boost", "Egg-size boost option from the source."},
 {"Egg Luck Boost", "Egg-spawn luck boost option from the source."},
})

local settings = createTab("Settings", "⚙ Settings")
createSection(settings, "Interface")
createButton(settings, "Reset window position", function()
 Main.Position = UDim2.new(0.5, -240, 0.5, -170)
end)
createButton(settings, "Close SCRIPTER BRO HUB V2", function()
 ScreenGui.Enabled = false
end)
createButton(settings, "Turn Off All UI Switches", function()
 for _, descendant in ipairs(ScreenGui:GetDescendants()) do
  if descendant:IsA("TextButton") and descendant.Name == "Switch" then
   descendant:SetAttribute("ResetRequested", true)
   descendant:Activate()
  end
 end
end)
createInfo(settings, "Use the floating S button to reopen the window. Feature controls are UI placeholders until connected to the original source logic.")

selectTab("Home")

-- Drag window using the top bar.
local dragging = false
local dragInput, dragStart, startPosition
TopBar.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1
 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPosition = Main.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 dragging = false
 end
 end)
 end
end)

TopBar.InputChanged:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseMovement
 or input.UserInputType == Enum.UserInputType.Touch then
 dragInput = input
 end
end)

UserInputService.InputChanged:Connect(function(input)
 if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
 local delta = input.Position - dragStart
 Main.Position = UDim2.new(
 startPosition.X.Scale, startPosition.X.Offset + delta.X,
 startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
 )
 end
end)

FloatingToggle.Activated:Connect(function()
 ScreenGui.Enabled = not ScreenGui.Enabled
end)

Close.Activated:Connect(function()
 ScreenGui.Enabled = false
end)

print("[SCRIPTER BRO HUB V2] UI loaded successfully.")
