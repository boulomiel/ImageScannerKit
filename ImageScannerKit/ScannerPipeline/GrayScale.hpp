//
//  GrayScale.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//
#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

using namespace cv;

class GrayScale: public ScannerStep {
    
public:
    void handle(cv::Mat &mat) override {
        cvtColor(mat, mat, COLOR_BGR2GRAY);
        if (next) {
            next->handle(mat);
        }
    };
};
