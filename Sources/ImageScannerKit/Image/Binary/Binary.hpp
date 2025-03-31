//
//  Binary.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Binary_h
#define Binary_h

#include <opencv2/opencv.hpp>

using namespace cv;

class Binary {
    
public:
    
    static void toAdaptiveBinary(Mat& image) {
        cvtColor(image, image, COLOR_BGR2GRAY);
        equalizeHist(image, image);
        adaptiveThreshold(image, image, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 11, 2);
    }
    
    static void toBinary(Mat& image, float threshold) {
        cvtColor(image, image, COLOR_BGR2GRAY);
    }
};

#endif /* Binary_h */
