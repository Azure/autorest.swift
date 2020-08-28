#!/bin/bash

make install

files=( "head" "body-file")
for i in "${files[@]}"
do
    autorest --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/$i.json --output-folder=./test/integration/generated/$i --namespace=$i --use=.
    cd ./test/integration/generated/$i
    swift build
    swift package generate-xcodeproj
    cd ../../../..
done
