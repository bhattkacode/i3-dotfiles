## Some scripts I made for personal use
- `nscratch.sh` scratchpad terminal for i3
  - `nscratch.sh <number>` to toggle the terminal with a tmux session
  - `nscratch.sh output` does 3 things:
    - if a command(not neovim) running in terminal AND the terminal is hidden, give its output. if not:
    - display my next exam's date (`givedate.py`) if `~/notes/todo.md` first bullet point is empty
    - ~display first todo.md bullet point if not empty~

- `bmon.sh` battery monitor
  - display output according to battery (pango markup)
  - sends notifications also

- `blu-notif` notifications for bluetooth
- `dualmonitor/` scripts to setup some external hdmi monitor
- `gsearch` and `hide.sh` is incomplete
- `cal.py` displays current event from your google calendar(put your credentials.json in your home directory)
  - download credentials.json by making a project google console/cloud, create credentials, then choose Oauth client api, then choose WebApp then download credentials
  - go to display_current_events() funcion in cal.py and change the calendar ids in calendar list to your ones(primary will be your first calendar, then you have to add ids for other calendars if you want)
- `fm` is an fzf file browser for quick navigation (select `.` to quit/land in the current directory)
  - left and right (or enter) arrow for back, forward navigation
- `LBSync.sh` to upload dotfiles to github
