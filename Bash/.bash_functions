#!/usr/bin/env bash

autocd()
{
    local dir="$1"

    if [[ "$dir" =~ ^(\.\./)+[^/]*$ ]]; then
        builtin cd "$dir"|| echo "Folder tidak ditemukan: $dir"
    else
        builtin cd "$dir"
    fi
}

cari1()
{
    if [ -z "$1" ]; then
        echo "Sintaks: cari1 LOKASI FORMAT KATA_KUNCI, contoh: cari /etc conf system";
    else
        find "$1" -not -path "./snapshots/*" -type f -iregex ".*\.\(${2}\)" -exec grep --color -n "$3" {} +;
    fi
}

cari2()
{
    if [ -z "$1" ]; then
        echo "Sintaks: cari1 LOKASI KATA_KUNCI, contoh: cari /etc system";
    else
        find "$1" -not -path "./snapshots/*" -type f -exec grep --color -n "$2" {} +;
    fi
}

lokasi()
{
    if [ -z "$1" ]; then
        echo "Sintaks: lokasi LOKASI NAMA_FILE, contoh: lokasi /etc config";
    else
        find "$1" -not -path "./snapshots/*" | grep --color -n "$2";
    fi
}

snar()
{
    if [ -z "$1" ]; then
        echo "Sintaks: snar SUBVOLUME SNAPSHOT, contoh: snar @root root";
    else
        TARGET="$1"
        REMOVE="@"
        TARGET="${TARGET//$REMOVE}"

        if [ -z "$2" ]; then
            sna -r "$1" "$TARGET_$(date +%Y-%m-%d_%H-%M-%S)";
        else
            sna -r "$1" "$2_$(date +%Y-%m-%d_%H-%M-%S)";
        fi
    fi
}

rest()
{
    if [ -z "$1" ]; then
        echo "Sintaks: rest SUBVOLUME TARGET, contoh: snar root_subvolume /mnt/backup";
    else
        if [ -z "$2" ]; then
            sen "$1" | rec /mnt/multimedia/;
        else
            sen "$1" | rec "$2";
        fi
    fi
}

rsy()
{
    if [ -z "$1" ]; then
        echo "Sintaks: rsy SUMBER TARGET, contoh: rsy Music /mnt/backup/";
    else
        rsync -ah --info=progress2 --exclude .snapshots/ "$1" "$2";
    fi
}

mntiso()
{
    if [ -z "$1" ]; then
        echo "Sintaks: mntiso FILE_ISO, contoh: mntiso Linux.iso";
    else
        if [ -z "$2" ]; then
            mnt -o loop,ro -t iso9660 "$1" /mnt/iso;
        else
            mnt -o loop,ro -t iso9660 "$1" "$2";
        fi
    fi
}

ytd()
{
    if [ -z "$1" ]; then
        echo "Sintaks: ytd LINK, contoh: ytd https://www.youtube.com/watch?v=bPZ6ix949rg";
    else
        yt-dlp --downloader aria2c -S tbr --merge-output-format "mkv" --embed-subs --sub-langs en,id --mtime --embed-thumbnail --convert-thumbnails jpg --newline --ignore-config --no-playlist -P "~/Downloads/Videos" "$1";
    fi
}

yt()
{
    if [ -z "$1" ]; then
        echo "Sintaks: yt LINK, contoh: yt https://www.youtube.com/watch?v=bPZ6ix949rg";
    else
        mpv --ytdl-format="bestvideo[height<=?1440]+bestaudio/best" --slang=en --sub-auto=fuzzy --ytdl-raw-options=ignore-config=,sub-lang=en,write-sub=,write-auto-sub= --volume=55 "$1";
    fi
}

zst()
{
    if [ -z "$1" ]; then
        echo "Sintaks: zst FILE_FOLDER LEVEL_KOMPRESI, contoh zst Folder/ 19";
    else
        TARGET="$1"
        REMOVE="/"
        TARGET="${TARGET//$REMOVE}"

        if [ -z "$2" ]; then
            tar -c -I 'zstd -19 -T0' -f "$TARGET.tar.zst" "$1";
        else
            tar -c -I 'zstd -$2 -T0' -f "$TARGET.tar.zst" "$1";
        fi
    fi
}

_cari1_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "FORMAT" -- "$cur") )
    elif [[ $COMP_CWORD -eq 3 ]]; then
        COMPREPLY=( $(compgen -W "KATA_KUNCI" -- "$cur") )
    fi
}

_cari2_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "KATA_KUNCI" -- "$cur") )
    fi
}

_lokasi_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "KATA_KUNCI" -- "$cur") )
    fi
}

_snar_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "SNAPSHOT" -- "$cur") )
    fi
}

_rest_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -d "/mnt/" -- "$cur") )
    fi
}

_rsy_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )
    fi
}

_mntiso_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "FILE_ISO" -- "$cur") )
    fi
}

_ytd_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "LINK" -- "$cur") )
    fi
}

_yt_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "LINK" -- "$cur") )
    fi
}

_zst_completion()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "FILE_FOLDER" -- "$cur") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        COMPREPLY=( $(compgen -W "LEVEL_KOMPRESI" -- "$cur") )
    fi
}

shopt -s autocd

complete -F _cari1_completion cari1
complete -F _cari2_completion cari2
complete -F _lokasi_completion lokasi
complete -F _snar_completion snar
complete -F _rest_completion rest
complete -F _rsy_completion rsy
complete -F _mntiso_completion mntiso
complete -F _ytd_completion ytd
complete -F _yt_completion yt
complete -F _zst_completion zst
