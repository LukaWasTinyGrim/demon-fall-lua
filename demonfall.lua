--[[
	Made by Sparkle#0077 - ata#0099
	Dont skid this or there will be legal action
--]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JRL-lav/Scripts/main/U"))()
local Window = Library:CreateWindow("Ata Reis | Demonfall")

-- // Pre Scripts
game:GetService("UserInputService").MouseIconEnabled = true
game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end


-- // Vars \\ -- 
local plr           = game:GetService("Players").LocalPlayer
local TweenService  = game:GetService("TweenService")
local noclipE       = false
local antifall      = nil
local Settings      = {}

local function noclip()
	for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide == true then
			v.CanCollide = false
		end
	end
end

local function moveto(obj, speed)
    local info = TweenInfo.new(((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude)/ speed,Enum.EasingStyle.Linear)
    local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = obj})

    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0,0,0)
        noclipE = game:GetService("RunService").Stepped:Connect(noclip)
        tween:Play()
    end
        
    tween.Completed:Connect(function()
        antifall:Destroy()
        noclipE:Disconnect()
    end)
end

-- // Farming \\ -- 
local farm = Window:AddFolder("Farm")
local mob_list = {
    -- Demon List
    "Yesil Iblis",
    "Normal Iblis",
    "Buzul Iblis",
    "Mavi Iblis",
    "Iblis Avcisi Bosu",
    "Alt Ay 3",
    "Kaigaku",
    "Okuro",

    -- Slayer List
    "GenericSlayer",
    "Zenitsu",
}

farm:AddList({
    text = "Mob Sec",
    values = mob_list,
    callback = function(v)
        Settings["ChosenMob"] = v
    end
})

farm:AddToggle({
    text = "Autofarm",
    state = false,
    callback = function(v)
        Settings["autofarm"] = v
    end
})

farm:AddSlider({
    text = "TP Hizi",
    value = 75,
    min = 30,
    max = 100,
    float = 1,
    callback = function(v)
        Settings["TpSpeed"] = v
    end
})

farm:AddToggle({
    text = "OtoNefes",
    state = false,
    callback = function(v)
        Settings["OtoNefes"] = v
        if not v then 
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Breath", false)
        end
    end
})

farm:AddToggle({
    text = "Kilic-Kusan",
    state = false,
    callback = function(v)
        Settings["AutoSword"] = v
    end
})

local function getMob()
    local dist, mob = math.huge 
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == Settings.ChosenMob then 
            local get_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:GetModelCFrame().p).magnitude 
            if get_mag < dist then 
                dist = get_mag 
                mob = v 
            end
        end
    end
    return mob
end

spawn(function()
    while wait() do 
        if Settings.autofarm then 
            pcall(function()
                local enemy_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude 

                if not getMob():FindFirstChild("Executed") then 
                    moveto(getMob():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                end

                if getMob():FindFirstChild("Executed") then 
                    wait(1)
                    getMob():Destroy()
                end

                if getMob():FindFirstChild("Down") then
                    moveto(getMob():GetModelCFrame() * CFrame.new(0,0,3), tonumber(Settings.TpSpeed or 75))
                    game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Character", "Execute")
                end

                if enemy_mag <= 10 then 
                    if getMob():FindFirstChild("Block") then 
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Combat", "Heavy")
                    else
                        game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Combat", "Server")
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do 
        if Settings.OtoNefes then
            if game.Players.LocalPlayer.Character:FindFirstChild("Busy") then 
                game.Players.LocalPlayer.Character:FindFirstChild("Busy"):Destroy()
            end

            if game.Players.LocalPlayer.Character:FindFirstChild("Slow") then 
                game.Players.LocalPlayer.Character:FindFirstChild("Slow"):Destroy()
            end
        end
    end
end)

spawn(function()
    while wait() do 
        if Settings.OtoNefes then 
            if game:GetService("Players").LocalPlayer.Breathing.Value ~= 100 then 
                game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Breath", true)
            end
            wait(2)
        end
    end
end)

spawn(function()
    while wait() do
        if Settings.AutoSword then 
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Blade") then  
                    if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Model"):FindFirstChild("Equipped").Part0 == nil then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "R", false, game)
                    end
                end
            end)
        end
    end
end)

farm:AddLabel({text = "--Skils"})

farm:AddToggle({text = "Yetenek-1",state = false,callback = function(v) Settings["Yetenek-1"] = v end})
farm:AddToggle({text = "Yetenek-2",state = false,callback = function(v) Settings["Yetenek-2"] = v end})
farm:AddToggle({text = "Yetenek-3",state = false,callback = function(v) Settings["Yetenek-3"] = v end})
farm:AddToggle({text = "Yetenek-4",state = false,callback = function(v) Settings["Yetenek-4"] = v end})
farm:AddToggle({text = "Yetenek-5",state = false,callback = function(v) Settings["Yetenek-5"] = v end})
farm:AddToggle({text = "Yetenek-6",state = false,callback = function(v) Settings["Yetenek-6"] = v end})
farm:AddToggle({text = "Yetenek-7",state = false,callback = function(v) Settings["Yetenek-7"] = v end})

pcall(function()
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-1"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "One", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-2"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Two", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-3"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Three", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-4"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Four", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-5"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Five", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-6"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Six", false, game)
                    wait(5)
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if Settings.autofarm then
            local mobmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getMob():GetModelCFrame().p).magnitude
            if mobmag <= 10 then
                if Settings["Yetenek-7"] then 
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Seven", false, game)
                    wait(5)
                end
            end
        end
    end
end)
end)

