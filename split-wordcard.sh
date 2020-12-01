#!/usr/bin/env bash

# page_size=12
# 
# function rename_order {
#     ncol=${2%x*}
#     nrow=${2#*x}
# 
#     fbase=${1%.*}
#     fext=${1##*.}
#     page=${fbase%%-*}
#     sn=${fbase#*-}
# 
#     sn=$((page_size*(page-1) + (sn%2)*nrow + sn/2 + 1))
# 
#     dst="$(printf "%02d.%s" $sn "$fext")"
#     mv "$1" "$dst"
# }

if [[ "$#" != 4 ]]; then
    >&2 echo "usage: ${0##*/} <file1> <file2> <file3> <file4>"
    exit 1
fi

ext1=${1##*.}
ext2=${2##*.}
ext3=${3##*.}
ext4=${4##*.}

set -x
convert "$1" -crop 2x6@ "1-%d.$ext1"
convert "$2" -crop 2x6@ "2-%d.$ext2"
convert "$3" -crop 2x6@ "3-%d.$ext3"
convert "$4" -crop 2x3@ "4-%d.$ext4"
set +x

# for i in {0..11}; do rename_order "1-$i.jpg" 2x6; done
# for i in {0..11}; do rename_order "2-$i.jpg" 2x6; done
# for i in {0..11}; do rename_order "3-$i.jpg" 2x6; done
# for i in {0..5};  do rename_order "4-$i.jpg" 2x3; done

order=$(cat <<EOT
1-0.$ext1
2-1.$ext2
1-2.$ext1
2-3.$ext2
1-4.$ext1
2-5.$ext2
1-6.$ext1
2-7.$ext2
1-8.$ext1
2-9.$ext2
1-10.$ext1
2-11.$ext2
1-1.$ext1
2-0.$ext2
1-3.$ext1
2-2.$ext2
1-5.$ext1
2-4.$ext2
1-7.$ext1
2-6.$ext2
1-9.$ext1
2-8.$ext2
1-11.$ext1
2-10.$ext2
3-0.$ext3
4-1.$ext4
3-2.$ext3
4-3.$ext4
3-4.$ext3
4-5.$ext4
3-6.$ext3
3-8.$ext3
3-10.$ext3
3-1.$ext3
4-0.$ext4
3-3.$ext3
4-2.$ext4
3-5.$ext3
4-4.$ext4
3-7.$ext3
3-9.$ext3
3-11.$ext3
EOT
)

count=1;
for i in $order; do
    mv "$i" "$(printf "%02d.${i##*.}" $count)"
    ((count++))
done
