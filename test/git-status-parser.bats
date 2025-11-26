#!/usr/bin/env bats

# git-status.awk output format:
#
# branch ahead behind changes moved untracked stash

setup() {
    load 'test_helper/common-setup'
    _common_setup

    FIXTURES="$PROJECT_ROOT/test/fixtures/git-status"
    PARSER="$PROJECT_ROOT/src/parsers/git-status.awk"
}

@test "parses clean repository" {
    run awk -f "$PARSER" "$FIXTURES/clean.txt"

    assert_success
    assert_output "main 0 0 0 0 0 0 0"
}

@test "parses detached HEAD state" {
    run awk -f "$PARSER" "$FIXTURES/detached.txt"

    assert_success
    assert_output "HEAD(a24d5a1) 0 0 0 0 0 0 0"
}

@test "parses repository ahead of remote" {
    run awk -f "$PARSER" "$FIXTURES/ahead.txt"

    assert_success
    assert_output "main 1 0 0 0 0 0 0"
}

@test "parses repository behind remote" {
    run awk -f "$PARSER" "$FIXTURES/behind.txt"

    assert_success
    assert_output "main 0 1 0 0 0 0 0"
}

@test "parses repository diverged branches" {
    run awk -f "$PARSER" "$FIXTURES/diverged.txt"

    assert_success
    assert_output "main 1 1 0 0 0 0 0"
}

@test "parses changed files" {
    run awk -f "$PARSER" "$FIXTURES/changed.txt"

    assert_success
    assert_output "main 0 0 3 0 0 0 0"
}

@test "parses moved files" {
    run awk -f "$PARSER" "$FIXTURES/moved.txt"

    assert_success
    assert_output "main 0 0 0 3 0 0 0"
}

@test "parses untracked files" {
    run awk -f "$PARSER" "$FIXTURES/untracked.txt"

    assert_success
    assert_output "main 0 0 0 0 3 0 0"
}

@test "parses stashed changes" {
    run awk -f "$PARSER" "$FIXTURES/stash.txt"

    assert_success
    assert_output "main 0 0 0 0 0 1 0"
}

@test "parses unmerged changes in a conflict" {
    run awk -f "$PARSER" "$FIXTURES/unmerged.txt"

    assert_success
    assert_output "main 0 0 0 0 0 0 3"
}
