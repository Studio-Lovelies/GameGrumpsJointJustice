function DrawVolumeScreen()
    love.graphics.clear(unpack(colors.black))
    GameFont:setLineHeight(1)

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackImageScale = 2 * dimensions.window_width / 1920 * 2

    local backW = (dimensions.window_width * 1 / 5)
    local backX = (dimensions.window_width / 2 - backW / 2)
    local backY = blackImage:getHeight() * blackImageScale + 10
    local backH = 60

    local musicVolumeW =
        (dimensions.window_width * 1 / 3.75 +
        (love.graphics.newText(GameFont, "Music Volume (" .. settings.music_volume .. ")"):getWidth() / 4))
    local musicVolumeX = (dimensions.window_width / 2 - musicVolumeW / 2)
    local musicVolumeY = blackImage:getHeight() * blackImageScale - 480
    local musicVolumeH = 60

    local sfxVolumeW =
        (dimensions.window_width * 1 / 3.75 +
        (love.graphics.newText(GameFont, "SFX Volume (" .. settings.sfx_volume .. ")"):getWidth() / 4))
    local sfxVolumeX = (dimensions.window_width / 2 - sfxVolumeW / 2)
    local sfxVolumeY = blackImage:getHeight() * blackImageScale - 370
    local sfxVolumeH = 60

    local speechVolumeW =
        (dimensions.window_width * 1 / 3.75 +
        (love.graphics.newText(GameFont, "Speech Volume (" .. settings.speech_volume .. ")"):getWidth() / 4))
    local speechVolumeX = (dimensions.window_width / 2 - speechVolumeW / 2)
    local speechVolumeY = blackImage:getHeight() * blackImageScale - 260
    local speechVolumeH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44, 0.56, 0.89)
    if TitleSelection == "SFX Volume" then
        love.graphics.rectangle("fill", sfxVolumeX - dx, sfxVolumeY - dy, sfxVolumeW + 2 * dx, sfxVolumeH + 2 * dy)
    elseif TitleSelection == "Speech Volume" then
        love.graphics.rectangle(
            "fill",
            speechVolumeX - dx,
            speechVolumeY - dy,
            speechVolumeW + 2 * dx,
            speechVolumeH + 2 * dy
        )
    elseif TitleSelection == "Music Volume" then
        love.graphics.rectangle(
            "fill",
            musicVolumeX - dx,
            musicVolumeY - dy,
            musicVolumeW + 2 * dx,
            musicVolumeH + 2 * dy
        )
    else
        love.graphics.rectangle("fill", backX - dx, backY - dy, backW + 2 * dx, backH + 2 * dy)
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", musicVolumeX, musicVolumeY, musicVolumeW, musicVolumeH)
    love.graphics.setColor(0.25, 0.41, 0.88)
    love.graphics.rectangle(
        "fill",
        musicVolumeX,
        musicVolumeY,
        (musicVolumeW / 100) * settings.music_volume,
        musicVolumeH
    )

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", sfxVolumeX, sfxVolumeY, sfxVolumeW, sfxVolumeH)
    love.graphics.setColor(0.25, 0.41, 0.88)
    love.graphics.rectangle("fill", sfxVolumeX, sfxVolumeY, (sfxVolumeW / 100) * settings.sfx_volume, sfxVolumeH)

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", speechVolumeX, speechVolumeY, speechVolumeW, speechVolumeH)
    love.graphics.setColor(0.25, 0.41, 0.88)
    love.graphics.rectangle(
        "fill",
        speechVolumeX,
        speechVolumeY,
        (speechVolumeW / 100) * settings.speech_volume,
        speechVolumeH
    )

    love.graphics.setColor(1, 1, 1)
    local textScale = 3
    local backText = love.graphics.newText(GameFont, "Back")
    love.graphics.draw(
        backText,
        backX + backW / 2 - (backText:getWidth() * textScale) / 2,
        backY + backH / 2 - (backText:getHeight() * textScale) / 2,
        0,
        textScale,
        textScale
    )

    local musicVolumeText = love.graphics.newText(GameFont, "Music Volume (" .. settings.music_volume .. ")")
    love.graphics.draw(
        musicVolumeText,
        musicVolumeX + musicVolumeW / 2 - (musicVolumeText:getWidth() * textScale) / 2,
        musicVolumeY + musicVolumeH / 2 - (musicVolumeText:getHeight() * textScale) / 2,
        0,
        textScale,
        textScale
    )

    local sfxVolumeText = love.graphics.newText(GameFont, "SFX Volume (" .. settings.sfx_volume .. ")")
    love.graphics.draw(
        sfxVolumeText,
        sfxVolumeX + sfxVolumeW / 2 - (sfxVolumeText:getWidth() * textScale) / 2,
        sfxVolumeY + sfxVolumeH / 2 - (sfxVolumeText:getHeight() * textScale) / 2,
        0,
        textScale,
        textScale
    )

    local speechVolumeText = love.graphics.newText(GameFont, "Speech Volume (" .. settings.speech_volume .. ")")
    love.graphics.draw(
        speechVolumeText,
        speechVolumeX + speechVolumeW / 2 - (speechVolumeText:getWidth() * textScale) / 2,
        speechVolumeY + speechVolumeH / 2 - (speechVolumeText:getHeight() * textScale) / 2,
        0,
        textScale,
        textScale
    )

    return self
