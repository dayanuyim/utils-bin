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

convert 1.jpg -crop 2x6@ "1-%d.jpg"
convert 2.jpg -crop 2x6@ "2-%d.jpg"
convert 3.jpg -crop 2x6@ "3-%d.jpg"
convert 4.jpg -crop 2x3@ "4-%d.jpg"

# for i in {0..11}; do rename_order "1-$i.jpg" 2x6; done
# for i in {0..11}; do rename_order "2-$i.jpg" 2x6; done
# for i in {0..11}; do rename_order "3-$i.jpg" 2x6; done
# for i in {0..5};  do rename_order "4-$i.jpg" 2x3; done

order=$(cat <<EOT
1-0
2-1
1-2
2-3
1-4
2-5
1-6
2-7
1-8
2-9
1-10
2-11
1-1
2-0
1-3
2-2
1-5
2-4
1-7
2-6
1-9
2-8
1-11
2-10
3-0
4-1
3-2
4-3
3-4
4-5
3-6
3-8
3-10
3-1
4-0
3-3
4-2
3-5
4-4
3-7
3-9
3-11
EOT
)

count=1;
for i in $order; do
    mv "$i.jpg" "$(printf "%02d.jpg" $count)"
    ((count++))
done
