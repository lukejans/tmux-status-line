#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup

    FIXTURES="$PROJECT_ROOT/test/fixtures/git-issue"
    PARSER="$PROJECT_ROOT/src/parsers/git-issue.awk"
}

@test "parses gh pr list with bug label" {

    run awk -f "$PARSER" "$FIXTURES/gh-issue-list.txt"

    assert_success
    assert_output "3 2"
}

@test "parses gh pr empty list" {

    run awk -f "$PARSER" "$FIXTURES/gh-issue-empty-list.txt"

    assert_success
    assert_output "0 0"
}

@test "parses glab mr list with bug label" {

    run awk -f "$PARSER" "$FIXTURES/gh-issue-list.txt"

    assert_success
    assert_output "3 2"
}

@test "parses glab mr empty list" {

    run awk -f "$PARSER" "$FIXTURES/gh-issue-empty-list.txt"

    assert_success
    assert_output "0 0"
}
