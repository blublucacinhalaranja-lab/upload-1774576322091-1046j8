local collected = false
local eyeStep = 0
local eVsp = -10
function onCreate()
	makeLuaSprite('eye', 'zephy/part/eye', 0, 0)
	setProperty('eye.alpha', 0)
	addLuaSprite('eye', true)

	makeLuaSprite('mouse', 'zephy/part/picker', 0, 0)
	setProperty('mouse.alpha', 0)
	addLuaSprite('mouse', true)

	makeLuaSprite('fx', 'zephy/fx', 0, 0)
	setProperty('fx.alpha', 0)
	addLuaSprite('fx', true)

	makeLuaSprite('orb', 'zephy/partSmall', 0, 0)
	setProperty('orb.alpha', 0)
	addLuaSprite('orb', true)
end

function onBeatHit()
	if curBeat == 660 then
		if not isStoryMode or botplay or tonumber(getTextFromFile('Shaggy/savefiles/eye.txt', false)) > 0 then
			--nothing
		else
			setProperty('mouse.alpha', 1)
			setProperty('eye.alpha', 1)
			eyeStep = 1
		end
	end
end

function onUpdate()
	setProperty('mouse.x',getMouseX('camGame')+ getProperty('camGame.scroll.x'));
	setProperty('mouse.y',getMouseY('camGame')+ getProperty('camGame.scroll.y'));
	if eyeStep == 0 then
		setProperty('eye.x', getMidpointX('dad'))
		setProperty('eye.y', getMidpointY('dad') - 300)
	elseif eyeStep == 1 then
		setProperty('eye.angle', getProperty('eye.angle') + 1)
		setProperty('eye.y', getProperty('eye.y') + eVsp)
		eVsp = eVsp + 0.1
		setProperty('eye.x', getProperty('eye.x') + 2)
		if getProperty('eye.y') > 730 then
			eyeStep = 2
			setProperty('eye.angle', 0)
		end
	end
	if getProperty('eye.alpha') > 0 and not collected and mouseClicked('left') and (getProperty('mouse.y') < getProperty('eye.y') + 200) and (getProperty('mouse.y') > getProperty('eye.y')) and (getProperty('mouse.x') < getProperty('eye.x') + 200) and (getProperty('mouse.x') > getProperty('eye.x')) then
		collected = true
		setProperty('orb.x', getMidpointX('eye')-50)
		setProperty('orb.y', getMidpointY('eye')-50)

		setProperty('fx.x', getProperty('orb.x')-50)
		setProperty('fx.y', getProperty('orb.y')-50)
		cancelTween('eye_fall')
		cancelTween('eye_speen')
		playSound('zephyrus/maskColl')
		setProperty('fx.alpha', 1)
		setProperty('orb.alpha', 1)
		setProperty('eye.alpha', 0)
		setProperty('mouse.alpha', 0)
		doTweenX('fx_growX', 'fx.scale', 1.3, 1, 'linear')
		doTweenY('fx_growY', 'fx.scale', 1.3, 1, 'linear')
		doTweenAlpha('bye_fx', 'fx', 0, 1, 'linear')
		doTweenX('orb_flyX', 'orb', getMidpointX('boyfriend'), 2, 'cubeIn')
		doTweenY('orb_flyY', 'orb', getMidpointY('boyfriend'), 2, 'sineInOut')
		saveFile('Shaggy/savefiles/eye.txt', "1", false)
	end
end

function onTweenCompleted(tag)
	if tag == 'eye_fall1' then
		doTweenY('eye_fall1', 'eye', getProperty('boyfriend.y') + 300, 1.8, 'cubeIn')
	end
	if tag == "orb_flyY" then
		doTweenX('orb_shrinkX', 'orb.scale', 0, 3, 'linear')
		doTweenY('orb_shrinkY', 'orb.scale', 0, 3, 'linear')
	end
end