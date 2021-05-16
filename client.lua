ESX	= nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

_menuPool = NativeUI.CreatePool()

local PlayerData = {}

local isAtImpounder = false
local isNearImpounder = false
local isPedLoaded = false
local isAtParkLoc = false
local isNearParkLoc = false
local npc = nil
local currentImpounder 

local ImpoundMenu
local parkMenu

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerData.job = xPlayer.job
	PlayerLoaded = true
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Impounder) do
        local blip = AddBlipForCoord(v.loc.x, v.loc.y, v.loc.z)
        SetBlipSprite (blip, v.blipSprite)
        SetBlipScale  (blip, 1.1)
        SetBlipDisplay(blip, 4)
        SetBlipColour (blip, v.blipColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
    


    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, true)

        isAtImpounder = false
        isNearImpounder = false
        isAtParkLoc = false
        isNearParkLoc = false

        for k, v in pairs(Config.Impounder) do
            
            local distance = Vdist(playerCoords, v.loc.x, v.loc.y, v.loc.z)
            
            if distance < 1.75 then
                isAtImpounder = true
                isNearImpounder = true
                currentImpounder = v
            elseif distance < 25.0 then
                isNearImpounder = true

                if not isPedLoaded then
                    local ped = v.pedModel
					RequestModel(GetHashKey(ped))
					while not HasModelLoaded(GetHashKey(ped)) do
						Wait(1)
					end
					npc = CreatePed(4, GetHashKey(ped), v.loc.x, v.loc.y, v.loc.z - 1.0, v.loc.rot, false, true)
					FreezeEntityPosition(npc, true)	
					SetEntityHeading(npc, v.loc.rot)
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)                    
					isPedLoaded = true
					
				end

            end
        end

        if (isPedLoaded and not isNearImpounder) then
            DeleteEntity(npc)
			SetModelAsNoLongerNeeded(GetHashKey(ped))
			isPedLoaded = false
		end

        Citizen.Wait(300)
    end
end)



