#!/usr/bin/env bash
target="$@"
target2="${target// /%20}"
#echo "$target2"
echo Going to: firefox http://translate.google.fr/#auto/fr/"$target"
#read
firefox http://translate.google.fr/#auto/fr/"$target2"