
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
            "this dollhouse update is gas ngl | join for whitelist g/u6FqTxRYE9 | yD4gB1",
            "can't believe the devs thought this was secure | join for whitelist g/u6FqTxRYE9 | jQ8hK3",
            "dollhouse keeps getting better while they sleep | join for whitelist g/u6FqTxRYE9 | tZ2mL6",
            "another day another patch we just bypassed | join for whitelist g/u6FqTxRYE9 | xR5dT7",
            "dollhouse vibes are unmatched right now | join for whitelist g/u6FqTxRYE9 | sH3pN9",
            "if they really think we are done they are wrong | join for whitelist g/u6FqTxRYE9 | nV8jP2",
            "the devs need to step it up for real | join for whitelist g/u6FqTxRYE9 | kB4wM1",
            "another patch just means more fun for us | join for whitelist g/u6FqTxRYE9 | vF9zQ5",
            "everyone is talking but we are still winning | join for whitelist g/u6FqTxRYE9 | mJ1hG8",
            "dollhouse is the place to be right now | join for whitelist g/u6FqTxRYE9 | fT6nX3",
            "every update just makes it easier for us | join for whitelist g/u6FqTxRYE9 | zE7kY2",
            "the hype around dollhouse is unreal | join for whitelist g/u6FqTxRYE9 | gL5jF4",
            "still going strong while others are stuck | join for whitelist g/u6FqTxRYE9 | hP3mJ8",
            "i love how we keep proving them wrong | join for whitelist g/u6FqTxRYE9 | bK2qV7",
            "dollhouse is basically our playground now | join for whitelist g/u6FqTxRYE9 | eN8hT1",
            "the devs are always one step behind us | join for whitelist g/u6FqTxRYE9 | wS6fY5",
            "waiting for the next update to flex even harder | join for whitelist g/u6FqTxRYE9 | aR9mG2",
            "they think they can catch us but they can't | join for whitelist g/u6FqTxRYE9 | jH5dN8",
            "just vibing while they try to keep up | join for whitelist g/u6FqTxRYE9 | cX4pL1",
            "dollhouse is thriving while the rest are struggling | join for whitelist g/u6FqTxRYE9 | pF8tJ3"
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
                queue_on_teleport(`https://raw.githubusercontent.com/7rabz/nodejs/refs/heads/main/dollhouse.lua`)
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

            task.wait(7)

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
