#!/bin/bash

rm -rf ./tmp
mkdir ./tmp

cp ../decwar/*.FOR ./tmp
cp ../decwar/*.MAC ./tmp
cp ../decwar/hlp/DECWAR.HLP ./tmp
cp ../decwar/hlp/DECWAR.NWS ./tmp
cp ../decwar/hlp/DECWAR.GRP ./tmp

./back10 -cf ./tapes/decwar.tap ./tmp/*
./back10 -lf ./tapes/decwar.tap

