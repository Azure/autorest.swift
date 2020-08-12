#!/bin/bash

# git_sync.sh

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
REPO_ROOT="$( cd -P "$( dirname "$SOURCE" )"/.. >/dev/null 2>&1 && pwd )"

# TODO: make this not hard coded
SDK_REPO_ROOT="/Users/travisprescott/Documents/repos/azure-sdk-for-ios-pr/"
SDK_PACKAGE_ROOT="/Users/travisprescott/Documents/repos/azure-sdk-for-ios-pr/sdk/secret/"
#SDK_DEST="/Users/travisprescott/Documents/repos/azure-sdk-for-ios-pr/sdk/secret/SecretSDK"
SDK_SRC="/Users/travisprescott/Documents/generated/sdk"

# FIXME: The build step fails when run with makefile.
#echo
#echo "AutoRest.Swift root: $REPO_ROOT"
#echo
#echo "==~ Building AutoRest.Swift ~=="
#echo
#make build -C $REPO_ROOT
#echo
#echo "==~ Generating SDK ~=="
#echo
#swift run --package-path $REPO_ROOT

## ensure the preview/SecretSDK branch is active
#echo
#echo "Refreshing folder: " $SDK_PACKAGE_ROOT
#rm -rf $SDK_PACKAGE_ROOT
#mkdir -p $SDK_PACKAGE_ROOT

echo
echo "==~ Copying generated code to azure-sdk-for-ios-pr ~=="
PACKAGE_NAME=$(ls  -1 -t $SDK_SRC | head -2)
# move the jazzy docs from the generated package into the SDK root
cp -r $SDK_SRC/$PACKAGE_NAME/.jazzy/ $SDK_REPO_ROOT/.jazzy
rm -rf $SDK_SRC/$PACKAGE_NAME/.jazzy/
cp -r $SDK_SRC/* $SDK_PACKAGE_ROOT

echo
echo "Switching to: " $SDK_REPO_ROOT
cd $SDK_REPO_ROOT

echo
echo "Checking out preview/SecretSDK branch"
git reset
git checkout preview/SecretSDK

cd $REPO_ROOT

echo "==~ Ready to Commit Changes in SourceTree! ~=="
