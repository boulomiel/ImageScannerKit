//
//  UIImage.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import <Foundation/Foundation.h>
#import "Crop.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Crop)


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



@end

NS_ASSUME_NONNULL_END
