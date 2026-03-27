local allowCountdown = false
local stops = 0;
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
        
		setProperty('inCutscene', true);

    if stops == 0 then
	addCharacterToList('sshaggy', 'dad')
	precacheImage('power')
	cameraSetTarget("dad")
	makeAnimatedLuaSprite('power boost', 'power', (getProperty('dad.x') - 330), (getProperty('dad.y') + 150))
	addAnimationByPrefix('power boost', 'burst instance 1', 'burst', 24, false)

	makeAnimatedLuaSprite('false_shaggy', 'characters/shaggy', getProperty('dad.x'), getProperty('dad.y'))
	addLuaSprite('false_shaggy', false)
	setProperty('dad.visible', false)
	makeLuaSprite('black', nil, 0, 0)
	makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000');
	screenCenter('black')
	setObjectCamera('black', 'camOther');
        runTimer('dial1', 0.8)
    end

    if stops == 1 then
        runTimer('magic', 0.5)
    end

        stops = stops + 1
		return Function_Stop;
	end
	return Function_Continue;
end

function onUpdate(elapsed)
	if getProperty('false_shaggy.animation.curAnim.name') == "power_up" and getProperty('false_shaggy.animation.curAnim.finished') == true then
		cameraShake('game', 0.06, 0.2)
		playSound('powerup', 1)
		addLuaSprite('power boost', true)
		objectPlayAnimation('power boost', 'burst', false)
		setProperty('dad.visible', true)
		removeLuaSprite('false_shaggy', true)
	end
end

function onTimerCompleted(tag)
	if tag == 'magic' then
		addAnimationByPrefix('false_shaggy', 'power_up', 'shaggy_powerup', 30, false)
		runTimer('end', 1.3)
	end
	if tag ==  'dial1' then
		triggerEvent('startDialogue', 'dialogue', '');
	end
	if tag == 'end' then
		allowCountdown = true;
		startCountdown()
	end
end	

function onTweenCompleted(tag)
	if tag == 'fadeOut' then
		removeLuaSprite('black0', true)
	end
end