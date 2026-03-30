local is_server = IsDuplicityVersion()

function BuildCycleData(cycles)
    local n = #cycles
    local total_ms = 0
    local segments = {}
    for i = 1, n do
        local c         = cycles[i]
        local next_c    = cycles[(i % n) + 1]
        local start_min = c.hh * 60 + c.mm
        local end_min   = next_c.hh * 60 + next_c.mm
        if end_min <= start_min then end_min = end_min + 1440 end -- wrap past midnight
        segments[i] = {
            offset_ms   = total_ms,
            duration_ms = c.duration * 1000,
            start_min   = start_min,
            span_min    = end_min - start_min,
        }
        total_ms = total_ms + c.duration * 1000
    end
    return total_ms, segments
end

function NetTimeToGameMin(net_time, total_ms, segments)
    local pos = net_time % total_ms
    for _, seg in ipairs(segments) do
        if pos < seg.offset_ms + seg.duration_ms then
            local t = (pos - seg.offset_ms) / seg.duration_ms
            return seg.start_min + t * seg.span_min
        end
    end
    local last = segments[#segments]
    return last.start_min + last.span_min
end

TIMESYNC_ENUM = {
    TIME_OFFSET_ROUND = 1,
    TIME_OFFSET_DAY = 2,
    IS_TIME_FREEZED = 3,
}

TIMESYNC_INFO = is_server and {
    [TIMESYNC_ENUM.TIME_OFFSET_ROUND] = 0,
    [TIMESYNC_ENUM.TIME_OFFSET_DAY] = 0,
    [TIMESYNC_ENUM.IS_TIME_FREEZED] = false,
}

if (is_server) then
    function UpdateGlobalState()
        if not (is_server) then return end

        GlobalState.TIMESYNC_INFO = TIMESYNC_INFO
    end

    -- reset global state
    UpdateGlobalState()
else
    TIMESYNC_INFO = GlobalState.TIMESYNC_INFO

    AddStateBagChangeHandler("TIMESYNC_INFO", "global", function(bag, key, value)
        if (key == "TIMESYNC_INFO") then
            TIMESYNC_INFO = value
        end
    end)
end
