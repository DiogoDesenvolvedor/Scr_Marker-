
local todosMarkers = {}
local markerDestroy = {}
local markerAtivado = {}

function createMarkerDioguin(markerType, position, tipo, Message, trigger, button, cor, tamanho, img)


	if not getMarkerExist(markerType) then 
		if type(position) == "table" then
			position = Vector3(position)
		end
	
		if type(markerType) ~= "string" or not position then
			return false
		end
		if type(direction) ~= "number" then
			direction = 0
		end
	    restricted = "player"
		local marker = Marker(position,"cylinder", tamanho -0.5,0,0,0,0, Message, trigger, button)
		markerDestroy[markerType] = {marker, }
		todosMarkers[marker] = {markerType, Message, trigger, button, cor, tamanho, img, tipo}
		marker:setData("tipo-->Marker",{markerType, Message, trigger, button, cor, tamanho, img})


		addMarkerToDraw(marker)
		setTimer(function ()
			reloadMarkers ()
		end, 300, 1)

		return marker
	end


end
addEvent("Dioguin-->CreateMarker",  true)
addEventHandler("Dioguin-->CreateMarker", getRootElement(), createMarkerDioguin)

getMarkerExist = function (name)
	for i, v in pairs(todosMarkers) do
		if v[1] == name then 
			return true
		end
	end
	return false
end
addEvent("Dioguin-->destruirMarker", true)
addEventHandler("Dioguin-->destruirMarker", getRootElement(), function(markerDes)
	if markerDestroy[markerDes] then
		for i, v in ipairs(markerDestroy[markerDes]) do 
			if isElement(v) then
				local userMarker = getMarkerFromName(markerDes)
				if userMarker then
					remove_marker (userMarker)

					todosMarkers[userMarker] = nil
				end
				destroyElement(v)
			end
		end
	end
end)

getMarkerFromName = function (name)
	for i, v in pairs(todosMarkers) do
		if v[1] == name then 
			return i
		end
	end
	return false
end

function bindKeyMarker (_, _,  i, v)
	if isElement(i) then
		if isElementWithinMarker(localPlayer, i) then
			if v[8] == 'server' then 
				triggerServerEvent(v[3], localPlayer, localPlayer)
			else
				triggerEvent(v[3], localPlayer, localPlayer)
			end
		end
	end
end

function reloadMarkers ()
	for i, v in pairs(todosMarkers) do
		if not markerAtivado[i] then
			markerAtivado[i] = true
			bindKey(v[4], 'up', bindKeyMarker, i, v)
		end
	end
end


