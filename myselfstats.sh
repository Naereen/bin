#! /usr/bin/env /bin/bash
# clear
echo -e "Basic selfstats results."
echo -e "See https://github.com/gurgeh/selfspy#example-statistics for more."
echo -e "See https://naereen.github.io/selfspy-vis/ for graphs."

selfstats --human-readable --ratios
selfstats --human-readable --pactive
