#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup

    PARSER="$PROJECT_ROOT/src/parsers/git-remote.awk"
}

@test "parses https github URL" {
    test_url="https://github.com/user-group/repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "github.com user-group repo"
}

@test "parses ssh github URL" {
    test_url="git@github.com:user-group/repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "github.com user-group repo"
}

@test "parses https gitlab URL" {
    test_url="https://gitlab.com/user-group/repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "gitlab.com user-group repo"
}

@test "parses ssh gitlab URL" {
    test_url="git@gitlab.com:user-group/repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "gitlab.com user-group repo"
}

@test "parses https URLs with dots in the user-group and repo" {
    test_url="https://gitlab.com/user.foo-group/cool.git.repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "gitlab.com user.foo-group cool.git.repo"
}

@test "parses ssh URLs with dots in the user-group and repo" {
    test_url="git@gitlab.com:user.foo-group/cool.git.repo.git"

    run awk -f "$PARSER" <<<"$test_url"

    assert_success
    assert_output "gitlab.com user.foo-group cool.git.repo"
}
