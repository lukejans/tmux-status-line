#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup

    FIXTURES="$PROJECT_ROOT/test/fixtures/git-pr-mr"
    PARSER="$PROJECT_ROOT/src/parsers/git-pr-mr.awk"
}

@test "parses gh pr list" {

    run awk -f "$PARSER" "$FIXTURES/gh-pr-list.txt"

    assert_success
    assert_output "2"
}

@test "parses gh pr empty list" {

    run awk -f "$PARSER" "$FIXTURES/gh-pr-empty-list.txt"

    assert_success
    assert_output "0"
}

@test "parses glab mr list" {

    run awk -f "$PARSER" "$FIXTURES/glab-mr-list.txt"

    assert_success
    assert_output "2"
}

@test "parses glab mr empty list" {

    run awk -f "$PARSER" "$FIXTURES/glab-mr-empty-list.txt"

    assert_success
    assert_output "0"
}
