
----------------------------------------------
--                  Global                  --
----------------------------------------------
QBCore = exports['qb-core']:GetCoreObject()
isUseDrugs = false

--Globally used for all drugs as a way to reset the count.
RegisterNetEvent('consumables:client:narcan', function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"nosepick"})
    QBCore.Functions.Progressbar("drink_something", "Administering Narcan..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["narcan"], "remove")
        TriggerServerEvent("QBCore:Server:RemoveItem", "narcan", 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        fentanylCount = 0
    end)
end)

--Globally used for all drugs as the count. Each time you take a drug, you will get another added to the count. Once your players count hits 6 they will drop dead of a fentanyl overdose. 
RegisterNetEvent('consumables:client:fentanylCount', function(itemName)
    if fentanylCount <= 5 and not isUseDrugs then
        fentanylCount = fentanylCount + 1
        if fentanylCount > 1 and fentanylCount < 6 then
            TriggerEvent("evidence:client:SetStatus", "schedule1", 200)
        elseif fentanylCount >= 6 then
            TriggerEvent("evidence:client:SetStatus", "schedule1_overdose", 200)
            SetEntityHealth(PlayerPedId(), 0)
        end
    else
        print("no count added.")
    end
    --print(fentanylCount)
end)

--Drug effect here:
function drugEffectCocaine()
    Citizen.CreateThread(function()
      AnimpostfxPlay("DrugsMichaelAliensFightIn", 30000, false)
      Wait(30000)
      AnimpostfxPlay("DrugsMichaelAliensFight", 30000, false)
      Wait(30000)
      AnimpostfxPlay("DrugsMichaelAliensFightOut", 15000, false)
      Wait(15000)
      AnimpostfxStopAll()
    end)
end

function drugEffectMeth()
    Citizen.CreateThread(function()
      AnimpostfxPlay("DrugsTrevorClownsFightIn", 15000, false)
      Wait(15000)
      AnimpostfxPlay("DrugsMichaelAliensFight", 15000, false)
      Wait(15000)
      AnimpostfxPlay("DrugsTrevorClownsFightOut", 15000, false)
      Wait(15000)
      AnimpostfxStopAll()
    end)
end

function drugEffectHeroin()
    Citizen.CreateThread(function()
      AnimpostfxPlay("Rampage", 15000, false)
      Wait(15000)
      AnimpostfxPlay("SuccessNeutral", 15000, false)
      Wait(15000)
      AnimpostfxPlay("RampageOut", 15000, false)
      Wait(15000)
      AnimpostfxStopAll()
    end)
end

function drugEffectOxy()
    Citizen.CreateThread(function()
      AnimpostfxPlay("DrugsDrivingIn", 15000, false)
      Wait(15000)
      AnimpostfxPlay("RaceTurbo", 15000, false)
      Wait(15000)
      AnimpostfxPlay("DrugsDrivingOut", 15000, false)
      Wait(15000)
      AnimpostfxStopAll()
    end)
end

function drugEffectLsd()
    Citizen.CreateThread(function()
      AnimpostfxPlay("PeyoteIn", 15000, false)
      Wait(15000)
      AnimpostfxPlay("Dont_tazeme_bro", 15000, false)
      Wait(15000)
      AnimpostfxPlay("PeyoteOut", 15000, false)
      Wait(15000)
      AnimpostfxStopAll()
    end)
end

--Function used to passively reduce your fentanyl count.
CreateThread(function()
    while fentanylCount >= 1 do
        Wait(10)
        if fentanylCount > 0 then
            Wait(1000 * 60 * 15)
            fentanylCount = fentanylCount - 1
        else
            Wait(2000)
        end
    end
end)

RegisterNetEvent('consumables:client:useDrug', function(code, progressText, animationA, animationB)
    print(code, progressText, animationA, animationB)
    print(fentanylCount)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    if fentanylCount < 6 and not isUseDrugs then
        isUseDrugs = true
        QBCore.Functions.Progressbar("Donp-Drugs", progressText, useTime * 1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = animationA,
            anim = animationB,
            flags = 49,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, animationA, animationB, 1.0)
            TriggerServerEvent("QBCore:Server:RemoveItem", code, 1)
            if code == "coke_baggy" then
                SetPedArmour(ped, GetPedArmour(ped) + 20)
                if fentanylCount == 1 then
                    CokeBaggyEffectOne(code)
                elseif fentanylCount == 2 then
                    CokeBaggyEffectTwo()
                elseif fentanylCount == 3 then
                    CokeBaggyEffectThree()
                elseif fentanylCount == 4 then
                    CokeBaggyEffectFour()
                elseif fentanylCount == 5 then
                    CokeBaggyEffectFive()
                end
            elseif code == "meth" then
                if fentanylCount == 1 then
                    MethEffectOne()
                elseif fentanylCount == 2 then
                    MethEffectTwo()
                elseif fentanylCount == 3 then
                    MethEffectThree()
                elseif fentanylCount == 4 then
                    MethEffectFour()
                elseif fentanylCount == 5 then
                    MethEffectFive()
                end
            elseif code == "heroin" then
                if fentanylCount == 1 then
                    HeroinEffectOne()
                elseif fentanylCount == 2 then
                    HeroinEffectTwo()
                elseif fentanylCount == 3 then
                    HeroinEffectThree()
                elseif fentanylCount == 4 then
                    HeroinEffectFour()
                elseif fentanylCount == 5 then
                    HeroinEffectFive()
                end
            elseif code == "oxy" then
                if fentanylCount == 1 then
                    OxyEffectOne()
                elseif fentanylCount == 2 then
                    OxyEffectTwo()
                elseif fentanylCount == 3 then
                    OxyEffectThree()
                elseif fentanylCount == 4 then
                    OxyEffectFour()
                elseif fentanylCount == 5 then
                    OxyEffectFive()
                end
            elseif code == "lsd" then
                if fentanylCount < 6 then
                    LsdEffect()
                end
            elseif code == "pcp" then
                if fentanylCount < 6 then
                    LsdEffect()
                end
            elseif code == "shrooms" then
                if fentanylCount < 6 then
                    LsdEffect()
                end
            elseif code == "lean" then
                if fentanylCount < 6 then
                    LsdEffect()
                end
            end
        end, function() -- Cancel
                StopAnimTask(ped, animationA, animationB, 1.0)
            end)
        else
            print("**You cant take another drug, count is to high. / You must wait for the effect to complete before taking another bag**")
        end
