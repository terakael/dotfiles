#!/usr/bin/env bash
set -euo pipefail

CURRENT_THEME_PATH="$HOME/.local/state/omarchy/current/theme"
COLORS_TOML="$CURRENT_THEME_PATH/colors.toml"
SKIN_FILE="${1:-skins/omarchy.yaml}"

if [[ ! -f "$COLORS_TOML" ]]; then
  echo "Error: colors.toml not found at $COLORS_TOML" >&2
  exit 1
fi

# Parse colors from colors.toml using awk
eval "$(awk -F ' = ' '
  /^(accent|background|foreground|selection|color[0-9]+) / {
    gsub(/"/, "", $2);
    print $1 "=\"" $2 "\""
  }
' "$COLORS_TOML")"

# Fallbacks if any color is missing
accent="${accent:-#8d8d8d}"
background="${background:-#000000}"
foreground="${foreground:-#ffffff}"
selection="${selection:-#1a1a1a}"
color0="${color0:-#101010}"
color1="${color1:-#f5a191}"
color2="${color2:-#90b99f}"
color3="${color3:-#e6b99d}"
color4="${color4:-#aca1cf}"
color5="${color5:-#e29eca}"
color6="${color6:-#ea83a5}"
color7="${color7:-#ffffff}"
color8="${color8:-#7e7e7e}"
color9="${color9:-#ff8080}"
color10="${color10:-#99ffe4}"
color11="${color11:-#ffc799}"
color12="${color12:-#b9aeda}"
color13="${color13:-#ecaad6}"
color14="${color14:-#f591b2}"
color15="${color15:-#ffffff}"

cat > "$SKIN_FILE" <<EOF
k9s:
  body:
    fgColor: "$foreground"
    bgColor: "$background"
    logoColor: "$accent"

  info:
    fgColor: "$color6"
    sectionColor: "$foreground"

  frame:
    border:
      fgColor: "$color8"
      focusColor: "$accent"

    menu:
      fgColor: "$foreground"
      keyColor: "$accent"
      numKeyColor: "$color3"

    crumbs:
      fgColor: "$background"
      bgColor: "$accent"
      activeColor: "$color2"

    status:
      newColor: "$color2"
      modifyColor: "$color5"
      addColor: "$color2"
      errorColor: "$color1"
      highlightColor: "$accent"
      killColor: "$color8"
      completedColor: "$color8"

    title:
      fgColor: "$foreground"
      bgColor: "$background"
      highlightColor: "$accent"
      counterColor: "$color6"
      filterColor: "$color8"

  views:
    table:
      fgColor: "$foreground"
      bgColor: "$background"
      cursorColor: "$accent"
      markColor: "$color3"
      changerColor: "$color5"
      header:
        fgColor: "$color3"
        bgColor: "$background"
        sorterColor: "$accent"

    yaml:
      keyColor: "$accent"
      colonColor: "$color8"
      valueColor: "$foreground"

    logs:
      fgColor: "$foreground"
      bgColor: "$background"
EOF

echo "Generated K9s skin at $SKIN_FILE"
