#!/bin/bash

autorest --verbose --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/head.json --output-folder=./test/integration/generated/head --namespace=head --use=.
cd ./test/integration/generated/head
swift build
swift package generate-xcodeproj
cd ../../../..