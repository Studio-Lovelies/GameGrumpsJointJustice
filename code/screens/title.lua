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

    local loadGameText = love.graphics.newText(GameFont, "Load Game")
    love.graphics.draw(
        loadGameText,
        loadX + loadW/2-(loadGameText:getWidth() * textScale)/2,
        loadY + loadH/2-(loadGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local scenesText = love.graphics.newText(GameFont, "Browse Scenes")
    love.graphics.draw(
        scenesText,
        scenesX + scenesW/2-(loadGameText:getWidth() * textScale)/1.5,
        scenesY + scenesH/2-(loadGameText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )
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
titleSelections[1] = "Browse Scenes";
titleSelections[2] = "Load Game";

TitleScreenConfig = {
    displayed = false;
    onKeyPressed = function(key)
        print(SelectionIndex)
        if key == controls.start_button then
            -- Since there's no displayKey, this screen
            -- is responsible for removing itself
            love.graphics.clear(0,0,0);
            if TitleSelection == "Browse Scenes" then
                -- browse scenes screen here
                screens.browsescenes.displayed = true;
                screens.browsescenes.SelectionIndex = SelectionIndex;
                DrawBrowseScreen()
                screens.title.displayed = false;
            elseif TitleSelection == "Load Game" then
                -- replace this and handle load game logic
                Episode:begin()
                screens.title.displayed = false;
            elseif TitleSelection == "New Game" then
                -- replace this and handle new game logic
                Episode:begin()
                screens.title.displayed = false;
            end
        elseif key == controls.press_right then
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0
            end
            TitleSelection = titleSelections[SelectionIndex]
        elseif key == controls.press_left then
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2
            end
            TitleSelection = titleSelections[SelectionIndex]
        end
    end;
    onDisplay = function()
        TitleSelection = "New Game";
        SelectionIndex = 0;
    end;
    draw = function()
        if screens.title.displayed == true then
            DrawTitleScreen()
        end
    end
}