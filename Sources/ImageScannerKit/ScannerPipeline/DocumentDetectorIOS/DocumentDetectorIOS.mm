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

using namespace cv;
using namespace std;

@implementation DocumentDetectorIOS

PointToCGConverter *converter = [[PointToCGConverter alloc] init];
Mat mat, image_copy;

- (void)detectDocumentIn:(UIImage *)image completion:(void (^)(UIImage *, NSArray<NSValue *> *))completion {
    UIImageToMat(image, mat);

    cvtColor(mat, mat, COLOR_BGR2BGRA);
    mat.copyTo(image_copy);
    NSLog(@"Mat size: %d x %d, Channels: %d", image_copy.rows, image_copy.cols, image_copy.channels());

    GrayScale *grayScale = new GrayScale;
    Blurry *blurry = new Blurry;

    Thresholded *thresHolded = new Thresholded;
    Erosion *openErosion = new Erosion(MORPH_OPEN);
    Erosion *closeErosion = new Erosion(MORPH_CLOSE);
    Cannyied *canny = new Cannyied;
    __weak typeof(self) weakSelf = self;
    
    DetectPolygon *detectPolygon = new DetectPolygon(0.2, 0, [&, weakSelf](const std::vector<cv::Point> points){
        if(!weakSelf) { return; }
            NSLog(@"Mat size: %d x %d, Channels: %d", mat.rows, mat.cols, mat.channels());
            completion(MatToUIImage(mat), [converter convertPoint:points]);
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
