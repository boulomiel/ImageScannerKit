//
//  ScannerLink.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 03/03/2025.
//

#ifndef ScannerLink_hpp
#define ScannerLink_hpp

#include <stdio.h>
#include<string>
#include<opencv2/opencv.hpp>

struct ScannerLink {
    std::string stepname;
    cv::Mat& image;
    
    ScannerLink(std::string stepname, cv::Mat& image): stepname(stepname), image(image) {
        std::cout << stepname << "created" << std::endl;
    };
};

#endif
