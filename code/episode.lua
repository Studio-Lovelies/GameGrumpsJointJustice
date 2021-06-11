function NewEpisode(episodePath)
    local self = {
        loaded = false,
        started = false,
        scenes = {},
        sceneIndex = 1,
        courtRecords = {
            evidence = {},
            profiles = {}
        }
    }
    self.episodePath = episodePath
    self.nextEpisode = nil

    for line in love.filesystem.lines(episodePath) do
        table.insert(self.scenes, line)
    end

    self.update = function(self, dt)
        ScreenShake = math.max(ScreenShake - dt, 0)
        -- TODO: Decide if this applies to all screens that can be displayed
        if screens.title.displayed == false and screens.options.displayed == false and screens.volume.displayed == false and screens.pause.displayed == false and screens.browsescenes.displayed == false and screens.jorytrial.displayed == false then
            CurrentScene:update(dt)
        end
    end

    self.begin = function()
        self.sceneIndex = 1
        self.nextScene()
        self.started = true
    end

    self.stop = function()
        for i,v in pairs(Music) do
            v:stop()
        end
        for i,v in pairs(Sounds) do
            v:stop()
        end
        self.started = false
        return false
    end

    self.nextScene = function()

        if self.sceneIndex <= #self.scenes then
            CurrentScene = NewScene(self.scenes[self.sceneIndex])
            CurrentScene:update(0)
            DtReset = true
        else
            if episodePath ~= settings.game_over_path then
                CurrentScene:startCredits(self.creditLines)
            else
                Episode = self.nextEpisode
                Episode:begin()
            end
        end
    end

    self.loaded = true
    return self
end

function startCredits(scene)
    love.graphics.clear(1, 1, 1, 1)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(SmallFont)

    for line in love.filesystem.lines(settings.credits_path) do
        table.insert(scene.creditLines, line)
        love.graphics.print(line)
    end
end