//
//  Blurry.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 10/03/2025.
//

#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

using namespace cv;

class Blurry: public ScannerStep {
  
    void handle(cv::Mat &mat) override {
        blur(mat, mat, cv::Size(9,9));
        if (next) {
            next->handle(mat);
        }
    };
};
