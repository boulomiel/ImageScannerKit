//
//  Crop.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import "Crop.h"
#include "opencv2/opencv.hpp"
#include "opencv2/imgcodecs/ios.h"

using namespace cv;

@implementation Crop

-(UIImage *)crop: (UIImage *) image toPoints:(NSArray<NSValue *> *)points {
    std::vector<cv::Point> pts;
    for (NSValue *value in points) {
        CGPoint cgPoint = [value CGPointValue];
        pts.push_back(cv::Point((int)cgPoint.x, (int)cgPoint.y));
    }
    Mat cvImage;
    UIImageToMat(image, cvImage);
    Mat mask = Mat::zeros(cvImage.size(), CV_8UC1);
    fillPoly(mask, pts, cv::Scalar(255));
    Mat croppedImage;
    cvImage.copyTo(croppedImage, mask);
    return MatToUIImage(croppedImage);
}

@end