end

volumeSelections = {}
volumeSelections[0] = "Back"
volumeSelections[1] = "Speech Volume"
volumeSelections[2] = "SFX Volume"
volumeSelections[3] = "Music Volume"
TitleSelection = "Back"
SelectionIndex = 0
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.sfx_volume / 100 / 2)
jingle:setVolume(settings.sfx_volume / 100 / 2)
Music = {}
Sounds = {}

musicFiles = love.filesystem.getDirectoryItems(settings.music_directory)
soundFiles = love.filesystem.getDirectoryItems(settings.sfx_directory)

for b, i in ipairs(musicFiles) do
    if string.match(i, ".mp3") then
        local a = i:gsub(".mp3", ""):upper()
        Music[a] = love.audio.newSource(settings.music_directory .. i, "static")
    elseif string.match(i, ".wav") then
        local a = i:gsub(".wav", ""):upper()
        Music[a] = love.audio.newSource(settings.music_directory .. i, "static")
    end
end
for b, i in ipairs(soundFiles) do
    if string.match(i, ".mp3") then
        local a = i:gsub(".mp3", ""):upper()
        Sounds[a] = love.audio.newSource(settings.sfx_directory .. i, "static")
    elseif string.match(i, ".wav") then
        local a = i:gsub(".wav", ""):upper()
        Sounds[a] = love.audio.newSource(settings.sfx_directory .. i, "static")
    end
end

VolumeConfig = {
    displayed = false,
    onKeyPressed = function(key)
        if key == controls.start_button then
            love.graphics.clear(0, 0, 0)
            if TitleSelection == "Back" then
                blip2:stop()
                blip2:play()
                screens.options.displayed = true
                DrawOptionsScreen()
                screens.volume.displayed = false
                SelectionIndex = 1
                TitleSelection = "Volume"
            end
        elseif key == controls.pause_nav_up then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 3) then
                SelectionIndex = 0
            end
            TitleSelection = volumeSelections[SelectionIndex]
        elseif key == controls.pause_nav_down then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 3
            end
            TitleSelection = volumeSelections[SelectionIndex]
        elseif key == controls.press_right then
            if TitleSelection == "Music Volume" then
                if settings.music_volume < 100 then
                    settings.music_volume = settings.music_volume + 5
                    MusicVolume = settings.music_volume
                    for i, v in pairs(Music) do
                        v:setVolume(settings.music_volume / 100)
                    end
                    blip2:stop()
                    blip2:play()
                end
            elseif TitleSelection == "SFX Volume" then
                if settings.sfx_volume < 100 then
                    settings.sfx_volume = settings.sfx_volume + 5
                    SFXVolume = settings.sfx_volume
                    for i, v in pairs(Sounds) do
                        if i ~= "maletalk" and i ~= "femaletalk" then
                            v:setVolume(settings.sfx_volume / 100)
                        end
                    end
                    blip2:stop()
                    blip2:play()
                end
            elseif TitleSelection == "Speech Volume" then
                if settings.speech_volume < 100 then
                    settings.speech_volume = settings.speech_volume + 5
                    SFXVolume = settings.speech_volume
                    blip2:stop()
                    blip2:play()
                end
            end
        elseif key == controls.press_left then
            if TitleSelection == "Music Volume" then
                if settings.music_volume > 0 then
                    settings.music_volume = settings.music_volume - 5
                    MusicVolume = settings.music_volume
                    for i, v in pairs(Music) do
                        v:setVolume(settings.music_volume / 100)
                    end
                    blip2:stop()
                    blip2:play()
                end
            elseif TitleSelection == "SFX Volume" then
                if settings.sfx_volume > 0 then
                    settings.sfx_volume = settings.sfx_volume - 5
                    SFXVolume = settings.sfx_volume
                    for i, v in pairs(Sounds) do
                        if i ~= "maletalk" and i ~= "femaletalk" then
                            v:setVolume(settings.sfx_volume / 100)
                        end
                    end
                    blip2:stop()
                    blip2:play()
                end
            elseif TitleSelection == "Speech Volume" then
                if settings.speech_volume > 0 then
                    settings.speech_volume = settings.speech_volume - 5
                    SFXVolume = settings.speech_volume
                    blip2:stop()
                    blip2:play()
                end
            end
        end
    end,
    onKeyReleased = function(key)
    end,
    onDisplay = function()
        screens.pause.displayed = false
        screens.courtRecords.displayed = false
        screens.options.displayed = false
        screens.title.displayed = false
        screens.volume.displayed = true
        TitleSelection = "Back"
        SelectionIndex = 0
    end,
    draw = function()
        if screens.volume.displayed == true then
            DrawVolumeScreen()
            blip2:setVolume(settings.sfx_volume / 100 / 2)
            jingle:setVolume(settings.sfx_volume / 100 / 2)
        end
    end
}
