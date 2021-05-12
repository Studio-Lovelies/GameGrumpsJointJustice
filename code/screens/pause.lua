-- TODO: This matches the Switch UI but not the DS UI, and should be updated
-- after the art team has established the look
function DrawPauseScreen(self)
    -- Add a light overlay
    GameFont:setLineHeight(1)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackImageScale = 2*dimensions.window_width/1920 * 2

    -- Add the settings box with a 2px white outline
    DrawCenteredRectangle({
        width = love.graphics.getWidth() * 3/5,
        height = love.graphics.getHeight() - 120,
        buttons = {
            {
                title = "Close",
                key = controls.pause
            }
        },
    })

    local resumeW = (dimensions.window_width * 1/3.75 + (love.graphics.newText(GameFont, "Resume"):getWidth() / 4))
    local resumeX = (dimensions.window_width/2 - resumeW/2)
    local resumeY = blackImage:getHeight()*blackImageScale - 480
    local resumeH = 60

    local settingsW = (dimensions.window_width * 1/3.75 + (love.graphics.newText(GameFont, "Settings"):getWidth() / 4))
    local settingsX = (dimensions.window_width/2 - settingsW/2)
    local settingsY = blackImage:getHeight()*blackImageScale - 370
    local settingsH = 60

    local backToMenuW = (dimensions.window_width * 1/3.75 + (love.graphics.newText(GameFont, "Back to menu"):getWidth() / 4))
    local backToMenuX = (dimensions.window_width/2 - backToMenuW/2)
    local backToMenuY = blackImage:getHeight()*blackImageScale - 260
    local backToMenuH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Settings" then
        love.graphics.rectangle("fill", settingsX-dx, settingsY-dy, settingsW+2*dx, settingsH+2*dy)
    elseif TitleSelection == "Back to menu" then
        love.graphics.rectangle("fill", backToMenuX-dx, backToMenuY-dy, backToMenuW+2*dx, backToMenuH+2*dy)
    else
        love.graphics.rectangle("fill", resumeX-dx, resumeY-dy, resumeW+2*dx, resumeH+2*dy)
    end

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", resumeX, resumeY, resumeW, resumeH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", settingsX, settingsY, settingsW, settingsH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", backToMenuX, backToMenuY, backToMenuW, backToMenuH)

    love.graphics.setColor(1,1,1)
    local textScale = 3

    local resumeText = love.graphics.newText(GameFont, "Resume")
    love.graphics.draw(
        resumeText,
        resumeX + resumeW/2-(resumeText:getWidth() * textScale)/2,
        resumeY + resumeH/2-(resumeText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local settingsText = love.graphics.newText(GameFont, "Settings")
    love.graphics.draw(
        settingsText,
        settingsX + settingsW/2-(settingsText:getWidth() * textScale)/2,
        settingsY + settingsH/2-(settingsText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local backToMenuText = love.graphics.newText(GameFont, "Back to menu")
    love.graphics.draw(
        backToMenuText,
        backToMenuX + backToMenuW/2-(backToMenuText:getWidth() * textScale)/2,
        backToMenuY + backToMenuH/2-(backToMenuText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

pauseSelections = {}
pauseSelections[1] = "Back to menu";
pauseSelections[2] = "Settings";
pauseSelections[3] = "Resume";
TitleSelection = "Resume";
SelectionIndex = 3;
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.sfx_volume / 100 / 2)
jingle:setVolume(settings.sfx_volume / 100 / 2)
Music = {}
Sounds = {}

musicFiles = love.filesystem.getDirectoryItems(settings.music_directory)
soundFiles = love.filesystem.getDirectoryItems(settings.sfx_directory)

PauseScreenConfig = {
    displayed = false;
    displayKey = controls.pause;
    displayCondition = function()
        -- Don't let the pause menu show until the scene has
        -- started (AKA we're off the title screen)
        return Episode.loaded;
    end;
    onKeyPressed = function(key)
        if key == controls.start_button then
            if TitleSelection == "Resume" then
                screens.pause.displayed = false
            elseif TitleSelection == "Back to menu" then
                screens.pause.displayed = false
                Episode:stop()
                DrawTitleScreen()
                screens.title.displayed = true
                TitleSelection = "New Game";
                SelectionIndex = 0;
                blip2:stop()
                blip2:play()
            elseif TitleSelection == "Settings" then
                screens.pause.displayed = false
                DrawOptionsScreen()
                screens.options.displayed = true
                TitleSelection = "Back";
                SelectionIndex = 0;
                blip2:stop()
                blip2:play()
            end
        elseif key == controls.pause_nav_up then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex + 1;
            if (SelectionIndex > 3) then
                SelectionIndex = 1
            end
            TitleSelection = pauseSelections[SelectionIndex]
        elseif key == controls.pause_nav_down then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex - 1;
            if (SelectionIndex < 1) then
                SelectionIndex = 3
            end
            TitleSelection = pauseSelections[SelectionIndex]
        end
    end;
    onDisplay = function()
        TitleSelection = "Resume";
        SelectionIndex = 3;
    end;
    draw = function()
        DrawPauseScreen()
    end
}