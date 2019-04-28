#!/usr/bin/env bash

# Option defaults
FRAME_LOCATION="."
KEEP_FRAME=0
VERBOSITY=0

usage() { echo "Usage: $(basename $0) SOURCE_VIDEO [OPTIONS]"; }

help() {
usage
echo "
Selects a random frame from specified video, and sets it as the desktop environment wallpaepr.

OPTIONS:
  -h, --help                   Display this text.
  -v                           Enable verbose output. Stacks up to 3 (-vvv).
  -k, --keep-frame             Keep the frame as PNG instead of removing it after usage.
  --frame-location=LOCATION    Frame's file location. Defaults to current folder.             
"
exit 2

}

print_if_verbose() {
local message=$1
local verbosity_level=$2

if [[ $VERBOSITY -ge $verbosity_level ]]; then echo $message; fi

}

# Check for source file
INPUT=$1
if [[ $INPUT = "-h" || $INPUT = "--help" ]]; then
	help
	exit 2
fi

if [[ -z $INPUT || $INPUT == -* ]]; then
	usage
	exit 3
fi

if [[ ! -f $INPUT ]]; then
	>&2 echo "ERROR: File $INPUT does not exist."
	exit
fi

shift



# Parse command line arguments
while getopts "hvk-:" arg; do
case $arg in
	h)
	help
	;;
	v)
	VERBOSITY=$((VERBOSITY + 1))
	;;
	k)
	KEEP_FRAME=1
	;;
	-) 
		case "${OPTARG}" in
			help)
			help
			;;
			keep-frame)
			KEEP_FRAME=1
			;;
			frame-location=*)
			FRAME_LOCATION=${OPTARG#*=}
			FRAME_LOCATION=${FRAME_LOCATION/#~/$HOME}
			if [[ ! -d FRAME_LOCATION ]]; then
				2&> echo "ERROR: $FRAME_LOCATION is not a directory."
			fi
			;;
		esac
esac
done

# Gather information on source file.
METADATA=$(ffprobe -select_streams v -show_streams $INPUT 2> /dev/null)
FRAMES=$(echo "$METADATA" | grep nb_frames | cut --delimiter="=" -f 2)
FRAMERATE=$(echo "$METADATA" | grep avg_frame_rate | cut --delimiter="=" -f 2)
print_if_verbose "$INPUT contains $FRAMES frame(s) at the rate of $FRAMERATE FPS." 3

# Choose random frame.
FRAME=$(shuf -i 1-$FRAMES -n 1)
SECONDS=$(( ($FRAME / $FRAMERATE) % 60))
MINUTES=$((( ($FRAME / $FRAMERATE) / 60) % 60))
HOURS=$((( ($FRAME / $FRAMERATE) / 3600) % 60))
TIMESTAMP=$(printf "%02d:%02d:%02d" $HOURS $MINUTES $SECONDS)
print_if_verbose "Using frame #$FRAME, at timestamp $TIMESTAMP." 1

if [[ $KEEP_FRAME -eq 0 ]]; then
	FRAME_FILE="$FRAME_LOCATION/temp_$FRAME"
else
	FRAME_FILE="$FRAME_LOCATION/$FRAME.png"
fi

ffmpeg -ss $HOURS:$MINUTES:$SECONDS -i $INPUT  -vframes 1 -f image2 $FRAME_FILE 2> /dev/null

print_if_verbose "Frame saved to $FRAME_FILE." 2
feh --bg-scale $FRAME_FILE
print_if_verbose "Replaced wallpaer." 2

# Remove frame, unless specified otherwise.
if [[ $KEEP_FRAME -eq 0 ]]; then
	rm $FRAME_FILE
	print_if_verbose "Removed frame file." 2 
fi

