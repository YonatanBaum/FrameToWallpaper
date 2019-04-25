#!/usr/bin/env bash
INPUT=$HOME"/Videos/source.mp4"
OUTPUT="output.png"
rm $OUTPUT
METADATA=$(ffprobe -select_streams v -show_streams ~/Videos/source.mp4 2> /dev/null)
FRAMES=$(echo "$METADATA" | grep nb_frames | cut --delimiter="=" -f 2)
FRAMERATE=$(echo "$METADATA" | grep avg_frame_rate | cut --delimiter="=" -f 2)
FRAME=$(shuf -i 1-$FRAMES -n 1)
SECONDS=$(( ($FRAME / $FRAMERATE) % 60))
MINUTES=$((( ($FRAME / $FRAMERATE) / 60) % 60))
HOURS=$((( ($FRAME / $FRAMERATE) / 3600) % 60))
printf "Extraction frame #%d at timestamp %02d:%02d:%02d\n" $FRAME $HOURS $MINUTES $SECONDS
ffmpeg -ss $HOURS:$MINUTES:$SECONDS -i $INPUT  -vframes 1 $OUTPUT 2> /dev/null
feh --bg-scale $OUTPUT

