//
//  OCVWrapper.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 26/02/2025.
//

#import "OCVWrapper.h"

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

@implementation OCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}
#pragma mark Public
+ (UIImage *)toGray:(UIImage *)source {
    cout << "OpenCV: ";
    return [OCVWrapper _imageFrom:[OCVWrapper _grayFrom:[OCVWrapper _matFrom:source]]];
}
#pragma mark Private
+ (Mat)_grayFrom:(Mat)source {
    cout << "-> grayFrom ->";
    Mat result;
    cvtColor(source, result, COLOR_BGR2GRAY);
    return result;
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
@end
