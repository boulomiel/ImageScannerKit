//
//  DocumentDetector.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import "DocumentDetectorIOS.h"
#import "CameraHandler.hpp"
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

@implementation DocumentDetectorIOS

- (void)detectDocumentIn:(UIImage *)image completion:(void (^)(UIImage *, NSArray<NSValue *> *))completion {
    Mat mat, baseImage, image_copy;
    UIImageToMat(image, mat);
    cvtColor(mat, mat, COLOR_BGR2BGRA);
    
    cvtColor(mat, baseImage, COLOR_BGR2RGB);
    mat.copyTo(image_copy);

    GrayScale *grayScale = new GrayScale;
    Blurry *blurry = new Blurry;
    Clahe *clahe = new Clahe;

    Thresholded *thresHolded = new Thresholded;
    Erosion *openErosion = new Erosion(MORPH_OPEN);
    Erosion *closeErosion = new Erosion(MORPH_CLOSE);
    Cannyied *canny = new Cannyied;
    __weak typeof(self) weakSelf = self;
    DetectPolygon *detectPolygon = new DetectPolygon([&, weakSelf](const std::vector<cv::Point> points){
        dispatch_async(dispatch_get_main_queue(), ^{
            PointToCGConverter *converter = [[PointToCGConverter alloc] init];
            completion(image, [converter convertPoint:points]);
        });
    });
   
    grayScale->setNext(blurry);
    blurry->setNext(closeErosion);
    closeErosion->setNext(thresHolded);
    thresHolded->setNext(openErosion);
    openErosion->setNext(canny);
    canny->setNext(detectPolygon);
    
    grayScale->handle(image_copy);
}

@end
