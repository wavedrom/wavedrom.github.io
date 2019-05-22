#!/bin/bash
cp node_modules/wavedrom/wavedrom.min.js WaveDrom.js
cp node_modules/wavedrom/wavedrom.min.js wavedrom.min.js
cp node_modules/wavedrom/skins/*.js skins

mkdir src
rm -rf src/*

mkdir src/images
mkdir src/skins
mkdir src/css
mkdir src/scripts

cp editor.js src/
cp init.js src/
cp editor.html src/
cp tutorial.html src/
cp WaveDromEditor/package.json src/
cp node_modules/wavedrom/wavedrom.min.js src/

cp images/ic_*.png src/images/
cp images/favicon.ico src/images
cp images/logo.png src/images
cp node_modules/wavedrom/skins/* src/skins
cp css/* src/css
cp scripts/* src/scripts

curl https://raw.githubusercontent.com/drom/simple-nwjs-app/master/build.sh -o build.sh

bash build.sh --name wavedrom-editor --version v2.1.2