-- //  \\ -- 
local misc = Window:AddFolder("Diger")
misc:AddToggle({
    text = "FallDamageAlmama",
    state = false,
    callback = function(v)
        Settings["FallDamageAlmama"] = v
    end
})

misc:AddToggle({
    text = "Guneste Yanmama",
    state = false,
    callback = function(v)
        Settings["AntiSun"] = v
    end
})

misc:AddToggle({
    text = "Anti Crow",
    state = false,
    callback = function(v)
        Settings["AntiCrow"] = v
    end
})

local FallDamageAlmama 
FallDamageAlmama = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "FallDamageServer" and Settings.FallDamageAlmama then 
        return nil
    end

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "DemonWeakness" and Settings.AntiSun then 
        return nil
    end

    if method == "FireServer" and tostring(self) == "Async" and args[1] == "Character" and args[2] == "Crow" and Settings.AntiCrow then 
        return nil
    end

    return FallDamageAlmama(self, ...)
end)

misc:AddToggle({
    text = "Trinket Farm",
    state = false,
    callback = function(v)
        Settings["TrinketFarm"] = v
    end
})

local function getTrinket()
    local dist, trin = math.huge 
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("PickableItem") and v:FindFirstChild("Part") then 
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("Part").Position).magnitude 
            if mag < dist then 
                dist = mag 
                trin = v 
            end
        end
    end
    return trin
end

spawn(function()
    while wait() do
        if Settings.TrinketFarm then
            local trinmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getTrinket():FindFirstChild("Part").Position).magnitude
            if trinmag <= 20 then 
                for i,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("PickableItem") and v:FindFirstChild("Part") then 
                        local partmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("Part").Position).magnitude 
                        if partmag < 20 then 
                            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Interaction", v.Part)
                        end
                    end
                end                
            else
                moveto(getTrinket():FindFirstChild("Part").CFrame, tonumber(Settings.TpSpeed or 75))
            end
        end
    end
end)

misc:AddToggle({
    text = "ChatLogger",
    state = false,
    callback = function(v)
        if v then 
            plr.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
        else
            plr.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = false
        end
    end
})

local function SinirsizZiplama(inputObject, gameProcessedEvent)
    if inputObject.KeyCode == Enum.KeyCode.Space then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(3)
    end
end

local connection
misc:AddToggle({
    text = "SinirsizZiplama",
    state = false,
    callback = function(v)
        if v then 
            connection = game:GetService("UserInputService").InputBegan:connect(SinirsizZiplama)
        else
            if connection then 
                connection:Disconnect()
            end
        end
    end
})

local noclipT
misc:AddToggle({
    text = "NoClip",
    state = false,
    callback = function(v)
        if v then 
            noclipT = game:GetService("RunService").Stepped:Connect(noclip)
        else
            if noclipT then 
                noclipT:Disconnect()
            end
        end
    end
})

misc:AddToggle({
    text = "Anti-Combat",
    state = false,
    callback = function(v)
        Settings["AntiCombat"] = v
    end
})

local baditems = {
    "Combat",
    "Stun",
    "Damaged",
    "downCooldown",
    "Cooldown"
}

spawn(function()
    while wait() do 
        if Settings.AntiCombat then 
            pcall(function()
                for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if table.find(baditems, v.Name) then 
                        v:Destroy()
                    end
                end                
            end)
        end
    end
end)

