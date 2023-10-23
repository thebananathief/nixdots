#!/usr/bin/env sh
# Font preview with ueberzug and fzf

SIZE=${FONTPREVIEW_SIZE:-800x800}
FONT_SIZE=${FONTPREVIEW_FONT_SIZE:-72}
BG_COLOR=${FONTPREVIEW_BG_COLOR:-#ffffff}
FG_COLOR=${FONTPREVIEW_FG_COLOR:-#000000}
TEXT_ALIGN=${FONTPREVIEW_TEXT_ALIGN:-center}
PREVIEW_TEXT=${FONTPREVIEW_PREVIEW_TEXT:-"ABCDEFGHIJKLM\nNOPQRSTUVWXYZ\n\
abcdefghijklm\nnopqrstuvwxyz\n1234567890\n!@#$\%^&*,.;:\n_-=+'\"|\\(){}[]"}

# Ueberzug related variables
FIFO="/tmp/preview_fifo"
IMAGE="/tmp/fontpreview_img.png"
[ -p "$FIFO" ] || mkfifo "$FIFO"
touch "$IMAGE"

ID="fontpreview-ueberzug"
WIDTH=$FZF_PREVIEW_COLUMNS
HEIGHT=$FZF_PREVIEW_LINES

usage() {
    echo "Usage: fontpreview-ueberzug [-h] [-a ALIGNMENT] [-s FONT_SIZE] [-b BG] [-f FG] [-t TEXT]"
}

start_ueberzug() {
    ueberzugpp layer --silent < "$FIFO" &
    exec 3>"$FIFO"
    # https://github.com/seebye/ueberzug/issues/54#issuecomment-502869935
}

stop_ueberzug() {
    exec 3>&-
}
trap stop_ueberzug HUP INT QUIT TERM EXIT

preview() {
  fontfile=$(echo "$1" | cut -f2)
  convert -size "$SIZE" xc:"$BG_COLOR" -fill "$FG_COLOR" \
      -pointsize "$FONT_SIZE" -font "$fontfile" -gravity "$TEXT_ALIGN" \
      -annotate +"${PADDING:-0}+0" "$PREVIEW_TEXT" "$IMAGE" &&
  {   printf '{ "action": "add", "identifier": "%s", "path": "%s",' "$ID" "$IMAGE"
      printf '"x": %d, "y": %d, "scaler": "fit_contain",' 2 1
      printf '"width": %d, "height": %d }\n' "$((WIDTH - VPAD))" "$((HEIGHT - 2))"
  } > "$FIFO" ||
  printf '{ "action": "remove", "identifier": "%s" }\n' "$ID" > "$FIFO"
  echo '{"path": "'"$IMAGE"'", "action": "add", "identifier": "fzfpreview", "x": "'"$x"'", "y": "'"$y"'", "width": "'"$width"'", "height": "'"$height"'"}' > "$FIFO"
}

case "$1" in
  -W)
    shift
    preview "$@"
    exit
    ;;
esac

main() {
  start_ueberzug
  # get fonts and fzf them
  selected_font=$(
    fc-list -f "%{family[0]}%{:style[0]=}\t%{file}\n" |
    grep -i '\.\(ttc\|otf\|ttf\)$' | sort | uniq |
    fzf --preview "sh $0 -W {}" --reverse --preview-window="left:50%:noborder:wrap"
  )
  # finished fzf, print selected font
  [ -n "$selected_font" ] && echo "$selected_font"
  rm -f "$FIFO" "$IMAGE"
}
main

# if [ "$#" = 0 ]; then
#     # Prepare
#     start_ueberzug
#     # Export cli args as environment variables for preview command
#     TEXT_ALIGN=$(echo "$TEXT_ALIGN" | sed 's/top/north/; s/bottom/south/; s/left/west/; s/right/east/')
#     export FONTPREVIEW_TEXT_ALIGN="$TEXT_ALIGN"
#     export FONTPREVIEW_FONT_SIZE="$FONT_SIZE"
#     export FONTPREVIEW_BG_COLOR="$BG_COLOR"
#     export FONTPREVIEW_FG_COLOR="$FG_COLOR"
#     export FONTPREVIEW_PREVIEW_TEXT="$PREVIEW_TEXT"
#     # The preview command runs this script again with an argument
#     fc-list -f "%{family[0]}%{:style[0]=}\t%{file}\n" |
#     grep -i '\.\(ttc\|otf\|ttf\)$' | sort | uniq |
#     fzf --with-nth 1 --delimiter "\t" --reverse --preview "sh $0 {}" \
#         --preview-window "left:50%:noborder:wrap"
# elif [ "$#" = 1 ]; then
#     [ -p "$FIFO" ] && preview "$1"
# fi
