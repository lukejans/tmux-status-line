BEGIN {
    FS = "\t"
    issues = 0
    bugs = 0
}

/^[0-9]/ {
    issues++

    gh_label_count = split($4, gh_labels, ",")
    for (i = 1; i <= gh_label_count; i++) {
        if (gh_labels[i] == "bug") {
            bugs++
            break
        }
    }
}

/^#[0-9]/ {
    issues++

    glab_label_count = split($3, glab_labels, "[\(,\]")
    for (i = 1; i <= glab_label_count; i++) {
        print glab_labels[i]
    }
}

END {
    print issues, bugs
}
