function DrawBrowseScreen()

    love.graphics.clear(unpack(colors.black))

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.main_logo_path)

    local blackScale = 1

    local backW = (dimensions.window_width * 1/5)
    local backX = (dimensions.window_width * 1/18)
    local backY = blackImage:getHeight()*blackScale
    local backH = 60

    local pretrialW = (dimensions.window_width * 1/3.75)
    local pretrialX = (dimensions.window_width * 10.75/18) - pretrialW
    local pretrialY = blackImage:getHeight()*blackScale
    local pretrialH = 60

    local jorytrialW = (dimensions.window_width * 1/3.75)
    local jorytrialX = (dimensions.window_width * 17/18) - jorytrialW
    local jorytrialY = blackImage:getHeight()*blackScale
    local jorytrialH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Back" then
        love.graphics.rectangle("fill", backX-dx, backY-dy, backW+2*dx, backH+2*dy)
    elseif TitleSelection == "Jory's Trial" then
        love.graphics.rectangle("fill", jorytrialX-dx, jorytrialY-dy, jorytrialW+2*dx, jorytrialH+2*dy)
    else
        love.graphics.rectangle("fill", pretrialX-dx, pretrialY-dy, pretrialW+2*dx, pretrialH+2*dy)
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", pretrialX, pretrialY, pretrialW, pretrialH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", jorytrialX, jorytrialY, jorytrialW, jorytrialH)

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

    local pretrialText = love.graphics.newText(GameFont, "Pre-Trial")
    love.graphics.draw(
        pretrialText,
        pretrialX + pretrialW/2-(pretrialText:getWidth() * textScale)/1.5,
        pretrialY + pretrialH/2-(pretrialText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local jorytrialText = love.graphics.newText(GameFont, "Jory's Trial")
    love.graphics.draw(
        jorytrialText,
        jorytrialX + jorytrialW/2-(jorytrialText:getWidth() * textScale)/2,
        jorytrialY + jorytrialH/2-(jorytrialText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

sceneSelections = {}
sceneSelections[0] = "Back";
sceneSelections[1] = "Pre-Trial";
sceneSelections[2] = "Jory's Trial";

BrowseScreenConfig = {
    TitleSelection = "Back";
    SelectionIndex = 0;
    displayed = false;
    onKeyPressed = function (key)
        if key == controls.start_button then
            love.graphics.clear(0,0,0);
            if TitleSelection == "Back" then
                screens.title.displayed = true;
                DrawTitleScreen()
                screens.browsescenes.displayed = false;
            elseif TitleSelection == "Pre-Trial" then
                Episode:begin()
                screens.browsescenes.displayed = false;
            elseif TitleSelection == "Jory's Trial" then
                NewEpisode(settings.jory_trial_path):begin()
                screens.browsescenes.displayed = false;
            end
        elseif key == controls.press_right then
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0
            end
            TitleSelection = sceneSelections[SelectionIndex]
        elseif key == controls.press_left then
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2
            end
            TitleSelection = sceneSelections[SelectionIndex]
        end
    end;
    onDisplay = function()
        screens.browsescenes.displayed = true
        screens.title.displayed = false
    end;
    draw = function()
        if screens.browsescenes.displayed == true then
            DrawBrowseScreen()
        end
    end;
}