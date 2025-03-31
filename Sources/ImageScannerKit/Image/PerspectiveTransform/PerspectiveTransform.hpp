//
//  PerspectiveTransform.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 12/03/2025.
//

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

#include <opencv2/opencv.hpp>

using namespace cv;

class PerspectiveTransform {
public:
    
    static Mat perspectiveTransform(std::vector<cv::Point2f> sourcePoints, Mat &sourceImage, Mat &destinationImage) {
        cv::Size destSize = destinationImage.size();
        std::vector<cv::Point2f> destinationPoint {
            cv::Point2f(0, 0),
            cv::Point2f(destSize.width, 0),
            cv::Point2f(destSize.width, destSize.height),
            cv::Point2f(0, destSize.height)
        };
        
        Mat transform = getPerspectiveTransform(sourcePoints, destinationPoint);
        warpPerspective(sourceImage, sourceImage, transform, destSize);
        return sourceImage;
    }
};
