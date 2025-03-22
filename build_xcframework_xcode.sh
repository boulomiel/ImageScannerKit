#!/bin/bash

# Input Arguments
SCHEME_NAME="ImageScannerKit"  # The scheme to build, e.g., "ImageScannerKit"
FRAMEWORK_NAME="ImageScannerKit"  # The framework name, e.g., "ImageScannerKit"
PROJECT_PATH="${SOURCE_ROOT}/ImageScannerKit.xcodeproj"

# Step 0: Remove Previous Creation
echo "Cleaning previous XCFrameworks..."
rm -rf "${SOURCE_ROOT}/xcframeworks/"

# Step 1: Set Derived Data Path
echo "Fetching Derived Data Path..."
DERIVED_DATA_PATH=$(xcodebuild -project "${SOURCE_ROOT}/${SCHEME_NAME}.xcodeproj" -showBuildSettings | grep -m 1 "BUILD_DIR" | awk '{print $3}')

echo "Building framework for iPhoneOS..."
xcodebuild archive \
  -project "${SOURCE_ROOT}/${SCHEME_NAME}.xcodeproj" \
  -scheme "$SCHEME_NAME" \
  -sdk iphoneos \
  -archivePath "$DERIVED_DATA_PATH/$SCHEME_NAME-iphoneos.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES 

# Build the framework for iphonesimulator
echo "Building framework for iPhoneSimulator..."
xcodebuild archive \
  -project "${SOURCE_ROOT}/${SCHEME_NAME}.xcodeproj" \
  -scheme "$SCHEME_NAME" \
  -sdk iphonesimulator \
  -archivePath "$DERIVED_DATA_PATH/$SCHEME_NAME-iphonesimulator.xcarchive" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES 

# Step 3: Define paths for the frameworks
FRAMEWORK_IPHONEOS="$DERIVED_DATA_PATH/$SCHEME_NAME-iphoneos.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"
FRAMEWORK_SIMULATOR="$DERIVED_DATA_PATH/$SCHEME_NAME-iphonesimulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"

# Step 4: Create the XCFramework
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$FRAMEWORK_IPHONEOS" \
  -framework "$FRAMEWORK_SIMULATOR" \
  -output "${SOURCE_ROOT}/xcframeworks/$FRAMEWORK_NAME.xcframework"

echo "XCFramework created successfully at: ${SOURCE_ROOT}/xcframeworks/$FRAMEWORK_NAME.xcframework"
