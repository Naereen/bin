#!/usr/bin/env bash
#
# by Sairon Istyar, 2012, modified by Lilian Besson, 2014
# Now: https://bitbucket.org/lbesson/bin/wa_nocolor.sh
# OldSource: https://github.com/saironiq/shellscripts/blob/master/wolframalpha_com/wa.sh
# distributed under the GPLv3 license
# http://www.opensource.org/licenses/gpl-3.0.html
#

[ -f ~/.wolfram_api_key ] && . ~/.wolfram_api_key

# properly encode query
q=$(echo ${*} | sed 's/+/%2B/g' | tr '\ ' '\+')

# fetch and parse result
result=$(curl -s "http://api.wolframalpha.com/v2/query?input=${q}&appid=${API_KEY}&format=plaintext")

if [ -n "$(echo ${result} | grep 'Invalid appid')" ] ; then
	echo "Invalid API key!"
	echo "Get one at https://developer.wolframalpha.com/portal/apisignup.html"
	echo -n 'Enter your WolframAlpha API key:'
	read api_key
	echo "API_KEY=${api_key}" >> ~/.wolfram_api_key
	exit 1
fi

result=`echo "${result}" \
	| tr '\n' '\t' \
	| sed -e 's/<plaintext>/\'$'\n<plaintext>/g' \
	| grep -oE "<plaintext>.*</plaintext>|<pod title=.[^\']*" \
	| sed -e 's!<plaintext>!!g; \
		s!</plaintext>!!g; \
		s!<pod title=.*!## &!g; \
		s!<pod title=.!!g; \
		s!\&amp;!\&!g; \
		s!\&lt;!<!g; \
		s!\&gt;!>!g; \
		s!\&quot;!"!g' \
		-e "s/\&apos;/'/g" \
	| tr '\t' '\n' \
	| sed  '/^$/d; \
		s/\ \ */\ /g; \
		s/\\\:/\\\u/g'`

# print result
echo -e "${result}"
