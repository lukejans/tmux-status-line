BEGIN {
    FS = "/|:|@"
    provider = "unknown"
    user_group = "unknown"
    repo = "unknown"
}

/^https:/ {
    provider = $4
    user_group = $5

    sub(/\.git$/, "", $6)
    repo = $6
}

/^git@/ {
    provider = $2
    user_group = $3

    sub(/\.git$/, "", $4)
    repo = $4
}


END {
    print provider, user_group, repo
}
