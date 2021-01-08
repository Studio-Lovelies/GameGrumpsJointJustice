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
    self.creditLines = {}

    for line in love.filesystem.lines(episodePath) do
        table.insert(self.scenes, line)
    end

    self.update = function(self, dt)
        ScreenShake = math.max(ScreenShake - dt, 0)
        -- TODO: Decide if this applies to all screens that can be displayed
        if screens.title.displayed == false and screens.pause.displayed == false then
            if screens.browsescenes.displayed == false and screens.title.displayed == false and screens.jorytrial.displayed == false then
                CurrentScene:update(dt)
            end
        end
    end

    self.begin = function()
        self.sceneIndex = 0
        self.nextScene()
    end

    self.stop = function()
        self.sceneIndex = #self.scenes
        return false
    end

    self.nextScene = function()
        self.sceneIndex = self.sceneIndex + 1

        if self.sceneIndex <= #self.scenes then
            CurrentScene = NewScene(self.scenes[self.sceneIndex])
            CurrentScene:update(0)
            DtReset = true
        else
            startCredits(self)
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
        print(line)
    end
end