//
//  Contrast.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Contrast_h
#define Contrast_h

#include <opencv2/opencv.hpp>

#endif /* Contrast_h */

class Contrast {
  
public:
    
    static void contrast(Mat& image, float alpha, float beta) {
        addWeighted(image, alpha, image, alpha, beta, image);
    }
};
