#!/usr/bin/env bash

# if ! declare -p DRYRUN &>/dev/null; then
#     DRYRUN=1
# fi

source "$HOME/bin/libs.sh"

PREFIXES=(
    /Volumes/bulk/Movie
    /Volumes/bulk
)
MOV_LST="$HOME/Dropbox/Doc_文件/movies.lst"

#================================================================================

function errmsg_exit {
    echo >&2 "$1"
    echo >&2 "usage: ${0##*/} lst"
    exit 1
}

function print_bar
{
    w=$(($(tput cols) - 2))
    echo "$(str_repeat '=' $w)>"
}

#================================================================================

function rm_meta_files {
    local dir="$1"

    chmod o-w "$dir"
    find "$dir" \( -name '.DS_Store' -or \
                   -name '~uTorrent*.dat' -or \
                   -name 'RARBG*' -or \
                   -name '*YIYF*.txt' -or \
                   -name '*YIYF*.jpg' -or \
                   -name '*YTS*.txt' -or \
                   -name '*YTS*.jpg' \
                \) -delete
    find "$dir" -type f -name '.*' -exec sh -c 'if file "{}" | grep -q AppleDouble; then rm "{}"; fi' \;
}

function mv_subtitles {
    local dir="$1"

    if [[ ! -d "$dir/Subs" ]]; then
        return 0
    fi

    local video="$(find "$dir" -size +100M -type f)"
    local count="$(wc -l <<<"$video" | xargs)"
    if [[ "$count" != 1 ]]; then
        echo >&2 "error: cannot identify the video file"
    else
        video="${video##*/}"
        echo >&2 "[+] video file: $video"

        # flaten subtitle files
        local basename="${video%.*}"
        for f in "$dir/Subs/"*; do
            [[ -e "$f" ]] || break  # handle the case of no files
            local fname="${f##*/}"
            if [[ ${fname} != ${basename}* ]]; then
                fname="$basename.$fname"
            fi
            mv "$f" "$dir/$fname"
        done
        rmdir "$dir/Subs"

        # rename the country part of filenames
        mv "$dir/$basename".*_Eng*.srt     "$dir/$basename.en.srt" 2>/dev/null
        mv "$dir/$basename".*_Chinese.srt  "$dir/$basename.zh.srt" 2>/dev/null
        mv "$dir/$basename".*_Japanese.srt "$dir/$basename.ja.srt" 2>/dev/null
    fi
}

function settle_mov {

    local dryrun=
    if [[ $1 == "-n" || $1 == "--dry-run" ]]; then
        dryrun=1 && shift
    fi

    local init=1
    if [[ $1 == "--no-init" ]]; then
        init=  && shift
    fi

    local src="${1%/}"
    local dst="${2%/}"

    if [[ -z $dryrun && ! -d "$src" ]]; then
        echo >&2 "settle_mov: No source folder '$src'."
        return 1
    fi

    if [[ -z $dryrun ]]; then
        if [[ -n "$init" ]]; then
            rm_meta_files "$src"
            mv_subtitles "$src"
        fi
        mv -n -v "$src" "$dst"
    else
        echo "mv $src -> $dst"
    fi
}

# read global variables $Src, $Dst
function copy_mov
{
    if [[ -z $Src ]]; then
        echo >&2 "error: no source folder specified"
        exit 2
    fi

    if [[ -z $Dst ]]; then
        echo >&2 "error: no destination folder specified"
        exit 2
    fi

    local flag=
    if [[ "$1" == "--dry-run" ]]; then
        flag="$1" && shift
    fi

    local mov="$1"
    local new_mov="$2"
    declare -n inv=$3

    if [[ -n "$KEEP_SRC" ]]; then
        rsync -avhP $flag \
            --exclude='.*' \
            --exclude='.DS_Store' \
            --exclude='~uTorrent*.dat' \
            --exclude='RARBG*' \
            --exclude='*YIFY*.txt' \
            --exclude='*YIFY*.jpg' \
            --exclude='*YTS*.txt' \
            --exclude='*YTS*.jpg' \
            "$Src/$mov" "$Dst/" ;
        ec=$?
        if [[ $ec -ne 0 ]]; then return $ec; fi

        local res="$(settle_mov $flag           "$Dst/$mov" "$Dst/$new_mov")"
    else
        local res="$(settle_mov $flag --no-init "$Src/$mov" "$Dst/$new_mov")"
    fi

    echo "${c_blueB}$res${c_end}"
    inv+=("$Dst/$new_mov")
}

