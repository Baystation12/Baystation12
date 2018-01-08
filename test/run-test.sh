#!/usr/bin/env bash

# This is the entrypoint to the testing system, written for Baystation12 and
# inspired by Rust's configure system
#
# The tests are split up into groups by the `case` at the bottom, and the
# group(s) to run are selected by the TEST environment variable. Right now,
# there are 4 test groups:
# - ALL: Run all tests
# - CODE: Run code quality checks
# - WEB: Run tgui tests
# - MAP: Run map tests (notably, only this one compiles!)
#
# Additionally, the MAP group requires an additional environent variable,
# MAP_PATH, to be set. This variable is passed to the compiler to indicate which
# map to test. You will want to configure CI to run each of these passes, and
# run MAP several times with MAP_PATH set to each map that should be tested.
#
# The general structure of the test execution is as follows:
# - find_code:              Look for the project root directory and fail fast if
#                           it can't be found. Assumes that it is in . or ..;
#                           custom locations can be specified in CODEPATH
#                           environment variable.
# - run_configured_tests:   Evaluate TEST variable, call into appropriate test
#                           runner function.
# - run_all_tests:          Run every test group in sequence.
# - run_xxx_tests:          Run the tests for $xxx, doing any necessary setup
#                           first, including calling find_xxx_deps.
# - find_xxx_deps:          Using need_cmd, ensure that programs needed to run
#                           tests that are part of $xxx are available.
# - need_cmd:               Checks availability of command passed as the single
#                           argument. Fails fast if it's not available.
# - err:                    Prints arguments as text, exits indicating failure.
# - warn:                   Prints arguments as text, indicating a warning
#                           condition.
# - msg:                    Used by all printing, formats text nicely.
# - run_test:               Runs a test. The first argument is the friendly name
#                           of the test. The remaining arguments are the shell
#                           command(s) to run. If a test fails, a global counter
#                           is incremented and a warning is emitted.
# - run_test_fail:          Exactly as run_test, but considers failure of the
#                           command to be a successful test.
# - run_test_ci:            Gates run_test to only run test when being run on a
#                           CI platform. This is used to gate tests that are
#                           destructive in some manner.
# - exec_test:              Called by run_test{,fail}, actually executes the
#                           test and returns its resulti.
# - check_fail:             Called at the end of the run, prints final report
# and sets exit status appropriately.
# !!!!!!!! Instructions for adding tests:
# In general, if you want to add a test, it will probably belong to one of the
# groups that already exists. Add it to the relevant run_xxx_tests function, and
# if it introduces any new dependencies, add them to the check_xxx_deps
# function. Some dependencies are guaranteed to be on CI platforms by outside
# means (like .travis.yml), others will need to be installed by this script.
# You'll see plenty of examples of checking for CI and gating tests on that,
# installing instead of checking when running on CI.
#
# If you are *SURE* you need to add a new test group, you'll want to add it
# first to the case at the end of the file, and then add the run_xxx_tests and
# find_xxx_deps for it, adding things to them as appropriate. Importantly, make
# sure to also call run_xxx_tests from run_all_tests. Make sure also to call
# your find_xxx_deps from run_xxx_tests.
#
# Good luck!
# - xales

# Global counter of failed tests
FAILED=0
# List of names of failed tests
FAILED_BYNAME=()
# Global counter of passed tests
PASSED=0

# Version of Node to install for tgui
NODE_VERSION=4

function msg {
    echo -e "\t\e[34mtest\e[0m: $*"
}

function msg_bad {
    echo -e "\e[31m$*\e[0m"
}

function msg_good {
    echo -e "\e[32m$*\e[0m"
}

function msg_meh {
    echo -e "\e[33m$*\e[0m"
}

function warn {
    msg_meh "WARNING: $*"
}

function err {
    msg_bad "error: $*"
    exit 1
}

function fail {
    warn "test \"$1\" failed: $2"
    ((FAILED++))
    FAILED_BYNAME+=("$1")
}

function need_cmd {
    if command -v $1 >/dev/null 2>&1
    then msg "found '$1'"
    else err "program '$1' is missing, please install it"
    fi
}

function run_test {
    msg "running \"$1\""
    name=$1
    shift
    exec_test "$*"
    ret=$?
    if [[ ret -ne 0 ]]
    then fail "$name" $ret
    else ((PASSED++))
    fi
}

function run_test_fail {
    msg "running(fail) \"$1\""
    name=$1
    shift
    exec_test "$*"
    ret=$?
    if [[ ret -eq 0 ]]
    then fail "$name" $ret
    else ((PASSED++))
    fi
}

function run_test_ci {
    if [[ "$CI" == "true" ]]
    then run_test "$@"
    else msg_meh "skipping \"$1\""
    fi
}

function check_fail {
    if [[ $FAILED -ne 0 ]]; then
        for t in "${FAILED_BYNAME[@]}"; do
            msg_bad "TEST FAILED: \"$t\""
        done
        err "$FAILED tests failed"
    else msg_good "$PASSED tests passed"
    fi
}

function exec_test {
    eval "$*"
    ret=$?
    return $ret
}

