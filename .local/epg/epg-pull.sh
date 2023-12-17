#!/bin/bash

INSTALL_DIR="/config"

epg_install() {

	# https://github.com/iptv-org/epg/blob/master/README.md#installation
	echo "Installing iptv-org/epg ..."
	mkdir -p "$INSTALL_DIR"
	cd "$INSTALL_DIR"
	git clone --depth 1 -b master https://github.com/iptv-org/epg.git
	cd "${INSTALL_DIR}/epg"
	npm install
	echo "Finished installing iptv-org/epg"

}

get_all_sites() {

	SITES_LIST_URL="https://raw.githubusercontent.com/iptv-org/epg/master/SITES.md"
	SYMBOL_NOT_WORKING=$'\U0001F534'		# Symbol denoting non-working sites

	# Get sites list from github
	SITES_MD=$(wget -q -O - "$SITES_LIST_URL")

	# Filter out non-working sites & header
	SITES_MD=$(echo "$SITES_MD" | grep -v "$SYMBOL_NOT_WORKING")
	SITES_MD=$(echo "$SITES_MD" | grep "|[ ]*|$")

	# Extract the site name
	SITES=$(echo "$SITES_MD" | sed "s/| \[//;s/\].*//")
	echo "$SITES"

}

set_cronjob() {
	# Add cronjob for scraping site later
	cd "${INSTALL_DIR}/epg"
	echo "Setting cronjob with parameters:" "${PARAMS[@]}"
	npm run grab -- "${PARAMS[@]}" &
}

grab_site() {
	# Scrape site now
	cd "${INSTALL_DIR}/epg"
	echo "Scraping site with parameters:" "${PARAMS_NO_CRON[@]}"
	npm run grab -- "${PARAMS_NO_CRON[@]}"
}

serve_site() {
	cd "${INSTALL_DIR}/epg"
	echo "Serving site with parameters:" "${PARAMS_NO_CRON[@]}"
	npm run serve
}

main() {

	epg_install
	# grab_site
	set_cronjob
	serve_site

}

# save args
PARAMS=("$@")

# args without --cron "x y z"
PARAMS_NO_CRON=()
while [ -n "$1" ]
do
	if [ "$1" = "--cron" ]
	then
		shift 2
	else
		PARAMS_NO_CRON+=("$1")
		shift
	fi
done

main
