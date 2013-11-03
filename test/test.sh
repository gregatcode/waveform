#!/usr/bin/env bash

# delete previous run's output
rm data/*.png

# inject the padding and the start of the array for the test page,
echo "injectWaveforms([" > images.js

# iterate through all files in the data/ folder and pass them
# into the waveform, generating a 1600x400 png file wth the same name,
# including the original audio file extension.
FILES=data/*
for f in $FILES
do
    echo "converting $f..."
    #../old_waveform"$f" "$f.old.png" --verbose
    ../waveform -i "$f" -o "$f.png" -h 400 -w 1600

    if [ $? -eq 0 ];
    then
        echo "'$f.png'," >> images.js
    else
        # tell the images.js file that this file failed by
        # tweaking the filename
        echo "'$f.png.FAILED'," >> images.js
    fi
done

# generate different sizes of thumbnails to show how the waveform changes
# with the quantization resolution
echo "Generating WD thumbnail sizes"
file="data/midnight_city.mp3"
../waveform -i "$file" -o "$file.TINY.png" -h 20 -w 80
../waveform -i "$file" -o "$file.SMALL.png" -h 45 -w 180
../waveform -i "$file" -o "$file.LARGE.png" -h 160 -w 640
../waveform -i "$file" -o "$file.MAX.png" -h 400 -w 1600
echo "'$file.TINY.png'," >> images.js
echo "'$file.SMALL.png'," >> images.js
echo "'$file.LARGE.png'," >> images.js
echo "'$file.MAX.png'," >> images.js

# end the padding for the test page array
# leaving a trailing comma because why the hell are you viewing it 
# in a browser that can't ignore trailing commas in arrays?
echo "]);" >> images.js