function infer_name {
    local name="$1"
    local title="$2"
    local sp=

    # change the folder name
    if [[ $(grep -o '\.-' <<< "$name" | wc -l) -ge 3 ]]; then    # Archive
        sp='\.-'
    elif [[ $(grep -o '-' <<< "$name" | wc -l) -ge 3 ]]; then    # Archive
        sp='-'
    elif [[ $name == *" "* ]]; then                              # YTS
        sp=' '
    else                                                        # RARBG
        sp='\.'
    fi

    # Change Seperator to Comma;
    # Camel Case
    # Exclude Prepositions
    # Insert TITLE and Trim anyting after the year -------
    gsed <<< "$name" -E "\
        s@${sp}+@.@g; \
        s@['\"]@@g; \
        s@(.*)@\L\1@; \
        s@(\.|^)([a-z])@\1\U\2@g; \
        s@\.Of\.@.of.@g; \
        s@\.Or\.@.or.@g; \
        s@\.And\.@.and.@g; \
        s@\.Ii\.@.II.@g; \
        s@\.Iii\.@.III.@g; \
        s@\.Iv\.@.IV.@g; \
        s@\.Vi\.@.VI.@g; \
        s@\.Vii\.@.VII.@g; \
        s@\.Viii\.@.VIII.@g; \
        s@\.Ix\.@.IX.@g; \
        s@(.*)\.\(?(19|20)([0-9]{2})\)?(\..*|$)@\1.${title}.\2\3@"
}

function remove_prefix {
    local sed_script=
    for prefix in "${PREFIXES[@]}"; do
        sed_script+="s#^$prefix/##;"
    done
    sed -e "$sed_script"
}

function flash_inv {
    if [[ "$1" == "--dry-run" ]]; then
        shift
        local lst="/dev/null"
    else
        local lst="$MOV_LST"
    fi

    declare -n inv=$1

    print_bar
    printf '%s\n' "${inv[@]}" \
        | remove_prefix \
        | tee -a "$lst" \
        | nl -n rz -w2 -s'  '
}

function run
{
    clear && tmux clear-history

    local flag=
    if [[ "$1" == "--dry-run" ]]; then
        flag="$1" && shift
    fi

    local cnt=1
    local inventory=()

    while IFS= read -r line; do
        case "$line" in
            "" | "#"*)
                ;;
            "<< "*) Src="${line:3}"
                KEEP_SRC=
                ;;
            "< "*) Src="${line:2}"
                KEEP_SRC=1
                ;;
            "> "*) Dst="${line:2}"
                ;;
            *)
                local mov="$line"
                local title
                local sn
                local new_mov

                # read the next two lines
                IFS= read -r title
                IFS= read -r sn

                if [[ -n "$sn" && "$sn" != *. ]]; then
                    sn="${sn}."
                fi

                # infer the new movie name
                if [[ "$title" == "=" ]]; then                     # no change
                    new_mov="${sn}${mov}"
                elif [[ "$title" == =* ]]; then                    # just assign
                    new_mov="${sn}${title:1}"
                else
                    new_mov="${sn}$(infer_name "$mov" "$title")"   # to inder
                fi

                print_bar
                echo "${c_greenB}$(printf "#%03d   %-90s %-30s" "$cnt" "$mov" "$new_mov")${c_end}"
                #echo "${c_greenB}$(LC_ALL=C.UTF-8 gawk '{ printf "#%03d   %-90s %s", $1, $2, $3 }' <<< "$cnt $mov $new_mov")${c_end}"

                copy_mov $flag "$mov" "$new_mov" inventory

                ((++cnt))
                ;;
        esac
    done

    flash_inv $flag inventory
    return ${#inventory}
}

lst="$1"
if [[ ! -f $lst ]]; then
    errmsg_exit "error: no list file '$lst'"
fi

run --dry-run < "$lst"

count=$?
if [[ $count == 0 ]]; then
    echo >&2 "no entry in the list."
    exit 0
fi

if ask_yesno "Do the copy"; then
    run < "$lst"
fi
