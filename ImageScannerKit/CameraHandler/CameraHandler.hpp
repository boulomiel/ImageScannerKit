//
//  CameraHandler.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 27/02/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CameraHandlerFrameHolder.h"
#import "CameraHandlerDelegate.h"

NS_ASSUME_NONNULL_BEGIN


NS_SWIFT_SENDABLE
@interface CameraHandler : NSObject

//MARK: - Constructor
- (id)initWithFrameHolder:(id<CameraHandlerFrameHolder>) frameHolder andDelegate:(id<CameraHandlerDelegate>) delegate;

@property(nonatomic, weak) id<CameraHandlerDelegate> delegate;

// MARK: - Exposed
/// start the OpenCV Camera - must be run from background thread
- (void) startCamera;

/// stop the OpenCV Camera - must be run from background thread
- (void) stopCamera;

/// Activate or deactivate the camera flash
/// - Parameter enable: if true, the flash is activated
- (void)toggleFlash:(BOOL)enable;

/// Applies or cancel the the automatic snap when a document is detected
/// - Parameter isActivated: if true, automatic detection is activated, otherwise cancelled. Default value is true
- (void) setAutoDetectionActivated:(BOOL) isActivated;

/// Applies or cancel the the automatic detection frame above the image when a document is detected
/// - Parameter isActivated: Default value is true
- (void) setUIDetectionActivated:(BOOL) isActivated;


@end

NS_ASSUME_NONNULL_END