end)

function CokeBaggyEffectOne()
    local startStamina = 75
    local ped = PlayerPedId()
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectCocaine()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function CokeBaggyEffectTwo()
    local startStamina = 75
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectCocaine()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
end

function CokeBaggyEffectThree()
    local startStamina = 75
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectCocaine()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
end

function CokeBaggyEffectFour()
    local startStamina = 75
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectCocaine()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
end

function CokeBaggyEffectFive()
    local startStamina = 75
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectCocaine()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
end

function MethEffectOne()
    local startStamina = 15
    local ped = PlayerPedId()
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectMeth()
    --Starts run speed multiplier
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 50 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 10 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
        end
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function MethEffectTwo()
    local startStamina = 15
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectMeth()
    --Starts run speed multiplier
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.39)
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 40 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 15 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
        end
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function MethEffectThree()
    local startStamina = 15
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectMeth()
    --Starts run speed multiplier
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.29)
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 30 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 20 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
        end
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function MethEffectFour()
    local startStamina = 15
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectMeth()
    --Starts run speed multiplier
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.19)
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 25 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
        end
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function MethEffectFive()
    local startStamina = 15
    local ped = PlayerPedId()
    --Starts screen effect
    drugEffectMeth()
    --Starts run speed multiplier
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.09)
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 25 and IsPedRunning(ped) then
            SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
        end
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function HeroinEffectOne()
    local startStamina = 10
    SetPlayerInvincible(PlayerId(), true)
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectHeroin()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
        print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
    SetPlayerInvincible(PlayerId(), false)
end

function HeroinEffectTwo()
    local startStamina = 8
    SetPlayerInvincible(PlayerId(), true)
    --Starts screen effect
    drugEffectHeroin()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetPlayerInvincible(PlayerId(), false)
end

function HeroinEffectThree()
    local startStamina = 6
    SetPlayerInvincible(PlayerId(), true)
    --Starts screen effect
    drugEffectHeroin()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetPlayerInvincible(PlayerId(), false)
end

function HeroinEffectFour()
    local startStamina = 4
    SetPlayerInvincible(PlayerId(), true)
    --Starts screen effect
    drugEffectHeroin()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetPlayerInvincible(PlayerId(), false)
end

function HeroinEffectFive()
    local startStamina = 2
    SetPlayerInvincible(PlayerId(), true)
    --Starts screen effect
    drugEffectHeroin()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
    end
    startStamina = 0
    isUseDrugs = false
    SetPlayerInvincible(PlayerId(), false)
end

function OxyEffectOne()
    local startStamina = 20
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectOxy()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        local health = GetEntityHealth(PlayerPedId())
        Wait(1000)
        SetEntityHealth(PlayerPedId(), health + 5)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function OxyEffectTwo()
    local startStamina = 20
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectOxy()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        local health = GetEntityHealth(PlayerPedId())
        Wait(1000)
        SetEntityHealth(PlayerPedId(), health + 4)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function OxyEffectThree()
    local startStamina = 20
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectOxy()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        local health = GetEntityHealth(PlayerPedId())
        Wait(1000)
        SetEntityHealth(PlayerPedId(), health + 3)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function OxyEffectFour()
    local startStamina = 20
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectOxy()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        local health = GetEntityHealth(PlayerPedId())
        Wait(1000)
        SetEntityHealth(PlayerPedId(), health + 2)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function OxyEffectFive()
    local startStamina = 20
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectOxy()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        local health = GetEntityHealth(PlayerPedId())
        Wait(1000)
        SetEntityHealth(PlayerPedId(), health + 1)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end

function LsdEffect()
    local startStamina = 20
    local ped = PlayerPedId()
    --Starts screen effect (for me tommorow. while startstamina is looping or the effect they wont go at the same time. gotta figure that out. )
    drugEffectLsd()
    --while loop which basically says while startStamina is more than 0 it will loop whats below(if empty table, used just as a time before triggering the server events.)
    while startStamina > 0 do
        Wait(1000)
        startStamina = startStamina - 1
        --print(startStamina)
    end
    startStamina = 0
    isUseDrugs = false
end