#!/usr/bin/env bash

autocd()
{
    local dir="$1"

    [[ "$dir" =~ ^(\.\./)+[^/]*$ ]] && builtin cd "$dir" || echo "Folder tidak ditemukan: $dir"
}

cari()
{
    [[ -z "$1" ]] && echo "Sintaks: cari LOKASI FORMAT KATA_KUNCI, contoh: cari /etc conf system" && return

    find "$1" -not -path "./snapshots/*" -type f -iregex ".*\.\(${2}\)" -exec grep --color -n "$3" {} +
}

cari_semua()
{
    [[ -z "$1" ]] && echo "Sintaks: cari_semua LOKASI KATA_KUNCI, contoh: cari_semua /etc system" && return

    find "$1" -not -path "./snapshots/*" -type f -exec grep --color -n "$2" {} +
}

lokasi()
{
    [[ -z "$1" ]] && echo "Sintaks: lokasi LOKASI NAMA_FILE, contoh: lokasi /etc config" && return

    find "$1" -not -path "./snapshots/*" | grep --color -n "$2"
}

snar()
{
    [[ -z "$1" ]] && echo "Sintaks: snar SUBVOLUME SNAPSHOT, contoh: snar @root root" && return

    local target="${1//@/}"

    sna -r "$1" "${2:-$target}_$(date +%Y-%m-%d_%H-%M-%S)"
}

rest()
{
    [[ -z "$1" ]] && echo "Sintaks: rest SUBVOLUME TARGET, contoh: snar root_subvolume /mnt/backup" && return

    sen "$1" | rec "${2:-/mnt/multimedia/}"
}

rsy()
{
    [[ -z "$1" ]] && echo "Sintaks: rsy SUMBER TARGET, contoh: rsy Music /mnt/backup/" && return

    rsync -ah --info=progress2 --exclude .snapshots/ "$1" "$2"
}

mntiso()
{
    [[ -z "$1" ]] && echo "Sintaks: mntiso FILE_ISO, contoh: mntiso Linux.iso" && return

    mnt -o loop,ro -t iso9660 "$1" "${2:-/mnt/iso}"
}

ytd()
{
    [[ -z "$1" ]] && echo "Sintaks: ytd LINK, contoh: ytd https://www.youtube.com/watch?v=bPZ6ix949rg" && return

    yt-dlp --downloader aria2c -S tbr --merge-output-format "mkv" --embed-subs --sub-langs en,id --mtime --embed-thumbnail --convert-thumbnails jpg --newline --ignore-config --no-playlist -P "~/Downloads/Videos" "$1"
}

yt()
{
    [[ -z "$1" ]] && echo "Sintaks: yt LINK, contoh: yt https://www.youtube.com/watch?v=bPZ6ix949rg" && return

    mpv --ytdl-format="bestvideo[height<=?1440]+bestaudio/best" --slang=en --sub-auto=fuzzy --ytdl-raw-options=ignore-config=,sub-lang=en,write-sub=,write-auto-sub= --volume=55 "$1"
}

zst()
{
    [[ -z "$1" ]] && echo "Sintaks: zst FILE_FOLDER LEVEL_KOMPRESI, contoh zst Folder/ 19" && return

    local target="${1//\//}"

    tar -c -I "zstd -${2:-19} -T0" -f "$target.tar.zst" "$1"
}

ubah()
{
    [[ -z "$1" || -z "$2" || -z "$3" ]] && echo "Sintaks: ubah STRING_ASAL STRING_UBAHAN FILE, contoh ubah AAAA BBBB file.txt" && return

    local asal=$(printf '%s\n' "$1" | sed 's/[\/&*]/\\&/g')
    local ubahan=$(printf '%s\n' "$2" | sed 's/[\/&]/\\&/g')

    sed -i "s/$asal/$ubahan/g" "$3"
}

ubah_semua()
{
    [[ -z "$1" || -z "$2" || -z "$3" ]] && echo "Sintaks: ubah_semua STRING_ASAL STRING_UBAHAN LOKASI, contoh ubah_semua AAAA BBBB /tmp" && return

    local asal=$(printf '%s\n' "$1" | sed 's/[\/&*]/\\&/g')
    local ubahan=$(printf '%s\n' "$2" | sed 's/[\/&]/\\&/g')

    find "$3" -type f | xargs sed -i "s/$asal/$ubahan/g"
}

_cari_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "FORMAT" -- "$cur"))
    [[ $COMP_CWORD -eq 3 ]] && COMPREPLY=($(compgen -W "KATA_KUNCI" -- "$cur"))
}

