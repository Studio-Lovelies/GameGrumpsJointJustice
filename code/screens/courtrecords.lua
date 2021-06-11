require "config"

function DrawCourtRecords(ui)
    local bodyOptions = {}
    local bodySelected = nil
    local menuButtons = {
        {
            title = "Back",
            key = controls.press_court_record
        },
        -- TODO: Can you present a profile?
        {
            title = "Present",

            key = controls.press_confirm
        }
    }
    local menuTitle

    if ui == "evidence" then
        menuTitle = "Evidence"

        -- Draw evidence UI
        for i=1, #Episode.courtRecords.evidence do
            table.insert(bodyOptions, Episode.courtRecords.evidence[i].sprite)
        end

        table.insert(
            menuButtons,
            {
                title = "Profiles",
                key = controls.press_toggle_profiles
            }
        )

        if Episode.courtRecords.evidence[CourtRecordIndexE] ~= nil then
            bodySelected = {
                image = Episode.courtRecords.evidence[CourtRecordIndexE].sprite,
                title = Episode.courtRecords.evidence[CourtRecordIndexE].externalName,
                details = Episode.courtRecords.evidence[CourtRecordIndexE].info
            }
        end
    else
        menuTitle = "Profiles"

        -- Draw profiles UI
        for i=1, #Episode.courtRecords.profiles do
            table.insert(bodyOptions, Episode.courtRecords.profiles[i].sprite)
        end
        table.insert(
            menuButtons,
            {
                title = "Evidence",
                key = controls.press_toggle_profiles
            }
        )

        if Episode.courtRecords.profiles[CourtRecordIndexP] ~= nil then
            bodySelected = {
                image = Episode.courtRecords.profiles[CourtRecordIndexP].sprite,
                title = Episode.courtRecords.profiles[CourtRecordIndexP].characterName.." (Age: "..Episode.courtRecords.profiles[CourtRecordIndexP].age..")",
                details = Episode.courtRecords.profiles[CourtRecordIndexP].info
            }
        end
    end

    DrawCenteredRectangle({
        width = love.graphics.getWidth() * 4/5,
        height = love.graphics.getHeight() - 120,
        buttons = menuButtons,
        title = menuTitle,
        body = {
            selected = bodySelected,
            options = bodyOptions
        }
    })
end

bleep = love.audio.newSource("sounds/bleep.wav", "static")
bleep:setVolume(settings.sfx_volume / 100 / 2)

CourtRecordsConfig = {
    displayed = false;
    displayKey = controls.press_court_record;
    displayCondition = function()
        -- You can only view your court records
        return true;
    end;
    onDisplay = function()
        screens.pause.displayed = false
        screens.courtRecords.displayed = true
        screens.options.displayed = false
        screens.title.displayed = false
        screens.volume.displayed = false
        CourtRecordIndexE = 1
        CourtRecordIndexP = 1
        menu_type = "evidence"
    end;
    onKeyPressed = function(key)
        if CourtRecordIndexE == nil then
            CourtRecordIndexE = 1
        end
        if CourtRecordIndexP == nil then
            CourtRecordIndexP = 1
        end
        if key == controls.advance_text then
            return
        end
        if menu_type == "evidence" then
            if key == controls.press_left and CourtRecordIndexE > 1 then
                bleep:stop()
                bleep:play()
                CourtRecordIndexE = CourtRecordIndexE - 1
            elseif key == controls.press_right then
                bleep:stop()
                bleep:play()
                if menu_type == "evidence" and CourtRecordIndexE < #Episode.courtRecords.evidence then
                    CourtRecordIndexE = CourtRecordIndexE + 1
                end
            elseif key == controls.press_confirm then
                -- TODO: Implement what happens when you confirm?
            elseif key == controls.press_toggle_profiles then
                CourtRecordIndexP = 1
                if menu_type == "evidence" then
                    -- Toggle on profiles UI
                    menu_type = "profiles"
                else
                    -- Toggle off profiles UI
                    menu_type = "evidence"
                end
            end
        else
            if key == controls.press_left and CourtRecordIndexP > 1 then
                bleep:stop()
                bleep:play()
                CourtRecordIndexP = CourtRecordIndexP - 1
            elseif key == controls.press_right then
                bleep:stop()
                bleep:play()
                if menu_type == "profiles" and CourtRecordIndexP < #Episode.courtRecords.profiles then
                    CourtRecordIndexP = CourtRecordIndexP + 1
                end
            elseif key == controls.press_confirm then
                -- TODO: Implement what happens when you confirm?
            elseif key == controls.press_toggle_profiles then
                CourtRecordIndexE = 1
                if menu_type == "evidence" then
                    -- Toggle on profiles UI
                    menu_type = "profiles"
                else
                    -- Toggle off profiles UI
                    menu_type = "evidence"
                end
            end
        end
    end;
    draw = function()
        DrawCourtRecords(menu_type)
    end
}
