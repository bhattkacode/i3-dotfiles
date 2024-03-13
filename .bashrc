# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias nvn='cd ~/notes && nv -c "Telescope find_files"'
alias notesync='cd ~/notes && git add . && git commit -m "vault backup" && git push'
alias unimatrix='unimatrix -n -s 96 -l o'
alias ls='ls -a --group-directories-first --color=always'
alias nv='nvim'
alias v='vim'
alias nvsu='sudo -E -s nvim'
alias pymath='python3 -ic "from math import *"'
alias cpcmd='fc -nl -1 | cut -d " " -f 2- | xclip -sel clipboard'
alias todo="glow ~/notes/todo.md"
alias todon="nvim ~/notes/todo.md"
alias pcon="ssh u0_a251@192.168.0.199 -p8022 -L 9901:localhost:5901"
alias vncv="vncviewer localhost:9901"
alias ttoggle="xinput --list-props 13 | grep 'Device Enabled' | cut -f2 -d ':' | xargs -I {} bash -c 'if [ {} -eq 0 ]; then xinput --enable 13; else xinput --disable 13; fi'"
alias tk="tmux kill-session"
alias xsc="xclip -sel c"
adbw () { adb connect 192.168.0.194:$(nmap 192.168.0.197 -p 30000-49999 | awk '/\/tcp/' | cut -d/ -f1); }

PS1='\[\e[0;96m\]\W \[\e[0;1;91m\]>\[\e[0;1;38;5;118m\]> \[\e[0m\]'

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:~/scripts:/sbin/:~/.local/bin:~/.cargo/bin

# journal script (j, j -1, j w 2, etc.)
j() {
    local offset=0
    local type=d

    if [[ $1 =~ ^[dwmy]$ ]]; then
        type=$1
        shift
    fi

    if [[ $1 =~ ^[+-]?[0-9]+$ ]]; then
        offset=$1
    fi

    local desired_date
    local subpath

    case "$type" in
        d) desired_date=$(date -d "$offset days" +"%F")
           subpath="daily" ;;
        w) desired_date=$(date -d "$offset weeks" +"%Y-W%V")
           subpath="weekly" ;;
        m) desired_date=$(date -d "$offset months" +"%Y-%m")
           subpath="monthly" ;;
        y) desired_date=$(date -d "$offset years" +"%Y")
           subpath="yearly" ;;
    esac

    local file_path=~/notes/journal/"$subpath"/"$desired_date".md

    if [ ! -f "$file_path" ]; then
        nvim -c "e $file_path" -c "ObsidianTemplate $subpath.md" -c "norm \"_dd"
else
nvim "$file_path"
    fi
}
allcommands () { compgen -ac | fzf --preview 'whereis {};tldr {}' --layout=reverse --bind 'enter:execute( tldr {} | less)'; }
ggl () { links www.google.com/search?q="$*"; }
packbrowse() { pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'; }
orphanrm() { echo "sudo pacman -Qtdq | sudo pacman -Rns -"; }
pc() { sudo pacman -Syu "$*"; }
pcn() { sudo pacman -Syu --noconfirm "$*"; }
ycn() { yay -Syu --noconfirm "$*"; }
adbcon () { sudo adb devices; sudo adb tcpip 5555; sudo adb connect $(adb shell ip route | awk '{print $9}'):5555;}
# geturl () { sed 's/},{/}\n{/g' ~/Downloads/$(\ls -t1 ~/Downloads| grep tabgroups | head -n 1) | sed -n 's/.*"url":"\([^"]*\).*/\1/p' | xclip -sel clipboard; }
pcs() { 
    package_list=$(pacman -Ss | awk -F '/' '{print $2}' | awk '{print $1}' | sort);
    package=$(echo "$package_list" | fzf --preview 'pacman -Si {}' --layout=reverse --query="'");
    if [ "$package" != "" ];then
        echo -ne "sudo pacman -Syu $package\nExecute?(Y/n/no(c)onfirm)"
        read yn;
        if [ "$yn" == "y" ] || [ "$yn" == "" ];then
            sudo pacman -Syu "$package"
        elif [ "$yn" == "c" ];then
            sudo pacman -Syu --noconfirm "$package"
        fi
    fi
}

ycs() {
    if [ "$1" == "" ];then
        echo "search argument required"
    else
        aur_package_list=$(yay -Ss "$1" | awk 'NR % 2 == 1' | tac);
        selected_package=$(echo "$aur_package_list" | fzf --layout=reverse --query="'");
        if [ "$selected_package" != "" ];then
            packname=$( echo "$selected_package" | awk -F/ '{print $2}' | awk '{print $1}' )
            echo -ne "yay -S $packname \nExecute?(Y/n)"
            read yn;
            if [ "$yn" == "y" ] || [ "$yn" == "" ];then
                yay -Syu "$packname"
            fi
        fi
    fi
}

bind '"\C-g":"source ~/scripts/fm\C-m"'
bind '"\C- ":complete'

countdown() {
    start="$(( $(date +%s) + $1))"
    while [ "$start" -ge $(date +%s) ]; do
        ## Is this more than 24h away?
        # days="$(($(($(( $start - $(date +%s) )) * 1 )) / 86400))"
        time="$(( $start - `date +%s` ))"
        # printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.5
    done
    /usr/bin/paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}

stopwatch() {
    start=$(date +%s)
    while true; do
        # days="$(($(( $(date +%s) - $start )) / 86400))"
        time="$(( $(date +%s) - $start ))"
        # printf '%s day(s) and %s\r' "$days" "$(date -u -d "@$time" +%H:%M:%S)"
        printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 0.5
    done
}
# hdmi () {
#     xrandr=$(xrandr)
#     con_monitors=$(echo "$xrandr" | grep -c "HDMI")
#     if [[ $con_monitors -eq 1 ]]; then
#         xrandr --output eDP-1 --primary --mode 1366x768 --pos 1360x768 --rotate normal --output HDMI-1 --mode 1360x768 --pos 0x0 --rotate normal
#     else
#         echo "No HDMI connected"
#     fi
# }

export TERMINAL='st' 

source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash
export SUDO_EDITOR="nvim"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export PAGER="nvim +Man!"
export BROWSER="thorium-browser"
