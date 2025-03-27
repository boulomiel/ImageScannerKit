//
//  UIImage.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(OpencvExtension)

/// Check if the current image contains 4 channels (RGBA, BGRA, HSVA...)
/// - Returns: true if the image is a four channel matrix
-(bool) hasFourChannels;

/// Crop image to points
/// - Parameter toPoints: CGPoints into NSValue in this order: topLeft, topRight, bottomRight, bottomLeft
-(UIImage *)crop: (NSArray<NSValue *> *) toPoints;

/// Align an image position position to a desired image frame - reports the four corners of the source to the four corners of the destination
/// - Parameters:
///   - sourcePoints: source Image corners points - must be given - if within the image bounds, or the image corner itself.
///   - sourceImage: sourceImage to be adapted
///   - destination: destionation image the frame is used as destionation
-(UIImage *)perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination;

/// Rotate images around center
/// - Parameters:
///   - flag: 0 - ROTATE_90_CLOCKWISE, 1 - ROTATE_180, 2 - ROTATE_90_COUNTERCLOCKWISE
-(UIImage*) rotate: (int) flag;

/// Rotate images around center
/// - Parameters:
///   - image: uiimage to rotate
///   - amgle: float value of angle in degrees
-(UIImage*) rotateToAngle:(float) angle;

/// Creates a adaptive threshold binary image  https://docs.opencv.org/4.x/d7/d4d/tutorial_py_thresholding.html
-(UIImage*) toAdaptiveBinary;

/// Creates a adaptive threshold binary image  https://docs.opencv.org/4.x/d7/d4d/tutorial_py_thresholding.html
/// - Parameters:
///   - threshold: float value up to 255 - Whatever channel (B,G,R,A) value below this threshold will be set to 0.
-(UIImage*) toBinary:(float) threshold;

/// Adjusts the contrast and brightness of the given UIImage.
/// - Parameter alpha: The contrast factor ( >1 increases contrast, 0-1 decreases contrast).
/// - Parameter beta: The brightness adjustment (positive values increase brightness, negative values decrease it).
/// - Returns: A new UIImage with the applied contrast and brightness adjustments.
-(UIImage*) contrast: (float) alpha andBeta:(float) beta;


/// Adjusts the brightness of the given UIImage.
/// - Parameter value: The brightness adjustment (positive values increase brightness, negative values decrease it).
/// - Returns: A new UIImage with the applied brightness adjustment.
-(UIImage*) brightness:(float) value;

/// Adjusts the sharpness of the given UIImage.
/// - Parameter strength: The sharpness intensity (higher values increase sharpness, lower values decrease it).
/// - Returns: A new UIImage with the applied sharpness enhancement.
- (UIImage *)sharpness:(float)strength;

/// Detect and returns the corners of a rectangle shape in an image
/// - Returns: An array of cgPointsValue
- (NSArray<NSValue*> *) corners;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface OpencvExtension

@end

@implementation OpencvExtension


@end

NS_ASSUME_NONNULL_END

