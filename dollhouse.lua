
function gplr(String)
    local Found = {}
    
    if typeof(String) ~= "string" then
        warn("Invalid input: Expected a string for 'String' parameter.")
        return nil
    end
    
    local strl = String:lower()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer

    if strl == "all" then
        for i, v in pairs(Players:GetPlayers()) do
            table.insert(Found, v)
        end
    elseif strl == "others" then
        for i, v in pairs(Players:GetPlayers()) do
            if v.Name ~= lp.Name then
                table.insert(Found, v)
            end
        end
    elseif strl == "me" then
        local ownerName = _NightmareInternals.Controller[1]
        for i, v in pairs(Players:GetPlayers()) do
            if v.Name == ownerName then
                table.insert(Found, v)
                break
            end
        end
    elseif strl == "double" then
        local ownerName = _NightmareInternals.Controller[2]
        for i, v in pairs(Players:GetPlayers()) do
            if v.Name == ownerName then
                table.insert(Found, v)
                break
            end
        end
    elseif strl == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers, Player) then
            table.remove(GetPlayers, table.find(GetPlayers, Player))
        end

        return GetPlayers[math.random(#GetPlayers)]

        elseif strl == "owner" then
            local ownerName = _NightmareInternals.Controller[6]
            for i, v in pairs(Players:GetPlayers()) do
                if v.Name == ownerName then
                    table.insert(Found, v)
                    break
                end
            end
    else
        for i, v in pairs(Players:GetPlayers()) do
            if v.Name:lower():sub(1, #String) == String:lower() or v.DisplayName:lower():sub(1, #String) == String:lower() then
                table.insert(Found, v)
            end
        end
    end

    if #Found == 1 then
        return Found[1]
    else
        return Found
    end
end

__ = {
    Settings = {
        WhitelistedUsers = {"R_ZPP", "NightmareBot_1", "NightmareBot_2", "NightmareBot_5", "NightmareBot_7", "NightmareBot_9"},
        RandomMessages = {
            "can't believe the devs thought this was foolproof | join 4 whitelist g/u6FqTxRYE9",
            "dollhouse out here making moves, gg to the 'anti' lol | join 4 whitelist g/u6FqTxRYE9",
            "newest 'security' update really boosting our stats 😂 | join 4 whitelist g/u6FqTxRYE9",
            "another day, another 'patch' bypassed... | join 4 whitelist g/u6FqTxRYE9",
            "dollhouse keeps winning, meanwhile the filter's sleeping | join 4 whitelist g/u6FqTxRYE9",
            "if 'unhackable' was real, we wouldn't be here, right? | join 4 whitelist g/u6FqTxRYE9",
            "anticheat be on coffee break again lol | join 4 whitelist g/u6FqTxRYE9",
            "devs say patched, we say game on 🕹️ | join 4 whitelist g/u6FqTxRYE9",
            "dollhouse vibes: maxed stats, 'protection' be like nah | join 4 whitelist g/u6FqTxRYE9",
            "fun fact: the devs thought they'd outsmart us | join 4 whitelist g/u6FqTxRYE9",
            "imagine if the devs got a low taper fade | join 4 whitelist g/u6FqTxRYE9",
            "nightmare runs dollhouse | join 4 whitelist g/u6FqTxRYE9",
            "me when bypassed hyperion :3 | join 4 whitelist g/u6FqTxRYE9"
        },
        DollhouseUsername = gplr("random").Name,
        DollhouseMaxLoops = 30,
        DollhouseLoops = 0
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local bangConnection
local bangAnimTrack

local function getBangRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

function bang(targetName, speed)
    speed = speed or 1
    local speaker = Players.LocalPlayer
    local targetPlayer = gplr(targetName)

    if not targetPlayer then
        warn("Target player not found.")
        return
    end

    if typeof(targetPlayer) == "table" then
        warn("Multiple players found. Specify a single player name.")
        return
    end

    local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        warn("Humanoid not found for the local player.")
        return
    end


    local bangAnim = Instance.new("Animation")
    bangAnim.AnimationId = "rbxassetid://" .. (speaker.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 and "5918726674" or "148840371")
    bangAnimTrack = humanoid:LoadAnimation(bangAnim)
    bangAnimTrack:Play(0.1, 1, 1)
    bangAnimTrack:AdjustSpeed(speed)

    local bangDiedConnection = humanoid.Died:Connect(function()
        unbang()
        bangDiedConnection:Disconnect()
    end)

    local bangOffset = CFrame.new(0, 0, 1.1)
    bangConnection = RunService.Stepped:Connect(function()
        pcall(function()
            local targetRoot = getBangRoot(targetPlayer.Character)
            local speakerRoot = getBangRoot(speaker.Character)
            if targetRoot and speakerRoot then
                speakerRoot.CFrame = targetRoot.CFrame * bangOffset
            end
        end)
    end)
end

function unbang()
    if bangConnection then
        bangConnection:Disconnect()
        bangConnection = nil
    end

    if bangAnimTrack then
        bangAnimTrack:Stop()
        bangAnimTrack:Destroy()
        bangAnimTrack = nil
    end
end

local SeatStorage = {}
    
function RemoveSeats()
    local parts = Workspace:GetDescendants()
    for _, part in ipairs(parts) do
        if part:IsA("Seat") then
            table.insert(SeatStorage, part:Clone())
            part:Destroy()
        end
    end
end

local TCS = game:WaitForChild("TextChatService")
local ChatServiceType = nil
    
function FindChatServiceType()
    if TCS and TCS.ChatVersion then
        if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
            ChatServiceType = "TCS"
        else
            ChatServiceType = "LCS"
        end
    end
    return ChatServiceType
end

ChatServiceType = FindChatServiceType()

if ChatServiceType == "LCS" then
    local SayMessageReq = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
end

function SendAllServiceMSG(Message, Public)
    local ReportMessage = Message

    if ChatServiceType == "LCS" then
        if Public then
            local SayMessageRequest = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
            if SayMessageRequest then
                SayMessageRequest:FireServer(ReportMessage, "All")
            else
                warn("SayMessageRequest not found in ReplicatedStorage. Check if 'LCS' is enabled.")
            end
        end
    elseif ChatServiceType == "TCS" then
        local TextChannels = TCS:FindFirstChild("TextChannels")
        if TextChannels and TextChannels:FindFirstChild("RBXGeneral") then
            TextChannels.RBXGeneral:SendAsync(ReportMessage)
        else
            warn("TextChannels or RBXGeneral not found. Check if 'TCS' is set up correctly.")
        end
    else
        warn("ChatServiceType is not set correctly.")
    end
end


function dollhouse(str)
    if str then
        while str do
            if __.Settings.DollhouseLoops == __.Settings.DollhouseMaxLoops then
                local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/z7rab/nightmare.cc/main/Modules/ServerHopModule.lua"))()
                module:Teleport(game.PlaceId)
                queue_on_teleport(``)
            end

            for i,v in pairs(__.Settings.WhitelistedUsers) do
                if v == __.Settings.DollhouseUsername then
                    __.Settings.DollhouseUsername = gplr("random").Name
                end
            end

            __.Settings.DollhouseUsername = gplr("random").Name

            local randommsg = __.Settings.RandomMessages[math.random(1, #__.Settings.RandomMessages)]

            print("[➡️] ".. randommsg)

            bang(__.Settings.DollhouseUsername, 3)
            SendAllServiceMSG(randommsg, true)

            task.wait(5)

            __.Settings.DollhouseLoops = __.Settings.DollhouseLoops + 1
            unbang()

            task.wait(0.3)
        end
    elseif not str then
        game:Shutdown()
    else
        SendAllServiceMSG("[⚙️ Nightmare; System ]: Invalid argument given for Dollhouse Autofarm, please pick true or false!", true)
    end
end

dollhouse(true)
