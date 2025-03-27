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

using namespace cv;

@implementation DocumentDetector

- (void)detectDocumentIn:(Mat &)image completion:(void (^)(Mat, std::vector<cv::Point>)) completion {
    Mat baseImage, image_copy;
    cvtColor(image, image, COLOR_BGR2BGRA);
    
    cvtColor(image, baseImage, COLOR_BGR2RGB);
    image.copyTo(image_copy);

    GrayScale *grayScale = new GrayScale;
    Blurry *blurry = new Blurry;

    Thresholded *thresHolded = new Thresholded;
    Erosion *openErosion = new Erosion(MORPH_OPEN);
    Erosion *closeErosion = new Erosion(MORPH_CLOSE);
    Cannyied *canny = new Cannyied;
    __weak typeof(self) weakSelf = self;
    DetectPolygon *detectPolygon = new DetectPolygon(0.25, 80.0, [&, weakSelf](const std::vector<cv::Point> points){
        completion(baseImage, points);
    });
   
    grayScale->setNext(blurry);
    blurry->setNext(thresHolded);
    thresHolded->setNext(closeErosion);
    closeErosion->setNext(openErosion);
    openErosion->setNext(canny);
    canny->setNext(detectPolygon);
    
    grayScale->handle(image_copy);
}

@end
