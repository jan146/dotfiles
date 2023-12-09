#!/bin/sh

# check if hooks.d exists
test ! -d "/usr/local/gpu/hooks.d" && echo "${0}: hooks.d doesn't exist" 1>&2 && exit 1

# check if hooks.d is non-empty
test ! "$(ls -A /usr/local/gpu/hooks.d)" && echo "${0}: hooks.d is empty" && exit 1

# check if argument was passed
test "$#" -ne 1 && echo "${0}: invalid number of arguments" && exit 1

for script in /usr/local/gpu/hooks.d/*
do
	sh -c "${script} ${1}"
done
