#!/usr/bin/env awk

# Columns:    1,     2,    3,     4,     5,    6
# Columns: time, price, kind, store, goods, note

{
    print $0;
    total += $2;
    sum[$3] += $2;
}

END{
    print "----------";
    for(kind in sum){
        print kind, sum[kind]
    }
    print "----------";
    print total;
}