_cari_semua_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "KATA_KUNCI" -- "$cur"))
}

_lokasi_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "KATA_KUNCI" -- "$cur"))
}

_snar_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "SNAPSHOT" -- "$cur"))
}

_rest_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -d "/mnt/" -- "$cur"))
}

_rsy_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -d -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -d -- "$cur"))
}

_mntiso_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "FILE_ISO" -- "$cur"))
}

_ytd_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "LINK" -- "$cur"))
}

_yt_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "LINK" -- "$cur"))
}

_zst_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "FILE_FOLDER" -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "LEVEL_KOMPRESI" -- "$cur"))
}

_ubah_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "STRING_ASAL" -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "STRING_UBAHAN" -- "$cur"))
    [[ $COMP_CWORD -eq 3 ]] && COMPREPLY=($(compgen -W "FILE" -- "$cur"))
}

_ubah_semua_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    [[ $COMP_CWORD -eq 1 ]] && COMPREPLY=($(compgen -W "STRING_ASAL" -- "$cur"))
    [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "STRING_UBAHAN" -- "$cur"))
    [[ $COMP_CWORD -eq 3 ]] && COMPREPLY=($(compgen -W "LOKASI" -- "$cur"))
}

shopt -s autocd

complete -F _cari_completion cari
complete -F _cari_semua_completion cari_semua
complete -F _lokasi_completion lokasi
complete -F _snar_completion snar
complete -F _rest_completion rest
complete -F _rsy_completion rsy
complete -F _mntiso_completion mntiso
complete -F _ytd_completion ytd
complete -F _yt_completion yt
complete -F _zst_completion zst
complete -F _ubah_completion ubah
complete -F _ubah_semua_completion ubah_semua

