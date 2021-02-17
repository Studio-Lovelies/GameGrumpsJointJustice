function DrawCenteredRectangle(options)
    local borderSize = options.borderSize or 4
    local borderColorAlpha = options.borderColorAlpha or {1, 1, 1, 1}
    local colorAlpha = options.colorAlpha or {0.169, 0.526, 0.722}

    local buttons = options.buttons or {}
    local title = options.title
    local titleHeight = options.titleHeight or 18

    local body = options.body
    local bodyHeight = options.bodyHeight or 380
    local bodyPadding = options.bodyPadding or 80

    local width = options.width
    local height = options.height
    local topLeftX = (love.graphics.getWidth() - width)/2
    local topLeftY = (love.graphics.getHeight() - height)/2

    -- Shift the box down a little to account for the tab
    if title then
        height = height - titleHeight
        topLeftY = topLeftY + titleHeight
    end

    if borderSize > 0 then
        love.graphics.setColor(unpack(borderColorAlpha))
        love.graphics.rectangle(
            "fill",
            topLeftX - borderSize,
            topLeftY - borderSize,
            width + (2 * borderSize),
            height + (2 * borderSize)
        )
    end

    love.graphics.setColor(unpack(colorAlpha))
    love.graphics.rectangle(
        "fill",
        topLeftX,
        topLeftY,
        width,
        height
    )

    if body then
        love.graphics.setColor(unpack(colors.white))
        love.graphics.rectangle(
            "fill",
            topLeftX + borderSize,
            topLeftY + borderSize,
            width - borderSize * 2,
            bodyHeight
        )

        local selectedTopLeftX = topLeftX + borderSize + bodyPadding
        local selectedTopLeftY = topLeftY + borderSize + bodyPadding + titleHeight
        local selectedPadding = 30
        -- TODO: Default styling for an empty Evidence/Profiles UI (if that ever happens)
        local imageWidth = body.selected ~= nil and body.selected.image:getWidth() or 200
        local selectedDetailsWidth = width - (borderSize * 2 + imageWidth * 4 + selectedPadding * 2 + bodyPadding)
        local selectedDetailHorizontalPadding = 15
        local selectedDetailVerticalPadding = 80

        local highlightedR, highlightedG, highlightedB = RGBColorConvert(254,195,33)

        if body.selected then
            love.graphics.draw(
                body.selected.image,
                selectedTopLeftX,
                selectedTopLeftY,
                0,
                4,
                4
            )

            local detailTitleHeight = 40
            local detailX = selectedTopLeftX + imageWidth * 4 + selectedPadding
            local detailTextX = detailX + selectedDetailHorizontalPadding

            -- Highlight title
            love.graphics.setColor(highlightedR, highlightedG, highlightedB)
            love.graphics.rectangle(
                "fill",
                detailX,
                selectedTopLeftY + 10,
                selectedDetailsWidth,
                detailTitleHeight
            )

            -- Write the title
            love.graphics.setColor(unpack(colors.black))
            love.graphics.print(
                body.selected.title,
                detailTextX,
                selectedTopLeftY + 10,
                0,
                3,
                3
            )

            local detailTextY = selectedTopLeftY + detailTitleHeight + selectedDetailVerticalPadding
            local detailTextLineHeight = 60
            local dashLength = 6
            local dashSpaceSize = 4

            -- Draw the lines for the details
            DrawDashedLine(detailX, detailTextY, detailX + selectedDetailsWidth, detailTextY, dashLength, dashSpaceSize)
            DrawDashedLine(detailX, detailTextY + detailTextLineHeight, detailX + selectedDetailsWidth, detailTextY + detailTextLineHeight, dashLength, dashSpaceSize)
            DrawDashedLine(detailX, detailTextY + detailTextLineHeight * 2, detailX + selectedDetailsWidth, detailTextY + detailTextLineHeight * 2, dashLength, dashSpaceSize)

            -- Write the details
            GameFont:setLineHeight(1.9)
            love.graphics.printf(
                body.selected.details,
                detailTextX,
                detailTextY - 35,
                selectedDetailsWidth / 2 - selectedDetailHorizontalPadding,
                left,
                0,
                2,
                2
            )
        end

        if body.options and #body.options > 0 then
            local optionDetailsPadding = 25
            local optionHorizontalPadding = 10
            local optionWidth = 96
            local lastOptionX = topLeftX + optionDetailsPadding
            local optionY = topLeftY + borderSize + bodyHeight + 20
            -- TODO: Adding pixels to center the icons because
            -- they have a grey background right now and don't fit
            -- the square perfectly. This seems janky.
            local centerPadding = 2

            local cornerBorderSize
            local cornerBorderLength
            for i=1, 9 do
                love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
                love.graphics.rectangle(
                    "fill",
                    lastOptionX + centerPadding,
                    optionY + centerPadding,
                    optionWidth,
                    optionWidth
                )

                cornerBorderSize = 5
                cornerBorderLength = 15
                if i <= #body.options then
                    -- Specifically needed for the opacity, corners, and triangle
                    love.graphics.setColor(unpack(colors.white))
                    love.graphics.draw(
                        body.options[i],
                        lastOptionX + centerPadding,
                        optionY + centerPadding,
                        0,
                        1.5,
                        1.5
                    )

                    -- Draw a tiny white triangle to show it's been selected
                    local triangleWidth = 60
                    local triangleHeight = 40
                    if body.selected and body.selected.image == body.options[i] then
                        love.graphics.polygon(
                            "fill",
                            lastOptionX + optionWidth/2 - triangleWidth/2,
                            optionY - triangleHeight,
                            lastOptionX + optionWidth/2 + triangleWidth/2,
                            optionY - triangleHeight,
                            lastOptionX + optionWidth/2,
                            optionY
                        )
                        love.graphics.setColor(highlightedR, highlightedG, highlightedB)
                        cornerBorderSize = 6
                        cornerBorderLength = 24
                    end
                else
                    love.graphics.setColor(1, 1, 1, 0.5)
                end

                -- Draw the corners with the color already set
                DrawCorner('topLeft', lastOptionX, optionY, cornerBorderSize, cornerBorderLength)
                DrawCorner('topRight', lastOptionX + optionWidth + (centerPadding * 2), optionY, cornerBorderSize, cornerBorderLength)
                DrawCorner('bottomLeft', lastOptionX, optionY + optionWidth + (centerPadding * 2), cornerBorderSize, cornerBorderLength)
                DrawCorner('bottomRight', lastOptionX + optionWidth + (centerPadding * 2), optionY + optionWidth + (centerPadding * 2), cornerBorderSize, cornerBorderLength)

                lastOptionX = lastOptionX + optionWidth + optionHorizontalPadding
            end
        end
    end

    if title then
        local titleColorAlpha = options.titleColorAlpha or {1, 1, 1, 1}
        local titleWidth = options.titleWidth or 220
        local titlePadding = options.titlePadding or 5
        local titleSlantWidth = options.titleSlantWidth or 20

        if borderSize > 0 then
            -- Title tab border
            love.graphics.setColor(unpack(borderColorAlpha))
            love.graphics.polygon(
                "fill",
                topLeftX - borderSize,
                topLeftY - titleHeight - borderSize,
                topLeftX + titleWidth + borderSize,
                topLeftY - titleHeight - borderSize,
                topLeftX + titleWidth + titleSlantWidth + borderSize,
                topLeftY,
                topLeftX - borderSize,
                topLeftY
            )
        end

        -- Title tab background
        love.graphics.setColor(unpack(colorAlpha))
        love.graphics.polygon(
            "fill",
            topLeftX,
            topLeftY - titleHeight,
            topLeftX + titleWidth,
            topLeftY - titleHeight,
            topLeftX + titleWidth + titleSlantWidth,
            topLeftY,
            topLeftX,
            topLeftY
        )

        if body then
            -- Bottom "half" of the title tab background
            love.graphics.polygon(
                "fill",
                topLeftX,
                topLeftY + borderSize,
                topLeftX + titleWidth + titleSlantWidth,
                topLeftY + borderSize,
                topLeftX + titleWidth,
                topLeftY + borderSize + titleHeight,
                topLeftX,
                topLeftY + borderSize + titleHeight
            )
        end

        -- Title tab text
        love.graphics.setColor(unpack(titleColorAlpha))
        love.graphics.print(title, topLeftX + titlePadding * 2, topLeftY - titleHeight + titlePadding, 0, 2, 2)
    end

    if #buttons > 0 then
        local buttonColorAlpha = options.buttonColorAlpha or {0, 0, 0, 1}
        local buttonTabColorAlpha = options.buttonTabColorAlpha or {1, 1, 1, 1}
        local buttonKeyColorAlpha = options.buttonKeyColorAlpha or {1, 1, 1, 1}
        local buttonKeyBackgroundColorAlpha = options.buttonKeyBackgroundColorAlpha or {0.169, 0.526, 0.722}
        local buttonPadding = options.buttonPadding or 30
        local buttonSlantWidth = options.buttonSlantWidth or 30
        local buttonTabHeight = options.buttonHeight or 30
        local buttonTextPadding = options.buttonTextPadding or 5

        -- Approximate the width we'll need to display all the buttons
        -- Eventually this could just be an asset
        local buttonTabWidth = 0
        for i=1, #buttons do
            local buttonKey = love.graphics.newText(GameFont, buttons[i].key)
            local buttonTitle = love.graphics.newText(GameFont, buttons[i].title)

            local keyLen = #(buttons[i].key)
            local keyHeight = buttonTabHeight - (buttonTextPadding * 2)
            local keyWidth = keyLen > 1 and buttonKey:getWidth() + (buttonTextPadding * 2) or keyHeight

            buttonTabWidth = buttonTabWidth +
                (i > 1 and buttonPadding or 0) +
                keyWidth +
                buttonTitle:getWidth() + (buttonTextPadding * 2)
        end

        local bottomRightX = topLeftX + width
        local bottomRightY = topLeftY + height

        -- Button tab background
        love.graphics.setColor(unpack(buttonTabColorAlpha))
        love.graphics.polygon(
            "fill",
            bottomRightX - buttonTabWidth,
            bottomRightY - buttonTabHeight,
            bottomRightX,
            bottomRightY - buttonTabHeight,
            bottomRightX,
            bottomRightY,
            bottomRightX - buttonTabWidth - buttonSlantWidth,
            bottomRightY
        )

        local lastX = bottomRightX - buttonTabWidth
        local keyY = bottomRightY - buttonTabHeight + buttonTextPadding
        local keyHeight = buttonTabHeight - (buttonTextPadding * 2)
        for i=1, #buttons do
            local buttonKey = love.graphics.newText(GameFont, GetKeyDisplayName(buttons[i].key))
            local buttonTitle = love.graphics.newText(GameFont, buttons[i].title)

            local keyLen = #(buttons[i].key)
            local keyX = lastX + (i > 1 and buttonPadding or 0)
            local keyWidth = keyLen > 1 and buttonKey:getWidth() + (buttonTextPadding * 2) or keyHeight

            -- Button key indicator
            love.graphics.setColor(unpack(buttonKeyBackgroundColorAlpha))
            love.graphics.rectangle(
                "fill",
                keyX,
                keyY,
                keyWidth,
                keyHeight,
                2,
                2
            )

            -- Button key text
            love.graphics.setColor(unpack(buttonKeyColorAlpha))
            love.graphics.draw(buttonKey, keyX + buttonTextPadding, keyY + 2, 0, 1, 1)

            -- Button command text
            love.graphics.setColor(unpack(buttonColorAlpha))
            love.graphics.draw(buttonTitle, keyX + keyWidth + buttonTextPadding, keyY + 2, 0, 1, 1)

            -- Keep track of where this button ended so we know where to start
            lastX = keyX + keyWidth + buttonTextPadding + buttonTitle:getWidth()
        end
    end
