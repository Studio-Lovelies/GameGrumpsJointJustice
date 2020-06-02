function DrawTitleScreen()
    local logoImage = love.graphics.newImage(settings.main_logo_path)
    local logoScale = 1

    love.graphics.clear(unpack(colors.black))
    love.graphics.draw(
        logoImage,
        -- Center the logo in the window regardless of image or window size
        GetCenterOffset(logoImage:getWidth() * logoScale, false),
        0,
        0,
        logoScale,
        logoScale
    )

    -- get dimensions for New Game and Load Game buttons
    local newX = (dimensions.window_width * 1/9)
    local newW = (dimensions.window_width * 1/3)
    local newY = logoImage:getHeight()*logoScale
    local newH = 60

    local loadW = (dimensions.window_width * 1/3)
    local loadX = (dimensions.window_width * 8/9) - loadW
    local loadY = logoImage:getHeight()*logoScale
    local loadH = 60

    -- blue bounding box offset
    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89) -- roughly GG blue
    if TitleSelection == "New Game" then
        love.graphics.rectangle("fill", newX-dx, newY-dy, newW+2*dx, newH+2*dy)
    else
        love.graphics.rectangle("fill", loadX-dx, loadY-dy, loadW+2*dx, loadH+2*dy)
    end

    -- draw New Game, Load Game, and text
    love.graphics.setColor(0.96,0.53,0.23) -- roughly GG orange
    love.graphics.rectangle("fill", newX, newY, newW, newH)

    love.graphics.setColor(0.3,0.3,0.3) -- greyed out
    love.graphics.rectangle("fill", loadX, loadY, loadW, loadH)

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

    local loadGameText = love.graphics.newText(GameFont, "Load Game")
    love.graphics.draw(
        loadGameText,
        loadX + loadW/2-(loadGameText:getWidth() * textScale)/2,
        loadY + loadH/2-(loadGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )
end

TitleScreenConfig = {
    displayed = false;
    onKeyPressed = function (key)
        if key == controls.start_button then
            -- Since there's no displayKey, this screen
            -- is responsible for removing itself
            screens.title.displayed = false;
            love.graphics.clear(0,0,0);
            if TitleSelection == "Load Game" then
                -- replace this and handle load game logic
                Episode:begin()
            else
                -- replace this and handle new game logic
                Episode:begin()
            end
        elseif key == controls.press_right then
            TitleSelection = "Load Game"
        elseif key == controls.press_left then
            TitleSelection = "New Game"
        end
    end;
    onDisplay = function ()
        -- This will depend on whether or not there are saves
        TitleSelection = "New Game"
    end;
    draw = function ()
        DrawTitleScreen()
    end;
}
