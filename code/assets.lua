function LoadBackgrounds(directoryName)
    Backgrounds = {
        NONE = {},
    }

    files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i,".png") then
            if string.match(i,"_1") then
                local a = i:gsub(".png","")
                local a = a:gsub("_1","")
                Backgrounds[a] = {love.graphics.newImage(directoryName..i)}
            elseif string.match(i,"_2") then
                local a = i:gsub(".png","")
                local a = a:gsub("_2","")
                table.insert(Backgrounds[a], love.graphics.newImage(directoryName..i))
            else
                local a = i:gsub(".png","")
                Backgrounds[a] = {love.graphics.newImage(directoryName..i)}
            end
        end
    end
end

function LoadMusic(directoryName)
    Music = {}

    files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i,".mp3") then
            local a = i:gsub(".mp3",""):upper()
            Music[a] = love.audio.newSource(directoryName..i, "static")
        elseif string.match(i,".wav") then
            local a = i:gsub(".wav",""):upper()
            Music[a] = love.audio.newSource(directoryName..i, "static")
        end
    end

    for i,v in pairs(Music) do
        v:setLooping(true)
        v:setVolume(MusicVolume / 100)
    end
end

function LoadSprites(directoryName)
    Sprites = {}

    files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i,".png") then
            if string.match(i,"_") then
                if string.match(i,"_1") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_1","")
                    local a = a.."Animation"
                    Sprites[a] = {love.graphics.newImage(directoryName..i)}
                elseif string.match(i,"_2") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_2","")
                    local a = a.."Animation"
                    table.insert(Sprites[a],love.graphics.newImage(directoryName..i))
                elseif string.match(i,"_3") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_3","")
                    local a = a.."Animation"
                    table.insert(Sprites[a],love.graphics.newImage(directoryName..i))
                elseif string.match(i,"_4") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_4","")
                    local a = a.."Animation"
                    table.insert(Sprites[a],love.graphics.newImage(directoryName..i))
                elseif string.match(i,"_5") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_5","")
                    local a = a.."Animation"
                    table.insert(Sprites[a],love.graphics.newImage(directoryName..i))
                elseif string.match(i,"_6") then
                    local a = i:gsub(".png","")
                    local a = a:gsub("_6","")
                    local a = a.."Animation"
                    table.insert(Sprites[a],love.graphics.newImage(directoryName..i))
                end
            elseif string.match(i,"Font") then
                False = false
            else
                local a = i:gsub(".png","")
                Sprites[a] = love.graphics.newImage(directoryName..i)
            end
        end
    end
end

function LoadShouts(directoryName)
    Shouts = {}

    files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i,".png") then
            local a = i:gsub(".png","")
            Shouts[a] = love.graphics.newImage(directoryName..i)
        end
    end
end

function LoadSFX(directoryName)
    Sounds = {}

    files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i,".mp3") then
            local a = i:gsub(".mp3",""):upper()
            Sounds[a] = love.audio.newSource(directoryName..i, "static")
        elseif string.match(i,".wav") then
            local a = i:gsub(".wav",""):upper()
            Sounds[a] = love.audio.newSource(directoryName..i, "static")
        end
    end

    for i,v in pairs(Sounds) do
        v:setVolume(SFXVolume / 100 / 2)
    end
end

function LoadMisc()
    GameFont = love.graphics.newImageFont("sprites/GameFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"', 2)
    SmallFont = love.graphics.newImageFont("sprites/SmallFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():", 1)
    GameFontBold = love.graphics.newImageFont("sprites/GameFontBold.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"', 2)
    SmallFontBold = love.graphics.newImageFont("sprites/SmallFontBold.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():", 1)
    CreditsFont = love.graphics.newImageFont("sprites/CreditsFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"/#@', 2)
    CreditsSmallFont = love.graphics.newImageFont("sprites/CreditsSmallFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~:(),-'*" .. '"``/#@', 1)
    love.graphics.setFont(GameFont)
end

function LoadAssets()
    LoadBackgrounds(settings.background_directory)
    LoadMusic(settings.music_directory)
    LoadSprites(settings.sprite_directory)
    LoadShouts(settings.shouts_directory)
    LoadSFX(settings.sfx_directory)
    LoadMisc()
end
