#!/bin/bash

make install

files=( "head" "body-file" "report")
for i in "${files[@]}"
do
    rm ./test/integration/generated/$i/Package.resolved
    rm -Rf ./test/integration/generated/$i/.build
    autorest --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/$i.json --output-folder=./test/integration/generated/$i --namespace=$i --use=.
    cd ./test/integration/generated/$i
    swift build
    swift package generate-xcodeproj
    cd ../../../..
done
