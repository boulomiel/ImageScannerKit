//
//  File.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//
#import <Foundation/Foundation.h>

#ifndef CameraHandlerDelegate_h
#define CameraHandlerDelegate_h

NS_SWIFT_UI_ACTOR
@protocol CameraHandlerDelegate<NSObject>

@optional
- (void) startCamera;

@optional
- (void) stopCamera;

@optional
- (void) setFlashEnabled:(bool) isEnabled;

@optional
- (void) setAutoDetectionEnabled:(bool) isEnabled;

@optional
- (void) setUIDetectionEnabled:(bool) isEnabled;

@optional
- (void) onDocumentSnapped:(NSArray*) points andImage:(UIImage *) uiImage;

@required
- (void) onDocumentDetected:(NSArray*) points andImage:(UIImage *) uiImage;

@end

#endif 