Citizen.CreateThread(function()

    while true do

        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        end

        if isAtImpounder then
            showInfobar(Translation[Config.Locale]['interact_impound'])
            if IsControlJustReleased(0, 38) then
                openImpoundMenu()
            end
        end

        if isNearParkLoc then
            DrawMarker(27, currentImpounder.park.x, currentImpounder.park.y, currentImpounder.park.z - 0.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9*0.9, 0.9*0.9, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
        end

        Citizen.Wait(1)
    end
end)

function openImpoundMenu()
    if ImpoundMenu ~= nil and ImpoundMenu:Visible() then
        ImpoundMenu:Visible(false)
    end

    ImpoundMenu = NativeUI.CreateMenu(Translation[Config.Locale]['impound'], nil)
    _menuPool:Add(ImpoundMenu)

    local myImpoundedVehicles_sub = _menuPool:AddSubMenu(ImpoundMenu, Translation[Config.Locale]['my_impounded_vehicles'], '~b~')
    ESX.TriggerServerCallback('myImpound:retrieveOwnedImpoundedVehicles', function(impoundVehicles)
        if impoundVehicles ~= nil and #impoundVehicles > 0 then
            for k, v in pairs(impoundVehicles) do
                local vehicleSubmenu = _menuPool:AddSubMenu(myImpoundedVehicles_sub, GetLabelText(GetDisplayNameFromVehicleModel(tonumber(v.vehicleModel))), Translation[Config.Locale]['desc_impound_by'] .. v.officerCharname)
                myImpoundedVehicles_sub.Items[k]:RightLabel(v.vehiclePlate)

                local vehicleModel = NativeUI.CreateItem(Translation[Config.Locale]['vehicle_model'], '~b~')
                vehicleModel:RightLabel('~s~' .. GetLabelText(GetDisplayNameFromVehicleModel(tonumber(v.vehicleModel))))
                vehicleSubmenu:AddItem(vehicleModel)

                local vehiclePlate = NativeUI.CreateItem(Translation[Config.Locale]['plate'], '~b~')
                vehiclePlate:RightLabel('~s~' .. v.vehiclePlate)
                vehicleSubmenu:AddItem(vehiclePlate)

                local impoundedAt = NativeUI.CreateItem(Translation[Config.Locale]['impound_at'], '~b~')
                if v.timeStamp ~= nil then
                    impoundedAt:RightLabel('~o~' .. v.timeStamp)
                else
                    impoundedAt:RightLabel('~r~-')
                end
                vehicleSubmenu:AddItem(impoundedAt)

                local spacerItem = NativeUI.CreateItem('~b~', '~b~')
                vehicleSubmenu:AddItem(spacerItem)

                local impoundBy = NativeUI.CreateItem(Translation[Config.Locale]['impound_by'], '~b~')
                impoundBy:RightLabel('~b~' .. v.officerCharname)
                vehicleSubmenu:AddItem(impoundBy)

                local cautionAllowed = NativeUI.CreateItem(Translation[Config.Locale]['caution_allowed'], '~b~')
                vehicleSubmenu:AddItem(cautionAllowed)

                if v.cautionAllowed == 1 then
                    cautionAllowed:RightLabel(Translation[Config.Locale]['yes'])

                    local cautionAmount = NativeUI.CreateItem(Translation[Config.Locale]['caution'], '~b~')
                    cautionAmount:RightLabel('~r~' .. v.caution .. '$')
                    vehicleSubmenu:AddItem(cautionAmount)

                    local spacerItem2 = NativeUI.CreateItem('~b~', '~b~')
                    vehicleSubmenu:AddItem(spacerItem2)

                    local releaseVehicle = NativeUI.CreateItem(Translation[Config.Locale]['pay_caution'], '~b~')
                    releaseVehicle:RightLabel('~b~→→→')
                    vehicleSubmenu:AddItem(releaseVehicle)

                    releaseVehicle.Activated = function(sender, index)
                        -- pay the bill
                        ESX.TriggerServerCallback('myImpound:checkCanPayCaution', function(hasEnoughMoney)
                            if hasEnoughMoney then
                                _menuPool:CloseAllMenus()
                                TriggerServerEvent('myImpound:releaseVehicle', v.owner, v.vehiclePlate, v.vehicleProps, v.vehicleType, v.vehicleJob)
                                SpawnVehicle(v.vehicleModel, currentImpounder.spawn, currentImpounder.spawn.rot, v.vehicleProps)
                                showPictureNotification('CHAR_PROPERTY_TOWING_IMPOUND', Translation[Config.Locale]['caution_paid'] .. v.vehiclePlate .. Translation[Config.Locale]['caution_paid2'] .. v.caution .. Translation[Config.Locale]['caution_paid3'], Translation[Config.Locale]['impound'], '')
                            else
                                ShowNotification(Translation[Config.Locale]['not_enough_money'])
                            end
                        end, v.caution)
                    end

                else
                    cautionAllowed:RightLabel(Translation[Config.Locale]['no'])
                end


                _menuPool:MouseEdgeEnabled(false)
            end
        end
    end, currentImpounder.name)

    -- POLICE OR JOB ONLY 
    if PlayerData ~= nil and PlayerData.job ~= nil and (PlayerData.job.name == Config.Jobname or PlayerData.job.name == Config.Jobname2 or PlayerData.job.name == Config.Jobname3) then

        local impoundVehicle_sub = _menuPool:AddSubMenu(ImpoundMenu, Translation[Config.Locale]['impound_vehicle'], '')
        local vehiclesInArea = ESX.Game.GetVehiclesInArea(currentImpounder.park, 6.0)

        for k, v in pairs(vehiclesInArea) do
            local vehInArea_sub = _menuPool:AddSubMenu(impoundVehicle_sub, GetDisplayNameFromVehicleModel(GetEntityModel(v)))
            impoundVehicle_sub.Items[k]:RightLabel(GetVehicleNumberPlateText(v))

            local cautionAllowed = false

            local cautionAllowedCheckbox = NativeUI.CreateCheckboxItem(Translation[Config.Locale]['check_caution_allowed'], cautionAllowed, '~b~')
            vehInArea_sub:AddItem(cautionAllowedCheckbox)

            vehInArea_sub.OnCheckboxChange = function(sender, item, checked_)
                if item == cautionAllowedCheckbox then
                    cautionAllowed = checked_
                    print('Caution allowed: ' .. tostring(cautionAllowed))
                end
            end

            local currentCaution = 0

            local setCaution = NativeUI.CreateItem(Translation[Config.Locale]['set_caution'], '~b~')
            setCaution:RightLabel('~b~→→→')
            vehInArea_sub:AddItem(setCaution)

            setCaution.Activated = function(sender, index)
                local caution_res = CreateDialog(Translation[Config.Locale]['set_caution'])
                if caution_res ~= nil and tonumber(caution_res) then
                    currentCaution = tonumber(caution_res)
                    setCaution:RightLabel('~r~' .. currentCaution .. '$')
                end
            end

            local spacerItem = NativeUI.CreateItem('~b~', '~b~')
            vehInArea_sub:AddItem(spacerItem)

            local veh_impound = NativeUI.CreateItem(Translation[Config.Locale]['impound_vehicle_final'], '~b~')
            veh_impound:SetRightBadge(BadgeStyle.Alert)
            vehInArea_sub:AddItem(veh_impound)

            veh_impound.Activated = function(sender, index)
                ESX.TriggerServerCallback('myImpound:impoundVehicle', function(hasAnOwner)
                    if not hasAnOwner then
                        ShowNotification(Translation[Config.Locale]['vehicle_has_no_owner'])
                    else
                        ESX.Game.DeleteVehicle(v)
                    end
                end, currentImpounder.name, GetVehicleNumberPlateText(v), GetEntityModel(v), cautionAllowed, currentCaution)
            end

        end

        local impoundedVehicles_sub = _menuPool:AddSubMenu(ImpoundMenu, Translation[Config.Locale]['impounded_vehicles'], nil)

        ESX.TriggerServerCallback('myImpound:retrieveImpoundVehicles', function(impoundVehicles)
            if impoundVehicles ~= nil and #impoundVehicles > 0 then
                for k, v in pairs(impoundVehicles) do
                    local vehicleSubmenu = _menuPool:AddSubMenu(impoundedVehicles_sub, Translation[Config.Locale]['vehicle_of'] .. v.ownerCharname, Translation[Config.Locale]['impounded_by'] .. v.officerCharname)
                    impoundedVehicles_sub.Items[k]:RightLabel(v.vehiclePlate)

                    local vehicleModel = NativeUI.CreateItem(Translation[Config.Locale]['vehicle_model'], '~b~')
                    vehicleModel:RightLabel('~s~' .. GetLabelText(GetDisplayNameFromVehicleModel(tonumber(v.vehicleModel))))
                    vehicleSubmenu:AddItem(vehicleModel)
    
                    local vehiclePlate = NativeUI.CreateItem(Translation[Config.Locale]['plate'], '~b~')
                    vehiclePlate:RightLabel('~s~' .. v.vehiclePlate)
                    vehicleSubmenu:AddItem(vehiclePlate)
    
                    local impoundedAt = NativeUI.CreateItem(Translation[Config.Locale]['impound_at'], '~b~')
                    if v.timeStamp ~= nil then
                        impoundedAt:RightLabel('~o~' .. v.timeStamp)
                    else
                        impoundedAt:RightLabel('~r~-')
                    end
                    vehicleSubmenu:AddItem(impoundedAt)
    
                    local spacerItem = NativeUI.CreateItem('~b~', '~b~')
                    vehicleSubmenu:AddItem(spacerItem)
    
                    local impoundBy = NativeUI.CreateItem(Translation[Config.Locale]['impound_by'], '~b~')
                    impoundBy:RightLabel('~b~' .. v.officerCharname)
                    vehicleSubmenu:AddItem(impoundBy)
    
                    local cautionAllowed = NativeUI.CreateItem(Translation[Config.Locale]['caution_allowed'], '~b~')
                    vehicleSubmenu:AddItem(cautionAllowed)

                    --print('curr caution allowed: ' ..  v.cautionAllowed)
                    local cautionAllowedCheckbox = NativeUI.CreateCheckboxItem(Translation[Config.Locale]['check_caution_allowed'], v.cautionAllowed, '~b~')
                    vehicleSubmenu:AddItem(cautionAllowedCheckbox)

                    vehicleSubmenu.OnCheckboxChange = function(sender, item, checked_)
                        if item == cautionAllowedCheckbox then
                            v.cautionAllowed = checked_
                            TriggerServerEvent('myImpound:changeCautionAllowed', v.owner, v.vehiclePlate, v.cautionAllowed)
                            if v.cautionAllowed then
                                ShowNotification(Translation[Config.Locale]['caution_changed_true'])
                            else
                                ShowNotification(Translation[Config.Locale]['caution_changed_false'])
                            end
                            --print('Caution change to: ' .. tostring(v.cautionAllowed))
                        end
                    end

                    if v.cautionAllowed == 1 then
                        cautionAllowed:RightLabel(Translation[Config.Locale]['yes'])

                        local cautionAmount = NativeUI.CreateItem(Translation[Config.Locale]['caution'], '~b~')
                        cautionAmount:RightLabel('~r~' .. v.caution .. '$')
                        vehicleSubmenu:AddItem(cautionAmount)

                        cautionAmount.Activated = function(sender, index)
                            local caution_res = CreateDialog(Translation[Config.Locale]['set_caution'])
                            if caution_res ~= nil and tonumber(caution_res) then
                                v.caution = tonumber(caution_res)
                                cautionAmount:RightLabel('~r~' .. v.caution .. '$')
                                TriggerServerEvent('myImpound:changeCaution', v.owner, v.vehiclePlate, v.caution)
                            end
                        end

                    else
                        cautionAllowed:RightLabel(Translation[Config.Locale]['no'])
                    end

                    local spacerItem2 = NativeUI.CreateItem('~b~', '~b~')
                    vehicleSubmenu:AddItem(spacerItem2)

                    local releaseVehicle = NativeUI.CreateItem(Translation[Config.Locale]['release_vehicle'], '~b~')
                    releaseVehicle:RightLabel('~b~→→→')
                    vehicleSubmenu:AddItem(releaseVehicle)

                    releaseVehicle.Activated = function(sender, index)
                        _menuPool:CloseAllMenus()
                        TriggerServerEvent('myImpound:releaseVehicle', v.owner, v.vehiclePlate, v.vehicleProps, v.vehicleType, v.vehicleJob)
                        SpawnVehicle(v.vehicleModel, currentImpounder.spawn, currentImpounder.spawn.rot, v.vehicleProps)
                        showPictureNotification('CHAR_PROPERTY_TOWING_IMPOUND', Translation[Config.Locale]['released_vehicle'] .. v.vehiclePlate .. Translation[Config.Locale]['released_vehicle2'], Translation[Config.Locale]['impound'], '')
                    
                    end


                    _menuPool:MouseEdgeEnabled(false)
                end
            end
        end, currentImpounder.name)
    end

    ImpoundMenu:Visible(true)
    _menuPool:MouseEdgeEnabled(false)

    
end



function SpawnVehicle(modelHash, pos, rot, vehProps)
    local model = GetDisplayNameFromVehicleModel(tonumber(modelHash))

    local newVehProps = {}
    ESX.TriggerServerCallback('myImpound:decodeProps', function(vehProps_res)

        newVehProps = vehProps_res

        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end

        ESX.Game.SpawnVehicle(model, pos, rot, function(vehicle)
            print(newVehProps.plate)
            ESX.Game.SetVehicleProperties(vehicle, newVehProps)
            SetVehRadioStation(vehicle, "OFF")
            --SetPedIntoVehicle(GetPlayerPed(-1), vehicle, - 1)
            return vehicle
        end)

    end, vehProps)
    
end

function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
	AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

RegisterNetEvent('myImpound:picturemsg')
AddEventHandler('myImpound:picturemsg', function(icon, msg, title, subtitle)
	showPictureNotification(icon, msg, title, subtitle)
end)