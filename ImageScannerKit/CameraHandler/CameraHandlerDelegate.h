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
- (void) onDocumentSnapped:(NSArray*) points andImage:(UIImage *) uiImage;

@required
- (void) onDocumentDetected:(NSArray*) points andImage:(UIImage *) uiImage;

@end

#endif 
