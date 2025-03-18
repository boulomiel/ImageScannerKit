//
//  Brightness.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import "Brightness.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation Brightness

- (UIImage *)brightness:(UIImage *)image andValue:(float)value {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat bright;
    cv::convertScaleAbs(mat, bright, 1.0, value);
    return MatToUIImage(bright);
}

@end
