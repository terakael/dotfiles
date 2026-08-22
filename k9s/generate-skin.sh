#!/usr/bin/env bash
set -euo pipefail

CURRENT_THEME_PATH="$HOME/.local/state/omarchy/current/theme"
GHOSTTY_CONF="$CURRENT_THEME_PATH/ghostty.conf"
SKIN_FILE="${1:-skins/omarchy.yaml}"

if [[ ! -f "$GHOSTTY_CONF" ]]; then
  echo "Error: ghostty.conf not found at $GHOSTTY_CONF" >&2
  exit 1
fi

# Parse colors from ghostty.conf
background=$(grep "^background" "$GHOSTTY_CONF" | cut -d= -f2 | tr -d ' "' || true)
foreground=$(grep "^foreground" "$GHOSTTY_CONF" | cut -d= -f2 | tr -d ' "' || true)
selection=$(grep "^selection-background" "$GHOSTTY_CONF" | cut -d= -f2 | tr -d ' "' || true)
for i in $(seq 0 15); do
  eval "color$i=\$(grep \"^palette = $i=\" \"$GHOSTTY_CONF\" | cut -d= -f3 | tr -d ' \"' || true)"
done

# ghostty.conf has no accent field - reuse blue (palette 4)
accent="$color4"

# Fallbacks if any color is missing
accent="${accent:-#8d8d8d}"
background="${background:-#000000}"
foreground="${foreground:-#ffffff}"
selection="${selection:-#222222}"
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
  prompt:
    fgColor: "$foreground"
    bgColor: "$background"
    suggestColor: "$accent"
  info:
    fgColor: "$color8"
    sectionColor: "$accent"
    cpuColor: "$accent"
    memColor: "$color4"
  help:
    fgColor: "$foreground"
    bgColor: "$selection"
    keyColor: "$accent"
    numKeyColor: "$color4"
    sectionColor: "$accent"
  dialog:
    fgColor: "$foreground"
    bgColor: "$selection"
    buttonFgColor: "$background"
    buttonBgColor: "$accent"
    buttonFocusFgColor: "$background"
    buttonFocusBgColor: "$color4"
    labelFgColor: "$color3"
    fieldFgColor: "$foreground"
  frame:
    border:
      fgColor: "$color8"
      focusColor: "$accent"
    menu:
      fgColor: "$foreground"
      keyColor: "$accent"
      numKeyColor: "$color4"
    crumbs:
      fgColor: "$background"
      bgColor: "$color8"
      activeColor: "$accent"
    status:
      newColor: "$color2"
      modifyColor: "$color5"
      addColor: "$color2"
      errorColor: "$color1"
      pendingColor: "$color3"
      highlightColor: "$accent"
      killColor: "$color8"
      completedColor: "$color8"
    title:
      fgColor: "$accent"
      bgColor: "$background"
      highlightColor: "$color1"
      counterColor: "$color9"
      filterColor: "$accent"
  views:
    charts:
      bgColor: "$background"
      defaultDialColors:
        - "$accent"
        - "$color1"
      defaultChartColors:
        - "$accent"
        - "$color1"
    table:
      fgColor: "$foreground"
      bgColor: "$background"
      cursorFgColor: "$background"
      cursorBgColor: "$accent"
      markColor: "$color3"
      header:
        fgColor: "$color8"
        bgColor: "$background"
        sorterColor: "$accent"
    xray:
      fgColor: "$foreground"
      bgColor: "$background"
      cursorColor: "$accent"
      cursorTextColor: "$background"
      graphicColor: "$color4"
      showIcons: false
    yaml:
      keyColor: "$accent"
      colonColor: "$color8"
      valueColor: "$foreground"
    logs:
      fgColor: "$foreground"
      bgColor: "$background"
      indicator:
        fgColor: "$accent"
        bgColor: "$background"
        toggleOnColor: "$color2"
        toggleOffColor: "$color8"
    help:
      fgColor: "$foreground"
      bgColor: "$selection"
      indicator:
        fgColor: "$accent"
EOF

echo "Generated K9s skin at $SKIN_FILE"
