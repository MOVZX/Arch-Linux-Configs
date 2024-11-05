#!/usr/bin/env bash

alias clr='clear'
alias rst='clear && reset && history -c && history -w'
alias hclean='history -c && history -w && exit'
alias hcl='hclean'

alias sd='sudo'

alias dc='cd'
alias ccd='cd'

alias mkd='mkdir'
alias md='mkd'
alias smkd='sd mkdir'
alias smd='sd mkdir'

alias rrf='rm -rf'
alias srm='sd rm'
alias srmd='sd rm -rf'

alias sctl='systemctl'

alias nan='nano'
alias snan='sd nano'

alias kat='kate'

alias pacman='sd pacman'
alias pac='pacman'

alias pacu='pac -Sy'
alias pacs='pac -Ss'
alias pacsi='pac -Q | grep'
alias pacug='pac -Syu'
alias paci='pac -S'
alias pacr='pac -R'
alias pacc='yay -Scc'
alias pacp='pac -Rsn'
alias pacar='pac -Qqd | pac -Rsu -'
alias pacru='sd paccache -ruk0'
alias yayc='yay -Yc'
alias pacfi='pac -U'
alias pacfu='pac -Fy'

alias dk='make darkness_defconfig'
alias mrp='make mrproper -j$(nproc)'
alias mk='make -j$(nproc)'
alias mkc='make clean -j$(nproc)'

alias mkp='makepkg --skipchecksums --skipinteg --skippgpcheck'
alias mkpc='rm -rf src/ pkg/ *.zst & mkp -si'

alias ls='lsd --color=auto'
alias sl='ls'
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias lt='ls --tree'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias blk='lsblk -po NAME,LABEL,SIZE,FSUSED,FSUSE%,FSTYPE,MOUNTPOINTS,TRAN,MODEL'

alias ff='fastfetch'
alias matrix='neo-matrix -aD -c purple -s'

alias wat='watch -c -d -n 1'

alias btrfs='sd btrfs'
alias btr='btrfs'
alias vol='btr subvolume'
alias sna='vol snapshot'
alias lis='vol list'
alias sen='btr send'
alias rec='btr receive'
alias cre='vol create'
alias del='vol delete'

alias ugrub='sd update-grub'

alias mnt='sd mount'
alias umnt='sd umount'
alias umntiso='umnt /mnt/iso'

alias htop='btop'

alias mygit='source ~/.mygit'
