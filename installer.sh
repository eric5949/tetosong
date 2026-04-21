#!/usr/bin/bash
if ! [ -x "$(command -v fortune)" ]; then
  echo 'fortune is not installed, checking for misfortune'm
  if ! [ -x "$(command -v misfortune)" ]; then
      echo 'neither program is installed, exiting'
      exit 1
    else
      echo 'misfortune found'
  fi
else
    echo 'fortune found'
fi
echo "Downloading custom fortunes..."
mkdir -p ~/.local/share/tetosong
curl -s -L -o ~/.local/share/tetosong/tetofortunes https://github.com/eric5949/TetoSongOfTheDay/raw/a52c877bfb1508f0223469e3b9e86c65ee6915ae/tetofortunes
curl -s -L -o ~/.local/share/tetosong/tetofortunes.dat https://github.com/eric5949/TetoSongOfTheDay/raw/a52c877bfb1508f0223469e3b9e86c65ee6915ae/tetofortunes.dat
echo "writing tetosong to ~/.local/bin"
mkdir -p ~/.local/bin
cat > ~/.local/bin/tetosong <<EOF
#!/bin/bash
if ! [ -x "$(command -v fortune)" ]; then
  if ! [ -x "$(command -v misfortune)" ]; then
      echo 'No fortune commmand is installed, exiting!'
      exit 1
  else
    misfortune ~/.local/share/tetosong/tetofortunes
  fi
else
    fortune ~/.local/share/tetosong/tetofortunes
fi
EOF
chmod +x ~/.local/bin/tetosong
echo "you can get your Teto Song Of the Day by typing in tetosong or adding it to your bashrc :)"
