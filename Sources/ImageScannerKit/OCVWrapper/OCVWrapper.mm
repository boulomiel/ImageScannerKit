//
//  OCVWrapper.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 26/02/2025.
//

#import "OCVWrapper.hpp"

#import <UIKit/UIKit.h>


//#import "Brightness.h"
//#import "Sharpness.h"
//#import "Corners.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "Channel.hpp"
#import "Crop.hpp"
#import "PerspectiveTransform.hpp"
#import "Rotate.hpp"
#import "Binary.hpp"
#import "Contrast.hpp"
#import "Brightness.hpp"
#import "Sharpness.hpp"
#import "Corners.hpp"
#include "PointToCGConverter.hpp"

using namespace std;
using namespace cv;

@implementation OCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (Mat)_matFrom:(UIImage *)source {
    cout << "matFrom ->";
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    Mat result(rows, cols, CV_8UC4);
    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = result.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    CGContextRef context = CGBitmapContextCreate(result.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    return result;
}

+ (UIImage *)_imageFrom:(Mat)source {
    cout << "-> imageFrom\n";
    NSData *data = [NSData dataWithBytes:source.data length:source.elemSize() * source.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGBitmapInfo bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = source.step[0];
    CGColorSpaceRef colorSpace = (source.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
    CGImageRef image = CGImageCreate(source.cols, source.rows, bitsPerComponent, bitsPerComponent * source.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+(bool) hasFourChannels: (UIImage *) image {
    cv::Mat mat; UIImageToMat(image, mat);
    @autoreleasepool {
        return Channel::hasFourChannels(mat);
    }
}

+ (UIImage *)crop:(UIImage *)image andPoints:(NSArray<NSValue *> *)toPoints {
    std::vector<cv::Point> pts;
    for (NSValue *value in toPoints) {
        CGPoint cgPoint = [value CGPointValue];
        pts.push_back(cv::Point((int)cgPoint.x, (int)cgPoint.y));
    }
    cv::Mat cvImage; UIImageToMat(image, cvImage);
    @autoreleasepool {
        cv::Mat result = Crop::toPoints(cvImage, pts);
        return MatToUIImage(result);
    }
}

+ (UIImage *)perspectiveTransform:(NSArray<NSValue *> *)sourcePoints with:(UIImage *)sourceImage toDestination:(UIImage *)destination {
    std::vector<cv::Point2f> pts;
    for (NSValue *value in sourcePoints) {
        CGPoint cgPoint = [value CGPointValue];
        pts.push_back(cv::Point(cgPoint.x, cgPoint.y));
    }
    Mat destinationMat; UIImageToMat(destination, destinationMat);
    Mat sourceMat; UIImageToMat(sourceImage, sourceMat);
    @autoreleasepool {
        cv::Mat result = PerspectiveTransform::perspectiveTransform(pts, sourceMat, destinationMat);
        return MatToUIImage(result);
    }
}


+ (UIImage *)rotate:(UIImage *)image withFlag:(int)flag {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Rotate::rotateWithFlat(mat, flag);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)rotate:(UIImage *)image toangle:(float)angle {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Rotate::rotateToAngle(mat, angle);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)toAdaptiveBinary:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Binary::toAdaptiveBinary(mat);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)toBinary:(UIImage *)image withThreshold:(float)threshold {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Binary::toBinary(mat, threshold);
        return MatToUIImage(mat);
    }
}

+ (UIImage*) contrast: (UIImage *)image andAlpha: (float) alpha andBeta:(float) beta{
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Contrast::contrast(mat, alpha, beta);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)brightness:(UIImage *)image andValue:(float)value {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Brightness::brightness(mat, value);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)sharpness:(UIImage *)image withStrength:(float)strength {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Sharpness::sharpness(mat,strength);
        return MatToUIImage(mat);
    }
}

+ (UIImage *)detailEnhance:(UIImage *)image withStrength:(float)strength {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        Sharpness::detailEnhance(mat, strength);
        return MatToUIImage(mat);
    }
}

+ (NSArray<NSValue *> *)corners:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    @autoreleasepool {
        std::vector<Point2f> points = Corners::corners(mat);
        return [PointToCGConverter convertPoint2f:points];
    }
}

@end
