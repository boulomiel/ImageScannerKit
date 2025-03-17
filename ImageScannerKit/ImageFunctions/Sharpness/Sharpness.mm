//
//  Sharpness.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import "Sharpness.h"
#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation Sharpness

- (UIImage *)sharpness:(UIImage *)image withStrength:(float)strength {
    cv::Mat mat, enhanced;
    UIImageToMat(image, mat);
    if (mat.channels() < 4) {
        cv::cvtColor(mat, mat, cv::COLOR_GRAY2RGBA);
    }
    cv::detailEnhance(mat, enhanced, strength, 0.5);
    return MatToUIImage(enhanced);
}

@end
