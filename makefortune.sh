#!/usr/bin/bash
ARTIST=116 # 116 is Kasane Teto
CHILDREN="true" # If we want child voicebanks, we do so we can get all songs from utau, sv, and sv2
START=0 # Start at the beginning of the recordset. if i wanted to make the file in chunks to use the api less i would use this and max to get the songs in chunks.  They say dont use it "thousands of times a day", getting every teto song is 163 times. I think I'm ok.
RESULTS=100 # Max results. Limit is 100.
MAX=20000 # when to stop, there's as of 4-20-26 16327 songs featuring Kasane Teto in the recordset i have selected.
if [ ! -f var.json ]; then # var.json has our latest date, we use it to know where to stop going back, past it the songs already exist in the fortune file.
    echo '{"lastDate": "2000-04-21T00:00:00Z"}' > var.json #  if it doesn't exist, we create it with a default date back in 2000.
fi
PREVDATE=$(jq -r '.lastDate' var.json)
AFTERDATE=$(date -u -d "$PREVDATE + 1 Second" +"%Y-%m-%dT%H:%M:%SZ")
echo "Result: $AFTERDATE"
#rm tetofortunes var.json tetofortunes.dat # during testing we will remove everything, or if we want to regenerate the fortune file from scratch.
# setting the latest date.  just pulling the latest song from the api and setting the createDate as the latest date in var.json for use when we update the fortune file again, dont want to add the same songs twice. idk how I'll handle broken links and such, maybe just regenerate the whole thing periodically.
CURLURL="https://vocadb.net/api/songs?songTypes=Original&afterDate=${AFTERDATE}&&artistId%5B%5D=${ARTIST}&childVoicebanks=${CHILDREN}&onlyWithPvs=true&status=Finished&start=0&maxResults=1&sort=PublishDate&fields=PVs"
echo "CURLURL: $CURLURL"
DATA=$(curl -X 'GET' \
$CURLURL \
    -H 'accept: application/json')
DATE=$(echo "$DATA" | jq -r '.items[0].publishDate')
echo "DATE: $DATE"
# making sure there are songs to add.
SONGS=$(echo "$DATA" | jq '.items | length')
if [ "$SONGS" -eq 0 ]; then
  echo "Result is empty. No more songs."
  exit 0
fi
echo "{\"lastDate\": \"$DATE\"}" > var.json
# looping the api to get all songs we need.
while true; do
    CURLURL="https://vocadb.net/api/songs?songTypes=Original&afterDate=${AFTERDATE}&&artistId%5B%5D=${ARTIST}&childVoicebanks=${CHILDREN}&onlyWithPvs=true&status=Finished&start=${START}&maxResults=${RESULTS}&sort=PublishDate&fields=PVs"
    DATA=$(curl -X 'GET' \
    $CURLURL \
        -H 'accept: application/json')
    SONGS=$(echo "$DATA" | jq '.items | length')
    if [ "$SONGS" -eq 0 ]; then
      echo "Result is empty. No more songs."
      break
    else
      START=$((START + SONGS))
      echo "Found songs! Processing... (Total fetched: $START)"
      echo "$DATA" | jq -r '.items[] | [.artistString, .defaultName, .pvs[0].url] | @tsv' | while IFS=$'\t' read -r artist name url; do
          echo "TETO SONG OF THE DAY!"
          echo ""
          echo "$artist -- $name"
          echo ""
          echo "$url"
          echo ""
          echo "▼・ᴗ・▼"
          echo "%"
      done >> tetofortunes
      if [ "$START" -ge "$MAX" ]; then
        echo "Reached max results. Stopping."
        break
      fi
      echo "Done!"
    fi
done
# create the fortune database from tetofortunes
rm tetofortunes.dat # delete the old database if it extists.
strfile -c % tetofortunes tetofortunes.dat