function find_code_deps {
    need_cmd grep
    need_cmd awk
    need_cmd md5sum
    need_cmd python2
    need_cmd pip
}

function find_web_deps {
    need_cmd npm
    [[ "$CI" != "true" ]] && need_cmd gulp
}

function find_byond_deps {
    [[ "$CI" != "true" ]] && need_cmd DreamDaemon
}

function find_code {
    if [[ -z ${CODEPATH+x} ]]; then
        if [[ -d ./code ]]
        then CODEPATH=.
        else if [[ -d ../code ]]
            then CODEPATH=..
            fi
        fi
    fi
    cd $CODEPATH
    if [[ ! -d ./code ]]
    then err "invalid CODEPATH: $PWD"
    else msg "found code at $PWD"
    fi
}

function run_code_tests {
    msg "*** running code tests ***"
    find_code_deps
    pip install --user PyYaml -q
    pip install --user beautifulsoup4 -q
    shopt -s globstar
    run_test "check travis contains all maps" "scripts/validateTravisContainsAllMaps.sh"
    run_test_fail "maps contain no step_[xy]" "grep 'step_[xy]' maps/**/*.dmm"
    run_test_fail "ensure nanoui templates unique" "find nano/templates/ -type f -exec md5sum {} + | sort | uniq -D -w 32 | grep nano"
    run_test_fail "no invalid spans" "grep -En \"<\s*span\s+class\s*=\s*('[^'>]+|[^'>]+')\s*>\" **/*.dm"
    run_test "code quality checks" "test/check-paths.sh"
    run_test "indentation check" "awk -f tools/indentation.awk **/*.dm"
    run_test "check changelog example unchanged" "md5sum -c - <<< '79e058ac02ed52aad99a489ab4c8f75b *html/changelogs/example.yml'"
    run_test "check tags" "python2 tools/TagMatcher/tag-matcher.py ."
    run_test "check punctuation" "python2 tools/PunctuationChecker/punctuation-checker.py ."
    run_test "check icon state limit" "python2 tools/dmitool/check_icon_state_limit.py ."
    run_test_ci "check changelog builds" "python2 tools/GenerateChangelog/ss13_genchangelog.py html/changelog.html html/changelogs"
}

function run_web_tests {
    msg "*** running web tests ***"
    find_web_deps
    msg "installing web tools"
    if [[ "$CI" == "true" ]]; then
        rm -rf ~/.nvm && git clone https://github.com/creationix/nvm.git ~/.nvm && (cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`) && source ~/.nvm/nvm.sh && nvm install $NODE_VERSION
        npm install --no-spin -g gulp-cli
    fi

    msg "installing node modules"
    cd tgui && npm install --no-spin && cd ..
    run_test "check tgui builds" "cd tgui && gulp; cd .."
}

function run_byond_tests {
    msg "*** running map tests ***"
    find_byond_deps
    if [[ -z "${MAP_PATH+x}" ]]
    then exit 1
    else msg "configured map is '$MAP_PATH'"
    fi
    cp config/example/* config/
    if [[ "$CI" == "true" ]]; then
        msg "installing BYOND"
        ./install-byond.sh || exit 1
        source $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/byondsetup
    fi
    run_test_ci "check globals build" "python tools/GenerateGlobalVarAccess/gen_globals.py baystation12.dme code/_helpers/global_access.dm"
    run_test "check globals unchanged" "md5sum -c - <<< '51cfe7faa8ee4810cb13e99a5335fa99 *code/_helpers/global_access.dm'"
    run_test "build map unit tests" "scripts/dm.sh -DUNIT_TEST -M$MAP_PATH baystation12.dme"
    run_test "check no warnings in build" "grep ', 0 warnings' build_log.txt"
    run_test "run unit tests" "DreamDaemon baystation12.dmb -invisible -trusted -core 2>&1 | tee log.txt"
    run_test "check tests passed" "grep 'All Unit Tests Passed' log.txt"
    run_test "check no runtimes" "grep 'Caught 0 Runtimes' log.txt"
    run_test_fail "check no runtimes 2" "grep 'runtime error:' log.txt"
    run_test_fail "check no scheduler failures" "grep 'Process scheduler caught exception processing' log.txt"
    run_test_fail "check no warnings" "grep 'WARNING:' log.txt"
    run_test_fail "check no failures" "grep 'ERROR:' log.txt"
}

function run_all_tests {
    run_code_tests
    run_web_tests
    run_byond_tests
}

function run_configured_tests {
    if [[ -z ${TEST+z} ]]; then
        msg_bad "You must provide TEST in environment; valid options ALL,MAP,WEB,CODE"
        msg_meh "Note: map tests require MAP_PATH set"
        exit 1
    fi
    case $TEST in
        "ALL")
            run_all_tests
            ;;
        "MAP")
            run_byond_tests
            ;;
        "WEB")
            run_web_tests
            ;;
        "CODE")
            run_code_tests
            ;;
        *)
            fail "invalid option for \$TEST: '$TEST'"
            ;;
    esac
}

find_code
run_configured_tests
check_fail
