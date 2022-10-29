local AllowedToFire = true
local delayTime = 15000 -- delay time for taraghe in ms = 15 seconds

function firework(command, type)
	local type = tonumber(type)
	if type and type >= 1 and type <= 4 and AllowedToFire then
		outputChatBox("شما ترقه نوع ".. type .. "را انتخاب کردید ", 50, 200, 100)
		if type == 1 then
			createBox(type,33)
			triggerServerEvent("showFireworkGlobal", localPlayer, type, {33})
		elseif type == 2 then
			createBox(type,25,935)
			triggerServerEvent("showFireworkGlobal", localPlayer, type, {25, 935})
		elseif type == 3 then
			outputChatBox("این نوع در حال حاضر در حال انجام است ، لطفاً در صورت بروز هرگونه مشکل ، منبع را مجدداً راه اندازی کنید",200,0,0)
			createBox(type,1,3014,1,-0.2)
			triggerServerEvent("showFireworkGlobal", localPlayer, type,{1,3014,1,-0.2})
		elseif type == 4 then
			createBox(type,100,3013,1,0.1,0)
			triggerServerEvent("showFireworkGlobal", localPlayer, type,{100,3013,1,0.1,0})
		end
		AllowedToFire = false
		setTimer(function () AllowedToFire = true end, delayTime, 1)
	elseif not AllowedToFire then
		outputChatBox("لطفاً صبر کنید",200,0,0,true)
	else
		outputChatBox("ERROR: Syntax is /firework [1-4] e.g.: /firework 1",200,0,0)
	end
end
addCommandHandler("firework",firework,false,false)

function fireClientFirework (type, args)
	createBox(type, args[1],args[2],args[3],args[4],args[5],args[6])
end
addEvent("FireClientFirework", true)
addEventHandler("FireClientFirework", localPlayer, fireClientFirework)

-- Credits to denny199 from the MTA forums for this little function
function getPositionInfrontOfElement ( element , meters )
    if not element or not isElement ( element ) then
        return false
    end
    if not meters then
        meters = 0.7
    end
    local posX , posY , posZ = getElementPosition ( element )
    local _ , _ , rotation = getElementRotation ( element )
    posX = posX - math.sin ( math.rad ( rotation ) ) * meters
    posY = posY + math.cos ( math.rad ( rotation ) ) * meters
    return posX , posY , posZ, rotation
end

function createBox(type,shots,id,scale,zOffset,rotx)
	if not shots then shots = 20 end
	if not id then id = 1217 end
	if not scale then scale = 0.4 end
	if not zOffset then zOffset = 0.26 end
	if not rotx then rotx = 180 end
    local x,y,z,rot = getPositionInfrontOfElement(localPlayer)
	local gz = getGroundPosition(x,y,z)
	local zOffset = zOffset+gz
	setPedAnimation(localPlayer,"BOMBER","BOM_Plant",1500,false,true,false,false)
	setTimer(
		function()
			local pot = createObject(id,x,y,zOffset,rotx,0,rot)
			local px,py,pz = getElementPosition(pot)
			local fuse = createEffect("prt_spark",px,py-0.5,pz-0.6,-22,0,0,300)
			local smoke = createEffect("vent",px,py,pz-1.8,0,0,0,300)
			local fuseTimer = math.random(3000,5000)
			setTimer(destroyElement,fuseTimer,1,fuse)
			setElementCollisionsEnabled(pot,false)
			setObjectScale(pot,scale)
			setTimer(
				function()
					local randomTimer = math.random(400,600)
					local destroyTimer = randomTimer*shots+5000
					if type == 1 then
						type1(px,py,pz,shots,randomTimer,destroyTimer)
					elseif type == 2 then
						type2(px,py,pz,shots,randomTimer,destroyTimer)
					elseif type == 3 then
						type3(px,py,pz,shots,randomTimer,destroyTimer)
					elseif type == 4 then
						type4(px,py,pz,shots,randomTimer,destroyTimer)
					end
					setTimer(destroyElement,destroyTimer,1,pot)
					setTimer(destroyElement,destroyTimer,1,smoke)
				end
			,fuseTimer,1)
		end
	,1250,1)
end

function sound(st,px,py,pz,looped,destroyTimer)
	if not looped then looped = false end
	if not destroyTimer then destroyTimer = nil end
	destroyTimer = tonumber(destroyTimer)
	if st == 1 then
		local shot = playSound3D("shot.mp3",px,py,pz,looped)
		setSoundMaxDistance(shot,200)
		if looped == true then
			setTimer(destroyElement,destroyTimer,1,shot)
		end
	elseif st == 2 then
		local pop = playSound3D("pop.mp3",px,py,pz,looped)
		setSoundMaxDistance(pop,200)
		if looped == true then
			setTimer(destroyElement,destroyTimer,1,pop)
		end
	elseif st == 3 then
		local spray_start = playSound3D("spray-start.mp3",px,py,pz,looped)
		setSoundMaxDistance(spray_start,200)
		if looped == true then
			setTimer(destroyElement,destroyTimer,1,spray_start)
		end
	elseif st == 4 then
		local spray = playSound3D("spray.mp3",px,py,pz,looped)
		setSoundMaxDistance(spray,200)
		if looped == true then
			setTimer(destroyElement,destroyTimer,1,spray)
		end
	end
end

-- Fireworks --

-- 1 ---------------------------------------------------------

