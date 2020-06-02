function Clamp(n,min,max)
    return math.max(math.min(n,max), min)
end
function choose(arr)
    return arr[math.floor(love.math.random()*(#arr))+1]
end
function rand(min,max, interval)
    local interval = interval or 1
    local c = {}
    local index = 1
    for i=min, max, interval do
        c[index] = i
        index = index + 1
    end

    return choose(c)
end

function GetSign(n)
    if n > 0 then
        return 1
    end
    if n < 0 then
        return -1
    end
    return 0
end
function Lerp(a,b,t) return (1-t)*a + t*b end
function DeltaLerp(a,b,t, dt)
    return Lerp(a,b, 1 - t^(dt))
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Convert RGB color values to LOVE color values
function RGBColorConvert(r,g,b)
    local r = r/255
    local g = g/255
    local b = b/255
    return r,g,b
end

-- Convert RGBA color values to LOVE color values
function RGBAColorConvert(r,g,b,a)
    local r = r/255
    local g = g/255
    local b = b/255
    local a = a/255
    return r,g,b,a
end

-- Capitalize the first letter in a given string
function FirstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- Given a keyboard key, return the display name
function GetKeyDisplayName(str)
    return key_display_names[str] or FirstToUpper(str)
end