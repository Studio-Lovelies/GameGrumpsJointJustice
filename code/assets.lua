local function LoadBackgrounds(directoryName)
    Backgrounds = {
        NONE = {}
    }

    local files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i, ".png") then
            if string.match(i, "_1") then
                local a = i:gsub(".png", "")
                local a = a:gsub("_1", "")
                Backgrounds[a] = {love.graphics.newImage(directoryName .. i)}
            elseif string.match(i, "_2") then
                local a = i:gsub(".png", "")
                local a = a:gsub("_2", "")
                table.insert(Backgrounds[a], love.graphics.newImage(directoryName .. i))
            else
                local a = i:gsub(".png", "")
                Backgrounds[a] = {love.graphics.newImage(directoryName .. i)}
            end
        end
    end
end

local function LoadMusic(directoryName)
    Music = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, song in ipairs(files) do
        lambdas[index] = function()
            print("loading music", song)
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

    for b, i in ipairs(files) do
        if string.match(i, ".png") then
            if string.match(i, "_") then
                if string.match(i, "_1") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_1", "")
                    local a = a .. "Animation"
                    Sprites[a] = {love.graphics.newImage(directoryName .. i)}
                elseif string.match(i, "_2") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_2", "")
                    local a = a .. "Animation"
                    table.insert(Sprites[a], love.graphics.newImage(directoryName .. i))
                elseif string.match(i, "_3") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_3", "")
                    local a = a .. "Animation"
                    table.insert(Sprites[a], love.graphics.newImage(directoryName .. i))
                elseif string.match(i, "_4") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_4", "")
                    local a = a .. "Animation"
                    table.insert(Sprites[a], love.graphics.newImage(directoryName .. i))
                elseif string.match(i, "_5") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_5", "")
                    local a = a .. "Animation"
                    table.insert(Sprites[a], love.graphics.newImage(directoryName .. i))
                elseif string.match(i, "_6") then
                    local a = i:gsub(".png", "")
                    local a = a:gsub("_6", "")
                    local a = a .. "Animation"
                    table.insert(Sprites[a], love.graphics.newImage(directoryName .. i))
                end
            elseif string.match(i, "Font") then
                False = false
            else
                local a = i:gsub(".png", "")
                Sprites[a] = love.graphics.newImage(directoryName .. i)
            end
        end
    end
end

local function LoadShouts(directoryName)
    Shouts = {}

    local files = love.filesystem.getDirectoryItems(directoryName)

    for b, i in ipairs(files) do
        if string.match(i, ".png") then
            local a = i:gsub(".png", "")
            Shouts[a] = love.graphics.newImage(directoryName .. i)
        end
    end
end

local function LoadSFX(directoryName)
    Sounds = {}

    local files = love.filesystem.getDirectoryItems(directoryName)
    local lambdas = {}

    for index, sfx in ipairs(files) do
        lambdas[index] = function()
            print("loading SFX", sfx)
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
    love.graphics.setFont(GameFont)
end

function LoadAssets()
    LoadBackgrounds(settings.background_directory)
    local musicLambdas = LoadMusic(settings.music_directory)
    LoadSprites(settings.sprite_directory)
    LoadShouts(settings.shouts_directory)
    local soundEffectLambdas = LoadSFX(settings.sfx_directory)
    LoadFonts()

    local allLambdas = {}
    local index = 1
    for i, lambda in ipairs(soundEffectLambdas) do
        allLambdas[index] = lambda
        index = index + 1
    end

    for i, lambda in ipairs(musicLambdas) do
        allLambdas[index] = lambda
        index = index + 1
    end

    return allLambdas
end

function FinishLoadingAssets()
    FinishLoadingMusic()
    FinishLoadingSFX()
end
