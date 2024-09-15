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
