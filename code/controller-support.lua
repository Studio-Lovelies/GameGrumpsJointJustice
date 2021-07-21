-- Intercept love.keyboard.isDown to also check controller input
local oldKeyIsDown = love.keyboard.isDown
love.keyboard.isDown = function(key)
    for i, joystick in ipairs(love.joystick.getJoysticks()) do
        if joystick:isGamepadDown(controller_button_to_keys[key]) then
            return true
        end
    end

    return oldKeyIsDown(key)
end

-- Forward gamepad inputs to love.keypressed
function love.gamepadpressed(_, joybutton)
    love.keypressed(controller_button_to_keys[joybutton]) -- yolo
end
