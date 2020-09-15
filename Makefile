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
	swift build --target AutorestSwift

copyRunResources:
	mkdir -p ${RUN_RESOURCES_DIRECTORY}
	cp templates/* ${RUN_RESOURCES_DIRECTORY}

copyTestResources:
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp templates/* ${TEST_RESOURCES_DIRECTORY}

buildSwiftlint:
	scripts/build-swift-lint.sh

copyTools:
	pod install
	cp ./Pods/SwiftFormat/CommandLineTool/swiftformat ${RUN_RESOURCES_DIRECTORY}
	cp ./Pods/SwiftLint/swiftlint ${RUN_RESOURCES_DIRECTORY}
	cp ./.swiftformat ${RUN_RESOURCES_DIRECTORY}
	cp ./.swiftlint.yml ${RUN_RESOURCES_DIRECTORY}

install: build copyTools

run: build
	${EXECUTABLE_DIRECTORY}/AutorestSwift

test: copyTestResources
	swift test

clean:
	rm -rf .build
	rm Package.resolved

.PHONY: run build test copyRunResources copyTestResources clean
