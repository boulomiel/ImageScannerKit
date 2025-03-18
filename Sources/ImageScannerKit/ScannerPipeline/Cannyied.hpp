//
//  Cannyied.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//

#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

using namespace cv;

class Cannyied: public ScannerStep {
    
    void handle(cv::Mat &mat) override {
        Canny(mat, mat, 0, 50, 3);
        if (next) {
            next->handle(mat);
        }
    };
};
