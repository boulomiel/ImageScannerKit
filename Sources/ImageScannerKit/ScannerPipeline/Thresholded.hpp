//
//  Thresholded.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//
#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

class Thresholded: public ScannerStep {
    
    void handle(cv::Mat &mat) override {
     //  threshold(mat, mat, 0, 255, THRESH_TRIANGLE);
      //  threshold(mat, mat, 100, 255, THRESH_TRUNC); // can be 60
        threshold(mat, mat, 140, 255, THRESH_BINARY_INV);

       //  adaptiveThreshold(mat, mat, 100, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 21, 2);
        if (next) {
            next->handle(mat);
        }
    }
};
