local collected = false
local wait = 960
local mVsp = 0

function onCreate()
	makeLuaSprite('mouth', 'zephy/part/mouth', getProperty('boyfriend.x') - 200, -300)
	addLuaSprite('mouth', true)

	makeLuaSprite('mouse', 'zephy/part/picker', 0, 0)
	setProperty('mouse.visible', false)
	addLuaSprite('mouse', true)

	makeLuaSprite('fx', 'zephy/fx', 0, 0)
	setProperty('fx.alpha', 0)
	addLuaSprite('fx', true)

	makeLuaSprite('orb', 'zephy/partSmall', 0, 0)
	setProperty('orb.alpha', 0)
	addLuaSprite('orb', true)
end

function onCreatePost()
	if not isStoryMode or botplay or tonumber(getTextFromFile('Shaggy/savefiles/mouth.txt', false)) > 0 then
		setProperty('mouth.alpha', 0)
		setProperty('mouse.alpha', 0)
	end
end


local timer = false
function onUpdate()
	setProperty('mouse.x',getMouseX('camGame')+ getProperty('camGame.scroll.x'));
	setProperty('mouse.y',getMouseY('camGame')+ getProperty('camGame.scroll.y'));
	if wait <= 0 then
		if getProperty('mouth.y') <= 6000 then
			setProperty('mouse.visible', true)
			setProperty('mouth.y', getProperty('mouth.y') + mVsp)
			mVsp = mVsp + 0.02
			setProperty('mouth.angle', getProperty('mouth.angle') - 3)
		else
			doTweenAlpha('mouse_bye', 'mouse', 0, 0.6, 'linear')
		end
	elseif timer then
		wait = wait - 1
	end
	if getProperty('mouth.alpha') > 0 and not collected and mouseClicked('left') and (getProperty('mouse.y') < getProperty('mouth.y') + 200) and (getProperty('mouse.y') > getProperty('mouth.y')) and (getProperty('mouse.x') < getProperty('mouth.x') + 200) and (getProperty('mouse.x') > getProperty('mouth.x')) then
		collected = true
		setProperty('orb.x', getMidpointX('mouth')-50)
		setProperty('orb.y', getMidpointY('mouth')-50)

		setProperty('fx.x', getProperty('orb.x')-50)
		setProperty('fx.y', getProperty('orb.y')-50)
		setProperty('mouse.alpha', 0)
		cancelTween('mouth_fall')
		cancelTween('mouth_speen')
		playSound('zephyrus/maskColl')
		setProperty('fx.alpha', 1)
		setProperty('orb.alpha', 1)
		setProperty('mouth.alpha', 0)
		setProperty('mouse.visible', false)
		doTweenX('fx_growX', 'fx.scale', 1.3, 1, 'linear')
		doTweenY('fx_growY', 'fx.scale', 1.3, 1, 'linear')
		doTweenAlpha('bye_fx', 'fx', 0, 1, 'linear')
		doTweenX('orb_flyX', 'orb', getMidpointX('boyfriend'), 2, 'cubeIn')
		doTweenY('orb_flyY', 'orb', getMidpointY('boyfriend'), 2, 'sineInOut')
		saveFile('Shaggy/savefiles/mouth.txt', "1", false)
	end
end

function onSongStart()
	timer = true
end

function onTweenCompleted(tag)
	if tag == "orb_flyY" then
		doTweenX('orb_shrinkX', 'orb.scale', 0, 3, 'linear')
		doTweenY('orb_shrinkY', 'orb.scale', 0, 3, 'linear')
	end
end