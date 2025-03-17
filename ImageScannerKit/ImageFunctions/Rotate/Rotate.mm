//
//  NSObject+Rotate.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import "Rotate.h"
#include "opencv2/opencv.hpp"
#include "opencv2/imgcodecs/ios.h"

@implementation Rotate

- (UIImage *)rotate:(UIImage *)image andFlag:(int)flag {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat rotated;
    cv::rotate(mat, rotated, flag);
    return MatToUIImage(rotated);
}

- (UIImage *)rotate:(UIImage *)image toAngle:(float)angle {
    cv::Mat mat;
    UIImageToMat(image, mat);

    int height = mat.rows;
    int width = mat.cols;
    
    cv::Point2f image_center(width / 2.0f, height / 2.0f);
    cv::Mat rotation_mat = cv::getRotationMatrix2D(image_center, angle, 1.0);
    
    double radians = angle * CV_PI / 180.0;
    double sin_angle = std::abs(std::sin(radians));
    double cos_angle = std::abs(std::cos(radians));
    
    int bound_w = static_cast<int>((height * sin_angle) + (width * cos_angle));
    int bound_h = static_cast<int>((height * cos_angle) + (width * sin_angle));
    
    rotation_mat.at<double>(0, 2) += ((bound_w / 2.0) - image_center.x);
    rotation_mat.at<double>(1, 2) += ((bound_h / 2.0) - image_center.y);
    
    cv::Mat rotated;
    cv::warpAffine(mat, rotated, rotation_mat, cv::Size(bound_w, bound_h));
    
    return MatToUIImage(rotated);
}

@end
