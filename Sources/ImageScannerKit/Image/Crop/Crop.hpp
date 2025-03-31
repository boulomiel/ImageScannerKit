//
//  Crop.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#include <opencv2/opencv.hpp>

NS_ASSUME_NONNULL_BEGIN

using namespace cv;

class Crop {
    
    public:
    
    static cv::Mat toPoints(cv::Mat& image, std::vector<cv::Point> pts) {
        Mat mask = Mat::zeros(image.size(), CV_8UC1);
        fillPoly(mask, pts, cv::Scalar(255));
        Mat croppedImage;
        image.copyTo(croppedImage, mask);
        return croppedImage;
    }
};

NS_ASSUME_NONNULL_END
