# awesome-calendar

## About
Simple Awesome 3.5 calendar widget, based on [http://awesome.naquadah.org/wiki/Calendar_widget](http://awesome.naquadah.org/wiki/Calendar_widget)

![Screenshot](https://github.com/cdump/awesome-calendar/raw/screenshots/awesome-calendar.png)

## Install

0. Go to configuration directory, usually `~/.config/awesome`

1. Clone repository:

`git clone https://github.com/cdump/awesome-calendar.git calendar35`

2. Modify your `rc.lua`, add

`local calendar = require("calendar35")`

`calendar.addCalendarToWidget(your_datetime_widget)`
