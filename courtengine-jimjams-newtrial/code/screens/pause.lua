-- TODO: This matches the Switch UI but not the DS UI, and should be updated
-- after the art team has established the look
function DrawPauseScreen(self)
    -- Add a light overlay
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Add the settings box with a 2px white outline
    DrawCenteredRectangle({
        width = love.graphics.getWidth() * 3/5,
        height = love.graphics.getHeight() - 120,
        buttons = {
            {
                title = "Back",
                key = controls.pause
            },
        },
    })

    -- Temporary text where the settings should go
    local pauseHeader = love.graphics.newText(GameFont, "PAUSED")
    love.graphics.setColor(unpack(colors.white))
    love.graphics.draw(pauseHeader, GetCenterOffset(pauseHeader:getWidth() * 2, false), 120, 0, 2, 2)

    -- Temporary(?) tools for easier developing/testing
    local boxWidth = love.graphics.getWidth() * 3/5 - 70
    local boxHeight = 380
    love.graphics.setColor(0.75, 0.75, 0.75, 0.5)
    love.graphics.rectangle(
        "fill",
        290,
        180,
        boxWidth,
        boxHeight
    )

    -- Use the default fonttype in lua so we can print out ALL characters, not just the ones
    -- with a corresponding character in our font sheets
    local defaultFont = love.graphics.newFont(14)
    defaultFont:setLineHeight(1.4)
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(unpack(colors.white))

    local textX = 300
    local textY = 200
    local printDetails = {}
    local defaultText = "NONE"
    love.graphics.printf("Scene Details", GetCenterOffset(0, false) - 55, textY, boxWidth - 80, left)

    local currentLocation = defaultText
    local currentMusic = defaultText
    local currentDisplayedCharacter = defaultText
    local currentDisplayedPose = defaultText
    local currentSpeaker = defaultText
    local currentText = defaultText
    local currentScriptCommand = defaultText
    if CurrentScene.location ~= nil then
        if CurrentScene.location ~= "NONE" then
            currentLocation = settings.background_directory..string.lower(CurrentScene.location)..".png"
        else
            currentLocation = CurrentScene.location
        end

        if CurrentScene.characterLocations[CurrentScene.location] ~= nil then
            currentDisplayedCharacter = CurrentScene.characterLocations[CurrentScene.location].name

            if CurrentScene.characters[currentDisplayedCharacter] ~= nil then
                currentDisplayedPose = settings.character_directory..currentDisplayedCharacter.."/"..CurrentScene.characters[currentDisplayedCharacter].frame..".png"
            end
        end
    end
    if CurrentScene.music ~= nil then
        currentMusic = settings.music_directory..string.lower(CurrentScene.music)..".mp3"
    end
    if CurrentScene.textTalker ~= nil then
        currentSpeaker = CurrentScene.textTalker
        currentText = CurrentScene.text
    end
    -- The first item on the stack is always the one we're looking at
    if #CurrentScene.stack[1].lineParts > 0 then
        currentScriptCommand = CurrentScene.stack[1].lineParts[1]
    end

    table.insert(printDetails, "Script File:                          "..CurrentScene.scriptPath);
    table.insert(printDetails, "Background Location:     "..currentLocation);
    table.insert(printDetails, "Background Music            "..currentMusic);
    table.insert(printDetails, "");
    table.insert(printDetails, "Displayed Character:      "..currentDisplayedCharacter);
    table.insert(printDetails, "Displayed Pose:                "..currentDisplayedPose);
    table.insert(printDetails, "");
    table.insert(printDetails, "Speaking Character:       "..currentSpeaker);
    table.insert(printDetails, "Rendered Text:                "..currentText);
    table.insert(printDetails, "");
    table.insert(printDetails, "");
    table.insert(printDetails, "Script Command:            "..currentScriptCommand);

    for i=1, #printDetails do
        love.graphics.printf(printDetails[i], textX, textY + 10 + (i * 20), boxWidth - 80, left)
    end

    for j=2, #CurrentScene.stack[1].lineParts do
        love.graphics.printf(
            CurrentScene.stack[1].lineParts[j],
            textX + ((j - 1) *20),
            textY + 10 + ((#printDetails + 1) * 20) + ((j - 2)*20),
            boxWidth - 80,
            left
        )
    end


end

PauseScreenConfig = {
    displayed = false;
    displayKey = controls.pause;
    displayCondition = function ()
        -- Don't let the pause menu show until the scene has
        -- started (AKA we're off the title screen)
        return Episode.loaded;
    end;
    draw = function ()
        DrawPauseScreen()
    end
}