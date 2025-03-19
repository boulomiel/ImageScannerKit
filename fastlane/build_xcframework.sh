echo "Build iOS"
xcodebuild -scheme ImageScannerKit -destination 'generic/platform=iOS' -configuration Release BUILD_LIBRARY_FOR_DISTRIBUTION=YES build

echo "Build simulator"
xcodebuild -scheme ImageScannerKit -destination 'generic/platform=iOS Simulator' -configuration Release BUILD_LIBRARY_FOR_DISTRIBUTION=YES build

echo "Build ImageScannerKit.xcframework"
xcodebuild -create-xcframework \
-framework /Users/rubenmimoun/Library/Developer/Xcode/DerivedData/ImageScannerKit-gygtchoukzxghuemxnbohanyqvku/Build/Products/Release-iphoneos/ImageScannerKit.framework \
-framework /Users/rubenmimoun/Library/Developer/Xcode/DerivedData/ImageScannerKit-gygtchoukzxghuemxnbohanyqvku/Build/Products/Release-iphonesimulator/ImageScannerKit.framework \
-output ../xcframeworks/ImageScannerKit.xcframework
