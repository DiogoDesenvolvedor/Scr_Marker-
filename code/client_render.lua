
local sx,sy = guiGetScreenSize()
local zoom = sx < 1024 and math.min(3,1024/sx) or 1

function s(n,f)
	if not f then
		return math.floor(tonumber(n)/zoom)
	else
		return tonumber(n)/zoom
	end
end

local texturas =  {}

local markersToDraw = {}
local txt = dxCreateTexture("files/floor.png", 'argb', true, 'clamp')

function createShadow(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 30), scale, font, alignX, alignY)
	dxDrawText(text, x1 + 2, y1 + 2, x2 + 2, y2 + 2, tocolor(0, 0, 0, 30), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 30), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

function drawText(text)
	createShadow(text,0,0,sx,sy-s(20),white,1,"default-bold","center","bottom")	
end

function drawMarker(marker)
	local markerType = marker:getData("tipo-->Marker")
	if markerType then  	
		local t = getTickCount()	
		local color = {
			markerType[5][1], 
			markerType[5][2], 
			markerType[5][3], 
			200 + math.sin(t * 0.002 / 3) * 35
		}	
		if (localPlayer:isWithinMarker(marker) or (localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(marker))) then
				color = {
					190 + math.sin(t * 0.002) * 23, 
					200 + math.sin(t * 0.002) * 20,
					216 + math.sin(t * 0.002) * 30,
					255
				}
			if not markerText then
				markerText = markerType[2]
			end
			drawText(markerText)
		end		
		local x, y, z = getElementPosition(marker)
		if markerType[7] then
			local markerIconSize = 1.4
			local animationSize = 0.1
			if markerType[6] then
				markerIconSize = markerType[6]
				animationSize = markerIconSize / 1.4 * 0.1
			end
			local iconSize = markerIconSize - math.sin(t * 0.002) * animationSize			
			local ox = math.cos(0) * iconSize / 2
			local oy =  math.sin(0) * iconSize / 2
			dxDrawMaterialLine3D(
				x + ox,
				y + oy,
				z,
				x - ox,
				y - oy,
				z,
				txt,
				iconSize,
				tocolor(0, 189, 174, color[4]),
				x,
				y,
				z + 1
			)
		end	
		if not markerType[2] then
			return
		end	
		if not texturas[marker] then 
			texturas[marker] = dxCreateTexture(markerType[7],"dxt5")
		end	
		dxDrawMaterialLine3D(
			x, 
			y,
			z + 0.8 / 2 + 1.2 + math.sin(t * 0.002) * 0.1,
			x,
			y,
			z - 0.8 / 2 + 1.2 + math.sin(t * 0.002) * 0.1,
			texturas[marker],
			0.8,
			white
		)
	end
end	

function addMarkerToDraw(marker)
	markersToDraw[marker] = true
end

function remove_marker (user)
	if markersToDraw[user] then 
		markersToDraw[user] = nil
	end
end


addEventHandler("onClientRender",root,function()
	for v in pairs(markersToDraw) do
		drawMarker(v)
	end
end)