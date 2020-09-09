function DrawOptionsScreen()

    love.graphics.clear(unpack(colors.black))

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackScale = 3

    local backW = (dimensions.window_width * 1/5)
    local backX = (dimensions.window_width * 1/18)
    local backY = blackImage:getHeight()*blackScale + 10
    local backH = 60

    local debugW = (dimensions.window_width * 1/3.75)
    local debugX = (dimensions.window_width * 10.75/18) - debugW
    local debugY = blackImage:getHeight()*blackScale + 10
    local debugH = 60

    local volumeW = (dimensions.window_width * 1/3.75)
    local volumeX = (dimensions.window_width * 17/18) - volumeW
    local volumeY = blackImage:getHeight()*blackScale + 10
    local volumeH = 60
    
    local controlsW = (dimensions.window_width * 1/3.75)
    local controlsX = (dimensions.window_width * 17/18) - controlsW
    local controlsY = blackImage:getHeight()*blackScale - 50
    local controlsH = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Debug Mode" then
        love.graphics.rectangle("fill", debugX-dx, debugY-dy, debugW+2*dx, debugH+2*dy)
        love.graphics.draw(
            blackImage,
            GetCenterOffset(blackImage:getWidth() * blackImageScale, false),
            0,
            0,
            blackImageScale,
            blackImageScale
        )
    elseif TitleSelection == "Volume" then
        love.graphics.rectangle("fill", volumeX-dx, volumeY-dy, volumeW+2*dx, volumeH+2*dy)
        love.graphics.draw(
            blackImage,
            GetCenterOffset(blackImage:getWidth() * blackImageScale, false),
            0,
            0,
            blackImageScale,
            blackImageScale
        )
    elseif TitleSelection == "Controls" then
        love.graphics.rectangle("fill", controlsX-dx, controlsY-dy, controlsW+2*dx, controlsH+2*dy)
        love.graphics.draw(
            controlsImage,
            GetCenterOffset(blackImage:getWidth() * blackImageScale, false),
            0,
            0,
            blackImageScale,
            blackImageScale
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

    if settings.debug then
        love.graphics.setColor(50,205,50)
    else
        love.graphics.setColor(55,0,0)
    end
    love.graphics.rectangle("fill", debugX, debugY, debugW, debugH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", volumeX, volumeY, volumeW, volumeH)
    love.graphics.setColor(0.25,0.41,0.88)
    love.graphics.rectangle("fill", volumeX, volumeY, volumeW * settings.master_volume, volumeH)

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

    local debugText = love.graphics.newText(GameFont, "Debug Mode")
    love.graphics.draw(
        debugText,
        debugX + debugW/2-(debugText:getWidth() * textScale)/2,
        debugY + debugH/2-(debugText:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local volumeText = love.graphics.newText(GameFont, "Volume ("..(settings.master_volume * 100).."%)")
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
optionsSelections[1] = "Debug Mode";
optionsSelections[2] = "Volume";
optionsSelections[3] = "Controls";
TitleSelection = "Back";
SelectionIndex = 0;

OptionsConfig = {
    displayed = false;
    onKeyPressed = function (key)
        if key == controls.start_button then
            love.graphics.clear(0,0,0);
            if TitleSelection == "Back" then
                Sounds["SELECTBLIP2"]:play()
                screens.title.displayed = true;
                DrawTitleScreen();
                screens.options.displayed = false;
                TitleSelection = "Options";
                SelectionIndex = 1;
            elseif TitleSelection == "Debug Mode" then
                Sounds["SELECTBLIP2"]:play()
                if settings.debug then
                    settings.debug = false
                else
                    settings.debug = true
                end
            elseif TitleSelection == "Controls" then
                Sounds["SELECTBLIP2"]:play()
            end
        elseif key == controls.press_nav_up then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndex = SelectionIndex + 1
            if (SelectionIndex > 3) then
                SelectionIndex = 0;
            end
            TitleSelection = optionsSelections[SelectionIndex]
        elseif key == controls.press_nav_down then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndex = SelectionIndex - 1
            if (SelectionIndex < 0) then
                SelectionIndex = 3;
            end
            TitleSelection = optionsSelections[SelectionIndex]
        elseif key == controls.press_right then
            if TitleSelection == "Volume" then
                Sounds["SELECTBLIP2"]:play()
                settings.master_volume = settings.master_volume + 0.01
            end
        elseif key == controls.press_left then
            if TitleSelection == "Volume" then
                Sounds["SELECTBLIP2"]:play()
                settings.master_volume = settings.master_volume - 0.01
            end
        end
    end;
    onDisplay = function()
        screens.options.displayed = true
        screens.title.displayed = false
    end;
    draw = function()
        if screens.options.displayed == true then
            DrawOptionsScreen()
        end
    end;
}