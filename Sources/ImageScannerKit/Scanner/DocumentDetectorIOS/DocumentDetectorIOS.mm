//
//  DocumentDetector.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import "DocumentDetectorIOS.h"
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
#import <memory>

using namespace cv;
using namespace std;

@implementation DocumentDetectorIOS

PointToCGConverter *converter = [[PointToCGConverter alloc] init];
Mat mat, image_copy;

- (void)detectDocumentIn:(UIImage *)image completion:(void (^)(UIImage *, NSArray<NSValue *> *))completion {
    UIImageToMat(image, mat);

    cvtColor(mat, mat, COLOR_BGR2BGRA);
    mat.copyTo(image_copy);
  //  NSLog(@"Mat size: %d x %d, Channels: %d", image_copy.rows, image_copy.cols, image_copy.channels());

    auto grayScale = std::make_unique<GrayScale>();
    auto blurry = std::make_unique<Blurry>();
    auto thresHolded = std::make_unique<Thresholded>();
    auto openErosion = std::make_unique<Erosion>(MORPH_OPEN);
    auto closeErosion = std::make_unique<Erosion>(MORPH_CLOSE);
    auto canny = std::make_unique<Cannyied>();
    __weak typeof(self) weakSelf = self;
    
    auto detectPolygon = std::make_unique<DetectPolygon>(0.2, 0, [&, weakSelf](const std::vector<cv::Point> points){
        if(!weakSelf) { return; }
        completion(MatToUIImage(mat), [converter convertPoint:points]);
    });
   
    grayScale->setNext(blurry.get());
    blurry->setNext(closeErosion.get());
    closeErosion->setNext(thresHolded.get());
    thresHolded->setNext(openErosion.get());
    openErosion->setNext(canny.get());
    canny->setNext(detectPolygon.get());
    grayScale->handle(image_copy);
}

@end
