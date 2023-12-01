#!/usr/bin/env sh

gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`
ncolor="-h string:bgcolor:#191724 -h string:fgcolor:#faf4ed -h string:frcolor:#56526e"

if [ "${gtkMode}" == "light" ] ; then
  ncolor="-h string:bgcolor:#f4ede8 -h string:fgcolor:#9893a5 -h string:frcolor:#908caa"
fi

# Save-to location
if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

swpy_dir="$HOME/.config/swappy"
save_dir="${2:-$XDG_PICTURES_DIR}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

# Ensure the dir exists
mkdir -p $save_dir

# Entrypoint
case $1 in
p)  grim $save_dir/$save_file ;;
s)  mkdir -p $swpy_dir
    echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config
    grim -g "$(slurp)" - | swappy -f - ;;
*)  echo "...valid options are..."
    echo "p : print screen to $save_dir"
    echo "s : snip current screen to $save_dir"   
    exit 1 ;;
esac

# Notify the user that it succeeded
if [ -f "$save_dir/$save_file" ] ; then
    dunstify $ncolor "theme" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