function type1(px,py,pz,shots,randomTimer,destroyTimer)
	local spark = createEffect("prt_spark",px,py,pz+0.16,-90,0,0,300)
	local spark_2 = createEffect("prt_spark_2",px,py,pz+0.16,-90,0,0,300)
	sound(2,px,py,pz)
	createEffect("camflash",px,py,pz,0,0,0,300)
	createEffect("shootlight",px,py,pz,-90,0,0,300)
	setTimer(destroyElement,destroyTimer-5000,1,spark)
	setTimer(destroyElement,destroyTimer-5000,1,spark_2)
	setTimer(
		function(px,py,pz)
			randomTimer2 = math.random(50,750)
			setTimer(type1_2,randomTimer2,1,px,py,pz)
		end
	,randomTimer,shots,px,py,pz)
end

function type1_2(x,y,z)
	local random2 = math.random(-300,300)
	local random3 = math.random(75,500)
	local x,y,z = x+random2/100,y+random2/100,z+random3/100
	sound(2,x,y,z)
	createEffect("camflash",x,y,z,0,0,0,300)
	createEffect("shootlight",x,y,z,-90,0,0,300)
end

-- 2 ---------------------------------------------------------

function type2(px,py,pz,shots,randomTimer,destroyTimer)
	setTimer(
		function(px,py,pz)
			local r1 = math.random(50,750)
			local r2 = math.random(1000,2000)
			setTimer(type2_2,r1,1,px,py,pz,r2)
		end
	,randomTimer,shots,px,py,pz)
end

function type2_2(px,py,pz,r2)
	sound(1,px,py,pz)
	createEffect("gunflash",px,py,pz,0,0,0,300) --camflash
	ball = createObject(3106,px,py,pz,0,0,0) --3106
	setElementAlpha(ball,255)
	local r3 = math.random(-150,150)
	local pxs,pys,pzs = r3/100+px,r3/100+py,pz+math.random(15,21)
	moveObject(ball,r2,pxs,pys,pzs,0,0,0,"OutQuad")
	setTimer(
		function()
			sound(2,px,py,pzs)
			createEffect("camflash",pxs,pys,pzs,0,0,0,300)
			createEffect("shootlight",pxs,pys,pzs,0,0,0,300)
			--dxDrawLine3D(px,py,pz,pxs,pys,pzs,tocolor(255,255,255,70),2)
		end
	,r2,1,px,py,pz,pxs,pys,pzs)
	setTimer(destroyElement,r2,1,ball)
end

-- 3 --------------------------------------------------------- work in progress

function type3(px,py,pz,shots,randomTimer,destroyTimer)
	setTimer(
		function(px,py,pz)
			local r1 = math.random(50,750)
			local r2 = math.random(23000,25000)
			setTimer(type3_2,r1,1,px,py,pz,r2)
		end
	,randomTimer,shots,px,py,pz)
end

function type3_2(px,py,pz,r2)
	sound(1,px,py,pz)
	createEffect("gunflash",px,py,pz,0,0,0,300) --camflash
	ball = createObject(3106,px,py,pz,0,0,0) --3106
	setElementAlpha(ball,0)
	local r3 = math.random(-1500,1500)
	local pxs,pys = r3/100+px,r3/100+py
	local pzs = pz+math.random(50,55)
	moveObject(ball,r2,pxs,pys,pzs,0,0,0,"OutBack")
	flare = createEffect("smoke_flare",pxs,pys,pzs,90,0,90,2000)
	addEventHandler("onClientRender",root,type3_3)
	setTimer(
		function()
			removeEventHandler("onClientRender",root,type3_3)
		end
	,r2,1)
	setTimer(destroyElement,r2,1,ball)
end

function type3_3()
	local x,y,z = getElementPosition(ball)
	setElementPosition(flare,x,y,z)
end

-- 4 --------------------------------------------------------- work in progress

function type4(px,py,pz,shots,randomTimer,destroyTimer)
	local spark = createEffect("prt_spark",px,py,pz+0.16,-90,0,0,300)
	local spark_2 = createEffect("prt_spark_2",px,py,pz+0.16,-90,0,0,300)
	local spark_3 = createEffect("prt_spark_2",px,py,pz+0.26,-90,0,0,300)
	_,_,_,rot = getPositionInfrontOfElement(localPlayer)
	local spark_4 = createEffect("flame",px,py,pz+0.26,-90,0,rot,300)
	sound(3,px,py,pz)
	sound(4,px,py,pz,true,destroyTimer-5000)
	setTimer(destroyElement,destroyTimer-5000,1,spark)
	setTimer(destroyElement,destroyTimer-5000,1,spark_2)
	setTimer(destroyElement,destroyTimer-5000,1,spark_3)
	setTimer(destroyElement,destroyTimer-5000,1,spark_4)
	setTimer(
		function(px,py,pz)
			randomTimer2 = math.random(50,750)
			--setTimer(type1_2,randomTimer2,1,px,py,pz)
		end
	,randomTimer,shots,px,py,pz)
end

function type4_2(x,y,z)
	local random2 = math.random(-300,300)
	local random3 = math.random(75,500)
	local x,y,z = x+random2/100,y+random2/100,z+random3/100
	sound(2,x,y,z)
	createEffect("camflash",x,y,z,0,0,0,300)
	createEffect("shootlight",x,y,z,-90,0,0,300)
end
