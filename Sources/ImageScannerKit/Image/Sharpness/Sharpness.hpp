//
//  Sharpness.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Sharpness_h
#define Sharpness_h

#include <opencv2/opencv.hpp>

using namespace cv;

class Sharpness {
    
public:
    
    static void sharpness(Mat image, float strenght) {
        if (image.channels() < 3) {
            cv::cvtColor(image, image, cv::COLOR_GRAY2RGB);
        }
        Mat blurred;
        cv::GaussianBlur(image, blurred, cv::Size(0, 0), 1.0, 1.0, cv::BORDER_REPLICATE);
        cv::addWeighted(image, 1.0 + strenght, blurred, -strenght, 0, image);
    }
    
    static void detailEnhance(Mat image, float strenght) {
        if (image.channels() < 3) {
            cv::cvtColor(image, image, cv::COLOR_GRAY2RGB);
        }
        cv::detailEnhance(image, image, strenght, 0.5);
    }
};

#endif /* Sharpness_h */
