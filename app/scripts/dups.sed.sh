#!/usr/bin/sh

sed -E --silent --sandbox '
# https://www.gnu.org/software/sed/manual/sed.html

# remove empty lines
/^$/d

# print pattern space and exchange pattern and holdspace
p; x

# main loop
:check {
    # get the next line or exit if none
    n

    # matches lines that end in -git, -devel or version bound
    /(-git|[<=>].+|-devel)$/ {
        # exhange hold space and pattern space
        x

        # append copy of hold space to pattern space
        G

        # if the pattern space now matches the below pattern...
        s/^(.+)\n\1.*$/\1/M
        # exchange hold space and pattern space again
        x
        # and restart the loop
        t check
    }
    # otherwise, copy hold space to pattern space
    h
    # print the pattern space
    p
}
# and finally return back to the loop
b check
'
