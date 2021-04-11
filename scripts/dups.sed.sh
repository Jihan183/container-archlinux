#!/usr/bin/sh

sed -E --silent --sandbox '
# https://www.gnu.org/software/sed/manual/sed.html
p; x
:check {
    n
    # matches lines that end in -git, -devel or version bound
    /(-git|[<=>].+|-devel)$/ {
        x; G; s/^(.+)\n\1.*$/\1/M; x
        t check
    }
    h; p
}
b check
'