misc:AddToggle({
    text = "Pickup-Aura",
    state = false,
    callback = function(v)
        Settings["PickupAura"] = v
    end
})

spawn(function()
    while wait() do 
        if Settings.PickupAura then 
            pcall(function()
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name == "DropItem" then 
                        local partmag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude 
                        if partmag < 20 then 
                            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "Interaction", v)
                        end
                    end
                end
            end)
        end
    end
end)

misc:AddToggle({
    text = "OtoVurma",
    state = false,
    callback = function(v)
        Settings["OtoVurma"] = v
    end
})

spawn(function()
    while wait(0.1) do 
        if Settings.OtoVurma then 
            pcall(function()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 1)
                game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Clay", "Server2")
            end)
        end
    end
end)

misc:AddToggle({
    text = "Enhance-Visuals",
    callback = function(v)
        Settings["Visuals"] = v
        pcall(function()
            game.Lighting.SunRays.Enabled = false
            game.Lighting.ColorCorrection.Enabled = false
            game.Lighting.Blur.Enabled = false
            game.Lighting.Bloom.Enabled = false

            for i,v in pairs(game.Lighting:GetChildren()) do
                if v.Name == "Atmosphere" then 
                    v.Density = 0 
                    v.Glare = 0 
                    v.Haze = 0
                end
            end
            game.Lighting.Blind:Destroy()
        end)
    end
})

spawn(function()
    while wait(1) do
        if Settings.Visuals then 
            game.Lighting.SunRays.Enabled = false
            game.Lighting.ColorCorrection.Enabled = false
            game.Lighting.Blur.Enabled = false
            game.Lighting.Bloom.Enabled = false

            for i,v in pairs(game.Lighting:GetChildren()) do
                if v.Name == "Atmosphere" then 
                    v.Density = 0 
                    v.Glare = 0 
                    v.Haze = 0
                end
            end
            if game.Lighting:FindFirstChild("Blind") then 
                game.Lighting:FindFirstChild("Blind"):Destroy()
            end
            if workspace:FindFirstChild("Folder") and workspace:FindFirstChild("Folder"):FindFirstChild("Part") then 
                workspace:FindFirstChild("Folder"):Destroy()
            end
        end
    end
end)

misc:AddLabel({text = "---FallDamageAlmama Kapat---"})

misc:AddButton({
    text = "Olumsuzluk",
    callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", "nan(ind)")
        end)
    end
})

misc:AddButton({
    text = "Normal Can (Seni Oldurur)",
    callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Character", "FallDamageServer", 99999999999999999999999999999999999999999999999999999999999999999999)
        end)
    end
})

misc:AddLabel({text = "---FallDamageAlmama Kapat---"})
-- // Players \\ -- 
local plrs = Window:AddFolder("Players")
plrs:AddLabel({text = "----LocalPlayer Items"})

local mt = getrawmetatable(game)
local index = mt.__newindex

plrs:AddSlider({
    text = "YurumeHizi",
    value = 18,
    min = 18,
    max = 150,
    float = 1,
    callback = function(v)
        Settings["YurumeHizi"] = v
    end
})

plrs:AddToggle({
    text = "YurumeHizi Ac",
    state = false,
    callback = function(v)
        Settings["YurumeAc"] = v
    end
})


plrs:AddSlider({
    text = "ZiplamaGucu",
    value = 60,
    min = 60,
    max = 100,
    float = 1,
    callback = function(v)
        Settings["ZiplamaGucu"] = v
    end
})

plrs:AddToggle({
    text = "ZiplamaGucu Ac",
    state = false,
    callback = function(v)
        Settings["ZiplamaAc"] = v
    end
})

setreadonly(mt, false)
mt.__newindex = newcclosure(function(f,i,v)
    if tostring(f) == "Humanoid" and tostring(i) == "YurumeHizi" and Settings.YurumeAc then 
        return index(f,i,Settings.YurumeHizi)
    end

    if tostring(f) == "Humanoid" and tostring(i) == "ZiplamaGucu" and Settings.ZiplamaAc then 
        return index(f,i,Settings.ZiplamaGucu)
    end

    return index(f,i,v)
end)
setreadonly(mt, true)


plrs:AddLabel({text = "----Player Items"})
local plr_table = {}
for i,v in pairs(game.Players:GetPlayers()) do
    if not table.find(plr_table, v.Name) then 
        table.insert(plr_table, v.Name)
    end
