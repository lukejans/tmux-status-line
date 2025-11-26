BEGIN {
    pr_mr = 0
}

/^[!0-9]/ {
    pr_mr++
}

END {
    print pr_mr
}
