//
//  NSObject+Rotate.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

#include <opencv2/opencv.hpp>

using namespace cv;

class Rotate {
    
public:
    
    /// Rotate images around center
    /// - Parameters:
    ///   - image: uiimage to rotate
    ///   - flag: 0 - ROTATE_90_CLOCKWISE, 1 - ROTATE_180, 2 - ROTATE_90_COUNTERCLOCKWISE
    static void rotateWithFlat(Mat &image, int flag) {
        cv::rotate(image, image, flag);
    }
    
    /// Rotate images around center
    /// - Parameters:
    ///   - image: uiimage to rotate
    ///   - amgle: float value of angle in degrees
    static void rotateToAngle(Mat &image, float angle) {
        
        int height = image.rows;
        int width = image.cols;
        
        cv::Point2f image_center(width / 2.0f, height / 2.0f);
        cv::Mat rotation_mat = cv::getRotationMatrix2D(image_center, angle, 1.0);
        
        double radians = angle * CV_PI / 180.0;
        double sin_angle = std::abs(std::sin(radians));
        double cos_angle = std::abs(std::cos(radians));
        
        int bound_w = static_cast<int>((height * sin_angle) + (width * cos_angle));
        int bound_h = static_cast<int>((height * cos_angle) + (width * sin_angle));
        
        rotation_mat.at<double>(0, 2) += ((bound_w / 2.0) - image_center.x);
        rotation_mat.at<double>(1, 2) += ((bound_h / 2.0) - image_center.y);
        
        cv::warpAffine(image, image, rotation_mat, cv::Size(bound_w, bound_h));
    }
};

