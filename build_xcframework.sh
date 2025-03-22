#!/bin/bash

# Input Arguments
SCHEME_NAME="ImageScannerKit"  # The scheme to build, e.g., "ImageScannerKit"
FRAMEWORK_NAME="ImageScannerKit"  # The framework name, e.g., "ImageScannerKit"

# Step 1: Set Derived Data Path
DERIVED_DATA_PATH=$(xcodebuild -showBuildSettings | grep -m 1 "BUILD_DIR" | awk '{print $3}')

# Step 2: Build the framework for iphoneos and iphonesimulator
xcodebuild archive -scheme "$SCHEME_NAME" -sdk iphoneos \
  -archivePath "$DERIVED_DATA_PATH/$SCHEME_NAME-iphoneos.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme "$SCHEME_NAME" -sdk iphonesimulator \
  -archivePath "$DERIVED_DATA_PATH/$SCHEME_NAME-iphonesimulator.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Step 3: Define paths for the frameworks
FRAMEWORK_IPHONEOS="$DERIVED_DATA_PATH/$SCHEME_NAME-iphoneos.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"
FRAMEWORK_SIMULATOR="$DERIVED_DATA_PATH/$SCHEME_NAME-iphonesimulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"

# Step 4: Create the XCFramework
xcodebuild -create-xcframework \
  -framework "$FRAMEWORK_IPHONEOS" \
  -framework "$FRAMEWORK_SIMULATOR" \
  -output ./xcframeworks/$FRAMEWORK_NAME.xcframework
