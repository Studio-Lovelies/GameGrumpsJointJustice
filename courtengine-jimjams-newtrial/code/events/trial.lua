function NewShoutEvent(who, what)
    local self = {}
    self.timer = 0
    self.x,self.y = 0,0
    self.who = who
    self.what = what
    local shout = Shouts[self.what]

    self.update = function (self, scene, dt)
        scene.textHidden = true
        scene.characters[self.who].sounds[self.what]:play()
        self.timer = self.timer + dt
        self.x = self.x + love.math.random()*choose{1,-1}*2
        self.y = self.y + love.math.random()*choose{1,-1}*2

        return self.timer < 0.5
    end

    self.draw = function (self, scene)
        love.graphics.draw(shout, self.x,self.y)
    end

    return self
end

function NewWitnessEvent(queue)
    local self = {}
    self.queue = queue
    self.eventType = queue[1]
    self.textScroll = 1
    self.textIndex = 3
    self.wasPressing = true
    self.who = queue[2]
    self.timer = 0
    self.animationTime = 1.5
    local introSprite = Sprites[queue[1]]
    local cornerSprite = nil
    if self.eventType == "WitnessTestimony" then
        cornerSprite = Sprites["Testimony"]
    else  -- "CrossExamination"
        cornerSprite = Sprites["Penalty"]
    end

    self.advanceText = function (self)
        if self.eventType == "WitnessTestimony" then
            self.textIndex = self.textIndex + 1
            self.textScroll = 1
            self.wasPressing = true
        else  -- "CrossExamination"
            if self.textIndex == 3 then
                self.textIndex = 4
            else
                self.textIndex = self.textIndex + 3
            end
      
            self.textScroll = 1
            self.wasPressing = true
      
            if self.textIndex > #self.queue then  -- Loop cross examination
                self.textIndex = 4
            end
        end
    end

    self.update = function (self, scene, dt)
        self.timer = self.timer + dt

        -- Text format & behavior
        local text = self.queue[self.textIndex]
        local lastScroll = self.textScroll

        if not text then  -- Terminate witness testimony
            return false
        end

        self.textScroll = math.min(self.textScroll + dt*TextScrollSpeed, #text)

        local inTitle = self.textIndex == 3
        if inTitle then  -- Title formatting
            scene.textColor = {1, 0.5, 0}
            scene.textCentered = true
        else  -- Dialogue formatting
            if self.textScroll < #text then
                scene.characterTalking = true
            end

            if self.eventType == "WitnessTestimony" then
                scene.textColor = {1, 1, 1}
            else  -- "CrossExamination"
                scene.textColor = {0, 1, 0}
            end
        end

        scene.text = string.sub(text, 1, math.floor(self.textScroll))
        scene.fullText = text
        scene.textTalker = self.who

        local currentChar = string.sub(text, math.floor(self.textScroll), math.floor(self.textScroll))

        if self.textScroll > lastScroll
        and currentChar ~= " "
        and currentChar ~= ","
        and currentChar ~= "-" then
            if scene.characters[scene.textTalker].gender == "MALE" then
                Sounds.MALETALK:play()
            else
                Sounds.FEMALETALK:play()
            end
        end
        -- End text format & behavior

        -- Controls handling
        local canAdvance = self.textScroll >= #text and self.timer > self.animationTime

        -- Advance text
        local pressing = love.keyboard.isDown("x")
        if pressing 
        and not self.wasPressing
        and canAdvance then
            self:advanceText()
        end
        self.wasPressing = pressing

        if self.eventType == "CrossExamination" then
            -- Press witness
            if love.keyboard.isDown("c")
            and canAdvance
            and not inTitle then
                scene:runDefinition(self.queue[self.textIndex+1])
                self:advanceText()
            end

            -- Present evidence
            if love.keyboard.isDown("up")
            and screens.courtRecords.displayed
            and not inTitle then
                screens.courtRecords.displayed = false

                if Episode.courtRecords[CourtRecordIndex].name == self.queue[self.textIndex+2] then
                    return false
                else
                    scene:runDefinition(self.queue[3])
                    self:advanceText()
                end
            end
        end
        -- End controls handling

        return true
    end

    self.draw = function (self, scene)
        if self.timer < self.animationTime then
            love.graphics.draw(introSprite, GraphicsWidth/2, GraphicsHeight/2 - 24, 0, 1, 1, introSprite:getWidth()/2, introSprite:getHeight()/2)
        else
            love.graphics.setColor(1,1,1)

            if self.eventType == "WitnessTestimony" then
                love.graphics.draw(cornerSprite, 0 + 2, 2)  -- TODO: blinking animation
            else  -- "CrossExamination"
                for i=1, scene.penalties do
                    love.graphics.draw(cornerSprite, (i-1)*12 +2,2)
                end
            end
        end
    end

    return self
end

function NewIssuePenaltyEvent()
    local self = {}

    self.update = function (self, scene, dt)
        scene.penalties = scene.penalties - 1

        if scene.penalties <= 0 then
            scene:runDefinition("TRIAL_FAIL")
        end

        return false
    end

    return self
end

function NewGameOverEvent()
    local self = {}

    self.update = function (self, scene, dt)
        love.event.push("quit")
        return false
    end

    return self
end

function NewWideShotEvent()
    local self = {}
    self.timer = 0
    self.hasPlayed = false
    self.sources = {}
    self.headAnim = 1
    self.frameCounter = 0

    self.update = function (self, scene, dt)
        self.timer = self.timer + dt
        self.frameCounter = self.frameCounter + dt

        while self.frameCounter >= 2/15 do
            self.frameCounter = self.frameCounter - 2/15
            self.headAnim = self.headAnim + 1
            if self.headAnim > 4 then
                self.headAnim = 1
            end
        end

        scene.textHidden = true

        if not self.hasPlayed then
            --self.sources = love.audio.pause()
            Sounds.MUTTER:play()
            self.hasPlayed = true
        end

        scene.textHidden = true
        scene.canShowCourtRecord = false

        if self.timer >= 2 then
            Sounds.MUTTER:stop()
            for i,v in pairs(self.sources) do
                v:play()
            end
            return false
        end

        return true
    end

    self.draw = function (self, scene)
        local talkingHeadAnimation = Sprites["TalkingHeadAnimation"]
        love.graphics.draw(Sprites["WideShot"])
        love.graphics.draw(talkingHeadAnimation[self.headAnim])

        for i,v in pairs(scene.characters) do
            love.graphics.draw(v.wideshot.source, GetCenterOffset(v.wideshot.source:getWidth()))
        end
    end

    return self
end

function NewGavelEvent()
    local self = {}
    self.timer = 0
    self.index = 1
    self.hasPlayed = false
    self.muted = false
    self.sources = {}

    self.update = function (self, scene, dt)
        self.timer = self.timer + dt
        scene.textHidden = true
        scene.canShowCourtRecord = false

        if not self.muted then
            self.muted = true
            --self.sources = love.audio.pause()
        end

        if self.timer > 0.3 then
            self.index = 2
        end

        if self.timer > 0.35 then
            self.index = 3

            if not self.hasPlayed then
                self.hasPlayed = true
                Sounds.GAVEL:play()
            end
        end

        if self.timer >= 1.3 then
            for i,v in pairs(self.sources) do
                v:play()
            end
            return false
        end
        return true
    end

    self.draw = function (self, scene)
        local gavelAnimation = Sprites["GavelAnimation"]
        local spr = gavelAnimation[self.index]
        love.graphics.draw(spr, 0,0, 0, GraphicsWidth/spr:getWidth(),GraphicsHeight/spr:getHeight())
    end
    return self
end

function NewPanEvent(from, to)
    local self = {}
    local courtPanSprite = Sprites["CourtPan"]
    if from == "COURT_DEFENSE" then
        self.xStart = 0
    end
    if from == "COURT_PROSECUTION" then
        self.xStart = courtPanSprite:getWidth() - GraphicsWidth
    end
    if from == "COURT_WITNESS" then
        self.xStart = courtPanSprite:getWidth()/2 - GraphicsWidth/2
    end

    if to == "COURT_DEFENSE" then
        self.xTo = 0
    end
    if to == "COURT_PROSECUTION" then
        self.xTo = courtPanSprite:getWidth() - GraphicsWidth
    end
    if to == "COURT_WITNESS" then
        self.xTo = courtPanSprite:getWidth()/2 - GraphicsWidth/2
    end
    self.x = self.xStart

    self.update = function (self, scene, dt)
        scene.canShowBgTopLayer = false
        scene.canShowCharacter = false
        scene.textHidden = true

        self.x = self.x + 24*dt*60*GetSign(self.xTo-self.xStart)
        if self.xStart < self.xTo then
            return self.x < self.xTo
        end

        return self.x > self.xTo
    end

    self.draw = function (self, scene)
        love.graphics.draw(courtPanSprite, -1*self.x, 0)
        scene:drawCharacterAt("COURT_DEFENSE", -1*self.x, 0)
        scene:drawBackgroundTopLayer("COURT_DEFENSE", -1*self.x, 0)
        scene:drawCharacterAt("COURT_PROSECUTION", courtPanSprite:getWidth() - GraphicsWidth -1*self.x, 0)
        scene:drawBackgroundTopLayer("COURT_PROSECUTION", courtPanSprite:getWidth() - GraphicsWidth -1*self.x, 0)
        scene:drawCharacterAt("COURT_WITNESS", courtPanSprite:getWidth()/2 - GraphicsWidth/2 -1*self.x, 0)
        scene:drawBackgroundTopLayer("COURT_WITNESS", courtPanSprite:getWidth()/2 - GraphicsWidth/2 -1*self.x, 0)
    end

    return self
end
