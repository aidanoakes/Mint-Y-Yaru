#!/bin/bash

# download and install Mint-Y-Yaru theme
wget -O /tmp/Mint-Y-Yaru.zip https://github.com/adinmaccabee/Mint-Y-Yaru/raw/main/Mint-Y-Yaru.zip
mkdir -p ~/.themes
unzip -o /tmp/Mint-Y-Yaru.zip -d ~/.themes/

# download background
sudo wget -O /usr/share/backgrounds/custom-background.png https://raw.githubusercontent.com/adinmaccabee/Mint-Y-Yaru/main/background.png

# apply themes
gsettings set org.cinnamon.desktop.interface cursor-theme "Yaru"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.wm.preferences theme "Mint-Y-Yaru"
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y-Yaru"
gsettings set org.cinnamon.theme name "Mint-Y-Yaru"

# set background
gsettings set org.cinnamon.desktop.background picture-uri "file:///usr/share/backgrounds/custom-background.png"

# move panel to left
gsettings set org.cinnamon panels-enabled "['1:0:left']"

# calendar custom date format
CALENDAR_DIR="$HOME/.config/cinnamon/spices/calendar@cinnamon.org"
mkdir -p "$CALENDAR_DIR"
python3 -c "
import json, os
path = os.path.expanduser('$CALENDAR_DIR/13.json')
with open(path, 'r') as f:
    data = json.load(f)
data['use-custom-format']['value'] = True
data['custom-format']['value'] = '%H:%M'
data['custom-tooltip-format']['value'] = '%A, %B %e, %H:%M'
with open(path, 'w') as f:
    json.dump(data, f, indent=4)
"

# reload Cinnamon
cinnamon --replace &

echo "done"
