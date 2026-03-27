function onCreatePost()
	makeLuaText('EventText', nil, screenWidth, 0, 550)
	if downscroll then setProperty('EventText.y', 20) end
	setTextSize('EventText', 32)
	addLuaText('EventText')
end

local lyrics = {
	"Fo",
	"Focus!",
	"Focus!\nCon",
	"Focus!\nConcen",
	"Focus!\nConcentrate!",
	"Zoin",
	"Zoinks!",
	"Zoinks\nHo!",
	"Zoinks\nHo! Ho!"
}

local selector = 1
function opponentNoteHit()
	if (curBeat >= 424 and curBeat <= 431) or (curBeat >= 655 and curBeat <= 659) then
		setTextString('EventText', lyrics[selector])
		selector = selector + 1
	end
end

function onBeatHit()
	if curBeat == 432 or curBeat == 660 then
		setTextString('EventText', '')
	end
end