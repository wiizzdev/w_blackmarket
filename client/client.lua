    -- G_Corporation -- wiizz -- 
  -- https://github.com/wiizzdev --
 -- https://discord.gg/VpYP58ZjmD --

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5000)
    end
end)

local mainMenu = RageUI.CreateMenu("", "Black Market")
local open = false

mainMenu.Closed = function() open = false end 

function Blackmarket()
    if not open then open = true RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu, function()
                    for k,v in pairs(Config.Blackmarket.List) do
                        RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                            onSelected = function()
                                name = v.name
                                price = v.price
                                item = v.item
                                TriggerServerEvent('w_blackmarket:achatitem', name, price, item)
                            end
                        })
                    end
                    RageUI.Separator("discord.gg/VpYP58ZjmD")
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k,v in pairs(Config.Blackmarket.Ped.Pos) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if dist <= 1.5 then
                wait = 1
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour ouvrir le ~r~Blackmarket")
                if IsControlJustPressed(1,51) then Blackmarket() end
            end 
        end
    Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Blackmarket.Ped.Pos) do
        local hash = GetHashKey(Config.Blackmarket.Ped.Type)
        while not HasModelLoaded(hash) do RequestModel(hash) Wait(20) end
        local ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Blackmarket.Ped.Type, v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end)