function NewScene(scriptPath)
    local self = {}
    self.scriptPath = scriptPath
    self.location = "NONE"
    self.music = "NONE"
    self.characterLocations = {}
    self.characters = {}
    self.evidence = {}
    self.profiles = {}
    self.flags = {}
    self.showing = nil
    self.bigimage = nil
    self.closeUp = false
    self.backgroundCloseUpX = {0, -320, -640, -960, -1280, -1600, -1920, -2240}
    self.backgroundCloseUpIndex = 1
    self.skipIncrement = false

    self.index = 1
    self.canAdvance = false

    self.timerStarted = false
    self.konamiTimer = 2
    self.sequence = {}

    self.penalties = 5
    self.textHidden = false
    self.text = "empty"
    self.fullText = "empty"
    self.textTalker = ""
    self.textBoxSprite = Sprites["TextBox"]
    self.textColor = {1,1,1}
    self.textCentered = false

    self.credits = nil
    self.creditLines = {}

    self.charAnimIndex = 1

    self.wasPressingRight = false
    self.wasPressingLeft = false

    -- the script is loaded into the court scene's events table
    -- function definitions are stored in the court scene's definitions table
    -- the script is made up of individual "events"
    -- events are defined in scriptevents.lua
    LoadScript(self, scriptPath)
    self.currentEventIndex = 1

    -- run a function definition defined in the script
    self.runDefinition = function(self, defName, loc)
        if loc == nil then
            loc = 1
        end

        local definitions = deepcopy(self.definitions[defName])
        for i=#definitions, 1, -1 do
            table.insert(self.stack, loc, definitions[i])
        end
    end

    self.update = function(self, dt)
        -- update the active event
        self.canShowCharacter = true
        self.textCentered = false
        self.textBoxSprite = Sprites["TextBox"]
        self.characterTalking = false
        self.canShowBgTopLayer = true
        self.removes = 0

        if #self.stack > 0 then
            if self.stack[1].event.sync == nil or self.stack[1].event.sync ~= "true" then
                while #self.stack >= 1 and not self.stack[1].event:update(self, dt) do
                    table.remove(self.stack, 1)
                    self.currentEventIndex = self.currentEventIndex + 1
                end
            elseif self.stack[1].event.sync == "true" then
                for i = 1, 2 do
                    if not self.stack[i].event:update(self, dt) then
                        table.remove(self.stack, i)
                        self.removes = self.removes + 1
                        if i == 1 then
                            break
                        end
                    end
                end
                self.currentEventIndex = self.currentEventIndex + self.removes
            end
        end

        self.charAnimIndex = self.charAnimIndex + dt*5

        if self.credits ~= nil and #self.creditLines > 1 then
            for i = 1, #self.creditLines do
                if self.creditLines[#self.creditLines][3] > 60 then
                    self.creditLines[i][3] = self.creditLines[i][3] - 0.5
                end
            end
        end

        self.index = self.index + 0.2
        if self.index > 4 then
            self.index = 1
        end

        if self.timerStarted then
            self.konamiTimer = self.konamiTimer - dt*2
            if self.konamitTimer <= 0 then
                self.konamiTimer = 2
            end
        end
    end

    self.drawCharacterAt = function(self, characterLocation, x,y)
        local character = self.characterLocations[characterLocation]
        if character ~= nil then
            if self.characters[character.name].poses[character.frame] ~= nil then
                char = self.characters[character.name]
                pose = char.poses[character.frame]
            else
                char = self.characters[character.name]
                pose = Sprites["MissingCharacterSprite"]
            end

            if self.characterTalking and char.name == self.textTalker then
                if char.poses[character.frame.."Talking"] ~= nil then
                    pose = char.poses[character.frame.."Talking"]
                else
                    pose = Sprites["MissingCharacterSpriteTalking"]
                end
            end

            if string.find(character.frame, "CloseUp") or string.find(character.frame, "CloseUpTalking") then
                self.closeUp = true
            else
                self.closeUp = false
            end

            if self.characters[character.name].poses[character.frame] ~= nil then
                if self.charAnimIndex >= #pose.anim then
                    self.charAnimIndex = 1
                end
                local animIndex = math.max(math.floor(self.charAnimIndex + 0.5), 1)
                local nextPose = pose.anim[animIndex]
                local curX, curY, width, height = nextPose:getViewport()
                -- If x is 0, we expect we wanted to center the image. Right now, not
                -- every asset has been updated to the correct aspect ratio, so calculate
                -- the amount we need to move it over by based on the width of the frame
                if x == 0 then
                    love.graphics.draw(pose.source, nextPose, GetCenterOffset(width), y)
                else
                    love.graphics.draw(pose.source, nextPose, x, y)
                end
            else
                love.graphics.draw(Sprites["MissingCharacterSprite"], 0, x, y)
            end
        end
    end

    self.drawBackgroundTopLayer = function(self, location, x, y)
        local background = Backgrounds[location]

        if self.closeUp then
            local background = Backgrounds["SPEEDLINE"]
        end

        if background[2] ~= nil then
            love.graphics.draw(background[2], x, y)
        end
    end

    --[[function love.keypressed(key)
        if self.credits ~= nil then
            startKonamiTimer(self)
            table.insert(self.sequence, key)
            if checkKonami(self.sequence) then
                print("YES KONAMI")
            end
        end
    end]]

    self.draw = function(self, dt)
        love.graphics.setColor(1, 1, 1)

        -- draw the background of the current location
        
        local background = Backgrounds[self.location]

        if self.closeUp then
            background = Backgrounds["SPEEDLINE"]
        end

        if background[1] ~= nil then

            x = camerapan[1]
            y = camerapan[2]

            if self.closeUp then  
                if self.backgroundCloseUpIndex > 8 then
                    self.backgroundCloseUpIndex = 1
                end
                x = self.backgroundCloseUpX[self.backgroundCloseUpIndex]
            end

            love.graphics.draw(background[1], x, y)
            if self.closeUp then
                if not self.skipIncrement then
                    self.backgroundCloseUpIndex = self.backgroundCloseUpIndex + 1
                    self.skipIncrement = true
                else self.skipIncrement = false
                end
            end
        end

        -- draw the character who is at the current location
        if self.canShowCharacter then
            self:drawCharacterAt(self.location, 0, 0)
        end

        love.graphics.setColor(1, 1, 1)
        if #self.stack >= 1 then
            if self.stack[1].event.characterDraw ~= nil then
                self.stack[1].event:characterDraw(self)
            end
        end

        -- draw the top layer of the environment, like desk on top of character
        if self.canShowBgTopLayer then
            self:drawBackgroundTopLayer(self.location, 0, 0)
        end

        -- if the current event has an associated graphic, draw it
        love.graphics.setColor(1, 1, 1)
        if #self.stack >= 1 then
            if self.stack[1].event.draw ~= nil then
                self.stack[1].event:draw(self)
            end
        end

        -- draw the textbox
        if not self.textHidden then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(self.textBoxSprite, 0, GraphicsHeight-self.textBoxSprite:getHeight())

            -- draw who is talking
            love.graphics.setFont(SmallFont)
            love.graphics.print(self.textTalker, 4, GraphicsHeight-self.textBoxSprite:getHeight())
            if self.font == "small" then
                love.graphics.setFont(SmallFont)
            else
                love.graphics.setFont(GameFont)
            end


            if self.showing ~= nil then
                love.graphics.setColor(1,1,1)
                if Sprites[self.showing[1]:gsub(" ", "")] == nil then
                    love.graphics.draw(Sprites["MissingTexture"], 16,16)
                else
                    if self.showing[2]:lower() == "left" or self.showing[2]:lower() == "l" then
                        love.graphics.draw(Sprites[self.showing[1]], 24, 24)
                    elseif self.showing[2]:lower() == "right" or self.showing[2]:lower() == "r" then
                        love.graphics.draw(Sprites[self.showing[1]], 234, 24)
                    end
                end
            end

            if self.bigimage ~= nil then
                love.graphics.setColor(1, 1, 1)
                if Sprites[self.bigimage:gsub(" ", "")] == nil then
                    love.graphics.draw(Sprites["MissingTexture"], 16, 16)
                else
                    love.graphics.draw(Sprites[self.bigimage], 0, 0, 0, dimensions.background_scale, dimensions.background_scale)
                end
            end

            -- draw the current scrolling text
            love.graphics.setColor(unpack(self.textColor))

            if not self.textCentered then
                local wrapIndices = {}

                local lineTable = {"", "", ""}
                local spaces = {}
                local lineTableIndex = 1
                local fullwords = ""
                local working = ""
                -- Space to allocate to the left and right of the text within the box
                local sidePadding = 20
                local wrapWidth = self.textBoxSprite:getWidth() - (sidePadding * 2)

                --
                for i = 1, #self.fullText do
                    local char = string.sub(self.fullText, i, i)

                    if char == " " or char == "#" then
                        table.insert(spaces, i)
                    end

                    local currentSentence = working .. char
                    if lineTableIndex < 3 then
                        if GameFont:getWidth(currentSentence) >= wrapWidth or char == "#" then
                            wrapIndices[lineTableIndex] = spaces[#spaces] + 1
                            lineTableIndex = lineTableIndex + 1
                            working = ""
                            fullwords = ""
                        end
                    end

                    working = working .. char
                end

                local lineTableIndex = 1

                for i=1, #self.text do
                    local char = string.sub(self.text, i,i)

                    if i == wrapIndices[lineTableIndex] then
                        lineTableIndex = lineTableIndex + 1
                    end

                    lineTable[lineTableIndex] = lineTable[lineTableIndex] .. char
                end

                local coloredLine1 = {}
                local coloredLine2 = {}
                local coloredLine3 = {}
                local string = ""
                colorSetup = {}

                -- Supports colored text within lines
                for i=1, #lineTable do
                    for j=1, #lineTable[i] do
                        if i == 1 then
                            coloredTable = coloredLine1
                        elseif i == 2 then
                            coloredTable = coloredLine2
                        elseif i == 3 then
                            coloredTable = coloredLine3
                        end

                        local char = string.sub(lineTable[i], j,j)

                        -- Sets the color at the beginning of the line
                        if i == 1 then
                            if j == 1 then
                                table.insert(coloredTable,self.textColor)
                            end
                        elseif j == 1 then
                            if colored then -- Continues the color onto a newline
                                table.insert(coloredTable,tempColor)
                            else
                                table.insert(coloredTable,self.textColor)
                            end
                        end

                        -- Checks for script color setup character "%"
                        if char == "%" then
                            colorSetup = {}
                            colorSetup["s"] = j+1
                        end

                        if colorSetup["s"] == j then
                            if char == "0" then --End of a colored segment, add the colored string to the table, then add the normal color back
                                table.insert(coloredTable,string)
                                string = ""
                                table.insert(coloredTable,self.textColor)
                                colored = nil
                            elseif char == "1" then -- Start of a colored segment, add the string before the new color to the table, then add the new color
                                table.insert(coloredTable,string)
                                string = ""
                                tempColor = {1,0,0}
                                table.insert(coloredTable,tempColor)
                                colored = true
                            elseif char == "2" then -- Start of a colored segment, add the string before the new color to the table, then add the new color
                                table.insert(coloredTable,string)
                                string = ""
                                tempColor = {0,1,0}
                                table.insert(coloredTable,tempColor)
                                colored = true
                            elseif char == "3" then -- Start of a colored segment, add the string before the new color to the table, then add the new color
                                table.insert(coloredTable,string)
                                string = ""
                                tempColor = {0,0,1}
                                table.insert(coloredTable,tempColor)
                                colored = true
                            else -- If not the start or end of a colored segment, simply add the character to the string to be added to the table
                                string = string..char
                            end
                        else
                            string = string..char
                        end

                        if j == #lineTable[i] then -- If it's the end of the line, add the string to the table, always ends on a string
                            table.insert(coloredTable,string)
                            string = ""
                        end
                    end
                end

                -- Resets things between speak events
                colored = nil
                colorSetup = {}

                -- If these lines are empty, adds a blank string to ensure it doesn't crash
                if coloredLine2[1] == nil then coloredLine2[1] = "" end
                if coloredLine3[1] == nil then coloredLine3[1] = "" end

                -- Combine the colored line tables into a single colored line table
                local coloredLineTable = {coloredLine1,coloredLine2,coloredLine3}

                -- Prints
                for i=1, #lineTable do
                    love.graphics.print(coloredLineTable[i], 4, GraphicsHeight-60 + (i-1)*16)
                    if i == #lineTable then
                    end
                end
            -- Centered Text, untouched by inline colored text
            else
                local lineTable = {"", "", ""}
                local lineIndex = 1

                for i=1, #self.text do
                    local char = string.sub(self.text, i,i)

                    if char == "#" then
                        lineIndex = lineIndex + 1
                    else
                        lineTable[lineIndex] = lineTable[lineIndex] .. char
                    end
                end

                local lineTableFull = {"", "", ""}
                local lineIndex = 1

                for i=1, #self.fullText do
                    local char = string.sub(self.fullText, i,i)

                    if char == "#" then
                        lineIndex = lineIndex + 1
                    else
                        lineTableFull[lineIndex] = lineTableFull[lineIndex] .. char
                    end
                end



                for i=1, #lineTable do
                    local xText = GraphicsWidth/2 - GameFont:getWidth(lineTableFull[i])/2
                    love.graphics.print(lineTable[i], xText, GraphicsHeight-60 + (i-1)*16)
                    if i == #lineTable then
                    end
                end
            end
        end

        if self.canAdvance then
            local pointerAnimation = Sprites["PointerAnimation"]
            local spr = pointerAnimation[math.floor(self.index)]
            love.graphics.setColor(1,1,1)
            love.graphics.draw(spr, Sprites["TextBox"]:getWidth() - 20, Sprites["TextBox"]:getHeight() + 75)
        end

        if self.credits ~= nil then
            love.graphics.clear(0, 0, 0, 0)
            love.graphics.setColor(255, 255, 255)
            self.canShowCourtRecord = false

            if self.creditLines ~= nil then
                for i = 1, #self.creditLines do
                    if self.creditLines[i] ~= nil then
                        if self.creditLines[i][1] == "text" then
                            local xText = self.creditLines[i][2]
                            local yText = self.creditLines[i][3]
                            if string.find(self.credits[i], "SMALL$", 1, true) then
                                love.graphics.setFont(CreditsSmallFont)
                                xText = GraphicsWidth/2 - CreditsSmallFont:getWidth(self.credits[i])/2 + 20
                            else
                                love.graphics.setFont(CreditsFont)
                            end
                            love.graphics.print(string.gsub(self.credits[i], "SMALL", ""), xText, yText)
                        else
                            love.graphics.draw(self.creditLines[i][1], self.creditLines[i][2], self.creditLines[i][3], 0, 0.8, 0.8)
                        end
                    end
                end
            end
        end
    end

    self.startCredits = function()

        self.credits = {}

        for line in love.filesystem.lines(settings.credits_path) do
            table.insert(self.credits, line)
        end

        for i,v in pairs(Music) do
            if i == "AKISSFROMAROSE" then
                v:setVolume(MasterVolume/100)
                v:play()
            else
                v:stop()
            end
        end

        for i = 1, #self.credits do
            if string.find(self.credits[i], "IMAGE$", 1, true) then
                imgSrc = string.sub(self.credits[i], 7)
                img = love.graphics.newImage(imgSrc)
                self.creditLines[i] = {img, 60, GraphicsHeight + (i-1)*16 - 50}
            else
                self.creditLines[i] = {"text", GraphicsWidth/2 - CreditsFont:getWidth(self.credits[i])/2, GraphicsHeight + (i-1)*16}
            end
        end
    end

    return self
end

function checkKonami(sequence)
    local equals = true
    local konamiSequence = {"up", "up", "down", "down", "left", "right", "left", "right", "b", "a"}

    for i=1, #konamiSequence do
        if konamiSequence[i] ~= sequence[i] then
            equals = false
            break
        end
    end

    return equals
end

function startKonamiTimer(scene)
    scene.timerStarted = true

    if scene.konamiTimer <= 0 then
        scene.timerStarted = false
        scene.sequence = {}
    end
end