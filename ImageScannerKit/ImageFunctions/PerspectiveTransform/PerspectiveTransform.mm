//
//  PerspectiveTransform.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 12/03/2025.
//

#import "PerspectiveTransform.h"
#include <opencv2/opencv.hpp>
#include <opencv2/imgcodecs/ios.h>

using namespace cv;

@implementation PerspectiveTransform

-(UIImage *)perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination {
    std::vector<cv::Point2f> pts;
    for (NSValue *value in sourcePoints) {
        CGPoint cgPoint = [value CGPointValue];
        pts.push_back(cv::Point(cgPoint.x, cgPoint.y));
    }
    
    Mat destinationMat; UIImageToMat(destination, destinationMat);
    cv::Size destSize = destinationMat.size();
    std::vector<cv::Point2f> destinationPoint {
        cv::Point2f(0, 0),
        cv::Point2f(destSize.width, 0),
        cv::Point2f(destSize.width, destSize.height),
        cv::Point2f(0, destSize.height)
    };
    
    Mat transform = getPerspectiveTransform(pts, destinationPoint);
    
    Mat sourceMat; UIImageToMat(sourceImage, sourceMat);
    Mat result; warpPerspective(sourceMat, result, transform, destSize);
    return MatToUIImage(result);
}

@end
