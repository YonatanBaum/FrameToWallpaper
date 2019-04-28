# Frame to Wallpaper 

Frame to Wallpaper is a shell script which takes a video and sets a random frame from it as the desktop wallpaper.

## Installation
Make sure you have [feh](https://github.com/derf/feh) and [ffmpeg](https://github.com/FFmpeg/FFmpeg) installed on your machine.  
Then, clone this repository and make sure everything is working properly by executing `frame_to_wallapper.sh`, specifying a video file (you might need to allow execution for this file).
```bash
git clone https://github.com/YonatanBaum/FrameToWallpaper.git
cd FrameToWallpaper
./frame_to_wallpaper ~/Videos/myvideo.mp4
```

## Usage
```bash
./frame_to_wallpaper SOURCE_VIDEO [OPTIONS]
```

Available options are:
```bash
  -h, --help                   Display this text.
  -v                           Enable verbose output. Stacks up to 3 (-vvv).
  -k, --keep-frame             Keep the frame as PNG instead of removing it after usage.
  --frame-location=LOCATION    Frame's file location. Defaults to current folder. 
```

Note: While it is entirely possible to use this script from the terminal, it is highly recommended to set up a cron job or a keybinding for executing this script.

## License
[MIT](https://choosealicense.com/licenses/mit/)
