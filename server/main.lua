ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('night_weed:checkmoney', function(source,cb, money) 
    local xPlayer = ESX.GetPlayerFromId(source)
    
	local have = xPlayer.getMoney()
	
	if money ~= nil then  
		if have >= money then
			
			cb(true)
		else
			
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('night_weed:checkitem', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local e = xPlayer.getInventoryItem("meth_base")

    if e.count >= 10 then
        cb(true)
        xPlayer.removeInventoryItem("meth_base", 10)
    else
        cb(false)
    end    
end)

ESX.RegisterServerCallback('night_weed:checkgrams', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local e = xPlayer.getInventoryItem("methbrick")

    if e.count >= 1 then
        cb(true)
        xPlayer.removeInventoryItem("methbrick", 1)
    else
        cb(false)
    end    
end)

RegisterServerEvent('night_weed:true')
AddEventHandler('night_weed:true', function(item,count,money)
    local user = source
    local xPlayer = ESX.GetPlayerFromId(user)

    if xPlayer then
        xPlayer.addInventoryItem(item, count)
        xPlayer.removeMoney(money)
    end
end) 