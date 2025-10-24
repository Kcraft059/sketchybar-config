#!/bin/bash
export PATH=/opt/homebrew/bin/:$PATH
export RELPATH=$(dirname $0)/../..
source $RELPATH/log_handler.sh

pids=($(ps -p $(pgrep sh) | grep $0 | awk '{print $1}')) # List any left-over execution of this same process

### Kill any possible remaining streaming process from last config on reload
# script is made to be invoked only once per bar reload

if [[ -n "$pids" ]]; then
	for i in $(cat ${TMPDIR}/sketchybar/pids); do
		pids+=("$i")
	done
	sendWarn "Killing remaining media-control stream pids: ${pids[*]}" "debug"
	kill -9 ${pids[@]}
fi

ARTWORK_MARGIN="$1"
BAR_HEIGHT="$2"

### Open a stream to get current media continously

media-control stream | grep --line-buffered 'data' | while IFS= read -r line; do
	### List & store childs to prevent multiple background process remaining
	# Introduced because of a present bug, were the stream process detaches from the parent process causing stray processes

	if ps -p $$ >/dev/null; then
		pgrep -P $$ >${TMPDIR}/sketchybar/pids
	fi

	if ! {
		[[ "$(echo $line | jq -r .payload)" == '{}' ]] ||
			{ [[ -n $lastAppPID ]] && ! ps -p "$lastAppPID" >/dev/null; }
	}; then
		### Only trigger update for media info if process playing media still exists and current line feed isn't null

		### Get data from line feed

		artworkData=$(echo $line | jq -r .payload.artworkData)
		currentPID=$(echo $line | jq -r .payload.processIdentifier) # Get app currently streaming media
		playing=$(echo $line | jq -r .payload.playing)

		### Set Artwork

		if [[ $artworkData != "null" ]]; then

			tmpfile=$(mktemp ${TMPDIR}sketchybar/cover.XXXXXXXXXX)

			### Dump raw artwork data into tmpfile

			echo $artworkData |
				base64 -d >$tmpfile

			### Assign corresponding extension depending on file type + convert if not supported

			case $(identify -ping -format '%m' $tmpfile) in
			"JPEG")
				ext=jpg
				mv $tmpfile $tmpfile.$ext
				;;
			"PNG")
				ext=png
				mv $tmpfile $tmpfile.$ext
				;;
			"TIFF")
				mv $tmpfile $tmpfile.tiff
				magick $tmpfile.tiff $tmpfile.jpg
				ext=jpg
				;;
			esac

			sendLog "Artwork image generated at $tmpfile.$ext" "vomit"

			### Calculate width of media item to fit bar height nicely

			scale=$(bc <<<"scale=4; 
        ( ($BAR_HEIGHT - $ARTWORK_MARGIN * 2) / $(identify -ping -format '%h' $tmpfile.$ext) )
      ")
			icon_width=$(bc <<<"scale=0; 
        ( $(identify -ping -format '%w' $tmpfile.$ext) * $scale )
      ")

			### Set artwork to image, then purge image

			sketchybar --set $NAME background.image=$tmpfile.$ext \
				background.image.scale=$scale \
				icon.width=$(printf "%.0f" $icon_width)

			rm -f $tmpfile* && sendLog "Cleaned artwork image generated at $tmpfile.$ext" "vomit"
		fi

		### Set Title and artist + ?Album

		if [[ $(echo $line | jq -r .payload.title) != "null" ]]; then

			title_label="$(echo $line | jq -r .payload.title)"
			artist="$(echo "$line" | jq -r .payload.artist)"
			album="$(echo "$line" | jq -r .payload.album)"

			subtitle_label="$artist"
			if [[ -n "$album" ]]; then
				subtitle_label+=" • $album"
			fi

			sketchybar --set $NAME.title label="$title_label" \
				--set $NAME.subtitle label="$subtitle_label"
		fi

		### Set Playing state indicator

		if [[ $playing != "null" && $(echo $line | jq -r .diff) == "true" ]]; then
			case $playing in
			"true")
				sendLog "Updating playing state to play" "vomit"
				sketchybar --set $NAME icon.padding_left=-3 \
					--animate tanh 5 \
					--set $NAME icon="􀊆" \
					icon.drawing=on
				{
					sleep 5
					sketchybar --animate tanh 45 --set $NAME icon.drawing=false
				} &
				;;
			"false")
				sendLog "Updating playing state to pause" "vomit"
				sketchybar --set $NAME icon.padding_left=0 \
					--animate tanh 5 \
					--set $NAME icon="􀊄" \
					icon.drawing=on
				{
					sleep 5
					sketchybar --animate tanh 45 --set $NAME icon.drawing=false
				} &
				;;
			esac
		fi

		### Store app currently playing media to check for it's presence later

		if [[ $currentPID != "null" ]]; then
			lastAppPID=$currentPID
		fi

		sketchybar --set $NAME drawing=on \
			--set $NAME.title drawing=on \
			--set $NAME.subtitle drawing=on \
			--trigger activities_update

	else
		### If media stopped being played / app playing media is closed; hide music player

		sendLog "Media not playing $(if [[ -n $lastAppPID ]]; then echo "(media process: $lastAppPID)"; fi)" "debug"

		sketchybar --set $NAME drawing=off \
			--set $NAME.title drawing=off \
			--set $NAME.subtitle drawing=off \
			--trigger activities_update

		unset lastAppPID
	fi
done
