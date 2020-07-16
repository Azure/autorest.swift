#!/bin/bash

#  swiftlint.sh
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
REPO_ROOT="$( cd -P "$( dirname "$SOURCE" )"/.. >/dev/null 2>&1 && pwd )"

echo
echo "Repo root: $REPO_ROOT"
echo

if which swiftformat >/dev/null; then
    echo "Formatting Swift files at: $REPO_ROOT/src"
    swiftformat --quiet --config "$REPO_ROOT/.swiftformat" "$REPO_ROOT/src" &> /dev/null
else
    echo "warning: SwiftFormat not installed. Download from https://github.com/nicklockwood/SwiftFormat"
fi

if which swiftlint >/dev/null; then
    echo "Correcting Swift files at: $REPO_ROOT/src"
    swiftlint autocorrect --quiet --config "$REPO_ROOT/.swiftlint.yml" "$REPO_ROOT/src" &> /dev/null
    echo "Linting Swift files at: $REPO_ROOT/src"
    swiftlint lint --quiet --config "$REPO_ROOT/.swiftlint.yml" "$REPO_ROOT/src"
else
    echo "warning: SwiftLint not installed. Download from https://github.com/realm/SwiftLint"
fi
