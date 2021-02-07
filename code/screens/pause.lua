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
                title = "Close",
                key = controls.pause
            },
            {
                title = "Back to menu",
                key = "End"
            }
        },
    })

    -- Temporary text where the settings should go
    local pauseHeader = love.graphics.newText(GameFont, "PAUSED")
    love.graphics.setColor(unpack(colors.white))
    love.graphics.draw(pauseHeader, GetCenterOffset(pauseHeader:getWidth() * 2), 120, 0, 2, 2)

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


end

PauseScreenConfig = {
    displayed = false;
    displayKey = controls.pause;
    displayCondition = function()
        -- Don't let the pause menu show until the scene has
        -- started (AKA we're off the title screen)
        return Episode.loaded;
    end;
    onKeyPressed = function(key)
        if key == "end" then
            screens.pause.displayed = false
            for i,v in pairs(Music) do
                v:stop()
            end
            DrawTitleScreen()
            Episode:stop()
            screens.title.displayed = true
            TitleSelection = "New Game";
            SelectionIndex = 0;
        end
    end;
    draw = function ()
        DrawPauseScreen()
    end
}