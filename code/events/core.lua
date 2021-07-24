require "config"

camerapan = {0, 0}

function NewCharLocationEvent(name, location)
    local self = {}
    self.name = name
    self.location = location

    self.update = function(self, scene, dt)
        scene.characterLocations[self.location] = scene.characters[self.name]

        return false
    end

    return self
end

function NewPoseEvent(name, pose)
    local self = {}
    self.name = name
    self.pose = pose
    self.update = function(self, scene, dt)
        scene.characters[self.name].frame = self.pose

        return false
    end

    return self
end

function NewAnimationEvent(name, animation, speed)
    local self = {}
    self.name = name
    self.animation = animation
    self.timer = 0
    self.animIndex = 1

    if speed == nil then
        speed = 10
    end
    self.speed = speed

    self.update = function(self, scene, dt)
        scene.canShowCharacter = false
        scene.canShowCourtRecord = false
        scene.textHidden = true

        self.timer = self.timer + dt * self.speed
        self.animIndex = math.max(math.floor(self.timer + 0.5), 1)

        local animation = scene.characters[self.name].animations[self.animation]
        if self.animIndex <= #animation.anim then
            return true
        end

        scene.canShowCharacter = true
        return false
    end

    self.characterDraw = function(self, scene)
        local animation = scene.characters[self.name].animations[self.animation]
        love.graphics.draw(animation.source, animation.anim[self.animIndex], 32)
    end

    return self
end

function NewCutToEvent(cutTo)
    local self = {}
    self.cutTo = cutTo

    self.update = function(self, scene, dt)
        scene.location = self.cutTo
        scene.closeUp = false
        return false
    end

    return self
end

