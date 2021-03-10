function spl() {
    # usage split "string" "delim" N
    # returns the Nth element from the split array
    # https://github.com/dylanaraps/pure-bash-bible#split-a-string-on-a-delimiter
    IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
    printf '%s ' "${arr[@]}"
}
function dnsh() { 
    : ${DEBUG:=0}

    q=$1
    srv=$2
    tid="\x13\x37"
    flags="\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00" # standard, recursive, 1-question query
    qstr=""
    qtyp="\x00\x01\x00\x01" # type (A) class (IN)
    for s in $(spl $q "."); do
        qstr=$qstr$(printf '\\x%02X' "${#s}")$s
    done
    qstr=$qstr"\x00"
    q="$tid$flags$qstr$qtyp"
    exec 5<>/dev/udp/$srv/53
    echo -n -e "$q" >&5 
    cat <&5 | hexdump -C
}

# pure bash b64
# https://gist.github.com/p120ph37/015941a57f0d8f9a1722

# links
# http://dev.lab427.net/dns-query-wth-netcat.html
# https://www2.cs.duke.edu/courses/fall16/compsci356/DNS/DNS-primer.pdf
