#!/usr/bin/awk -f

# Takes all arguments passed to it as strings, and
# tries to remove any inappropriate suffixes

BEGIN {
    # https://catonmat.net/awk-one-liners-explained-part-two
    for (i = 1; i < ARGC; i++) {
        xfce[ARGV[i]]=1
        ARGV[i]=""
    }
}
{
    p = gensub(/(-git|[<=>].+|-devel)$/,"",1)
    if (xfce[p]) {
        print p
    } else {
        print $0
    }
}
