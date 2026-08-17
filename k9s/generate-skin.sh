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
  /^(accent|background|foreground|red|green|yellow|blue|magenta|cyan|muted|selection) / {
    gsub(/"/, "", $2);
    print $1 "=\"" $2 "\""
  }
' "$COLORS_TOML")"

# Fallbacks if any color is missing
accent="${accent:-#8d8d8d}"
background="${background:-#000000}"
foreground="${foreground:-#ffffff}"
muted="${muted:-#7a7a7a}"
selection="${selection:-#1a1a1a}"
cyan="${cyan:-#b0b0b0}"
yellow="${yellow:-#cecece}"
green="${green:-#b6b6b6}"
red="${red:-#a4a4a4}"

cat > "$SKIN_FILE" <<EOF
k9s:
  body:
    fgColor: "$foreground"
    bgColor: "$background"
    logoColor: "$accent"

  info:
    fgColor: "$cyan"
    sectionColor: "$foreground"

  frame:
    border:
      fgColor: "$muted"
      focusColor: "$accent"

    menu:
      fgColor: "$foreground"
      keyColor: "$accent"
      numKeyColor: "$yellow"

    crumbs:
      fgColor: "$background"
      bgColor: "$accent"
      activeColor: "$green"

    status:
      newColor: "$green"
      modifyColor: "$cyan"
      addColor: "$green"
      errorColor: "$red"
      highlightcolor: "$accent"
      killColor: "$muted"
      completedColor: "$muted"

    title:
      fgColor: "$foreground"
      bgColor: "$background"
      highlightColor: "$accent"
      counterColor: "$cyan"
      filterColor: "$muted"

  views:
    table:
      fgColor: "$foreground"
      bgColor: "$background"
      cursorColor: "$selection"
      header:
        fgColor: "$yellow"
        bgColor: "$background"
        sorterColor: "$accent"

    yaml:
      keyColor: "$accent"
      colonColor: "$muted"
      valueColor: "$foreground"

    logs:
      fgColor: "$foreground"
      bgColor: "$background"
EOF

echo "Generated K9s skin at $SKIN_FILE"
