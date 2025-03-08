local HighestLevelZones = {
    ["First Sea"] = {level = 700, quest = "Boss Quest", mob = "Boss", npc = "Boss Quest Giver", mobPos = Vector3.new(500, 50, 900)},
    ["Second Sea"] = {level = 1500, quest = "Ghost Ship Quest", mob = "Ghost Ship", npc = "Ghost Ship Quest Giver", mobPos = Vector3.new(1200, 100, 1800)},
    ["Third Sea"] = {level = 2600, quest = "Elite Pirate Quest", mob = "Elite Pirate", npc = "Elite Pirate Quest Giver", mobPos = Vector3.new(2200, 150, 2800)}
}

local function GetCurrentSea()
    local player = game.Players.LocalPlayer
    local level = player.Data.Level.Value
    if level < 700 then return "First Sea"
    elseif level < 1500 then return "Second Sea"
    else return "Third Sea" end
end

local function GetBestFarmingSpot()
    local player = game.Players.LocalPlayer
    local level = player.Data.Level.Value
    local currentSea = GetCurrentSea()

    if level >= 2600 or level >= HighestLevelZones[currentSea].level then
        return HighestLevelZones[currentSea]
    else
        for _, q in ipairs(QuestList) do
            if level >= q.level then return q end
        end
    end
    return nil
end

local function FlyInCircleUntilEnemySpawns(centerPosition, radius)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        while isAutoFarmActive do
            local hasEnemies = false
            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") and enemy.Name == currentQuest.mob then
                    hasEnemies = true
                    break
                end
            end
            if hasEnemies then break end

            local angle = (tick() * 2) % (2 * math.pi)
            local x = centerPosition.X + radius * math.cos(angle)
            local z = centerPosition.Z + radius * math.sin(angle)
            humanoidRootPart.CFrame = CFrame.new(Vector3.new(x, centerPosition.Y + 15, z))
            task.wait(0.1)
        end
    end
end

local function AutoFarm()
    while isAutoFarmActive do
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local currentQuest = GetBestFarmingSpot()
            
            if currentQuest then
                if not player.PlayerGui.Main.QuestFrame.Visible then GetQuest(currentQuest.npc) end
                FlyToPosition(currentQuest.mobPos)

                while isAutoFarmActive and player.PlayerGui.Main.QuestFrame.Visible do
                    GatherEnemies(currentQuest.mob)
                    IncreaseHitbox()
                    FlyToPosition(currentQuest.mobPos + Vector3.new(0, 15, 0))

                    local hasEnemies = false
                    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                        if enemy:IsA("Model") and enemy.Name == currentQuest.mob then
                            hasEnemies = true
                            repeat
                                character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                                game.ReplicatedStorage.Remotes.MeleeAttack:FireServer(enemy)
                                task.wait(0.5)
                            until not isAutoFarmActive or not enemy.Parent
                        end
                    end

                    if not hasEnemies then FlyInCircleUntilEnemySpawns(currentQuest.mobPos, 10) end
                end
            end
        end
        task.wait(1)
    end
end