function NewSpeakEvent(who, text, locorlit, color, needsPressing)
    local self = {}
    self.text = text
    self.textScroll = 1
    self.needsPressing = needsPressing ~= nil and needsPressing or true
    self.wasPressing = true
    self.who = who
    self.font = "game"
    self.locorlit = locorlit
    self.xTimer = 0

    if color == nil then
        color = "WHITE"
    end
    self.color = color
    self.animates = true
    self.speaks = true

    self.update = function(self, scene, dt)
        scene.font = self.font
        scene.textHidden = false
        if self.text == nil then
            self.text = ""
        end
        scene.fullText = self.text

        local lastScroll = self.textScroll
        local scrollSpeed = TextScrollSpeed
        local currentChar = string.sub(self.text, math.floor(self.textScroll), math.floor(self.textScroll))

        if love.keyboard.isDown("x") then
            if startTimer(self, dt) >= 0.6 then
                scrollSpeed = scrollSpeed * 8
            end
        else
            if currentChar == "." then
                if string.sub(self.text, math.floor(self.textScroll - 2), math.floor(self.textScroll)):lower() == "mr." then
                    scrollSpeed = scrollSpeed
                else
                    scrollSpeed = scrollSpeed * 0.15
                end
            elseif currentChar == "!" or currentChar == "?" then
                scrollSpeed = scrollSpeed * 0.15
            elseif currentChar == "," then
                scrollSpeed = scrollSpeed * 0.25
            elseif currentChar == " " then
                scrollSpeed = scrollSpeed * 0.75
            end
        end
        self.textScroll = math.min(self.textScroll + dt * scrollSpeed, #self.text)

        if self.textScroll < #self.text then
            scene.characterTalking = self.animates
        end

        if self.locorlit == "literal" then
            scene.textTalker = self.who
        else
            scene.textTalker = scene.characterLocations[self.who].name
        end

        if
            self.textScroll > lastScroll and currentChar ~= " " and currentChar ~= "," and currentChar ~= "-" and
                currentChar ~= "." and
                currentChar ~= "?" and
                currentChar ~= "!" and
                currentChar ~= "'" and
                currentChar ~= ":" and
                currentChar ~= ";" and
                currentChar ~= ")" and
                currentChar ~= "(" and
                self.speaks
         then
            if scene.characters[scene.textTalker].gender == "MALE" then
                Sounds.MALETALK:setVolume(settings.speech_volume / 100)
                Sounds.MALETALK:play()
            else
                Sounds.FEMALETALK:setVolume(settings.speech_volume / 100)
                Sounds.FEMALETALK:play()
            end
        end

        scene.textColor = colors[string.lower(self.color)]

        scene.text = string.sub(self.text, 1, math.floor(self.textScroll))

        local pressing = love.keyboard.isDown(controls.advance_text)
        -- What to do at the end of dialogue
        if self.textScroll >= #self.text then
            scene.canAdvance = true
            if self.needsPressing == false then
                -- This dialogue doesn't need the button to continue, like a run-on sentence
                scene.canAdvance = false
                return false
            elseif pressing and not self.wasPressing then
                -- This dialogue needs the button, and the button was just pressed
                scene.canAdvance = false
                return false
            end
        else
            scene.canAdvance = false
        end

        self.wasPressing = pressing
        return true
    end

    return self
end

function NewQuietSpeakEvent(who, text, locorlit, color, needsPressing)
    local self = {}
    self.text = text
    self.textScroll = 1
    self.needsPressing = needsPressing ~= nil and needsPressing or true
    self.wasPressing = true
    self.who = who
    self.font = "small"
    self.locorlit = locorlit
    self.xTimer = 0

    if color == nil then
        color = "WHITE"
    end
    self.color = color
    self.animates = true
    self.speaks = true

    self.update = function(self, scene, dt)
        scene.font = self.font
        scene.textHidden = false
        scene.fullText = self.text

        local lastScroll = self.textScroll
        local scrollSpeed = TextScrollSpeed
        local currentChar = string.sub(self.text, math.floor(self.textScroll), math.floor(self.textScroll))

        if love.keyboard.isDown("x") then
            if startTimer(self, dt) >= 0.6 then
                scrollSpeed = scrollSpeed * 8
            end
        else
            if currentChar == "." then
                if string.sub(self.text, math.floor(self.textScroll - 2), math.floor(self.textScroll)):lower() == "mr." then
                    scrollSpeed = scrollSpeed
                else
                    scrollSpeed = scrollSpeed * 0.15
                end
            elseif currentChar == "!" or currentChar == "?" then
                scrollSpeed = scrollSpeed * 0.15
            elseif currentChar == "," then
                scrollSpeed = scrollSpeed * 0.25
            elseif currentChar == " " then
                scrollSpeed = scrollSpeed * 0.75
            end
        end
        self.textScroll = math.min(self.textScroll + dt * scrollSpeed, #self.text)

        if self.textScroll < #self.text then
            scene.characterTalking = self.animates
        end

        if self.locorlit == "literal" then
            scene.textTalker = self.who
        else
            scene.textTalker = scene.characterLocations[self.who].name
        end

        if
            self.textScroll > lastScroll and currentChar ~= " " and currentChar ~= "," and currentChar ~= "-" and
                currentChar ~= "." and
                currentChar ~= "?" and
                currentChar ~= "!" and
                currentChar ~= "'" and
                currentChar ~= ":" and
                currentChar ~= ";" and
                currentChar ~= ")" and
                currentChar ~= "(" and
                currentChar ~= "#" and
                self.speaks
         then
            if scene.characters[scene.textTalker].gender == "MALE" then
                Sounds.MALETALK:setVolume(settings.speech_volume / 100)
                Sounds.MALETALK:play()
            else
                Sounds.FEMALETALK:setVolume(settings.speech_volume / 100)
                Sounds.FEMALETALK:play()
            end
        end

        scene.textColor = colors[string.lower(self.color)]

        scene.text = string.sub(self.text, 1, math.floor(self.textScroll))

        local pressing = love.keyboard.isDown(controls.advance_text)
        -- What to do at the end of dialogue
        if self.textScroll >= #self.text then
            scene.canAdvance = true
            if self.needsPressing == false then
                -- This dialogue doesn't need the button to continue, like a run-on sentence
                scene.canAdvance = false
                return false
            elseif pressing and not self.wasPressing then
                -- This dialogue needs the button, and the button was just pressed
                scene.canAdvance = false
                return false
            end
        else
            scene.canAdvance = false
        end

        self.wasPressing = pressing
        return true
    end

    return self
end

function NewInterruptedSpeakEvent(who, text, locorlit)
    local self = NewSpeakEvent(who, text, locorlit)
    self.needsPressing = false

    return self
end

function NewThinkEvent(who, text, locorlit)
    local self = NewSpeakEvent(who, text, locorlit)
    self.color = "LTBLUE"
    self.animates = false

    return self
end

function NewHideTextEvent()
    local self = {}
    self.update = function(self, scene, dt)
        scene.textHidden = true
        return false
    end

    return self
end

function NewTypeWriterEvent(text)
    local self = {}
    self.text = text
    self.textScroll = 1
    self.wasPressing = true

    self.update = function(self, scene, dt)
        scene.textHidden = false
        local lastScroll = self.textScroll
        self.textScroll = math.min(self.textScroll + dt * TextScrollSpeed, #self.text)

        if self.textScroll > lastScroll then
            Sounds.TYPEWRITER:play()
        end

        scene.fullText = self.text
        scene.textCentered = true
        scene.textColor = {0, 1, 0}
        scene.text = string.sub(self.text, 1, math.floor(self.textScroll))
        scene.textTalker = ""
        scene.textBoxSprite = Sprites["AnonTextBox"]

        local pressing = love.keyboard.isDown("x")
        if pressing and not self.wasPressing and self.textScroll >= #self.text then
            return false
        end
        self.wasPressing = pressing

        return true
    end

    self.draw = function(self, scene)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
    end

    return self
end

function NewSetSyncEvent(sync)
    local self = {}
    self.sync = sync:lower()

    self.update = function(self, scene, dt)
        scene.stack[2].event.sync = self.sync

        return false
    end

    return self
end

function NewPanImageEvent(a, b, c, d)
    local self = {}

    camerapan = {0, 0}

    self.a = tonumber(a)
    self.b = tonumber(b)
    self.c = tonumber(c)
    self.d = tonumber(d)

    self.x = self.a
    self.y = self.b

    self.bool = true
    self.bool2 = true
    self.bool3 = true

    self.cpx = self.c - self.a
    self.cpy = self.d - self.b

    self.update = function(self, scene, dt)
        scene.canShowBgTopLayer = false
        scene.canShowCharacter = false

        if self.x ~= self.c then
            if self.x > self.c then
                self.x = self.x - (self.cpx / (self.cpx + self.cpy))
            else
                self.x = self.x + (self.cpx / (self.cpx + self.cpy))
            end
        end
        if self.y ~= self.d then
            if self.y > self.d then
                self.y = self.y - (self.cpy / (self.cpx + self.cpy))
            else
                self.y = self.y + (self.cpy / (self.cpx + self.cpy))
            end
        end

        if self.a < self.c and self.x > self.c then
            self.x = self.c
        elseif self.a > self.c and self.x < self.c then
            self.x = self.c
        end
        if self.b < self.d and self.y > self.d then
            self.y = self.d
        elseif self.b > self.d and self.y < self.d then
            self.y = self.d
        end

        if self.x == self.c then
            self.bool2 = false
        end
        if self.y == self.d then
            self.bool3 = false
        end

        if not self.bool2 and not self.bool3 then
            self.bool = false
        end

        return self.bool
    end

    self.draw = function(self, scene)
        camerapan = {self.x, self.y}
    end

    return self
end

function NewCameraEvent(x, y)
    local self = {}
    self.x = x
    self.y = y

    self.update = function(self, scene, dt)
        camerapan = {self.x, self.y}

        return false
    end

    return self
end

function NewPlayMusicEvent(music)
    local self = {}
    self.music = music

    self.update = function(self, scene, dt)
        scene.music = music

        for i, v in pairs(Music) do
            -- Don't stop the current track before attempting to
            -- play it. This allows us to have consequtive scripts
            -- play the same music without the track restarting
            if i == self.music then
                v:setVolume(MusicVolume / 100)
                v:play()
            else
                v:stop()
            end
        end

        return false
    end

    return self
end

function NewFadeMusicEvent()
    local self = {}
    self.timer = MusicVolume / 100

    self.update = function(self, scene, dt)
        scene.music = nil

        local lastTimer = self.timer
        self.timer = self.timer - (dt / (1 / (MusicVolume / 100)))

        for i, v in pairs(Music) do
            v:setVolume(self.timer)
        end

        return self.timer >= 0 and lastTimer >= 0
    end

    return self
end

function NewStopMusicEvent()
    local self = {}

    self.update = function(self, scene, dt)
        scene.music = nil

        for i, v in pairs(Music) do
            v:stop()
        end

        return false
    end

    return self
end

function NewPlaySoundEvent(sound)
    local self = {}
    self.sound = sound:upper()

    self.update = function(self, scene, dt)
        if Sounds[self.sound] ~= nil then
            Sounds[self.sound]:play()
        end

        return false
    end

    return self
end

function NewCourtRecordAddEvent(itemType, name)
    local self = {}
    self.itemType = itemType
    self.name = name

    self.update = function(self, scene, dt)
        -- Returns whether item table, as identified by given item name,
        -- exists in given container table
        function ItemExistsInTable(item_name, container_name)
            -- Check if container is empty
            if container_name[1] == nil then
                return false
            end

            for _, item_table in ipairs(container_name) do
                if item_table["name"] == item_name then
                    return true
                end
            end

            return false
        end

        if self.itemType == "EVIDENCE" then
            if ItemExistsInTable(self.name, Episode.courtRecords.evidence) then
                return false
            end

            table.insert(Episode.courtRecords.evidence, scene.evidence[self.name])
        elseif self.itemType == "PROFILE" then
            if ItemExistsInTable(self.name, Episode.courtRecords.profiles) then
                return false
            end

            table.insert(Episode.courtRecords.profiles, scene.profiles[self.name])
        end

        return false
    end

    return self
end

function NewAddToCourtRecordAnimationEvent(evidenceSpriteName)
    local self = {}
    self.textScroll = 1
    self.evidence = evidenceSpriteName
    self.wasPressing = true

    self.update = function(self, scene, dt)
        self.text = self.evidence .. " added to#the Court Record."
        self.textScroll = math.min(self.textScroll + dt * TextScrollSpeed, #self.text)
        scene.fullText = self.text
        scene.textCentered = true
        local r, g, b = RGBColorConvert(107, 198, 247)
        scene.textColor = {r, g, b}
        scene.text = string.sub(self.text, 1, math.floor(self.textScroll))
        scene.textTalker = ""
        scene.textBoxSprite = Sprites["AnonTextBox"]

        local pressing = love.keyboard.isDown("x")
        if pressing and not self.wasPressing and self.textScroll >= #self.text then
            return false
        end
        self.wasPressing = pressing

        return true
    end

    self.draw = function(self, scene)
        love.graphics.setColor(1, 1, 1)
        if Sprites[self.evidence:gsub(" ", "")] == nil then
            love.graphics.draw(Sprites["MissingTexture"], 16, 16)
        else
            love.graphics.draw(Sprites[self.evidence:gsub(" ", "")], 24, 24)
        end
    end

    return self
end

function NewExecuteDefinitionEvent(def)
    local self = {}
    self.def = def
    self.hasRun = false

    self.update = function(self, scene, dt)
        if not self.hasRun then
            self.hasRun = true
            scene:runDefinition(self.def)
        end

        return false
    end

    return self
end

function NewClearExecuteDefinitionEvent(def)
    local self = {}
    self.def = def
    self.hasRun = false

    self.update = function(self, scene, dt)
        if not self.hasRun then
            self.hasRun = true
            scene.stack = {}
            scene:runDefinition(self.def, 2)
        end

        return false
    end

    return self
end

function NewShowEvent(evidence, side, scene)
    local self = {}
    self.evidence = evidence
    self.side = side

    self.update = function(self, scene, dt)
        if scene.showing == nil then
            scene.showing = {self.evidence, self.side}
        end
        Sounds.BLEEP:play()
        return false
    end

    return self
end

function NewStopShowingEvent(scene)
    local self = {}

    self.update = function(self, scene, dt)
        if scene.showing ~= nil then
            scene.showing = nil
        end
        return false
    end

    return self
end

function NewChoiceEvent(options, isFake)
    local self = {}
    self.select = 1
    self.options = options

    self.wasPressingUp = false
    self.wasPressingDown = false
    self.wasPressingX = true

    -- this is for FakeChoiceEvent polymorphism
    -- if a choice is fake, then whatever option the player chooses still continues the script
    self.isFake = isFake
    self.hasDone = false

    self.update = function(self, scene, dt)
        scene.textHidden = true
        local pressingUp = love.keyboard.isDown(controls.pause_nav_up)
        local pressingDown = love.keyboard.isDown(controls.pause_nav_down)

        if self.isFake then
            if not self.wasPressingUp and pressingUp then
                self.select = self.select - 2

                if self.select < 1 then
                    self.select = #self.options - 1
                end
            end

            if not self.wasPressingDown and pressingDown then
                self.select = self.select + 2

                if self.select > #self.options - 1 then
                    self.select = 1
                end
            end
        else
            if not self.wasPressingUp and pressingUp then
                self.select = self.select - 3

                if self.select < 1 then
                    self.select = #self.options - 1
                end
            end

            if not self.wasPressingDown and pressingDown then
                self.select = self.select + 3

                if self.select > #self.options - 1 then
                    self.select = 1
                end
            end
        end

        self.wasPressingUp = pressingUp
        self.wasPressingDown = pressingDown

        local pressingX = love.keyboard.isDown("x")

        if not self.hasDone then
            if pressingX and not self.wasPressingX then
                if self.isFake then
                    self.hasDone = true
                    return false
                else
                    if self.options[self.select + 2] == "1" then
                        scene:runDefinition(self.options[self.select + 1], 2)
                        return false
                    else
                        scene:runDefinition(self.options[self.select + 1])
                    end
                end
            end

            self.wasPressingX = pressingX

            return true
        else
            return false
        end
    end

    self.draw = function(self, scene)
        scene.textHidden = true
        if self.isFake then
            for i = 1, #self.options, 2 do
                love.graphics.setColor(0.2, 0.2, 0.2)
                if self.select == i then
                    love.graphics.setColor(0.8, 0, 0.2)
                end
                local textHeight = 28
                if #self.options[i] > 28 then
                    self.options[i] = stringInsert(self.options[i], "$n", 27)
                    textHeight = textHeight + 12
                    love.graphics.rectangle("fill", 146, 30 + (i - 1) * 16 - 4, GraphicsWidth, textHeight)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setFont(SmallFont)
                    love.graphics.print(stringSplit(self.options[i], "$n")[1], 150, 30 + (i - 1) * 16)
                    love.graphics.print(stringSplit(self.options[i], "$n")[2], 150, 42 + (i - 1) * 16)
                    love.graphics.setFont(GameFont)
                else
                    love.graphics.rectangle("fill", 146, 30 + (i - 1) * 16 - 4, GraphicsWidth, textHeight)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setFont(SmallFont)
                    love.graphics.print(self.options[i], 150, 30 + (i - 1) * 16)
                    love.graphics.setFont(GameFont)
                end
            end
        else
            for i = 1, #self.options, 3 do
                love.graphics.setColor(0.2, 0.2, 0.2)
                if self.select == i then
                    love.graphics.setColor(0.8, 0, 0.2)
                end
                local textHeight = 28
                if #self.options[i] > 28 then
                    self.options[i] = stringInsert(self.options[i], "$n", 27)
                    textHeight = textHeight + 12
                    love.graphics.rectangle("fill", 146, 30 + (i - 1) * 16 - 4, GraphicsWidth, textHeight)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setFont(SmallFont)
                    love.graphics.print(stringSplit(self.options[i], "$n")[1], 150, 30 + (i - 1) * 16)
                    love.graphics.print(stringSplit(self.options[i], "$n")[2], 150, 42 + (i - 1) * 16)
                    love.graphics.setFont(GameFont)
                else
                    love.graphics.rectangle("fill", 146, 30 + (i - 1) * 16 - 4, GraphicsWidth, textHeight)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.setFont(SmallFont)
                    love.graphics.print(self.options[i], 150, 30 + (i - 1) * 16)
                    love.graphics.setFont(GameFont)
                end
            end
        end
    end

    return self
end

function NewFakeChoiceEvent(options)
    local self = NewChoiceEvent(options, true)
    return self
end

function NewSceneEndEvent()
    local self = {}

    self.update = function(self, scene, dt)
        Episode.sceneIndex = Episode.sceneIndex + 1
        Episode:nextScene()
        return false
    end

    return self
end

function NewFadeToBlackEvent(fadeMusic)
    local self = {}
    self.timer = 0
    self.musicTimer = MusicVolume / 100
    self.fadeMusic = fadeMusic

    self.update = function(self, scene, dt)
        scene.textHidden = true
        scene.canShowCourtRecord = false

        local lastTimer = self.timer
        local lastMusicTimer = self.musicTimer
        self.timer = self.timer + (dt / 2)
        self.musicTimer = self.musicTimer - (dt / (1 / (MusicVolume / 100)))

        for i, v in pairs(Music) do
            if self.fadeMusic then
                v:setVolume(self.musicTimer)
            end
        end

        return self.timer <= 1 and lastTimer <= 1
    end

    self.draw = function(self, scene)
        love.graphics.setColor(0, 0, 0, self.timer)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
    end

    return self
end

function NewFadeToWhiteEvent()
    local self = {}
    self.timer = 0

    self.update = function(self, scene, dt)
        scene.textHidden = true
        scene.canShowCourtRecord = false

        local lastTimer = self.timer
        self.timer = self.timer + dt

        return self.timer <= 1 and lastTimer <= 1
    end

    self.draw = function(self, scene)
        love.graphics.setColor(255, 255, 255, self.timer)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
    end

    return self
end

function NewFadeInEvent()
    local self = {}
    self.timer = 1

    self.update = function(self, scene, dt)
        scene.textHidden = true
        scene.canShowCourtRecord = false

        local lastTimer = self.timer
        self.timer = self.timer - dt

        return self.timer >= 0 and lastTimer >= 0
    end

    self.draw = function(self, scene)
        love.graphics.setColor(0, 0, 0, self.timer)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
    end

    return self
end

function NewCrossFadeEvent(scene1, scene2)
    local self = {}
    self.timer1 = 1
    self.timer2 = 0
    self.scene1 = scene1
    self.scene2 = scene2

    self.update = function(self, scene, dt)
        scene.textHidden = true
        scene.canShowCourtRecord = false

        local lastTimer1 = self.timer1
        self.timer1 = self.timer1 - dt
        local lastTimer2 = self.timer2
        self.timer2 = self.timer2 + dt

        return self.timer1 >= 0 and lastTimer1 >= 0 and self.timer2 <= 1 and lastTimer2 <= 1
    end

    self.draw = function(self, scene)
        love.graphics.setColor(0, 0, 0, self.timer1)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
        love.graphics.draw()
    end

    return self
end

function NewBigImageEvent(sprite, scale)
    local self = {}
    self.sprite = sprite
    self.scale = scale

    self.update = function(self, scene, dt)
        scene.bigimage = self.sprite
        if self.scale ~= nil then
            scene.bigimageScale = self.scale
        end
        return false
    end

    return self
end

function NewStopBigImageEvent()
    local self = {}

    self.update = function(self, scene, dt)
        scene.bigimage = nil
        return false
    end

    return self
end

function NewTimedImageEvent()
    local self = {}

    self.update = function(self, scene, dt)
        return false
    end

    return self
end

function NewScreenShakeEvent()
    local self = {}

    self.update = function(self, scene, dt)
        ScreenShake = 0.15
        return false
    end

    return self
end

function NewSetFlagEvent(flag, set)
    local self = {}
    self.flag = flag
    self.set = set

    self.update = function(self, scene, dt)
        scene.flags[self.flag] = self.set
        print("set " .. self.flag .. " to " .. self.set)
        return false
    end

    return self
end

function NewIfEvent(flag, test, def)
    local self = {}
    self.flag = flag
    self.test = test
    self.def = def

    self.update = function(self, scene, dt)
        if scene.flags[self.flag] == self.test then
            scene:runDefinition(self.def, 2)
        end

        return false
    end

    return self
end

function NewWaitEvent(seconds)
    local self = {}
    self.timer = 0
    self.seconds = tonumber(seconds)

    self.update = function(self, scene, dt)
        self.timer = self.timer + dt

        return self.timer < self.seconds
    end

    return self
end

function NewAdvanceEvent(seconds)
    local self = {}
    self.timer = 0
    self.seconds = tonumber(seconds)

    self.update = function(self, scene, dt)
        self.timer = self.timer + dt

        if self.timer >= self.seconds then
            love.event.push("keypressed", "x")
            return false
        else
            return true
        end
    end

    return self
end

function NewClearLocationEvent(location)
    local self = {}
    self.location = location

    self.update = function(self, scene, dt)
        scene.characterLocations[self.location] = nil

        return false
    end

    return self
end

function NewGameOverEvent()
    local self = {}

    self.update = function(self, scene, dt)
        Episode:stop()
        local episodePath = Episode.episodePath
        local sceneIndex = Episode.sceneIndex
        Episode = NewEpisode(settings.game_over_path)
        Episode.nextEpisode = NewEpisode(episodePath)
        Episode.restartSceneIndex = sceneIndex
        Episode:begin()

        return false
    end

    return self
end

function stringInsert(str1, str2, pos)
    charPos = pos
    while str1:sub(charPos, charPos) ~= " " do
        charPos = charPos - 1
        if charPos < 0 then
            charPos = pos
        end
    end
    if string.match(str1:sub(charPos + 1, charPos + 2), "$n") then
        return str1
    end
    return str1:sub(1, charPos) .. str2 .. str1:sub(charPos + 1)
end

function stringSplit(s, delimiter)
    result = {}

    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function isNaN(n)
    if (tostring(n) == "nan") then
        return true
    else
        return false
    end
end

function startTimer(event, dt)
    event.xTimer = event.xTimer + dt * 2

    return event.xTimer
end
