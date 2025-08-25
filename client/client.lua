local shared = lib.load('config.shared')

local function loginSync()
    local timespeed = 60000 / shared.timeSpeed
    NetworkOverrideClockMillisecondsPerGameMinute(timespeed)
    SetRainLevel(-1.0)
    SetWeatherTypeNowPersist(GlobalState.weather)

    local wind = GlobalState.wind
    SetWindDirection(wind.direction)
    SetWindSpeed(wind.speed)
end

AddStateBagChangeHandler('time', 'global', function(_, _, time)
    NetworkOverrideClockTime(time.h, time.m, 0)
end)

AddStateBagChangeHandler('weather', 'global', function(_, _, weather)
    if not weather then return end

    SetRainLevel(-1.0)
    SetWeatherTypeOvertimePersist(GlobalState.weather, 40.0)
end)

AddStateBagChangeHandler('wind', 'global', function(_, _, wind)
    SetWindDirection(wind.direction)
    SetWindSpeed(wind.speed)
end)

CreateThread(loginSync)