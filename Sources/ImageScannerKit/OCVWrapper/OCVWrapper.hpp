//
//  OCVWrapper.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 26/02/2025.
//

//#include <opencv2/opencv.hpp>


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCVWrapper: NSObject

+ (UIImage *)toGray:(UIImage *)source;

+ (bool) hasFourChannels: (UIImage *) image;

+ (UIImage *) crop: (UIImage *) image andPoints:(NSArray<NSValue *> *) toPoints;

+ (UIImage *) perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination;

+ (UIImage *) rotate:(UIImage *) image withFlag:(int)flag;

+ (UIImage *) rotate:(UIImage *)image toangle:(float)angle;

+ (UIImage *) toAdaptiveBinary: (UIImage*) image;

+ (UIImage *) toBinary:(UIImage *)image withThreshold:(float) threshold;

+ (UIImage*) contrast: (UIImage *)image andAlpha: (float) alpha andBeta:(float) beta;

+ (UIImage*) brightness: (UIImage*) image andValue:(float) value;

+ (UIImage *) sharpness:(UIImage *)image withStrength:(float)strength;

+ (UIImage *) detailEnhance:(UIImage *)image withStrength:(float)strength;

+ (NSArray<NSValue *> *) corners:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