end

local plr_drop = plrs:AddList({
    text = "Oyuncu Sec",
    values = plr_table,
    callback = function(v)
        Settings["ChosenPlayer"] = v
    end
})

plrs:AddButton({
    text = "Oyunculari Yenile",
    callback = function()
        table.clear(plr_table)
        plr_drop:RemoveAll()

        for i,v in pairs(game.Players:GetPlayers()) do
            if not table.find(plr_table, v.Name) then 
                table.insert(plr_table, v.Name)
            end
        end
        
        for i,v in pairs(plr_table) do
            plr_drop:AddValue(tostring(v))
        end
    end
})

plrs:AddToggle({
    text = "Izle",
    state = false,
    callback = function(v)
        if v then 
            workspace.Camera.CameraSubject = game.Players:FindFirstChild(Settings.ChosenPlayer).Character.Humanoid
        else
            workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        end
    end
})

plrs:AddButton({
    text = "Teleport",
    callback = function()
        moveto(game.Players:FindFirstChild(Settings.ChosenPlayer).Character.HumanoidRootPart.CFrame, tonumber(Settings.TpSpeed or 75))
    end
})

-- // Teleports \\ -- 
local tele = Window:AddFolder("Teleports")
local breath_style = {
    ["SunBreath"] = "Tanjiro",
    ["MoonBreath"] = "Kokushibo",
    ["WaterBreath"] = "Urokodaki",
    ["ThunderBreath"] = "Kujima",
    ["FlameBreath"] = "Rengoku",
    ["WindBreath"] = "Grim",
    ["MistBreath"] = "Tokito",
    ["InsectBreath"] = "Shinobu",
    ["SoundBreath"] = "Uzui",
}
local breath_names = {}
for i,v in pairs(breath_style) do
    table.insert(breath_names, i)
end

tele:AddList({
    text = "Nefes Sec",
    values = breath_names,
    callback = function(v)
        Settings["SecilenNefes"] = v
    end
})

tele:AddButton({
    text = "Nefese Isinlan",
    callback = function()
        moveto(workspace.Npcs:FindFirstChild(breath_style[Settings.SecilenNefes]):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))
    end
})

local npc_list = {}
for i,v in pairs(workspace.Npcs:GetChildren()) do
    if v:IsA("Model") and not table.find(npc_list, v.Name) then 
        table.insert(npc_list, v.Name)
    end
end

tele:AddList({
    text = "NPC Sec",
    values = npc_list,
    callback = function(v)
        Settings["SecilenNPC"] = v
    end
})

tele:AddButton({
    text = "NPC'ye Isinlan",
    callback = function()
        moveto(workspace.Npcs:FindFirstChild(Settings.SecilenNPC):GetModelCFrame(), tonumber(Settings.TpSpeed or 75))        
    end
})

-- // Madenler \\ -- 
local Madenler = Window:AddFolder("Madenler")
local ore_list = {
    "Gunes Madeni",
    "Gumus Madeni"
}
Madenler:AddList({
    text = "Maden Sec",
    values = ore_list,
    callback = function(v)
        Settings["SecilenMaden"] = v
    end
})

Madenler:AddToggle({
    text = "MadenFarmi",
    state = false,
    callback = function(v)
        Settings["MadenFarmi"] = v
    end
})

local function getOre()
    local dist, ore = math.huge
    for i,v in pairs(game:GetService("Workspace").Map.Minerals:GetDescendants()) do
        if v.Name == "MineralName" and v.Value == Settings.SecilenMaden then 
            local oremag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).magnitude
            if oremag < dist then 
                dist = oremag
                ore = v.Parent
            end
        end
    end
    return ore
end

spawn(function()
    while wait() do 
        if Settings.MadenFarmi then 
            local ore_mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getOre().Position).magnitude
            if ore_mag <= 5 then 
                game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer("Pickaxe", "Server")
            else
                moveto(getOre().CFrame, tonumber(Settings.TpSpeed or 75))
            end
        end
    end
end)

-- // Credits \\ --
local cred = Window:AddFolder("Yapimcilar")
cred:AddButton({text = "Sparkle#0077", callback = function()
    setclipboard("Sparkle#0077")
end})
cred:AddButton({text = "Discord", callback = function()
    setclipboard("discord.gg/TCyGay6ADE")
end})

cred:AddLabel({text = "Olumsuzluk | ata#0099"})


-- // Init \\ -- 
Library:Init()
