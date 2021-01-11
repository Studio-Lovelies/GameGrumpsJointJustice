function DrawOptionsScreen()

    love.graphics.clear(unpack(colors.black))

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackImageScale = 3

    local backW = (dimensions.window_width * 1/5)
    local backX = (dimensions.window_width * 10.75/18) - backW
    local backY = blackImage:getHeight()*blackImageScale + 10
    local backH = 60

    local volumeW = (dimensions.window_width * 1/3.75)
    local volumeX = (dimensions.window_width * 11.25/18) - volumeW
    local volumeY = blackImage:getHeight()*blackImageScale - 260
    local volumeH = 60

    local controlsW = (dimensions.window_width * 1/3.75)
    local controlsX = (dimensions.window_width * 11.25/18) - controlsW
    local controlsY = blackImage:getHeight()*blackImageScale - 370
    local controlsH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Volume" then
        love.graphics.rectangle("fill", volumeX-dx, volumeY-dy, volumeW+2*dx, volumeH+2*dy)
    elseif TitleSelection == "Controls" then
        love.graphics.rectangle("fill", controlsX-dx, controlsY-dy, controlsW+2*dx, controlsH+2*dy)
    else
        love.graphics.rectangle("fill", backX-dx, backY-dy, backW+2*dx, backH+2*dy)
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    if settings.debug then
        love.graphics.setColor(0,1,0.25)
    else
        love.graphics.setColor(1,0,0)
    end

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", volumeX, volumeY, volumeW, volumeH)
    love.graphics.setColor(0.25,0.41,0.88)
    love.graphics.rectangle("fill", volumeX, volumeY, (volumeW / 100) * settings.master_volume, volumeH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", controlsX, controlsY, controlsW, controlsH)

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

    local volumeText = love.graphics.newText(GameFont, "Volume ("..settings.master_volume.."%)")
    love.graphics.draw(
        volumeText,
        volumeX + volumeW/2-(volumeText:getWidth() * textScale)/2,
        volumeY + volumeH/2-(volumeText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local controlsText = love.graphics.newText(GameFont, "Controls")
    love.graphics.draw(
        controlsText,
        controlsX + controlsW/2-(controlsText:getWidth() * textScale)/2,
        controlsY + controlsH/2-(controlsText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

optionsSelections = {}
optionsSelections[0] = "Back";
optionsSelections[1] = "Volume";
optionsSelections[2] = "Controls";
TitleSelection = "Back";
SelectionIndex = 0;
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.master_volume / 100 / 2)
jingle:setVolume(settings.master_volume / 100 / 2)
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
                blip2:play()
                screens.title.displayed = true;
                DrawTitleScreen();
                screens.options.displayed = false;
                SelectionIndex = 3;
            elseif TitleSelection == "Controls" then
                blip2:play()
            end
        elseif key == controls.pause_nav_up then
            blip2:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0;
            end
            TitleSelection = optionsSelections[SelectionIndex]
        elseif key == controls.pause_nav_down then
            blip2:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2;
            end
            TitleSelection = optionsSelections[SelectionIndex]
        elseif key == controls.press_right then
            if TitleSelection == "Volume" then
                if settings.master_volume < 100 then
                    settings.master_volume = settings.master_volume + 5
                    MasterVolume = settings.master_volume
                    for i,v in pairs(Music) do
                        v:setVolume(settings.master_volume / 100)
                    end
                    for i,v in pairs(Sounds) do
                        v:setVolume(settings.master_volume / 100 / 2)
                    end
                    blip2:play()
                end
            end
        elseif key == controls.press_left then
            if TitleSelection == "Volume" then
                if settings.master_volume > 0 then
                    settings.master_volume = settings.master_volume - 5
                    MasterVolume = settings.master_volume
                    for i,v in pairs(Music) do
                        v:setVolume(settings.master_volume / 100)
                    end
                    for i,v in pairs(Sounds) do
                        v:setVolume(settings.master_volume / 100 / 2)
                    end
                    blip2:play()
                end
            end
        end
    end;
    onKeyReleased = function(key)
    end;
    onDisplay = function()
        screens.browsescenes.displayed = false
        screens.pause.displayed = false
        screens.courtRecords.displayed = false
        screens.jorytrial.displayed = false
        screens.options.displayed = true
        screens.title.displayed = false
        TitleSelection = "Back";
        SelectionIndex = 0;
    end;
    draw = function()
        if screens.options.displayed == true then
            DrawOptionsScreen()
            blip2:setVolume(settings.master_volume / 100 / 2)
            jingle:setVolume(settings.master_volume / 100 / 2)
        end
    end;
}