local function LoadBackgrounds(directoryName)
    Backgrounds = {
        NONE = {}
    }

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, background in ipairs(files) do
        lambdas[index] = function()
            if string.match(background, ".png") then
                if string.match(background, "_1") then
                    local a = background:gsub(".png", "")
                    local a = a:gsub("_1", "")
                    Backgrounds[a] = {love.graphics.newImage(directoryName .. background)}
                elseif string.match(background, "_2") then
                    local a = background:gsub(".png", "")
                    local a = a:gsub("_2", "")
                    table.insert(Backgrounds[a], love.graphics.newImage(directoryName .. background))
                else
                    local a = background:gsub(".png", "")
                    Backgrounds[a] = {love.graphics.newImage(directoryName .. background)}
                end
            end
        end
    end

    return lambdas
end

local function LoadMusic(directoryName)
    Music = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, song in ipairs(files) do
        lambdas[index] = function()
            if string.match(song, ".mp3") then
                local a = song:gsub(".mp3", ""):upper()
                Music[a] = love.audio.newSource(directoryName .. song, "static")
            elseif string.match(song, ".wav") then
                local a = song:gsub(".wav", ""):upper()
                Music[a] = love.audio.newSource(directoryName .. song, "static")
            end
        end
    end

    return lambdas
end

local function FinishLoadingMusic()
    for i, v in pairs(Music) do
        v:setLooping(true)
        v:setVolume(MusicVolume / 100)
    end
end

local function LoadSprites(directoryName)
    Sprites = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, sprite in ipairs(files) do
        lambdas[index] = function()
            if string.match(sprite, ".png") then
                if string.match(sprite, "_") then
                    if string.match(sprite, "_1") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_1", "")
                        local a = a .. "Animation"
                        Sprites[a] = {love.graphics.newImage(directoryName .. sprite)}
                    elseif string.match(sprite, "_2") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_2", "")
                        local a = a .. "Animation"
                        table.insert(Sprites[a], love.graphics.newImage(directoryName .. sprite))
                    elseif string.match(sprite, "_3") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_3", "")
                        local a = a .. "Animation"
                        table.insert(Sprites[a], love.graphics.newImage(directoryName .. sprite))
                    elseif string.match(sprite, "_4") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_4", "")
                        local a = a .. "Animation"
                        table.insert(Sprites[a], love.graphics.newImage(directoryName .. sprite))
                    elseif string.match(sprite, "_5") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_5", "")
                        local a = a .. "Animation"
                        table.insert(Sprites[a], love.graphics.newImage(directoryName .. sprite))
                    elseif string.match(sprite, "_6") then
                        local a = sprite:gsub(".png", "")
                        local a = a:gsub("_6", "")
                        local a = a .. "Animation"
                        table.insert(Sprites[a], love.graphics.newImage(directoryName .. sprite))
                    end
                elseif string.match(sprite, "Font") then
                    False = false
                else
                    local a = sprite:gsub(".png", "")
                    Sprites[a] = love.graphics.newImage(directoryName .. sprite)
                end
            end
        end
    end

    return lambdas
end

local function LoadShouts(directoryName)
    Shouts = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, shout in ipairs(files) do
        lambdas[index] = function()
            if string.match(shout, ".png") then
                local a = shout:gsub(".png", "")
                Shouts[a] = love.graphics.newImage(directoryName .. shout)
            end
        end
    end

    return lambdas
end

local function LoadSFX(directoryName)
    Sounds = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, sfx in ipairs(files) do
        lambdas[index] = function()
            if string.match(sfx, ".mp3") then
                local a = sfx:gsub(".mp3", ""):upper()
                Sounds[a] = love.audio.newSource(directoryName .. sfx, "static")
            elseif string.match(sfx, ".wav") then
                local a = sfx:gsub(".wav", ""):upper()
                Sounds[a] = love.audio.newSource(directoryName .. sfx, "static")
            end
        end
    end

    return lambdas
end

local function FinishLoadingSFX()
    for i, v in pairs(Sounds) do
        if i ~= "maletalk" and i ~= "femaletalk" then
            v:setVolume(SFXVolume / 100 / 2)
        else
            v:setVolume(SpeechVolume / 100 / 2)
        end
    end
end

local function LoadFonts()
    GameFont =
        love.graphics.newImageFont(
        "sprites/GameFont.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"',
        2
    )
    SmallFont =
        love.graphics.newImageFont(
        "sprites/SmallFont.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():",
        1
    )
    GameFontBold =
        love.graphics.newImageFont(
        "sprites/GameFontBold.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"',
        2
    )
    SmallFontBold =
        love.graphics.newImageFont(
        "sprites/SmallFontBold.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():",
        1
    )
    CreditsFont =
        love.graphics.newImageFont(
        "sprites/CreditsFont.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~():,-'*" .. '`"/#@',
        2
    )
    CreditsSmallFont =
        love.graphics.newImageFont(
        "sprites/CreditsSmallFont.png",
        " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!?~:(),-'*" .. '"``/#@',
        1
    )
    LoadingFont = love.graphics.newFont(24) -- it really doesn't matter what this font is
    love.graphics.setFont(GameFont)
end

function LoadAssets()
    local allLambdas = {}
    local i = 1
    local function appendListToList(subList)
        for _, lambda in ipairs(subList) do
            allLambdas[i] = lambda
            i = i + 1
        end
    end

    -- Loading fonts is pretty quick compared to everything else
    LoadFonts()

    appendListToList(LoadBackgrounds(settings.background_directory))
    appendListToList(LoadMusic(settings.music_directory))
    appendListToList(LoadSprites(settings.sprite_directory))
    appendListToList(LoadShouts(settings.shouts_directory))
    appendListToList(LoadSFX(settings.sfx_directory))

    return allLambdas
end

function FinishLoadingAssets()
    FinishLoadingMusic()
    FinishLoadingSFX()
end
