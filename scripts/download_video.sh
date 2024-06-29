#!/bin/zsh

# Set the target folder
download_folder="$HOME/Downloads/music/yt-dl/unsorted"

# URL of the video
video_url="$1"
video_url=${video_url//\\/}
# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp is not installed. Please install it using 'pip install -U yt-dlp'."
    exit 1
fi

# Check if the target folder exists
if [ ! -d "$download_folder" ]; then
    echo "Target folder '$download_folder' does not exist. Creating it..."
    mkdir -p "$download_folder"
fi

# Set the download options
download_options="--output '$download_folder/%(title)s.%(ext)s'"

# Check if flac format is available, otherwise use best available
formats=$(yt-dlp --list-formats $video_url)  
if echo "$formats" | grep -q -i flac; then  
    echo "Best quality found"  
    format_option="--audio-format flac --audio-quality 0"  
else  
    echo "Downloading best possible, not flac."  
    format_option="--audio-format mp3" # was best  
fi  

# Download the video

echo "Command that was run: $command"  
command="yt-dlp -x $download_options $format_option \"$video_url\""
eval $command
# command="yt-dlp -x $download_options $format_option \"$video_url\""  
# $command
# # command=(yt-dlp -x $download_options $format_option "$video_url")  
# # "${command[@]}"  
# if [ $? -eq 0 ]; then  
#     echo "Download complete"  
# else  
#     echo "Error code: $?"  
#     #exit 1
# fi
