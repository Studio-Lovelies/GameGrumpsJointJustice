local background = love.graphics.newImage(settings.power_hour_set_path)
local logoImage = love.graphics.newImage(settings.main_logo_path)

function DrawTitleScreen()
    local backgroundScale = 2 * dimensions.window_width / 1920
    GameFont:setLineHeight(1)

    love.graphics.clear(unpack(colors.black))

    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.draw(background, backgroundScale * 9, 0, 0, backgroundScale, backgroundScale)

    love.graphics.setColor(1, 1, 1, 1)

    local logoScale = backgroundScale * 0.75

    love.graphics.draw(
        logoImage,
        dimensions.window_width / 2 - (logoImage:getWidth() * logoScale) / 2,
        -1 * logoScale * 5,
        0,
        logoScale,
        logoScale
    )

    -- get dimensions for New Game and Load Game buttons
    local newW = (dimensions.window_width * 1 / 5)
    local newX = (dimensions.window_width * 1 / 8 - newW / 2)
    local newY = logoImage:getHeight() * logoScale + 15
    local newH = 60

    local caseSelectW = (dimensions.window_width * 1 / 5)
    local caseSelectX = (dimensions.window_width * 3 / 8 - caseSelectW / 2)
    local caseSelectY = logoImage:getHeight() * logoScale + 15
    local caseSelectH = 60

    local settingsW = (dimensions.window_width * 1 / 5)
    local settingsX = (dimensions.window_width * 5 / 8 - settingsW / 2)
    local settingsY = logoImage:getHeight() * logoScale + 15
    local settingsH = 60

    local quitW = (dimensions.window_width * 1 / 5)
    local quitX = (dimensions.window_width * 7 / 8 - quitW / 2)
    local quitY = logoImage:getHeight() * logoScale + 15
    local quitH = 60

    -- blue bounding box offset
    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44, 0.56, 0.89) -- roughly GG blue
    if TitleSelection == "New Game" then
        love.graphics.rectangle("fill", newX - dx, newY - dy, newW + 2 * dx, newH + 2 * dy)
    elseif TitleSelection == "Quit Game" then
        love.graphics.rectangle("fill", quitX - dx, quitY - dy, quitW + 2 * dx, quitH + 2 * dy)
    elseif TitleSelection == "Case Select" then
        love.graphics.rectangle("fill", caseSelectX - dx, caseSelectY - dy, caseSelectW + 2 * dx, caseSelectH + 2 * dy)
    else
        love.graphics.rectangle("fill", settingsX - dx, settingsY - dy, settingsW + 2 * dx, settingsH + 2 * dy)
    end

    -- draw New Game, Load Game, Browse Scenes, and text
    love.graphics.setColor(0.96, 0.53, 0.23) -- roughly GG orange
    love.graphics.rectangle("fill", newX, newY, newW, newH)

    love.graphics.setColor(222, 0, 0)
    --love.graphics.setColor(0.3,0.3,0.3) -- greyed out
    love.graphics.rectangle("fill", quitX, quitY, quitW, quitH)

    love.graphics.setColor(0.3, 0.3, 0.3) -- greyed out
    love.graphics.rectangle("fill", caseSelectX, caseSelectY, caseSelectW, caseSelectH)

    love.graphics.setColor(0.3, 0.3, 0.3) -- greyed out
    love.graphics.rectangle("fill", settingsX, settingsY, settingsW, settingsH)

    love.graphics.setColor(1, 1, 1)

    local newGameText = love.graphics.newText(GameFont, "New Game")
    love.graphics.draw(
        newGameText,
        newX + newW / 2 - newGameText:getWidth() * 3 / 2,
        newY + newH / 2 - newGameText:getHeight() * 3 / 2,
        0,
        3,
        3
    )

    local quitGameText = love.graphics.newText(GameFont, "Quit Game")
    --"Load Game")
    love.graphics.draw(
        quitGameText,
        quitX + quitW / 2 - quitGameText:getWidth() * 3 / 2,
        quitY + quitH / 2 - quitGameText:getHeight() * 3 / 2,
        0,
        3,
        3
    )

    local caseSelectText = love.graphics.newText(GameFont, "Case Select")
    love.graphics.draw(
        caseSelectText,
        caseSelectX + caseSelectW / 2 - caseSelectText:getWidth() * 3 / 2,
        caseSelectY + caseSelectH / 2 - caseSelectText:getHeight() * 3 / 2,
        0,
        3,
        3
    )

    local settingsText = love.graphics.newText(GameFont, "Settings")
    love.graphics.draw(
        settingsText,
        settingsX + settingsW / 2 - settingsText:getWidth() * 3 / 2,
        settingsY + settingsH / 2 - settingsText:getHeight() * 3 / 2,
        0,
        3,
        3
    )

    return self
end

function getIndex(table, string)
    local index = {}
    for k, v in pairs(table) do
        index[v] = k
    end
    return tonumber(index[string])
end

titleSelections = {}
titleSelections[0] = "New Game"
titleSelections[1] = "Case Select"
titleSelections[2] = "Settings"
titleSelections[3] = "Quit Game"
TitleSelection = "New Game"
SelectionIndex = 0
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.sfx_volume / 100 / 2)
jingle:setVolume(settings.sfx_volume / 100 / 2)

TitleScreenConfig = {
    displayed = false,
    onKeyPressed = function(key)
        if key == controls.start_button then
            love.graphics.clear(0, 0, 0)
            if TitleSelection == "Settings" then
                blip2:stop()
                blip2:play()
                --screens.browsescenes.displayed = true
                --DrawBrowseScreen()
                screens.options.displayed = true;
                DrawOptionsScreen()
                screens.title.displayed = false
                SelectionIndex = 0
            elseif TitleSelection == "Case Select" then
                blip2:stop()
                blip2:play()
                screens.browsescenes.displayed = true
                DrawBrowseScreen()
                screens.title.displayed = false
                SelectionIndex = 0
            elseif TitleSelection == "Quit Game" then
                blip2:stop()
                blip2:play()
                love.event.push("quit")
            elseif TitleSelection == "New Game" then
                jingle:play()
                Episode = NewEpisode(settings.episode_path)
                Episode:begin()
                CurrentScene.penalties = 5
                screens.title.displayed = false
            end
        elseif key == controls.press_right then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 3) then
                SelectionIndex = 0
            end
            TitleSelection = titleSelections[SelectionIndex]
        elseif key == controls.press_left then
            blip2:stop()
            blip2:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 3
            end
            TitleSelection = titleSelections[SelectionIndex]
        end
    end,
    onDisplay = function()
        screens.pause.displayed = false
        screens.courtRecords.displayed = false
        screens.options.displayed = false
        screens.title.displayed = true
        screens.volume.displayed = false
        TitleSelection = "New Game"
        SelectionIndex = 0
    end,
    draw = function()
        if screens.title.displayed == true then
            DrawTitleScreen()
            blip2:setVolume(settings.sfx_volume / 100 / 2)
            jingle:setVolume(settings.sfx_volume / 100 / 2)
        end
    end
}
