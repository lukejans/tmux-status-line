BEGIN {
    branch = "<unknown>"
    changed = 0
    moved = 0
    untracked = 0
    unmerged = 0
    ahead = 0
    behind = 0
    stash = 0
}

/^# branch.oid / {
    o_id = $3
}

/^# branch.head / {
    head = $3
}

/^# branch.ab / {
    ahead = substr($3, 2)
    behind = substr($4, 2)
}

/^# stash / {
    stash = $3
}

/^[12] / {
    status = $2
    if (status ~ /M/ || status ~ /D/) changed++
    if (status ~ /R/) moved++
}

/^u / {
    unmerged++
}

/^\?/ {
    untracked++
}

END {
    if (head == "(detached)") {
        branch = "HEAD(" substr(o_id, 1, 7) ")"
    } else {
        branch = head
    }

    print branch, ahead, behind, changed, moved, untracked, stash, unmerged
}