end

-- Given the width of the drawable, return the x value to use to center the element
-- on the screen
function GetCenterOffset(elementWidth, isScaled)
    isScaled = isScaled == nil and true or isScaled
    if isScaled then
        return ((dimensions.window_width / dimensions.graphics_scale) - elementWidth/2)
    else
        return (dimensions.window_width - elementWidth/2)
    end
end

function DrawDashedLine(x1, y1, x2, y2, spaceSize, dashSize)
    love.graphics.setPointSize(1)

    local x, y = x2 - x1, y2 - y1
    local len = math.sqrt(x^2 + y^2)
    local stepx, stepy = x / len, y / len
    x = x1
    y = y1

    -- Initialize it as the space passed in so we start off with a dash
    local currentSpaceLength = spaceSize
    local currentDashLength = 0
    local drawPoint = true
    for i = 1, len do
        if currentDashLength == dashSize then
            currentDashLength = 0
            drawPoint = false
        elseif currentSpaceLength == spaceSize then
            currentSpaceLength = 0
            drawPoint = true
        elseif currentDashLength < dashSize then
            drawPoint = true
        else
            drawPoint = false
        end

        if drawPoint then
            love.graphics.points(x, y)
            currentDashLength = currentDashLength + 1
        else
            currentSpaceLength = currentSpaceLength + 1
        end
        x = x + stepx
        y = y + stepy
    end
end

function DrawCorner(direction, x, y, borderSize, borderLength)
    if direction == 'topLeft' then
        love.graphics.polygon("fill", x, y, x + borderLength, y, x + borderLength, y + borderSize, x + borderSize, y + borderSize, x + borderSize, y + borderLength, x, y + borderLength)
    elseif direction == 'topRight' then
        love.graphics.polygon("fill", x, y, x, y + borderLength, x - borderSize, y + borderLength, x - borderSize, y + borderSize, x - borderLength, y + borderSize, x - borderLength, y)
    elseif direction == 'bottomLeft' then
        love.graphics.polygon("fill", x, y, x, y - borderLength, x + borderSize, y - borderLength, x + borderSize, y - borderSize, x + borderLength, y - borderSize, x + borderLength, y)
    else
        love.graphics.polygon("fill", x, y, x, y - borderLength, x - borderSize, y - borderLength, x - borderSize, y - borderSize, x - borderLength, y - borderSize, x - borderLength, y)
    end
end