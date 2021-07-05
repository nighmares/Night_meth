ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(100)
		for k,v in pairs (Config.main) do
			local id = GetEntityCoords(PlayerPedId())
			local distancia = #(id - v.coords)
			
			if distancia < Config.Distancia and distancecheck == false then
				spawn(v.modelo, v.coords, v.heading, v.gender, v.animDict, v.animName)
				distancecheck = true
			end
			if distancia >= Config.Distancia and distancia <= Config.Distancia + 1 then
				
				distancecheck = false
				DeletePed(ped)
			end
		end
	end
	
	
end)

function spawn(modelo, coords, heading, gender, animDict, animName)
	
	RequestModel(GetHashKey(modelo))
	while not HasModelLoaded(GetHashKey(modelo)) do
		Citizen.Wait(1)
	end
	
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	end	

	
	local x, y, z = table.unpack(coords)
	ped = CreatePed(genderNum, GetHashKey(modelo), x, y, z - 1, heading, false, true)
		
	
	
	SetEntityAlpha(ped, 255, false)
	FreezeEntityPosition(ped, true) 
	SetEntityInvincible(ped, true) 
	SetBlockingOfNonTemporaryEvents(ped, true) 
	
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	
	
end

function loadAnimDict2( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function animationgive()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict2("mp_safehouselost@") 
    TaskPlayAnim(PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

RegisterNetEvent('Night:buy')
AddEventHandler('Night:buy', function()
	local ped = PlayerPedId()

	ESX.TriggerServerCallback('night_weed:checkmoney', function(money)
		if money then
			animationgive()
			Citizen.Wait(3000)
			ClearPedTasks(ped)
			TriggerServerEvent('night_weed:true','meth_base',5,100)
			notify('Get your shit and get out of here!!')
		else
			notify('you dont have any money scammer!')
		end	



	end, Config.methprice)	

    
end)

RegisterNetEvent('Night:makebrick')
AddEventHandler('Night:makebrick', function()
	local ped = PlayerPedId()

	ESX.TriggerServerCallback('night_weed:checkitem', function(cb)
		if cb then
			TriggerEvent("mythic_progbar:client:progress", {
                
                name = "unique_action_name",
                duration = 10000,
                label = 'creating brick',
                useWhileDead = true,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
				animation = {
					animDict = "mp_fbi_heist",
					anim = "loop",
				},
            },
			function(b)
				if not b then
					ClearPedTasks(a)
					notify('brick created!')
			        Citizen.Wait(1000)
			        TriggerServerEvent('night_weed:true','methbrick',1,0)
				else
					ClearPedTasks(a)
				end
			end)
                 
        
	    else
		   notify('You dont have anoug meth!')
	    end	

	end)

end)

RegisterNetEvent('Night:makegrams')
AddEventHandler('Night:makegrams', function()
	local ped = PlayerPedId()

	ESX.TriggerServerCallback('night_weed:checkgrams', function(cb)
		if cb then
			TriggerEvent("mythic_progbar:client:progress", {
                
                name = "unique_action_name",
                duration = 10000,
                label = 'Breaking brick into grams...',
                useWhileDead = true,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                },
				animation = {
					animDict = "mini@repair",
					anim = "fixing_a_player",
				},
            },
			function(b)
				if not b then
					ClearPedTasks(a)
			        Citizen.Wait(1000)
			        TriggerServerEvent('night_weed:true','meth',10,0)
					notify('meth grams created!')
				else
					ClearPedTasks(a)
				end
			end)
                 
        
	    else
		   notify('you dont have any methbrick!')
	    end	

	end)

end)


Citizen.CreateThread(function()
    local meth = {
		`a_m_m_hillbilly_02`
    }

    exports['bt-target']:AddTargetModel(meth, {
        options = {
            {
                event = 'Night:buy',
                icon = 'fas fa-prescription-bottle',
                label = "buy meth base"
            },
        },
        job = {'all'},
        distance = 1.5
    })

	local meth = {
		`v_ret_ml_tablea`
    }

    exports['bt-target']:AddTargetModel(meth, {
        options = {
            {
                event = 'Night:makebrick',
                icon = 'fas fa-prescription-bottle',
                label = "make meth"
            },
        },
        job = {'all'},
        distance = 1.5
    })

	local meth2 = {
		`v_med_trolley`
    }

    exports['bt-target']:AddTargetModel(meth2, {
        options = {
            {
                event = 'Night:makegrams',
                icon = 'fas fa-prescription-bottle',
                label = "Turn into grams"
            },
        },
        job = {'all'},
        distance = 1.5
    })



end)

function notify(mensaje)

    if Config.notitype == 'esx' then
        ESX.ShowNotification(mensaje)
    elseif Config.notitype == 'mythic' then
        exports['mythic_notify']:SendAlert('success', mensaje, 10000)
    end

end  