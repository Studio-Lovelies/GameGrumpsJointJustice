math.randomseed(os.time())
math.random()
math.random()
math.random()

function NewShoutEvent(who, what)
    local self = {}
    self.timer = 0
    self.x,self.y = 0,0
    self.who = who
    self.what = what:lower()
    local shout = Shouts[self.what]

    self.update = function(self, scene, dt)
        scene.textHidden = true
        if scene.characters[self.who].sounds[self.what] ~= nil then
            scene.characters[self.who].sounds[self.what]:setVolume(settings.speech_volume / 100 * 5)
            scene.characters[self.who].sounds[self.what]:play()
        end
        self.timer = self.timer + dt
        self.x = self.x + love.math.random()*choose{1,-1}*2
        self.y = self.y + love.math.random()*choose{1,-1}*2

        return self.timer < 0.5
    end

    self.draw = function(self, scene)
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
    self.timer2 = 0
    self.xTimer = 0
    self.index = 1
    self.animIndex = 1
    self.sprite = love.graphics.newImage("sprites/Testimony.png")
    self.cornerSpriteBlink = false
    self.animationTime = 1.5
    local introSprite = Sprites[queue[1]]
    local cornerSprite = nil
    if self.eventType == "WitnessTestimony" then
        cornerSprite = Sprites["Testimony"]
    else  -- "CrossExamination"
        cornerSprite = Sprites["Penalty"]
    end

    self.advanceText = function(self)
        if self.eventType == "WitnessTestimony" then
            self.textIndex = self.textIndex + 1
            self.textScroll = 1
            self.wasPressing = true
        else  -- "CrossExamination"
            if self.textIndex == 3 then
                self.textIndex = self.textIndex + 1
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

    self.update = function(self, scene, dt)
        if self.animIndex < 20 then
            for i,v in pairs(Music) do
                v:stop()
            end
        end

        self.timer = self.timer + dt
        self.timer2 = self.timer2 + dt
        scene.textHidden = true

        -- Text format & behavior
        if self.queue[self.textIndex] ~= nil then
        end
        local text = self.queue[self.textIndex]
        local lastScroll = self.textScroll

        if not text then  -- Terminate witness testimony
            return false
        end

        local inTitle = self.textIndex == 3
        if inTitle then  -- Title formatting
            scene.textColor = {1, 0.5, 0}
            scene.textCentered = true
            scene.textBoxSprite = Sprites["AnonTextBox"]
            scene.characterTalking = false
            scene.textTalker = ""
        else  -- Dialogue formatting
            if self.textScroll < #text then
                scene.characterTalking = true
                scene.textTalker = self.who
            end

            if self.eventType == "WitnessTestimony" then
                scene.textColor = {1, 1, 1}
            else  -- "CrossExamination"
                scene.textColor = {0, 1, 0}
            end
        end

        scene.text = string.sub(text, 1, math.floor(self.textScroll))
        scene.fullText = text

        local currentChar = string.sub(text, math.floor(self.textScroll), math.floor(self.textScroll))

        -- Controls handling
        local canAdvance = self.textScroll >= #text and self.timer > self.animationTime

        local scrollSpeed = TextScrollSpeed

        if love.keyboard.isDown("x") then
            if startTimer(self, dt) >= 1 then
                scrollSpeed = scrollSpeed*8
            end
        end

        self.textScroll = math.min(self.textScroll + dt*scrollSpeed, #text)

        if not inTitle then
            if self.textScroll > lastScroll
            and currentChar ~= " "
            and currentChar ~= ","
            and currentChar ~= "-" then
                if scene.characters[scene.textTalker].gender == "MALE" then
                    Sounds.MALETALK:setVolume(settings.speech_volume/100)
                    Sounds.MALETALK:play()
                else
                    Sounds.FEMALETALK:setVolume(settings.speech_volume/100)
                    Sounds.FEMALETALK:play()
                end
            end
        end
        -- End text format & behavior

        -- Advance text
        local pressing = love.keyboard.isDown(controls.advance_text)

        if canAdvance then
            scene.canAdvance = true
        else
            scene.canAdvance = false
        end

        if pressing
        and not self.wasPressing
        and canAdvance then
            scene.canAdvance = false
            self:advanceText()
        end
        self.wasPressing = pressing

        if self.eventType == "CrossExamination" then
            -- Press witness
            if love.keyboard.isDown("c")
            and self.queue[self.textIndex+1] ~= "Witness' Account"
            and self.queue[self.textIndex+1] ~= "CrossExamFail"
            and not self.queue[self.textIndex+1]:match("%s")
            and canAdvance then
                if self.queue[self.textIndex+2] ~= "1" then
                    scene:runDefinition(self.queue[self.textIndex+1])
                else
                    scene:runDefinition(self.queue[self.textIndex+1], 2)
                    return false
                end
            end

            -- Present evidence
            if love.keyboard.isDown(controls.press_confirm)
            and screens.courtRecords.displayed
            and not inTitle then
                screens.courtRecords.displayed = false

                if Episode.courtRecords.evidence[CourtRecordIndexE].name ~= self.queue[self.textIndex + 2] then
                    table.insert(scene.stack, 1, {lineParts = "penaltyIssued", event = NewIssuePenaltyEvent(scene)})
                else
                    scene.drawPenalties = false
                    return false
                end
            end
        end
        -- End controls handling


        if self.timer > self.animIndex * 0.075 then
            if self.animIndex < 20 then
                self.animIndex = self.animIndex + 1
            else
                Music[scene.music]:play()
                scene.textHidden = false
            end
        end

        if self.timer < 0.1 then
            Sounds.LONGWOOSH:play()
        end
        return true
    end

    self.draw = function(self, scene)
        if self.timer < self.animationTime then
            love.graphics.draw(Sprites[self.eventType..self.animIndex], GraphicsWidth/2, GraphicsHeight/2 - 20, 0, 1, 1, Sprites[self.eventType..self.animIndex]:getWidth()/2, Sprites[self.eventType..self.animIndex]:getHeight()/2)
        else
            love.graphics.setColor(1,1,1)

            if self.eventType == "WitnessTestimony" then
                if self.timer2 > 1 then
                    if self.cornerSpriteBlink then
                        self.sprite = love.graphics.newImage("sprites/Testimony.png")
                        self.cornerSpriteBlink = false
                    else
                        self.sprite = false
                        self.cornerSpriteBlink = true
                    end
                  self.timer2 = self.timer2 - 1
                end
                if self.sprite then
                    love.graphics.draw(self.sprite, 0 + 2, 2)
                end
            else  -- "CrossExamination"
                for i=1, scene.penalties do
                    love.graphics.draw(cornerSprite, (i - 1) * 12 + 2, 2)
                end
            end
        end
    end

    return self
end

function NewPresentEvent(type, evidence)
    local self = {}
    self.evidence = evidence
    self.type = type
    self.wasPressingConfirm = false

    self.update = function(self, scene, dt)
        scene.textHidden = false
        local pressingConfirm = love.keyboard.isDown(controls.press_confirm)
        if screens.courtRecords.displayed then
            if not self.wasPressingConfirm and pressingConfirm then
                if self.type == "EVIDENCE" then
                    if Episode.courtRecords.evidence[CourtRecordIndexE].externalName:gsub("%s+", ""):lower() == self.evidence:lower() and Episode.courtRecords.evidence[CourtRecordIndexP].externalName:gsub("%s+", ""):lower() ~= self.evidence:lower() then
                        screens.courtRecords.displayed = false
                        scene.drawPenalties = false
                        return false
                    else
                        screens.courtRecords.displayed = false
                        table.insert(scene.stack, 1, {lineParts = "penaltyIssued", event = NewIssuePenaltyEvent(scene)})
                    end
                elseif self.type == "PROFILE" then
                    if Episode.courtRecords.profiles[CourtRecordIndexP].characterName:gsub("%s+", ""):lower() == self.evidence:lower() and Episode.courtRecords.profiles[CourtRecordIndexE].characterName:gsub("%s+", ""):lower() ~= self.evidence:lower() then
                        screens.courtRecords.displayed = false
                        scene.drawPenalties = false
                        return false
                    else
                        screens.courtRecords.displayed = false
                        table.insert(scene.stack, 1, {lineParts = "penaltyIssued", event = NewIssuePenaltyEvent(scene)})
                    end
                end
            end
            self.wasPressingConfirm = pressingConfirm
            return true
        else
            screens.courtRecords.displayed = true
            screens.courtRecords.menu_type = "evidence";
            CourtRecordIndexE = 1;
            return true
        end
    end

    self.draw = function(self, scene)
        for i=1, scene.penalties do
            love.graphics.draw(Sprites["Penalty"], (i - 1) * 12 + 2, 2)
        end
    end
    return self
end

function NewIssuePenaltyEvent(scene)
    local self = {}
    scene.drawPenalties = true

    self.scripts = {
        {
            {"JUMPCUT", "COURT_JUDGE"}, {"POSE", "Judge Brent", "Thinking"}, {"SPEAK", "Judge Brent", "..."}, {"SPEAK", "Judge Brent", "You can't be serious with this, right?"}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "Sweaty"}, {"SPEAK", "Arin", "Uhhhh..."}, {"POSE", "Arin", "Embarassed"}, {"SPEAK", "Arin", "Maybe?"}, {"JUMPCUT", "COURT_JUDGE"}, {"SPEAK", "Judge Brent", "..."}, {"POSE", "Judge Brent", "Warning"}, {"SPEAK", "Judge Brent", "You need to take this more seriously Arin. Hopefully this Penalty will help you focus."}, {"ISSUE_PENALTY"}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "Sweaty"}, {"SPEAK", "Arin", "Y-yes, Your Honor. My bad."}, {"JUMPCUT", "COURT_WITNESS"}
        },
        {
            {"JUMPCUT", "COURT_ASSISTANT"}, {"POSE", "Dan", "Angry"}, {"SPEAK", "Dan", "Arin."}, {"SPEAK", "Arin", "What? It's the right answer, right?"}, {"POSE", "Dan", "Sad"}, {"SPEAK", "Dan", "..."}, {"POSE", "Dan", "SideAngryTurned"}, {"SPEAK", "Dan", "No arin, we're getting a penalty for that one."}, {"SPEAK", "Arin", "Wait, really?"}, {"JUMPCUT", "COURT_JUDGE"}, {"POSE", "Judge Brent", "Warning"}, {"SPEAK", "Judge Brent", "Yes!"}, {"ISSUE_PENALTY"}, {"JUMPCUT", "COURT_DEFENSE"}, {"SFX", "damage1"}, {"SET_SYNC", "TRUE"}, {"ANIMATION", "Arin", "Shock"}, {"POSE", "Arin", "Sweaty"}, {"SPEAK", "Arin", "OOF."}, {"THINK", "Arin", "(I need to be more thoughtful and pay more attention I guess.)"}, {"JUMPCUT", "COURT_WITNESS"}
        },
        {
            {"JUMPCUT", "COURT_JUDGE"}, {"POSE", "Judge Brent", "Surprised"}, {"SPEAK", "Judge Brent", "WHAM BAM BAZAAAM, THAT'S THE WRONG ANSWER MA'AM!"}, {"SET_SYNC", "TRUE"}, {"ISSUE_PENALTY"}, {"GAVEL"}, {"JUMPCUT", "COURT_ASSISTANT"}, {"POSE", "Dan", "SideNormalTurned"}, {"SPEAK", "Dan", "... I think you should try a different answer Arin."}, {"SPEAK", "Arin", "Gee ya THINK SO, DAN?"}, {"POSE", "Dan", "SideNormal"}, {"SPEAK", "Dan", "Yes. Yes I do Arin. I do."}, {"SPEAK", "Arin", "..."}, {"SPEAK", "Arin", "Yeah I guess so..."}, {"JUMPCUT", "COURT_WITNESS"}
        },
        {
            {"JUMPCUT", "COURT_JUDGE"}, {"POSE", "Judge Brent", "Normal"}, {"SPEAK", "Judge Brent", "I don't see how this could be the right answer..."}, {"SPEAK", "Judge Brent", "But I'm in a good mood, so I think I won't penalize you this time."}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "Embarassed"}, {"SPEAK", "Arin", "Dang, thanks Brent. This is a lot harder than it looks!"}, {"JUMPCUT", "COURT_PROSECUTION"}, {"POSE", "Tutorial Boy", "Confident"}, {"SPEAK", "Tutorial Boy", "Yes, accept his freebie. It won't help you in the long run, Mr. 'Video game BABY!'"}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "DeskSlam"}, {"SFX", "damage1"}, {"SCREEN_SHAKE"}, {"SPEAK", "Arin", "You shut your goddamn pie hole-"}, {"SFX", "objectionclean"}, {"POSE", "Arin", "CloseUp"}, {"SPEAK", "Arin", "-you FUCKING CLOD!!!"}, {"JUMPCUT", "COURT_PROSECUTION"}, {"POSE", "Tutorial Boy", "Sweaty"}, {"SPEAK", "Tutorial Boy", "..."}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "Sweaty"}, {"SPEAK", "Arin", "..."}, {"POSE", "Arin", "Embarassed"}, {"INTERRUPTED_SPEAK", "Arin", "Er... What I meant to say was--"}, {"JUMPCUT", "COURT_JUDGE"}, {"POSE", "Judge Brent", "Warning"}, {"SCREEN_SHAKE"}, {"SFX", "stab2"}, {"SPEAK", "Judge Brent", "Changed my mind. Penalty given."}, {"ISSUE_PENALTY"}, {"JUMPCUT", "COURT_DEFENSE"}, {"POSE", "Arin", "Sweaty"}, {"SPEAK", "Arin", "Aw man..."}, {"JUMPCUT", "COURT_WITNESS"}
        }
    }

    self.scriptLines = self.scripts[math.random(1, #self.scripts)]

    for i,v in pairs(self.scriptLines) do
        if v[1] == "SPEAK" then
            table.insert(scene.stack, i, {lineParts = v, event = NewSpeakEvent(v[2], v[3], "literal")})
        end
        if v[1] == "INTERRUPTED_SPEAK" then
            table.insert(scene.stack, i, {lineParts = v, event = NewInterruptedSpeakEvent(v[2], v[3], "literal")})
        end
        if v[1] == "THINK" then
            table.insert(scene.stack, i, {lineParts = v, event = NewThinkEvent(v[2], v[3], "literal")})
        end
        if v[1] == "POSE" then
            table.insert(scene.stack, i, {lineParts = v, event = NewPoseEvent(v[2], v[3])})
        end
        if v[1] == "ANIMATION" then
            if #v == 4 then
                table.insert(scene.stack, i, {lineParts = v, event = NewAnimationEvent(v[2], v[3], v[4])})
            else
                table.insert(scene.stack, i, {lineParts = v, event = NewAnimationEvent(v[2], v[3])})
            end
        end
        if v[1] == "JUMPCUT" then
            table.insert(scene.stack, i, {lineParts = v, event = NewCutToEvent(v[2])})
        end
        if v[1] == "SCREEN_SHAKE" then
            table.insert(scene.stack, i, {lineParts = v, event = NewScreenShakeEvent()})
        end
        if v[1] == "GAVEL" then
            table.insert(scene.stack, i, {lineParts = v, event = NewGavelEvent()})
        end
        if v[1] == "SFX" then
            table.insert(scene.stack, i, {lineParts = v, event = NewPlaySoundEvent(v[2])})
        end
        if v[1] == "SET_SYNC" then
            table.insert(scene.stack, i, {lineParts = v, event = NewSetSyncEvent(v[2])})
        end

        if v[1] == "ISSUE_PENALTY" then
            table.insert(scene.stack, i, {lineParts = v, event = NewStartPenaltyAnimationEvent(scene, self)})
        end
    end

    self.update = function(self, scene, dt)
        if scene.penalties <= 0 then
            table.insert(scene.stack, 2, {lineParts = "fadeToBlackEvent", event = NewFadeToBlackEvent()})
            table.insert(scene.stack, 3, {lineParts = "gameOverEvent", event = NewGameOverEvent()})
            table.remove(scene.stack, 1)
            scene.currentEventIndex = scene.currentEventIndex + 1
        end

        return false
    end

    self.draw = function(self, scene)
        for i=1, scene.penalties do
            love.graphics.draw(Sprites["Penalty"], (i - 1) * 12 + 2, 2)
        end
    end

    return self
end

function NewStartPenaltyAnimationEvent(scene, event)
    local self = {}
    self.timer = 0
    self.animIndex = 1
    self.removedPenalty = false

    self.update = function(self, scene, dt)

        if not self.removedPenalty then
            self.removedPenalty = true
            scene.penalties = scene.penalties - 1
        end

        self.timer = self.timer + dt

        if self.timer > self.animIndex * 0.1 then
            self.animIndex = self.animIndex + 1
        end

        if self.timer < 0.2 then
            Sounds.DAMAGE2:play()
        end

        return self.animIndex < 4
    end

    self.draw = function(self, scene)
        for i=1, scene.penalties do
            love.graphics.draw(Sprites["Penalty"], (i - 1) * 12 + 2, 2)
        end
        if self.animIndex < 4 then
            love.graphics.draw(Sprites["Explosion"..self.animIndex], scene.penalties * 12 + 1, 1, 0, 0.2, 0.2)
        end
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

    self.update = function(self, scene, dt)
        self.timer = self.timer + dt
        self.frameCounter = self.frameCounter + dt

        while self.frameCounter >= 2/15 do
            self.frameCounter = self.frameCounter - 2/15
            self.headAnim = self.headAnim + 1
            if self.headAnim > 4 then
                self.headAnim = 1
            end
        end

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

    self.draw = function(self, scene)
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

    self.update = function(self, scene, dt)
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

    self.draw = function(self, scene)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
        love.graphics.setColor(1,1,1)
        local gavelAnimation = Sprites["GavelAnimation"]
        local spr = gavelAnimation[self.index]
        love.graphics.draw(spr, 0, 0, 0, GraphicsWidth/spr:getWidth(),GraphicsHeight/spr:getHeight())
    end
    return self
end

function NewGavel3Event()
    local self = {}
    self.timer = 0
    self.loopIndex = 0
    self.index = 1
    self.sources = {}

    self.update = function(self, scene, dt)
        self.timer = self.timer + dt
        scene.textHidden = true
        scene.canShowCourtRecord = false

        if self.loopIndex <= 1.45 then

            if self.timer > 0.19 then
                self.index = 2
            end

            if self.timer > 0.24 then
                self.index = 3

                if self.loopIndex < 1 then
                    Sounds.GAVEL:play()
                end
            end

            if self.timer > 0.29 and self.loopIndex < 0.7 then
                self.index = 2
            end

            if self.timer > 0.34 and self.loopIndex < 0.7 then
                self.index = 1

                self.timer = 0
            end

            self.loopIndex = self.loopIndex + dt
            return true
        else
            return false
        end
    end

    self.draw = function(self, scene)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, GraphicsWidth, GraphicsHeight)
        love.graphics.setColor(1,1,1)
        local gavelAnimation = Sprites["GavelAnimation"]
        local spr = gavelAnimation[self.index]
        if self.loopIndex <= 1.5 then
            love.graphics.draw(spr, 0, 0, 0, GraphicsWidth/spr:getWidth(),GraphicsHeight/spr:getHeight())
        end
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

    self.update = function(self, scene, dt)
        scene.canShowBgTopLayer = false
        scene.canShowCharacter = false
        scene.textHidden = true

        self.x = self.x + 24*dt*60*GetSign(self.xTo-self.xStart)
        if self.xStart < self.xTo then
            return self.x < self.xTo
        end

        return self.x > self.xTo
    end

    self.draw = function(self, scene)
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

function NewVerdictEvent(verdict)
    local self = {}
    self.verdict = verdict
    self.verdictAnimFrames = nil
    self.timer = 0
    self.animIndex = 1
    self.animTime = 2.2

    self.update = function(self, scene, dt)
        scene.textHidden = true
        scene.canShowCourtRecord = false

        self.timer = self.timer + dt

        if self.verdict == "NotGuilty" then
            self.verdictAnimFrames = 22
            if self.timer > self.animIndex * 0.05 then
                if self.animIndex ~= self.verdictAnimFrames then
                    self.animIndex = self.animIndex + 1
                end
            end
            if self.animIndex == 10 or self.animIndex == 21 then
                for i,v in pairs(Sounds) do
                    v:stop()
                end
                Sounds["DRAMAPOUND"]:play()
            end
        elseif self.verdict == "Guilty" then
            self.verdictAnimFrames = 18
            if self.timer > self.animIndex * 0.1 then
                if self.animIndex ~= self.verdictAnimFrames then
                    self.animIndex = self.animIndex + 1
                end
                if (self.animIndex % 3 == 0 and self.animIndex ~= 18) or self.animIndex == 17 then
                    for i,v in pairs(Sounds) do
                        v:stop()
                    end
                    Sounds["DRAMAPOUND"]:play()
                end
            end
        end

        return self.timer < self.animTime
    end

    self.draw = function(self, scene)
        love.graphics.draw(Sprites[self.verdict..self.animIndex], GraphicsWidth/2 - 125, 0)
    end

    return self
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function stringSplit(s, delimiter)
    result = {};

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function isNaN(n)
    if (tostring(n) == "nan") then
        return true
    else return false
    end
end

function startTimer(event, dt)

    event.xTimer = event.xTimer + dt*2

    return event.xTimer
end