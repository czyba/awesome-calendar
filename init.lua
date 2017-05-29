--
-- Calendar module for Awesome 3.5 WM
--
-- Based on: http://awesome.naquadah.org/wiki/Calendar_widget
-- Modified by: Maxim Andreev <andreevmaxim@gmail.com>
-- Forked from: https://github.com/cdump/awesome-calendar
-- Github: https://github.com/czyba/awesome-calendar
--
-- Add to rc.lua:
-- local calendar = require("calendar40")
-- ..
-- calendar.addCalendarToWidget(widget_datetime)
--

local string = string
local tostring = tostring
local os = os
local capi = {
    mouse = mouse,
    screen = screen
}
local awful = require("awful")
local naughty = require("naughty")
module("calendar40")

local calendar = {}
local current_day_format = '<span color="#ee7777"><b>%s</b></span>'

function displayMonth(month,year,weekStart)
    local today = os.date("%Y-%m-%d")
    local t,wkSt=os.time{year=year, month=month+1, day=0},weekStart or 1
    local d=os.date("*t",t)
    local mthDays,stDay=d.day,(d.wday-d.day-wkSt+1)%7

    local lines = " "

    for x=0,6 do
        lines = lines .. os.date(" <b>%a</b> ",os.time{year=2006,month=1,day=x+wkSt})
    end

    lines = lines .. "\n"

    local writeLine = 1
    while writeLine < (stDay + 1) do
        lines = lines .. "     "
        writeLine = writeLine + 1
    end

    for d=1,mthDays do
        local x = string.format("%3i", d)
        local t = os.time{year=year,month=month,day=d}
        if writeLine == 8 then
            writeLine = 1
            lines = lines .. "\n"
        end
        if today == os.date("%Y-%m-%d", t) then
            x = string.format(current_day_format, x)
        end
        lines = lines .. "  " .. x
        writeLine = writeLine + 1
    end
    local header = "<b>" .. os.date("%B, %Y", os.time{year=year,month=month,day=1}) .. "</b>\n"

    return header .. "\n" .. lines .. "\n"
end

function switchNaughtyMonth(switchMonths)
    if (#calendar < 3) then return end
    local swMonths = switchMonths or 1
    calendar[1] = calendar[1] + swMonths

    calendar_new = { calendar[1], calendar[2],
    naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(calendar[1], calendar[2], 2)),
        timeout = 0,
        hover_timeout = 0.5,
        screen = capi.mouse.screen,
        replaces_id = calendar[3].id
    })}
    calendar = calendar_new
end

function switchNaughtyGoToToday()
    if (#calendar < 3) then return end
    local swMonths = switchMonths or 1
    calendar[1] = os.date("*t").month
    calendar[2] = os.date("*t").year
    switchNaughtyMonth(0)
end

function addCalendarToWidget(mywidget, custom_current_day_format)
    if custom_current_day_format then current_day_format = custom_current_day_format end

    mywidget:connect_signal('mouse::enter', function ()
        local month, year = os.date('%m'), os.date('%Y')
        calendar = { month, year,
        naughty.notify({
            text = string.format('<span font_desc="%s">%s</span>', "monospace", displayMonth(month, year, 2)),
            timeout = 0,
            hover_timeout = 0.5,
            screen = capi.mouse.screen
        })
    }
end)
mywidget:connect_signal('mouse::leave', function () naughty.destroy(calendar[3]) end)

mywidget:buttons(awful.util.table.join(
awful.button({ }, 1, function()
    switchNaughtyMonth(-1)
end),
awful.button({ }, 2, switchNaughtyGoToToday),
awful.button({ }, 3, function()
    switchNaughtyMonth(1)
end),
awful.button({ }, 4, function()
    switchNaughtyMonth(-1)
end),
awful.button({ }, 5, function()
    switchNaughtyMonth(1)
end),
awful.button({ 'Shift' }, 1, function()
    switchNaughtyMonth(-12)
end),
awful.button({ 'Shift' }, 3, function()
    switchNaughtyMonth(12)
end),
awful.button({ 'Shift' }, 4, function()
    switchNaughtyMonth(-12)
end),
awful.button({ 'Shift' }, 5, function()
    switchNaughtyMonth(12)
end)
))
end

