rawset(_ENV, "config", {}) -- stop linter from bitching

config.debug = false

config.gameTimeCycles = {
    { hh = 6,  mm = 0, duration = 1920 }, -- day:   06:00→19:00, 32 min real
    { hh = 19, mm = 0, duration = 960 },  -- night: 19:00→06:00, 16 min real
}

-- how often weather will change
config.weatherIntervalInSec = 3600 -- 1 hours

-- how fast weather will change, 0 is instantly
config.weatherInterpolationSpeedInMs = 128.0

-- startup time settings
config.startUpTime = { hour = 12, min = 0 }

-- weather will change in order of this list
config.availableWeathers = {
    "CLEAR",
    "EXTRASUNNY",
    "CLOUDS",
    "OVERCAST",
    "RAIN",
    "CLEARING",
    "THUNDER",
    "SMOG",
    "FOGGY",
    "XMAS",
    "SNOW",
    "SNOWLIGHT",
    "BLIZZARD",
    "HALLOWEEN",
    "NEUTRAL",
}
