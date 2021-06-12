
local optionsSelections = {}

optionsSelections[0] = "Back";
optionsSelections[1] = "Volume";
optionsSelections[2] = settings.displayModes[settings.displayModesIndex];

function DrawOptionsScreen()

    love.graphics.clear(unpack(colors.black))
    GameFont:setLineHeight(1)

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackImageScale = 3

    local backW = (dimensions.window_width * 1/5)
    local backX = (dimensions.window_width/2 - backW/2)
    local backY = blackImage:getHeight()*blackImageScale + 10
    local backH = 60

    local volumeW = (dimensions.window_width * 1/3.75)
    local volumeX = (dimensions.window_width/2 - volumeW/2)
    local volumeY = blackImage:getHeight()*blackImageScale - 260
    local volumeH = 60

    local displaymodeW = (dimensions.window_width * 1/3.75 + love.graphics.newText(GameFont, optionsSelections[2]):getWidth())
    local displaymodeX = (dimensions.window_width/2 - displaymodeW/2)
    local displaymodeY = blackImage:getHeight()*blackImageScale - 370
    local displaymodeH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Volume" then
        love.graphics.rectangle("fill", volumeX-dx, volumeY-dy, volumeW+2*dx, volumeH+2*dy)
    elseif TitleSelection == optionsSelections[2] then
        love.graphics.rectangle("fill", displaymodeX-dx, displaymodeY-dy, displaymodeW+2*dx, displaymodeH+2*dy)
    else
        love.graphics.rectangle("fill", backX-dx, backY-dy, backW+2*dx, backH+2*dy)
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", volumeX, volumeY, volumeW, volumeH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", displaymodeX, displaymodeY, displaymodeW, displaymodeH)

    love.graphics.setColor(1,1,1)
    local textScale = 3
    local backText = love.graphics.newText(GameFont, "Back")
    love.graphics.draw(
        backText,
        backX + backW/2-(backText:getWidth() * textScale)/2,
        backY + backH/2-(backText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local volumeText = love.graphics.newText(GameFont, "Volume Settings")
    love.graphics.draw(
        volumeText,
        volumeX + volumeW/2-(volumeText:getWidth() * textScale)/2,
        volumeY + volumeH/2-(volumeText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local displaymodeText = love.graphics.newText(GameFont, optionsSelections[2])
    love.graphics.draw(
        displaymodeText,
        displaymodeX + displaymodeW/2-(displaymodeText:getWidth() * textScale)/2,
        displaymodeY + displaymodeH/2-(displaymodeText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

TitleSelection = "Back";
SelectionIndex = 0;
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.sfx_volume / 100 / 2)
jingle:setVolume(settings.sfx_volume / 100 / 2)
Music = {}
Sounds = {}

musicFiles = love.filesystem.getDirectoryItems(settings.music_directory)
soundFiles = love.filesystem.getDirectoryItems(settings.sfx_directory)

for b, i in ipairs(musicFiles) do
    if string.match(i,".mp3") then
        local a = i:gsub(".mp3",""):upper()
        Music[a] = love.audio.newSource(settings.music_directory..i, "static")
    elseif string.match(i,".wav") then
        local a = i:gsub(".wav",""):upper()
        Music[a] = love.audio.newSource(settings.music_directory..i, "static")
    end
end
for b, i in ipairs(soundFiles) do
    if string.match(i,".mp3") then
        local a = i:gsub(".mp3",""):upper()
        Sounds[a] = love.audio.newSource(settings.sfx_directory..i, "static")
    elseif string.match(i,".wav") then
        local a = i:gsub(".wav",""):upper()
        Sounds[a] = love.audio.newSource(settings.sfx_directory..i, "static")
    end
end

OptionsConfig = {
    displayed = false;
    onKeyPressed = function(key)
        if key == controls.start_button then
            love.graphics.clear(0, 0, 0);
            if TitleSelection == "Back" then
                blip2:stop()
                blip2:play()
                if Episode.started then
                    screens.options.displayed = false;
                else
                    screens.title.displayed = true;
                    DrawTitleScreen()
                    screens.options.displayed = false;
                    SelectionIndex = 1;
                end
            elseif TitleSelection == "Volume" then
                blip2:stop()
                blip2:play()
                screens.volume.displayed = true;
                DrawVolumeScreen();
                screens.options.displayed = false;
                SelectionIndex = 0;
            elseif TitleSelection == optionsSelections[2] then
                blip2:stop()
                blip2:play()
                if optionsSelections[2] == "Fullscreen" then
                    settings.displayModesIndex = settings.displayModesIndex + 1
                    love.window.setFullscreen(true);
                    optionsSelections[2] = "Windowed-Fullscreen";
                elseif optionsSelections[2] == "Windowed-Fullscreen" then
                    settings.displayModesIndex = settings.displayModesIndex - 1;
                    love.window.setFullscreen(true, "desktop");
                    optionsSelections[2] = "Fullscreen";
                end
                TitleSelection = optionsSelections[2]
            end
        elseif key == controls.pause_nav_up then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0
            end
            TitleSelection = optionsSelections[SelectionIndex]
        elseif key == controls.pause_nav_down then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2;
            end
            TitleSelection = optionsSelections[SelectionIndex]
        end
    end;
    onKeyReleased = function(key)
    end;
    onDisplay = function()
        screens.pause.displayed = false
        screens.courtRecords.displayed = false
        screens.options.displayed = true
        screens.title.displayed = false
        screens.volume.displayed = false
        TitleSelection = "Back";
        SelectionIndex = 0;
    end;
    draw = function()
        if screens.options.displayed == true then
            DrawOptionsScreen()
            blip2:setVolume(settings.sfx_volume / 100 / 2)
            jingle:setVolume(settings.sfx_volume / 100 / 2)
        end
    end;
}