# Daftar Fungsi
fungsi()
{
    local BOLD="\e[1;37;45m"
    local RESET="\033[0m"
    local ITALIC="\e[1;37;44m"

    printf "${BOLD}Daftar Fungsi${RESET}\n"
    echo ""
    printf "${ITALIC}cari${RESET}       : LOKASI FORMAT KATA_KUNCI\n"
    printf "${ITALIC}cari_semua${RESET} : LOKASI KATA_KUNCI\n"
    printf "${ITALIC}lokasi${RESET}     : LOKASI NAMA_FILE\n"
    printf "${ITALIC}snar${RESET}       : SUBVOLUME SNAPSHOT\n"
    printf "${ITALIC}rest${RESET}       : SUBVOLUME TARGET\n"
    printf "${ITALIC}rsy${RESET}        : SUMBER TARGET\n"
    printf "${ITALIC}mntiso${RESET}     : FILE_ISO\n"
    printf "${ITALIC}ytd${RESET}        : LINK\n"
    printf "${ITALIC}yt${RESET}         : LINK\n"
    printf "${ITALIC}zst${RESET}        : FILE_FOLDER LEVEL_KOMPRESI\n"
    printf "${ITALIC}ubah${RESET}       : STRING_ASAL STRING_UBAHAN FILE\n"
    printf "${ITALIC}ubah_semua${RESET} : STRING_ASAL STRING_UBAHAN LOKASI\n"
    printf "${ITALIC}mirror${RESET}     : JUMLAH UMUR NEGARA\n"
    printf "${ITALIC}powerusage${RESET} : CONFIG CPU_GPU\n"
    printf "${ITALIC}upscale${RESET}    : GAMBAR METODE SKALA\n"
    printf "${ITALIC}vconvert${RESET}   : vconvert VIDEO ENCODER\n"
    echo ""
    echo ""

    printf "${BOLD}Daftar Alias${RESET}\n"
    echo ""

    # Group 1
    printf "${ITALIC}clr${RESET}        : clear\n"
    printf "${ITALIC}rst${RESET}        : clear && reset && history -c && history -w\n"
    printf "${ITALIC}hclean${RESET}     : history -c && history -w && exit\n"
    printf "${ITALIC}hcl${RESET}        : hclean\n"
    echo ""

    # Group 2
    printf "${ITALIC}sd${RESET}         : sudo\n"
    echo ""

    # Group 3
    printf "${ITALIC}dc/ccd${RESET}     : cd\n"
    echo ""

    # Group 4
    printf "${ITALIC}md/mkd${RESET}     : mkdir\n"
    printf "${ITALIC}smd/smkd${RESET}   : sd mkdir\n"
    echo ""

    # Group 5
    printf "${ITALIC}rrf${RESET}        : rm -rf\n"
    printf "${ITALIC}srm${RESET}        : sd rm\n"
    printf "${ITALIC}srmd${RESET}       : sd rm -rf\n"
    echo ""

    # Group 6
    printf "${ITALIC}sctl${RESET}       : systemctl\n"
    echo ""

    # Group 7
    printf "${ITALIC}nan${RESET}        : nano\n"
    printf "${ITALIC}snan${RESET}       : sd nano\n"
    echo ""

    # Group 8
    printf "${ITALIC}kat${RESET}        : kate\n"
    echo ""

    # Group 9
    printf "${ITALIC}pac${RESET}        : pacman\n"
    printf "${ITALIC}pacu${RESET}       : pac -Sy\n"
    printf "${ITALIC}pacs${RESET}       : pac -Ss\n"
    printf "${ITALIC}pacsi${RESET}      : pac -Q | grep\n"
    printf "${ITALIC}pacug${RESET}      : pac -Syu\n"
    printf "${ITALIC}paci${RESET}       : pac -S\n"
    printf "${ITALIC}pacr${RESET}       : pac -R\n"
    printf "${ITALIC}pacc${RESET}       : yay -Scc\n"
    printf "${ITALIC}pacp${RESET}       : pac -Rsn\n"
    printf "${ITALIC}pacar${RESET}      : pac -Qqd | pac -Rsu -\n"
    printf "${ITALIC}pacru${RESET}      : sd paccache -ruk0\n"
    printf "${ITALIC}yayc${RESET}       : yay -Yc\n"
    printf "${ITALIC}pacfi${RESET}      : pac -U\n"
    printf "${ITALIC}pacfu${RESET}      : pac -Fy\n"
    echo ""

    # Group 10
    printf "${ITALIC}mrp${RESET}        : make mrproper -j\$(nproc)\n"
    printf "${ITALIC}mk${RESET}         : make -j\$(nproc)\n"
    printf "${ITALIC}mkc${RESET}        : make clean -j\$(nproc)\n"
    echo ""

    # Group 11
    printf "${ITALIC}mkp${RESET}        : makepkg --skipchecksums --skipinteg --skippgpcheck\n"
    printf "${ITALIC}mkpc${RESET}       : rm -rf src/ pkg/ *.zst & mkp -si\n"
    echo ""

    # Group 12
    printf "${ITALIC}l/ls/sl${RESET}    : lsd --color=auto\n"
    printf "${ITALIC}la${RESET}         : ls -a\n"
    printf "${ITALIC}ll${RESET}         : ls -l\n"
    printf "${ITALIC}lla${RESET}        : ls -la\n"
    printf "${ITALIC}lt${RESET}         : ls --tree\n"
    echo ""

    # Group 14
    printf "${ITALIC}blk${RESET}        : lsblk -po NAME,LABEL,SIZE,FSUSED,FSUSE%%,FSTYPE,MOUNTPOINTS,TRAN,MODEL\n"
    echo ""

    # Group 15
    printf "${ITALIC}ff${RESET}         : fastfetch\n"
    printf "${ITALIC}matrix${RESET}     : neo-matrix -aD -c purple -s\n"
    echo ""

    # Group 16
    printf "${ITALIC}wat${RESET}        : watch -c -d -n 1\n"
    echo ""

    # Group 17
    printf "${ITALIC}btr${RESET}        : btrfs\n"
    printf "${ITALIC}vol${RESET}        : btr subvolume\n"
    printf "${ITALIC}sna${RESET}        : vol snapshot\n"
    printf "${ITALIC}lis${RESET}        : vol list\n"
    printf "${ITALIC}sen${RESET}        : btr send\n"
    printf "${ITALIC}rec${RESET}        : btr receive\n"
    printf "${ITALIC}cre${RESET}        : vol create\n"
    printf "${ITALIC}del${RESET}        : vol delete\n"
    echo ""

    # Group 18
    printf "${ITALIC}ugrub${RESET}      : sd update-grub\n"
    echo ""

    # Group 19
    printf "${ITALIC}mnt${RESET}        : sd mount\n"
    printf "${ITALIC}umnt${RESET}       : sd umount\n"
    printf "${ITALIC}umntiso${RESET}    : umnt /mnt/iso\n"
    echo ""

    # Group 20
    printf "${ITALIC}htop${RESET}       : btop\n"
    echo ""

    # Group 21
    printf "${ITALIC}mygit${RESET}      : source ~/.mygit\n"
}


