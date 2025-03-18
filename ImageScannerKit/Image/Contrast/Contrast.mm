//
//  Contrast.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import "Contrast.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation Contrast

- (UIImage *)contrast:(UIImage *)image withAlpha:(float)alpha andBeta:(float)beta {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat contrasted;
    cv::addWeighted(mat, alpha, mat, alpha, beta, contrasted);
    return MatToUIImage(contrasted);
}

@end
