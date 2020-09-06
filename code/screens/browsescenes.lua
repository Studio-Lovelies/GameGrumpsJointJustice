function DrawBrowseScreen()

    love.graphics.clear(unpack(colors.black))

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackScale = 3

    local jorytrialImage = love.graphics.newImage(settings.court_path)
    local jorytrialImageScale = 3

    local posttrialImage = love.graphics.newImage(settings.lobby_path)
    local posttrialImageScale = 3

    local backW = (dimensions.window_width * 1/5)
    local backX = (dimensions.window_width * 1/18)
    local backY = blackImage:getHeight()*blackScale + 10
    local backH = 60

    local jorytrialW = (dimensions.window_width * 1/3.75)
    local jorytrialX = (dimensions.window_width * 10.75/18) - jorytrialW
    local jorytrialY = blackImage:getHeight()*blackScale + 10
    local jorytrialH = 60

    local posttrialW = (dimensions.window_width * 1/3.75)
    local posttrialX = (dimensions.window_width * 17/18) - posttrialW
    local posttrialY = blackImage:getHeight()*blackScale + 10
    local posttrialH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Jory's Trial" then
        love.graphics.rectangle("fill", jorytrialX-dx, jorytrialY-dy, jorytrialW+2*dx, jorytrialH+2*dy)
        love.graphics.draw(
            jorytrialImage,
            GetCenterOffset(jorytrialImage:getWidth() * jorytrialImageScale, false),
            0,
            0,
            jorytrialImageScale,
            jorytrialImageScale
        )
    elseif TitleSelection == "Post-Trial" then
        love.graphics.rectangle("fill", posttrialX-dx, posttrialY-dy, posttrialW+2*dx, posttrialH+2*dy)
        love.graphics.draw(
            posttrialImage,
            GetCenterOffset(posttrialImage:getWidth() * posttrialImageScale, false),
            0,
            0,
            posttrialImageScale,
            posttrialImageScale
        )
    else
        love.graphics.rectangle("fill", backX-dx, backY-dy, backW+2*dx, backH+2*dy)
        love.graphics.draw(
            blackImage,
            GetCenterOffset(blackImage:getWidth() * blackScale, false),
            0,
            0,
            blackImageScale,
            blackImageScale
        )
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", jorytrialX, jorytrialY, jorytrialW, jorytrialH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", posttrialX, posttrialY, posttrialW, posttrialH)

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

    local jorytrialText = love.graphics.newText(GameFont, "Jory's Trial")
    love.graphics.draw(
        jorytrialText,
        jorytrialX + jorytrialW/2-(jorytrialText:getWidth() * textScale)/2,
        jorytrialY + jorytrialH/2-(jorytrialText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local posttrialText = love.graphics.newText(GameFont, "Post-Trial")
    love.graphics.draw(
        posttrialText,
        posttrialX + posttrialW/2-(posttrialText:getWidth() * textScale)/2,
        posttrialY + posttrialH/2-(posttrialText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

browseSceneSelections = {}
browseSceneSelections[0] = "Back";
browseSceneSelections[1] = "Jory's Trial";
browseSceneSelections[2] = "Post-Trial";
TitleSelection = "Back";
SelectionIndex = 0;

BrowseScreenConfig = {
    displayed = false;
    onKeyPressed = function (key)
        if key == controls.start_button then
            love.graphics.clear(0,0,0);
            if TitleSelection == "Back" then
                Sounds["SELECTBLIP2"]:play()
                screens.title.displayed = true;
                DrawTitleScreen();
                screens.browsescenes.displayed = false;
                TitleSelection = "Case Select";
                SelectionIndex = 1;
            elseif TitleSelection == "Jory's Trial" then
                Sounds["SELECTBLIP2"]:play()
                screens.jorytrial.displayed = true;
                DrawJoryTrialScreen();
                screens.browsescenes.displayed = false;
                SelectionIndexX = 0;
                SelectionIndexY = 0;
            elseif TitleSelection == "Post-Trial" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.posttrial_path):begin()
                screens.browsescenes.displayed = false;
            end
        elseif key == controls.press_right then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 2) then
                SelectionIndex = 0;
            end
            TitleSelection = browseSceneSelections[SelectionIndex]
        elseif key == controls.press_left then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 2;
            end
            TitleSelection = browseSceneSelections[SelectionIndex]
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