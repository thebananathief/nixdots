#!/usr/bin/env bash

#original_dir="$(pwd)"

#cd "$(dirname "$0")" || exit

#get logo path, if none random
#image="$HOME/icons/tux.png"

#import pywal colors
# shellcheck source=/home/master/.cache/wal/colors.sh
#source "$HOME/.cache/wal/colors.sh"

$background = 1f1d2e
$color1 = 1f1d2e
$color2 = 191724
$color3 = eb6f92
$color4 = e0def4
$color5 = 1f1d2e

swaylock \
  --indicator
  --indicator-radius 160 \
  --indicator-thickness 9 \
  --screenshots \
  --clock \
  --grace 5 \
  --fade-in 1 \
  --effect-blur 9x6 \
  --effect-vignette 0.5:0.5 \
  --font 'JetBrains Nerd Font:style=Thin,Regular 32' \
  --ignore-empty-password \
  #--daemonize
  #--inside-clear-color 00000000 \
  #--inside-ver-color 00000000 \
  #--inside-wrong-color 00000000 \
  #--bs-hl-color "$color2" \
  #--ring-clear-color "$color2" \
  #--ring-wrong-color "$color5" \
  #--ring-ver-color "$color3" \
  #--line-uses-ring \
  #--text-color 00000000 \
  #--text-clear-color 00000000 \ #"$color2" \
  #--text-wrong-color 00000000 \ #"$color5" \
  #--text-ver-color 00000000 \ #"$color4" \
  #--show-failed-attempts
  #--effect-compose "16.7%x29.6%;center;$HOME/icons/tux.png" \
