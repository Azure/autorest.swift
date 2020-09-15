#!/bin/bash

echo "== Compile AutoRest Swift =="
make install > /dev/null 2>&1

if [ $? -eq 0 ]; then
	echo "AutoRest Swift Compile succeed."
else
    echo "AutoRest Swift Compile failed! Exit."
    exit
fi

files=( "head" "body-file" "report" "xms-error-responses")
for i in "${files[@]}"
do
    echo "== Generate code for test server swagger $i.json =="
    if [ "$1" = "--clean" ]
    then
	echo "Remove Package.resolved and .build directory."
	rm ./test/integration/generated/$i/Package.resolved
	rm -Rf ./test/integration/generated/$i/.build
    fi
    echo "autorest --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/$i.json --output-folder=./test/integration/generated/$i --namespace=$i --use=."
    autorest --input-file=./node_modules/@microsoft.azure/autorest.testserver/swagger/$i.json --output-folder=./test/integration/generated/$i --namespace=$i --use=. > /dev/null 2>&1
    if [ $? -eq 0 ]; then
	echo "autorest code generation succeed."
    else
	echo "autorest code generation failed. Revert the generated code."
	git restore ./test/integration/generated/$i
    fi
    cd ./test/integration/generated/$i
    swift build  > /dev/null 2>&1
    if [ $? -eq 0 ]; then
	echo "swift build succeed."
    cd ../../../..
    else
	echo "swift build failed. Revert the generated code."
    cd ../../../..
	git restore ./test/integration/generated/$i
    fi
done