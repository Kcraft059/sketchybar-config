#!/bin/bash

ARTWORK_MARGIN=5
TITLE_MARGIN=$((3 + $BAR_HEIGHT / 4))
# Allow override from global config via MUSIC_INFO_WIDTH
INFO_WIDTH=${MUSIC_INFO_WIDTH:-80}

command -v 'menubar' 2>/dev/null 1>&2 || alias menubar="$RELPATH/menubar"

SCRIPT_MUSIC="export PATH=$PATH; $RELPATH/plugins/music/script-artwork.sh $ARTWORK_MARGIN $BAR_HEIGHT"

SCRIPT_CLICK_MUSIC_ARTWORK="export PATH=$PATH;  media-control toggle-play-pause"

SCRIPT_MUSIC_TITLE="export PATH=$PATH; $RELPATH/plugins/music/script-title.sh"

SCRIPT_CLICK_MUSIC_TITLE="export PATH=$PATH; menubar -s \"Control Center,NowPlaying\""

SCRIPT_CENTER_SEP="export PATH=$PATH; $RELPATH/plugins/music/script-separator.sh"

music_artwork=(
	drawing=off
	script="$SCRIPT_MUSIC"
	click_script="$SCRIPT_CLICK_MUSIC_ARTWORK"
	icon="􀊆"
	icon.drawing=off
	icon.color=$HIGH_MED
	icon.shadow.drawing=on
	icon.shadow.color=$BAR_COLOR
	icon.shadow.distance=3
	icon.align=center
	label.drawing=off
	icon.padding_right=0
	icon.padding_left=-3
	background.drawing=on
	background.height=$(($BAR_HEIGHT - $ARTWORK_MARGIN * 2))
	background.image.border_color=$MUTED
	background.image.border_width=1
	background.image.corner_radius=4
	background.image.padding_right=1
	update_freq=0
	padding_left=0
	padding_right=8
)

music_title=(
	label=Title
	drawing=off
	script="$SCRIPT_MUSIC_TITLE"
	click_script="$SCRIPT_CLICK_MUSIC_TITLE"
	label.color=$TEXT
	icon.drawing=off
	#background.color=0xff0000ff
	#background.height=8
	label.align=right
	label.width=$INFO_WIDTH
	label.max_chars=13
	label.font="$FONT:Semibold:10.0"
	scroll_texts=off
	padding_left=-$INFO_WIDTH
	padding_right=0
	y_offset=$(($BAR_HEIGHT / 2 - $TITLE_MARGIN))
)

music_subtitle=(
	label=SubTitle
	drawing=off
	script="$SCRIPT_MUSIC_TITLE"
	click_script="$SCRIPT_CLICK_MUSIC_TITLE"
	label.color=$SUBTLE
	icon.drawing=off
	#background.color=0xffff0000
	#background.height=8
	label.align=right
	label.width=$INFO_WIDTH
	label.max_chars=14
	label.font="$FONT:Semibold:9.0"
	scroll_texts=off
	#scroll_duration=10
	padding_left=0
	padding_right=0
	y_offset=$((-($BAR_HEIGHT / 2) + $TITLE_MARGIN))
)

center_separator=(
	icon="|"
	script="$SCRIPT_CENTER_SEP"
	icon.color=$SUBTLE
	icon.font="$FONT:Bold:16.0"
	icon.y_offset=2
	label.drawing=off
	icon.padding_left=0
	icon.padding_right=0
	update_freq=0
	updates=on
)

sketchybar --add item separator_center center \
	--set separator_center "${center_separator[@]}" \
	--add event activities_update \
	sketchybar --subscribe separator_center activities_update #\

sketchybar --add item music q \
	--set music "${music_artwork[@]}" \
	--add item music.title q \
	--set music.title "${music_title[@]}" \
	--add item music.subtitle q \
	--set music.subtitle "${music_subtitle[@]}" \
	--subscribe music.title mouse.entered mouse.exited \
	--subscribe music.subtitle mouse.entered mouse.exited

#--add event mediachange MPMusicPlayerControllerNowPlayingItemDidChange \
