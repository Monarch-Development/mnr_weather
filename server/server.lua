local shared = lib.load('config.shared')
local server = lib.load('config.server')
local weatherTypes = server.weather

local time = {}

function time.Validate(h, m)
    local hour = type(h) == 'number' and math.max(0, math.min(23, h)) or 0
    local minute = type(m) == 'number' and math.max(0, math.min(59, m)) or 0

    return { h = hour, m = minute }
end

function time.ValidateSpeed(speed)
    local acceleration = type(speed) == 'number' and math.max(1, math.min(60, speed)) or 30
    local gameMinute = 60000 / acceleration

    return gameMinute
end

local weather = {}

function weather:Change()
    local rand = math.random(1, 100)
    local cumulative = 0
    for name, data in pairs(weatherTypes) do
        cumulative = cumulative + (data.chance or 0)
        if rand <= cumulative then
            local duration = math.random(data.minDuration, data.maxDuration)

            return name, duration
        end
    end

    return 'CLEAR', 30
end

local world = {}

function world:UpdateTime()
    self.time.m = (self.time.m + 1) % 60

    if self.time.m == 0 then
        self.time.h = (self.time.h + 1) % 24
    end

    GlobalState.time = self.time
end

function world:UpdateWeather()
    if self.duration > 0 then
        self.duration -= 1
    else
        self.weather, self.duration = weather:Change()

        GlobalState.weather = self.weather
    end
end

function world:UpdateWind()
    if self.duration > 0 then
        return
    end

    local direction = math.random(0.0, 360.0)
    local force = math.random(1.0, 12.0)

    GlobalState.wind = { direction = direction, force = force }
end

function world:Loop()
    while self.start do
        self:UpdateTime()
        self:UpdateWeather()
        self:UpdateWind()

        Wait(self.speed)
    end
end

function world:Init()
    self.speed = time.ValidateSpeed(shared.timeSpeed)
    self.time = time.Validate(shared.time.h, shared.time.m)
    self.weather, self.duration = weather:Change()
    self:UpdateWind()

    GlobalState.time = self.time
    GlobalState.weather = self.weather

    self.start = true
end

CreateThread(function()
    world:Init()
    world:Loop()
end)