#!/usr/bin/env bash

cd $HOME

# delete old tetosong repo and replace with updated one.
yes | rm -r tetosong
git clone git@github.com:eric5949/tetosong.git
cd tetosong
# update vocafortunes.
sh ./makefortune.sh -p Teto
sh ./makefortune.sh -p Gumi
sh ./makefortune.sh -p Miku

# commit update
git add ./*
git commit -m "Automated update of fortune files"
git push -u origin main
