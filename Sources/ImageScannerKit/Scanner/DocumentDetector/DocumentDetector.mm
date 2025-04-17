//
//  DocumentDetector.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import "DocumentDetector.hpp"
#import "CameraHandler.h"
#import "Erosion.hpp"
#import "Thresholded.hpp"
#import "GrayScale.hpp"
#import "Blurry.hpp"
#import "Cannyied.hpp"
#import "ScannerStep.hpp"
#import "DetectPolygon.hpp"
#import "AutoSnapHandler.hpp"
#import "PointToCGConverter.hpp"
#import "Clahe.hpp"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#include <memory>

using namespace cv;

@implementation DocumentDetector

- (void)detectDocumentIn:(Mat &)image completion:(void (^)(Mat, std::vector<cv::Point>)) completion {
    Mat baseImage, image_copy;
    cvtColor(image, image, COLOR_BGR2BGRA);
    
    cvtColor(image, baseImage, COLOR_BGR2RGB);
    image.copyTo(image_copy);

    auto grayScale = std::make_unique<GrayScale>();
    auto blurry = std::make_unique<Blurry>();
    auto thresHolded = std::make_unique<Thresholded>();
    auto openErosion = std::make_unique<Erosion>(MORPH_OPEN);
    auto closeErosion = std::make_unique<Erosion>(MORPH_CLOSE);
    auto canny = std::make_unique<Cannyied>();
    auto detectPolygon = std::make_unique<DetectPolygon>(0.25, 80.0, [&](const std::vector<cv::Point> points){
        completion(baseImage, points);
    });

    grayScale->setNext(blurry.get());
    blurry->setNext(thresHolded.get());
    thresHolded->setNext(closeErosion.get());
    closeErosion->setNext(openErosion.get());
    openErosion->setNext(canny.get());
    canny->setNext(detectPolygon.get());

    grayScale->handle(image_copy);
}

@end
