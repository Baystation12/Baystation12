#!/usr/bin/env bash
set -e

WORLD_LOG_COUNT=47
ANGLE_BRACKET_COUNT=739

FAILED=0

shopt -s globstar
num=`grep -E '\\\\(red|blue|green|black|b|i[^mc])' **/*.dm | wc -l`; echo "$num escapes (expecting 0)"; [ $num -eq 0 ] || FAILED=1
num=`grep -E '\WDel\(' **/*.dm | wc -l`; echo "$num Del()s (expecting exactly 5)"; [ $num -eq 5 ] || FAILED=1
num=`grep -E '"/atom' **/*.dm | wc -l`; echo "$num /atom text paths (expecting 2 or less)"; [ $num -le 2 ] || FAILED=1
num=`grep -E '"/area' **/*.dm | wc -l`; echo "$num /area text paths (expecting 2 or less)"; [ $num -le 2 ] || FAILED=1
num=`grep -E '"/datum' **/*.dm | wc -l`; echo "$num /datum text paths (expecting 2 or less)"; [ $num -le 2 ] || FAILED=1
num=`grep -E '"/mob' **/*.dm | wc -l`; echo "$num /mob text paths (expecting 2 or less)"; [ $num -le 2 ] || FAILED=1
num=`grep -E '"/obj' **/*.dm | wc -l`; echo "$num /obj text paths (expecting 12 or less)"; [ $num -le 12 ] || FAILED=1
num=`grep -E '"/turf' **/*.dm | wc -l`; echo "$num /turf text paths (expecting 8 or less)"; [ $num -le 8 ] || FAILED=1
num=`grep -E 'world<<|world[[:space:]]<<' **/*.dm | wc -l`; echo "$num world<< uses (expecting 1 or less)"; [ $num -eq 1 ] || FAILED=1
num=`grep -E 'world.log<<|world.log[[:space:]]<<' **/*.dm | wc -l`; echo "$num world.log<< uses (expecting ${WORLD_LOG_COUNT} or less)"; [ $num -le ${WORLD_LOG_COUNT} ] || FAILED=1
num=`grep -P '(?<!<)<<(?!<)' **/*.dm | wc -l`; echo "$num << uses (expecting ${ANGLE_BRACKET_COUNT} or less)"; [ $num -le ${ANGLE_BRACKET_COUNT} ] || FAILED=1
num=`find ./html/changelogs -not -name "*.yml" | wc -l`; echo "$num non-yml files (expecting exactly 2)"; [ $num -eq 2 ] || FAILED=1

[[ $FAILED -eq 1 ]] && exit 1 || exit 0
