UNAME = ${shell uname}

# set EXECUTABLE_DIRECTORY according to your specific environment
# run swift build and see where the output executable is created

ifeq ($(UNAME), Darwin)
PLATFORM = x86_64-apple-macosx
EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
TEST_RESOURCES_DIRECTORY = ./.build/${PLATFORM}/debug/SwiftResourceHandlingExamplePackageTests.xctest/Contents/Resources
else ifeq ($(UNAME), Linux)
PLATFORM = x86_64-unknown-linux
EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
TEST_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}
endif

RUN_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}

build: copyRunResources
	swift build

copyRunResources:
	mkdir -p ${RUN_RESOURCES_DIRECTORY}
	cp templates/* ${RUN_RESOURCES_DIRECTORY}

copyTestResources:
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp templates/* ${TEST_RESOURCES_DIRECTORY}

buildSwiftlint:
	scripts/build-swift-lint.sh

copyTools:
	chmod +w ./.build/checkouts/SwiftFormat/CommandLineTool/swiftformat
	cp ./.build/checkouts/SwiftFormat/CommandLineTool/swiftformat ${RUN_RESOURCES_DIRECTORY}
	cp ./.build/checkouts/SwiftLint/.build/x86_64-apple-macosx/debug/swiftlint ${RUN_RESOURCES_DIRECTORY}
	cp ./.swiftformat ${RUN_RESOURCES_DIRECTORY}
	cp ./.swiftlint.yml ${RUN_RESOURCES_DIRECTORY}

install: build buildSwiftlint copyTools

run: build
	${EXECUTABLE_DIRECTORY}/AutorestSwift

test: copyTestResources
	swift test

clean:
	rm -rf .build

.PHONY: run build test copyRunResources copyTestResources clean
