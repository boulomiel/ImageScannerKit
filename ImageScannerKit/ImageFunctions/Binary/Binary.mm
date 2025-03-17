//
//  Binary.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import "Binary.h"
#include "opencv2/opencv.hpp"
#include "opencv2/imgcodecs/ios.h"

using namespace cv;

@implementation Binary

- (UIImage*) toAdaptiveBinary: (UIImage*) image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    Mat bgr, enhanced, blured, binary;
    cvtColor(mat, bgr, COLOR_BGR2GRAY);
    equalizeHist(bgr, enhanced);
    adaptiveThreshold(enhanced, binary, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 11, 2);
    
    return MatToUIImage(binary);
}

- (UIImage *)toBinary:(UIImage *)image withThreshold:(float) threshold {
    cv::Mat mat, bgr, thres;
    UIImageToMat(image, mat);
    cvtColor(mat, bgr, COLOR_BGR2GRAY);
    cv::threshold(bgr, thres, threshold, 255, THRESH_BINARY);
    return MatToUIImage(thres);
}

@end
