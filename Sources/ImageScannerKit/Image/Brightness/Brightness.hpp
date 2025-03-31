//
//  Brightness.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Brightness_h
#define Brightness_h
#include <opencv2/opencv.hpp>

class Brightness {
    
public:
    static void brightness(Mat& image, float value) {
        cv::convertScaleAbs(image, image, 1.0, value);
    }
};

#endif /* Brightness_h */
