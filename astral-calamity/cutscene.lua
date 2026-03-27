local allowCountdown = false
local stops = 0;
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not checkFileExists('Shaggy/savefiles/talla.txt', false) and not seenCutscene then

		if stops == 0 then
			makeLuaSprite('black', nil, 0, 0)
			makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000');
			screenCenter('black')
			setObjectCamera('black', 'camOther');
			addLuaSprite('black', true)
			doTweenAlpha('bye_black', 'black', 0, 2, 'linear')
		end

		if stops == 1 then
			soundFadeOut('musicLoop', 1, 0)
			runTimer('end', 1)
		end
 
		stops = stops + 1
		return Function_Stop;

	elseif not allowCountdown and isStoryMode and checkFileExists('Shaggy/savefiles/talla.txt', false) and not seenCutscene then

		if stops == 0 then
			makeLuaSprite('zephyrus', 'talladega/zephyrus', 1550, 500)
			addLuaSprite('zephyrus', true)
			makeLuaSprite('black', nil, 0, 0)
			makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000');
			screenCenter('black')
			setObjectCamera('black', 'camOther');
			addLuaSprite('black', true)
			doTweenAlpha('bye_blackB', 'black', 0, 2, 'linear')
		end

		if stops == 1 then
			runTimer('music', 1)
		end


		stops = stops + 1
		return Function_Stop;
	end
	return Function_Continue;
end


local allowEnd = false
local cut = 0;
function onEndSong()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowEnd and isStoryMode then
        
		setProperty('inCutscene', true);

    if cut == 0 then
	doTweenAlpha('byeHUD', 'camHUD', 0, 1.2, 'linear')
	runTimer('dial2', 0.8)
    end

    if cut == 1 then
        runTimer('fly', 1.2)
    end

    if cut == 2 then
        allowEnd = true
        endSong()
    end
        cut = cut + 1
		return Function_Stop;
	end
	return Function_Continue;
end


local wb_eX = 0
local wb_eY = 0
local rotI = 1
local wb_speed = 0
local songEnded = false
local wb_time = 0

function onUpdate()
	if not songEnded then
		wb_eX = wb_eX + wb_speed
		wb_eY = wb_eY + wb_speed
		rot = rotI/6
	elseif songEnded then
		cameraSetTarget('gf')
		wb_speed = wb_speed + 0.1
		if wb_speed > 20 then
			wb_speed = 20
		end
		wb_eX = wb_eX + wb_speed
		wb_eY = wb_eY - wb_speed
		wb_time = wb_time + 1

		if wb_time == 370 then
			setProperty('black.alpha', 1)
		elseif getProperty('black.alpha') >= 1 then
			endSong()
		end
	end
	setProperty('dad.x', -300 + math.cos(rot/3) * 20 + wb_eX)
	setProperty('dad.y', -500 + math.cos(rot/5) * 40 + wb_eY)

	rotI = rotI + 1

	if checkFileExists('Shaggy/savefiles/talla.txt', false) and isStoryMode then
		--stuff
	elseif not mustHitSection then
		cameraSetTarget('dad')
	end
end


function onUpdatePost()
	if checkFileExists('Shaggy/savefiles/talla.txt', false) and isStoryMode then
		setProperty('camFollowPos.x', getProperty('zephyrus.x'))
		setProperty('camFollowPos.y', getProperty('zephyrus.y'))
	end
end

function onTimerCompleted(tag)
	if tag == "music" then
		doTweenX('zephy_flx', "zephyrus", (getProperty('dad.x') + 275), 10, 'linear')
		doTweenY('zephy_fly', "zephyrus", (getProperty('dad.y') + 75), 10, 'linear')
		playSound('talla/possess', 1, 'stop1')
	end
	if tag == 'end' then
		allowCountdown = true;
		startCountdown()
	end
	if tag ==  'dial2' then
		doTweenX('camGY', 'camFollowPos', getMidpointX('gf')-100, 1, 'linear')
		doTweenY('camGF', 'camFollowPos', getMidpointY('gf')-100, 1, 'linear')
		triggerEvent('startDialogue', 'dialogue2', '');
	end
	if tag ==  'fly' then
		songEnded = true
	end
	if tag ==  'fall' then
		setPropertyFromClass('PlayState', 'seenCutscene', false)
		doTweenAngle('speeeeeen', 'posses', -60, 1.5, 'quadIn')
		doTweenY('possesFall', 'posses', 704, 1.43, 'smootherStepIn')
	end
	if tag ==  'endSSong' then
		allowEnd = true
		endSong()
	end
	if tag ==  'change_song' then
		loadSong('talladega', 2)
	end
end	

function onTweenCompleted(tag)
	if tag == 'bye_black' then 
		triggerEvent('startDialogue', 'dialogue', '')
	end
	if tag == 'bye_blackB' then 
		triggerEvent('startDialogue', 'dialogueB', '')
	end
	if tag == "zephy_fly" then
		doTweenX('zephy_flx2', "zephyrus", (getProperty('dad.x') + 275), 0.1, 'linear')
		doTweenY('zephy_fly2', "zephyrus", (getProperty('dad.y') + 75), 0.1, 'linear')
	end
	if tag == "zephy_fly2" then
		stopSound('stop1')
		makeLuaSprite('posses', 'talladega/possessed', 560, 60)
		scaleObject('posses', 0.5, 0.5)
		setObjectCamera('posses', 'camOther');
		
		setProperty('black.alpha', 1)
		addLuaSprite('posses', true)
		runTimer('fall', 2)
	end
	if tag == "dadFlyY" then
		runTimer('endSSong', 1)
	end
	if tag == 'speeeeeen' then
		playSound('god-eater/undSnap', 1)
		runTimer('change_song', 1.5)
	end
end

function onSoundFinished(tag)
	if tag == 'musicLoop' then
		playSound('talla/zephyrus', 1, 'musicLoop')
	end
end

-- Code from VS Whitty go check them out --

function setStrumVisibilty(v1,vis)
		strum = v1
		strumset = 'opponentStrums'

		if strum > 3 then
			strumset = 'playerStrums'
		end
		
		strum = v1 % 4

		setPropertyFromGroup(strumset,strum,'visible',vis)
end