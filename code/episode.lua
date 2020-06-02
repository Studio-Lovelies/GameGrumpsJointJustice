function NewEpisode(episodePath)
    local self = {
        loaded = false,
        scenes = {},
        sceneIndex = 0,
        courtRecords = {
            evidence = {},
            profiles = {}
        }
    }

    for line in love.filesystem.lines(episodePath) do
        table.insert(self.scenes, line)
    end

    self.update = function (self, dt)
        ScreenShake = math.max(ScreenShake - dt, 0)
        -- TODO: Decide if this applies to all screens that can be displayed
        if not screens.title.displayed and not screens.pause.displayed then
            CurrentScene:update(dt)
        end
    end

    self.begin = function ()
        self.sceneIndex = 0
        self.nextScene()
    end

    self.nextScene = function ()
        self.sceneIndex = self.sceneIndex + 1
        
        if self.sceneIndex <= #self.scenes then
            CurrentScene = NewScene(self.scenes[self.sceneIndex])
            CurrentScene:update(0)
            DtReset = true
        else
            love.event.push("quit")
        end
    end

    self.loaded = true
    return self
end