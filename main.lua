require "config" -- controls text file
require "code/events/index"
require "code/utils/index"
require "code/screens/index"
require "code/assets"
require "code/episode"
require "code/scene"
require "code/scriptloader"

local logoOpacity = 1
local drawLogo = true
local logoTimer = 0


function love.load(arg)
    InitGlobalConfigVariables()
    love.window.setFullscreen(true, "desktop")
    dimensions.window_width = love.graphics.getWidth()
    dimensions.window_height = love.graphics.getHeight()
    love.window.setMode(dimensions.window_width, dimensions.window_height, {fullscreen = true, resizable = true})
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")
    Renderable = love.graphics.newCanvas(GraphicsWidth, GraphicsHeight)
    ScreenShake = 0
    DtReset = false -- so scene load times don't factor into dt

    LoadAssets()
    Episode = NewEpisode(settings.episode_path)

    local arguments = {}
    local argIndex = 1
    -- First pass through the arguments to see what we're requesting
    while argIndex <= #arg do
        if arg[argIndex] == "debug" then
            arguments.debug = true
            argIndex = argIndex + 1
        else
            arguments[arg[argIndex]] = arg[argIndex + 1]
            argIndex = argIndex + 2
        end
    end

    -- Initialize the game based on our arguments
    if arguments.debug then
        controls.debug = arguments.debug
    end

    if arguments.script ~= nil then
        CurrentScene = NewScene(arguments.script)
        CurrentScene:update(0)
    else
        -- Select the first scene in the loaded episode
        CurrentScene = NewScene(Episode.scenes[1])
    end

    if arguments.skip ~= nil then
        for i=1, tonumber(arguments.skip) do
            table.remove(CurrentScene.stack, 1)
            CurrentScene.currentEventIndex = CurrentScene.currentEventIndex + 1
        end
    elseif arguments.script == nil then
        -- Title screen will take the player to the next scene on keypress
        screens.title.displayed = true
        -- This normally is triggered on keypress, but since we're showing
        -- the title manually, call this manually too
        screens.title.onDisplay()
    end
end

-- love.update and love.draw get called 60 times per second
-- transfer the update and draw over to the current game scene
function love.update(dt)
    if DtReset then
        dt = 1/60
        DtReset = false
    end

    if logoOpacity <= 0 then
        if logoTimer >= 4 then
            drawLogo = false
        else
            logoTimer = logoTimer + dt
        end
    else
        logoOpacity = logoOpacity - dt/3
        logoTimer = logoTimer + dt
    end

    Episode:update(dt)
end

function love.keypressed(key)
    local currentDisplayedScreen
    local nextScreenToDisplay
    for screenName, screenConfig in pairs(screens) do
        -- See if another screen is currently showing so we know whether
        -- or other screens can be displayed
        -- TODO: Is there a case where screens need to stack?
        if screenConfig.displayed then
            currentDisplayedScreen = screenName
        end

        if screenConfig.displayKey and key == screenConfig.displayKey and
            (screenConfig.displayCondition == nil or screenConfig.displayCondition()) then
            if screenName == currentDisplayedScreen then
                screenConfig.displayed = false
            else
                nextScreenToDisplay = screenConfig
            end
        elseif screenConfig.displayed and screenConfig.onKeyPressed then
            screenConfig.onKeyPressed(key)
        end

    end

    if nextScreenToDisplay and currentDisplayedScreen == nil then
        nextScreenToDisplay.displayed = true
        if nextScreenToDisplay.onDisplay then
            nextScreenToDisplay.onDisplay()
        end
    end
end

function love.draw()

    love.graphics.setColor(unpack(colors.white))
    love.graphics.setCanvas(Renderable)
    love.graphics.clear(unpack(colors.black))
    CurrentScene:draw()
    love.graphics.setCanvas()

    local dx,dy = 0,0
    if ScreenShake > 0 then
        dx = love.math.random() * choose{1, -1} * 2
        dy = love.math.random() * choose{1, -1} * 2
    end

    --dx = camerapan[1]
    --dy = camerapan[2]

    love.graphics.setColor(unpack(colors.white))

    love.graphics.draw(
        Renderable,
        dx*love.graphics.getWidth()/GraphicsWidth,
        dy*love.graphics.getHeight()/GraphicsHeight,
        0,
        love.graphics.getWidth()/GraphicsWidth,
        love.graphics.getHeight()/GraphicsHeight
    )

    for screenName, screenConfig in pairs(screens) do
        if screenConfig.displayed then
            screenConfig.draw()
        end
    end

    if controls.debug then
        love.graphics.setColor(unpack(colors.red))
        love.graphics.print(tostring(love.timer.getFPS( )), 10, 10)
        love.graphics.setColor(unpack(colors.white))
    end

    if drawLogo then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, dimensions.window_width, dimensions.window_height)
        love.graphics.setColor(1, 1, 1, logoOpacity)
        logo = love.graphics.newImage("studioloveliesfinal.png")
        love.graphics.draw(logo, dimensions.window_width/2 - logo:getWidth()/5.71, dimensions.window_height/2 - logo:getHeight()/5.71, 0, 0.35, 0.35)
    end
end
