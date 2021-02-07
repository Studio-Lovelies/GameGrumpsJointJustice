function NewAnimationInit(file, holdFirst)
    local animation = {}
    local source = love.graphics.newImage(file)

    animation.source = source
    animation.anim = {}

    -- TODO: This is to support animation files that are configured for the DS res.
    -- Once the files have been updated to have more white space between frames, should
    -- be able to remove this.
    local smallWidth = 256
    if holdFirst then
        for i = 1, 20 do
            animation.anim[i] = love.graphics.newQuad(0, 0, smallWidth, GraphicsHeight, source:getWidth(), source:getHeight())
        end
    end

    for i = 1, source:getWidth() / smallWidth do
        local x = (i - 1) * smallWidth
        animation.anim[#animation.anim + 1] = love.graphics.newQuad(x, 0, smallWidth, GraphicsHeight, source:getWidth(), source:getHeight())
    end

    return animation
end

-- initializes all character files based on folder
function NewCharInitEvent(name, location, gender)
    local self = {}
    self.name = name
    self.gender = gender

    -- allows for characters to be placed in characters/ or a custom directory
    if string.match(location,"/") then
        self.location = location
    else
        self.location = settings.character_directory..location
    end

    -- grabs the files in the character directory
    self.files = love.filesystem.getDirectoryItems(self.location)

    self.poses = {}
    self.animations = {}
    self.sounds = {}

    -- sorts files by type and adds them to the scene
    for b, i in ipairs(self.files) do
        if string.match(i,".png") then

            if string.match(i,"_ani") then
                local a = i:gsub(".png","")
                local a = a:gsub("_ani","")

                self.animations[a] = NewAnimationInit(self.location.."/"..i, false)
            elseif string.match(i,"_un") then
                local a = i:gsub(".png","")
                local a = a:gsub("_un","")

                self.poses[a] = NewAnimationInit(self.location.."/"..i, false)
            else
                local a = i:gsub(".png","")
                local isTalking = string.match(i, "Talking")

                self.poses[a] = NewAnimationInit(self.location.."/"..i, not isTalking)
            end

        elseif string.match(i,".wav") then
            local a = i:gsub(".wav","")
            self.sounds[a] = love.audio.newSource(self.location.."/"..i, "static")
            self.sounds[a]:setVolume(0.25)

        elseif string.match(i,".WAV") then
            local a = i:gsub(".WAV","")
            self.sounds[a] = love.audio.newSource(self.location.."/"..i, "static")
            self.sounds[a]:setVolume(0.25)
        end
    end

    self.update = function(self, scene, dt)
        scene.characters[self.name] = {
            poses = self.poses,
            animations = self.animations,
            sounds = self.sounds,

            location = self.location,
            wideshot = NewAnimationInit(self.location .. "/wideshot.png", false),
            name = self.name,
            gender = self.gender,
            frame = "Normal",
        }

        return false
    end

    return self
end

function NewEvidenceInitEvent(name, externalName, info, file)
    local self = {}
    self.name = name
    self.externalName = externalName
    self.info = info
    self.file = file

    self.update = function(self, scene, dt)
        if Sprites[self.externalName:gsub(" ", "")] == nil then
            mSprite = love.graphics.newImage("sprites/MissingTexture.png")
        else
            mSprite = love.graphics.newImage(self.file)
        end
        scene.evidence[self.name] = {
            name = self.name,
            externalName = self.externalName,
            info = self.info,
            sprite = mSprite,

        }

        return false
    end

    return self
end

function NewProfileInitEvent(name, characterName, age, info, file)
    local self = {}
    self.name = name
    self.characterName = characterName
    self.age = age
    self.info = info
    self.file = file

    self.update = function(self, scene, dt)
        scene.profiles[self.name] = {
            name = self.name,
            characterName = self.characterName,
            age = self.age,
            info = self.info,
            sprite = love.graphics.newImage(self.file),
        }

        return false
    end

    return self
end

function FileExists(filename)
    local f = io.open(filename,"r")
    if f~=nil then
        io.close(f)
        return true
    else
        return false
    end
end