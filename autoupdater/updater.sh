#!/usr/bin/bash
#
#  Updated 5-1-2026 to use new vocafortunes script instead of fortune/misfortune
#
#
# download custom fortunes and config file
echo "Updating tetosong..."
# check if the config file exists, if not download it and prompt the user for options.

#### remove files from old version
rm -rf ~/.local/share/tetosong/fortunes/
# add new files
mkdir -p ~/.local/share/tetosong
mkdir -p ~/.local/share/tetosong/vocafortunes
mkdir -p ~/.local/share/tetosong/vocafortunes/vocadb
curl -sLo ~/.local/share/tetosong/vocafortunes/vocadb/140308 https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/vocafortunes/vocadb/140308
AUDIO="$(. ~/.local/share/tetosong/tetosong.config; echo $AUDIO)"
if [ "$AUDIO" = "YES" ]; then
    curl -sLo ~/.local/share/tetosong/SOTD.zip https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/audio/teto/SOTD.zip
    mkdir -p ~/.local/share/tetosong/audio/
    mkdir -p ~/.local/share/tetosong/audio/teto/
    unzip -o ~/.local/share/tetosong/SOTD.zip -d ~/.local/share/tetosong/audio/teto/
    rm ~/.local/share/tetosong/SOTD.zip
fi

# set up autoupdater
# # i use systemd, so i use systemd timers.  I'll figure out something for non-systemd users later.
AUTOUPDATE="$(. ~/.local/share/tetosong/tetosong.config; echo $AUTOUPDATE)"
if [ "$AUTOUPDATE" = "YES" ]; then
    # write and enable systemd service file and timer user services
    echo "Auto-Updater enabled, updating service..."
    mkdir -p ~/.config/systemd/user
    curl -sLo ~/.config/systemd/user/tetosong.service https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/autoupdater/tetosong.service
    curl -sLo ~/.config/systemd/user/tetosong.timer https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/autoupdater/tetosong.timer
    systemctl --user daemon-reload
    systemctl --user enable tetosong.timer
    systemctl --user start tetosong.timer
else
    echo "Autoupdater disabled, skipping service update."
fi
# write tetosong to ~/.local/bin and tell the user how to use it.
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/tetosong
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/main/vocafortune
chmod +x ~/.local/bin/tetosong
chmod +x ~/.local/bin/vocafortune
echo "Make sure ~/.local/bin is in your PATH and you can get your Teto Song Of the Day by typing in tetosong or adding it to your bashrc :)"
