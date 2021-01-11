function DrawTitleScreen()
    local background = love.graphics.newImage(settings.power_hour_set_path)
    local backgroundScale = 1.326--3.8

    love.graphics.clear(unpack(colors.black))

    love.graphics.draw(
        background,
        GetCenterOffset(background:getWidth() * backgroundScale, false),
        0,
        0,
        backgroundScale,
        backgroundScale
    )

    local logoImage = love.graphics.newImage(settings.main_logo_path)
    local logoScale = 1

    love.graphics.draw(
        logoImage,
        GetCenterOffset(logoImage:getWidth() * logoScale, false),
        0,
        0,
        logoScale,
        logoScale
    )

    -- get dimensions for New Game and Load Game buttons
    local newW = (dimensions.window_width * 1/5)
    local newX = (dimensions.window_width * 1/18)
    local newY = logoImage:getHeight()*logoScale
    local newH = 60

    local scenesW = (dimensions.window_width * 1/3.75)
    local scenesX = (dimensions.window_width * 10.75/18) - scenesW
    local scenesY = logoImage:getHeight()*logoScale
    local scenesH = 60

    local loadW = (dimensions.window_width * 1/3.75)
    local loadX = (dimensions.window_width * 17/18) - loadW
    local loadY = logoImage:getHeight()*logoScale
    local loadH = 60

    -- blue bounding box offset
    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89) -- roughly GG blue
    if TitleSelection == "New Game" then
        love.graphics.rectangle("fill", newX-dx, newY-dy, newW+2*dx, newH+2*dy)
    elseif TitleSelection == "Load Game" then
        love.graphics.rectangle("fill", loadX-dx, loadY-dy, loadW+2*dx, loadH+2*dy)
    else
        love.graphics.rectangle("fill", scenesX-dx, scenesY-dy, scenesW+2*dx, scenesH+2*dy)
    end

    -- draw New Game, Load Game, Browse Scenes, and text
    love.graphics.setColor(0.96,0.53,0.23) -- roughly GG orange
    love.graphics.rectangle("fill", newX, newY, newW, newH)

    love.graphics.setColor(0.3,0.3,0.3) -- greyed out
    love.graphics.rectangle("fill", loadX, loadY, loadW, loadH)


    love.graphics.setColor(0.3,0.3,0.3) -- greyed out
    love.graphics.rectangle("fill", scenesX, scenesY, scenesW, scenesH)

    love.graphics.setColor(1,1,1)
    local textScale = 3
    local newGameText = love.graphics.newText(GameFont, "New Game")
    love.graphics.draw(
        newGameText,
        newX + newW/2-(newGameText:getWidth() * textScale)/2,
        newY + newH/2-(newGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local loadGameText = love.graphics.newText(GameFont, "Settings ")--"Load Game")
    love.graphics.draw(
        loadGameText,
        loadX + loadW/2-(loadGameText:getWidth() * textScale)/2,
        loadY + loadH/2-(loadGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local scenesText = love.graphics.newText(GameFont, "Case Select")
    love.graphics.draw(
        scenesText,
        scenesX + scenesW/2-(loadGameText:getWidth() * textScale)/2,
        scenesY + scenesH/2-(loadGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

function getIndex(table, string)
    local index={}
    for k,v in pairs(table) do
        index[v] = k;
    end
    return tonumber(index[string])
end

titleSelections = {}
titleSelections[0] = "New Game";
titleSelections[1] = "Case Select";
titleSelections[2] = "Load Game";
TitleSelection = "New Game";
SelectionIndex = 0;
blip2 = love.audio.newSource("sounds/selectblip2.wav", "static")
jingle = love.audio.newSource("sounds/selectjingle.wav", "static")
blip2:setVolume(settings.master_volume / 100 / 2);
jingle:setVolume(settings.master_volume / 100 / 2);

TitleScreenConfig = {
    displayed = false;
    onKeyPressed = function(key)
        if key == controls.start_button then
            love.graphics.clear(0,0,0);
            if TitleSelection == "Case Select" then
                blip2:play()
                screens.browsescenes.displayed = true;
                DrawBrowseScreen();
                SelectionIndex = 0;
            elseif TitleSelection == "Load Game" then
                -- replace this and handle load game logic
                --jingle:play()
                --Episode:begin()
                blip2:play()
                screens.options.lastDisplayed = screens.title.displayed
                screens.options.displayed = true
                DrawOptionsScreen()
                SelectionIndex = 0;
            elseif TitleSelection == "New Game" then
                jingle:play()
                Episode:begin()
                screens.title.displayed = false;
            end
        elseif key == controls.press_right then
            blip2:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0
            end
            TitleSelection = titleSelections[SelectionIndex]
        elseif key == controls.press_left then
            blip2:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2
            end
            TitleSelection = titleSelections[SelectionIndex]
        end
    end;
    onDisplay = function()
        screens.browsescenes.displayed = false
        screens.pause.displayed = false
        screens.courtRecords.displayed = false
        screens.jorytrial.displayed = false
        screens.options.displayed = false
        screens.title.displayed = true
        TitleSelection = "New Game";
        SelectionIndex = 0;
    end;
    draw = function()
        if screens.title.displayed == true then
            DrawTitleScreen()
        end
    end
}