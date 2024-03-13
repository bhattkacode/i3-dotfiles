#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

# if [ -e /home/sahaj/.nix-profile/etc/profile.d/nix.sh ]; then . /home/sahaj/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer