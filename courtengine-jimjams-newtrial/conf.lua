-- If a file by this name is present in the game folder,
-- it will be run before LOVE modules are loaded by love2D.
-- More info: https://love2d.org/wiki/Config_Files

function love.conf(t)
    -- Support console logging
    t.console = true
    t.window.vsync = -1
    t.window.title = "Game Grumps: Joint Justice"
    t.window.resizable = false
    t.window.icon = "icon.png"
end
