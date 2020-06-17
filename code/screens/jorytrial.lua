function DrawJoryTrialScreen()

    love.graphics.clear(unpack(colors.black))

    local blackImage = love.graphics.newImage(settings.black_screen_path)
    local blackScale = 3

    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local backW = (dimensions.window_width * 1/7)
    local backX = (dimensions.window_width * 1/24)
    local backY = blackImage:getHeight()*blackScale + 10
    local backH = 60

    local part1W = (dimensions.window_width * 1/5)
    local part1X = (dimensions.window_width * 3/12) - part1W
    local part1Y = blackImage:getHeight()*blackScale - 500
    local part1H = 60

    local part2W = (dimensions.window_width * 1/5)
    local part2X = (dimensions.window_width * 6/12) - part2W
    local part2Y = blackImage:getHeight()*blackScale - 500
    local part2H = 60

    local part3W = (dimensions.window_width * 1/5)
    local part3X = (dimensions.window_width * 9/12) - part3W
    local part3Y = blackImage:getHeight()*blackScale - 500
    local part3H = 60

    local part4W = (dimensions.window_width * 1/5)
    local part4X = (dimensions.window_width * 3/12) - part4W
    local part4Y = blackImage:getHeight()*blackScale - 300
    local part4H = 60

    local part5W = (dimensions.window_width * 1/5)
    local part5X = (dimensions.window_width * 6/12) - part5W
    local part5Y = blackImage:getHeight()*blackScale - 300
    local part5H = 60

    local part6W = (dimensions.window_width * 1/5)
    local part6X = (dimensions.window_width * 9/12) - part6W
    local part6Y = blackImage:getHeight()*blackScale - 300
    local part6H = 60

    local dx = 8
    local dy = 8

    love.graphics.setColor(0.44,0.56,0.89)
    if TitleSelection == "Part 1" then
        love.graphics.rectangle("fill", part1X-dx, part1Y-dy, part1W+2*dx, part1H+2*dy)
    elseif TitleSelection == "Part 2" then
        love.graphics.rectangle("fill", part2X-dx, part2Y-dy, part2W+2*dx, part2H+2*dy)
    elseif TitleSelection == "Part 3" then
        love.graphics.rectangle("fill", part3X-dx, part3Y-dy, part3W+2*dx, part3H+2*dy)
    elseif TitleSelection == "Part 4" then
        love.graphics.rectangle("fill", part4X-dx, part4Y-dy, part4W+2*dx, part4H+2*dy)
    elseif TitleSelection == "Part 5" then
        love.graphics.rectangle("fill", part5X-dx, part5Y-dy, part5W+2*dx, part5H+2*dy)
    elseif TitleSelection == "Part 6" then
        love.graphics.rectangle("fill", part6X-dx, part6Y-dy, part6W+2*dx, part6H+2*dy)
    else
        love.graphics.rectangle("fill", backX-dx, backY-dy, backW+2*dx, backH+2*dy)
    end

    love.graphics.setColor(222, 0, 0)
    love.graphics.rectangle("fill", backX, backY, backW, backH)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part1X, part1Y, part1W, part1H)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part2X, part2Y, part2W, part2H)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part3X, part3Y, part3W, part3H)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part4X, part4Y, part4W, part4H)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part5X, part5Y, part5W, part5H)

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", part6X, part6Y, part6W, part6H)

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

    local part1Text = love.graphics.newText(GameFont, "Part 1")
    love.graphics.draw(
        part1Text,
        part1X + part1W/2-(part1Text:getWidth() * textScale)/1.5,
        part1Y + part1H/2-(part1Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local part2Text = love.graphics.newText(GameFont, "Part 2")
    love.graphics.draw(
        part2Text,
        part2X + part2W/2-(part2Text:getWidth() * textScale)/2,
        part2Y + part2H/2-(part2Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local part3Text = love.graphics.newText(GameFont, "Part 3")
    love.graphics.draw(
        part3Text,
        part3X + part3W/2-(part3Text:getWidth() * textScale)/2,
        part3Y + part3H/2-(part3Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local part4Text = love.graphics.newText(GameFont, "Part 4")
    love.graphics.draw(
        part4Text,
        part4X + part4W/2-(part4Text:getWidth() * textScale)/2,
        part4Y + part4H/2-(part4Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local part5Text = love.graphics.newText(GameFont, "Part 5")
    love.graphics.draw(
        part5Text,
        part5X + part5W/2-(part5Text:getWidth() * textScale)/2,
        part5Y + part5H/2-(part5Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    local part6Text = love.graphics.newText(GameFont, "Part 6")
    love.graphics.draw(
        part6Text,
        part6X + part6W/2-(part6Text:getWidth() * textScale)/2,
        part6Y + part6H/2-(part6Text:getHeight() * textScale)/2,
        0,
        textScale,
        textScale
    )

    return self
end

jorySceneSelections = {}
for x = 0, 2 do
    jorySceneSelections[x] = {}

    for y = 0, 2 do
        jorySceneSelections[x][y] = 0
    end
end
jorySceneSelections[0][0] = "Back"
jorySceneSelections[0][2] = "Part 1"
jorySceneSelections[1][2] = "Part 2"
jorySceneSelections[2][2] = "Part 3"
jorySceneSelections[0][1] = "Part 4"
jorySceneSelections[1][1] = "Part 5"
jorySceneSelections[2][1] = "Part 6"
TitleSelection = "Back";
SelectionIndexX = 0;
SelectionIndexY = 0;

JoryTrialConfig = {
    displayed = false;
    onKeyPressed = function (key)
        print(TitleSelection.." ("..SelectionIndexX..", "..SelectionIndexY..")")
        if key == controls.start_button then
            love.graphics.clear(0,0,0);
            if TitleSelection == "Back" then
                Sounds["SELECTBLIP2"]:play()
                screens.browsescenes.displayed = true;
                DrawBrowseScreen();
                screens.jorytrial.displayed = false;
                TitleSelection = "Jory's Trial";
                SelectionIndex = 2;
            elseif TitleSelection == "Part 1" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_1_path):begin()
                screens.jorytrial.displayed = false;
            elseif TitleSelection == "Part 2" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_2_path):begin()
                screens.jorytrial.displayed = false;
            elseif TitleSelection == "Part 3" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_3_path):begin()
                screens.jorytrial.displayed = false;
            elseif TitleSelection == "Part 4" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_4_path):begin()
                screens.jorytrial.displayed = false;
            elseif TitleSelection == "Part 5" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_5_path):begin()
                screens.jorytrial.displayed = false;
            elseif TitleSelection == "Part 6" then
                Sounds["SELECTJINGLE"]:play()
                NewEpisode(settings.jory_trial_6_path):begin()
                screens.jorytrial.displayed = false;
            end
        elseif key == controls.press_right then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndexX = SelectionIndexX + 1
            if SelectionIndexY == 0 then
                if (SelectionIndexX > 0) then
                    SelectionIndexX = 0
                end
            else
                if (SelectionIndexX > 2) then
                    SelectionIndexX = 0
                end
            end
            TitleSelection = jorySceneSelections[SelectionIndexX][SelectionIndexY]
        elseif key == controls.press_left then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndexX = SelectionIndexX - 1
            if SelectionIndexY == 0 then
                if (SelectionIndexX < 0) then
                    SelectionIndexX = 0
                end
            else
                if (SelectionIndexX < 0) then
                    SelectionIndexX = 2
                end
            end
            TitleSelection = jorySceneSelections[SelectionIndexX][SelectionIndexY]
        elseif key == controls.pause_nav_up then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndexY = SelectionIndexY + 1
            if SelectionIndexX == 0 then
                if (SelectionIndexY > 2) then
                    SelectionIndexY = 0
                end
            else
                if (SelectionIndexY > 2) then
                    SelectionIndexY = 1
                end
            end
            TitleSelection = jorySceneSelections[SelectionIndexX][SelectionIndexY]
        elseif key == controls.pause_nav_down then
            Sounds["SELECTBLIP2"]:play()
            SelectionIndexY = SelectionIndexY - 1
            if SelectionIndexX == 0 then
                if (SelectionIndexY < 0) then
                    SelectionIndexY = 2
                end
            else
                if (SelectionIndexY < 1) then
                    SelectionIndexY = 2
                end
            end
            TitleSelection = jorySceneSelections[SelectionIndexX][SelectionIndexY]
        end
    end;
    onDisplay = function()
        screens.jorytrial.displayed = true
        screens.browsescenes.displayed = false
    end;
    draw = function()
        if screens.jorytrial.displayed == true then
            DrawJoryTrialScreen()
        end
    end;
}