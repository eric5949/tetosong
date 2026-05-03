#!/usr/bin/bash
#
# updated 5-2-26 to use other singer IDs so i can get songs from other singer IDs,  miku is 1.
#
while [ $# -gt 0 ]; do export "${1#-}"="$2"; shift 2; done # argument handling
if [ -z "$s" ]; then export ARTIST=140308; else export ARTIST=$s; fi # default to Kasane Teto if no singer ID is specified
if [ -z "$a" ]; then export ART="▼・ᴗ・▼"; else export ART="$a"; fi # default to ▼・ᴗ・▼ if no art is specified
if [ -z "$n" ]; then export vsynth="TETO"; else export vsynth="$n"; fi # default to TETO if no vsynth is specified
if [ -z "$p" ]; then export preset="none"; else export preset="$p"; fi # option for presetting singer ID, art, and vsynth

if [ $preset = "Teto" ]; then export ARTIST=140308; export ART="▼・ᴗ・▼"; export vsynth="TETO"; fi  # preset for Teto
if [ $preset = "Miku" ]; then export ARTIST=1; export ART="⎛⎝・ᴗ・⎠⎞ ა🥬"; export vsynth="MIKU"; fi # preset for Miku
if [ $preset = "Gumi" ]; then export ARTIST=3; export ART="💚🥕🎤💚"; export vsynth="GUMI"; fi # preset for Gumi

echo "vsynth: $vsynth"
echo "ARTIST: $ARTIST"
echo "ART: $ART"

#ARTIST=140308 # 116 is Kasane Teto
CHILDREN="true" # If we want child voicebanks, we do so we can get all songs from utau, sv, and sv2
START=0 # Start at the beginning of the recordset. if i wanted to make the file in chunks to use the api less i would use this and max to get the songs in chunks.  They say dont use it "thousands of times a day", getting every teto song is 280 times. I think I'm ok.  maybe.
RESULTS=100 # Max results. Limit is 100.
MAX=100000 # when to stop, 100,000 is 1000 uses of the api, there's like 70k miku songs total so this **should** be ok. A thousand isnt thousands.
if [ ! -f dates/${ARTIST}var.json ]; then # var.json has our latest date, we use it to know where to stop going back, past it the songs already exist in the fortune file.
    echo '{"lastDate": "2000-04-21T00:00:00Z"}' > dates/${ARTIST}var.json #  if it doesn't exist, we create it with a default date back in 2000.
fi
PREVDATE=$(jq -r '.lastDate' dates/${ARTIST}var.json)
AFTERDATE=$(date -u -d "$PREVDATE + 1 Second" +"%Y-%m-%dT%H:%M:%SZ")
echo "Result: $AFTERDATE"
#rm tetofortunes var.json tetofortunes.dat # during testing we will remove everything, or if we want to regenerate the fortune file from scratch.
# setting the latest date.  just pulling the latest song from the api and setting the createDate as the latest date in var.json for use when we update the fortune file again, dont want to add the same songs twice. idk how I'll handle broken links and such, maybe just regenerate the whole thing periodically.
CURLURL="https://vocadb.net/api/songs?songTypes=Original&afterDate=${AFTERDATE}&&artistId%5B%5D=${ARTIST}&childVoicebanks=${CHILDREN}&onlyWithPvs=true&status=Finished&start=0&maxResults=1&sort=PublishDate&fields=PVs"
echo "CURLURL: $CURLURL"
DATA=$(curl -X 'GET' $CURLURL -H 'accept: application/json')
# making sure there are songs to add.
SONGS=$(echo "$DATA" | jq -c '.items | length')
if [ "$SONGS" -eq 0 ]; then echo "Result is empty. No more songs."; exit 0; fi
DATE=$(date -u +%Y-%m-%dT00:00:00Z)
echo "DATE: $DATE"
echo "{\"lastDate\": \"$DATE\"}" > dates/${ARTIST}var.json
# looping the api to get all songs we need.
while true; do
    CURLURL="https://vocadb.net/api/songs?songTypes=Original&afterDate=${AFTERDATE}&&artistId%5B%5D=${ARTIST}&childVoicebanks=${CHILDREN}&onlyWithPvs=true&status=Finished&start=${START}&maxResults=${RESULTS}&sort=PublishDate&fields=PVs"
    DATA=$(curl -X 'GET' $CURLURL -H 'accept: application/json')
    SONGS=$(echo "$DATA" | jq -r '.items | length')
    if [ "$SONGS" -eq 0 ]; then echo "Result is empty. No more songs."; break
    else
      START=$((START + SONGS))
      echo "Found songs! Processing... (Total fetched: $START)"
      echo "$DATA" | jq -r '.items[] | [.artistString, .defaultName, .pvs[0].url] | @tsv' | while IFS=$'\t' read -r artist name url; do
          echo "$vsynth SONG OF THE DAY!" && echo "" && echo "$artist -- $name" && echo "" && echo "$url" && echo "" && echo "$ART" && echo "\`"
      done >> vocafortunes/vocadb/$ARTIST
      if [ "$START" -ge "$MAX" ]; then echo "Reached max results. Stopping."; break; fi
      echo "Done!"
    fi
done

# check for duplicates and save the file again.

readarray -d '`' tetosongs < vocafortunes/vocadb/$ARTIST
readarray -td '' dups < <((( ${#tetosongs[@]} == 0 )) || printf '%s\0' "${tetosongs[@]}" | LC_ALL=C sort -z | LC_ALL=C uniq -zd)
readarray -td '' uniq < <((( ${#tetosongs[@]} == 0 )) || printf '%s\0' "${tetosongs[@]}" | LC_ALL=C sort -z | LC_ALL=C uniq -zu)

echo ${#tetosongs[@]}
if ((${#dups[@]} > 0)); then echo >&2 "array has duplicates:"; echo ${#dups[@]};fi
if ((${#uniq[@]} > 0)); then echo >&2 "Uniques:"; echo ${#uniq[@]};fi

printf >&2 '%s' "${dups[@]}" > dups
printf >&2 '%s' "${uniq[@]}" > uniq

cat uniq > fixed
cat dups >> fixed
sed -i "1,/^${vsynth} SONG OF THE DAY!$/{/^${vsynth} SONG OF THE DAY!$/!d}" fixed
rm vocafortunes/vocadb/$ARTIST
rm uniq dups
mv fixed vocafortunes/vocadb/$ARTIST
