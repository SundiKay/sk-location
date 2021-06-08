ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)


Config              = {}
Config.DrawDistance = 100
Config.Size         = {x = 5.0, y = 5.0, z = 1.0}
Config.Color        = {r = 255, g = 255, b = 255}
Config.Type         = -1

local position = {
        {x = -1034.78,   y = -2732.76,  z = 20.17},        
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < Config.DrawDistance) then
                DrawMarker(Config.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

RMenu.Add('location', 'main', RageUI.CreateMenu("~b~Location de véhicule", "~o~Séléctionne un véhicule"))


Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('location', 'main'), true, true, true, function()

            RageUI.Button("~y~Panto", nil, {RightLabel = "~g~350$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('sundikay:vehicule', 650)
                spawnCar("panto")
                RageUI.CloseAll()
            end
            end)

                       RageUI.Button("~r~Faggio Sport", nil, {RightLabel = "~g~200$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('sundikay:vehicule', 75)
                spawnCar("faggio3")
                RageUI.CloseAll()
            end
            end)


        end, function()
        end)

        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la location de véhicule.")
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(RMenu:Get('location', 'main'), not RageUI.Visible(RMenu:Get('location', 'main')))
                    end   
                end
            end
        end
    end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -1033.58, -2729.02, 20.1, 241.51, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LOCATION"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

------------------------------------------------------------------------------ PED ----------------------------------------------------------------

DecorRegister("Caui", 4)
pedHash = "a_m_m_skidrow_01"
zone = vector3(-1034.49, -2732.1, 19.17)
Heading = 145.64
Ped = nil
HeadingSpawn = 145.64

Citizen.CreateThread(function()
    LoadModel(pedHash)
    Ped = CreatePed(2, GetHashKey(pedHash), zone, Heading, 0, 0)
    DecorSetInt(Ped, "Caui", 5431)
    FreezeEntityPosition(Ped, 1)
    TaskStartScenarioInPlace(Ped, "a_m_m_skidrow_01", 0, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
---------------------------------------------------------------------------------- Blip --------------------------------------------------------------
    local blip = AddBlipForCoord(zone)
    SetBlipSprite(blip, 464)
    SetBlipScale(blip, 0.7)
    SetBlipShrink(blip, true)
    SetBlipColour(blip, 11)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location")
    EndTextCommandSetBlipName(blip)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end
