#!/usr/bin/bash
# download custom fortunes and config file
echo "Updating tetosong..."

# past here is a modified installer.sh, if i build an update option into installer.sh i cant get it to run correctly with the curl command

# check if the config file exists, if not download it and prompt the user for options.
if [ ! -f ~/.local/share/tetosong/tetosong.config ]; then
    echo "Config file not found, downloading default..."
    curl -sLo ~/.local/share/tetosong/tetosong.config https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/tetosong.config
fi
mkdir -p ~/.local/share/tetosong
curl -sLo ~/.local/share/tetosong/tetofortunes https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/fortunes/tetosotd/tetofortunes
curl -sLo ~/.local/share/tetosong/tetofortunes.dat https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/fortunes/tetosotd/tetofortunes.dat
curl -sLo ~/.local/share/tetosong/sv2SOTD.wav https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/sv2SOTD.wav

# set up autoupdater
# # i use systemd, so i use systemd timers.  I'll figure out something for non-systemd users later.
AUTOUPDATE="$(. ~/.local/share/tetosong/tetosong.config; echo $AUTOUPDATE)"
if [ "$AUTOUPDATE" = "YES" ]; then
    # write and enable systemd service file and timer user services
    echo "Auto-Updater enabled, updating service..."
    mkdir -p ~/.config/systemd/user
    curl -sLo ~/.config/systemd/user/tetosong.service https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/autoupdater/tetosong.service
    curl -sLo ~/.config/systemd/user/tetosong.timer https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/autoupdater/tetosong.timer
    systemctl --user daemon-reload
    systemctl --user enable tetosong.timer
    systemctl --user start tetosong.timer
else
    echo "Autoupdater disabled, skipping service update."
fi
# write tetosong to ~/.local/bin and tell the user how to use it.
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
curl -sLo ~/.local/bin/tetosong https://raw.githubusercontent.com/eric5949/tetosong/refs/heads/eggs/tetosong
chmod +x ~/.local/bin/tetosong
echo "Update complete"
