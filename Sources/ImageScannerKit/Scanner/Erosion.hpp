//
//  Erosion.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//
#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

using namespace cv;

class Erosion: public ScannerStep {
    
private:
    MorphTypes morphType;
    
public:
    
    Erosion(MorphTypes morphType): morphType(morphType) {};
    
    void handle(cv::Mat &mat) override {
        Mat element = getStructuringElement(MORPH_RECT, cv::Size(21, 21));
        morphologyEx(mat, mat, morphType, element);
     //   morphologyEx(mat, mat, MORPH_CLOSE, element);
       // morphologyEx(mat, mat, MORPH_GRADIENT, element);
        if (next) {
            next->handle(mat);
        }
    };
};
