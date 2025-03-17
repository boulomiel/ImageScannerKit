//
//  ScannerStep.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//

#ifndef ScannerStep_hpp
#define ScannerStep_hpp

#include <stdio.h>
#include <string>
#include <ScannerLink.hpp>
#include <opencv2/opencv.hpp>

class ScannerStep {
    
    public:
    virtual ~ScannerStep() = default;
    virtual void handle(cv::Mat& mat) = 0;
    void setNext(ScannerStep *next) {
        this->next = next;
    };
    
    protected:
    ScannerStep *next;
};

#endif /* ScannerStep_hpp */
