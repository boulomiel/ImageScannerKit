//
//  CameraHandler.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 27/02/2025.
//

#include "opencv2/imgcodecs/ios.h"

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
#import "DocumentDetector.hpp"

#import <AVFoundation/AVFoundation.h>
#import <opencv2/videoio/cap_ios.h>


using namespace cv;
using namespace std;

@interface CameraHandler() <CvVideoCameraDelegate>
@end

@implementation CameraHandler

#pragma mark - State variables
BOOL isAutoDetectionActivated;
BOOL isUIDetectionActivated;

#pragma mark - References
PointToCGConverter* pointConverter;
AutoSnapHandlerProtocol* snapHandler;
CvVideoCamera* videoCamera;
DocumentDetector *detector;
NSOperationQueue *cameraOperationQueue;

/// Initialized the Camera Handler  with CameraHandlerFrameHolder
/// - Parameter frameHolder: CameraHandlerFrameHolder protocol, wrapping an image view to be the frame of the camera
- (nonnull id)initWithFrameHolder:(nonnull id<CameraHandlerFrameHolder>)frameHolder andDelegate:(nonnull id<CameraHandlerDelegate>)delegate {
    videoCamera = [[CvVideoCamera alloc] initWithParentView:frameHolder.frameView];
    detector = [[DocumentDetector alloc] init];
    _delegate = delegate;
    isAutoDetectionActivated = true;
    isUIDetectionActivated = true;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1920x1080;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.delegate = self;
    cameraOperationQueue = [[NSOperationQueue alloc] init];
    cameraOperationQueue.underlyingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    cameraOperationQueue.name = @"com.ImageScannerKit.CameraHandlerRunner";
    
    snapHandler = new AutoSnapHandler([delegate](const std::vector<cv::Point> points, cv::Mat image){
        dispatch_async(dispatch_get_main_queue(), ^{
            PointToCGConverter *converter = [[PointToCGConverter alloc] init];
            [delegate onDocumentSnapped: [converter convertPoint: points] andImage: MatToUIImage(image)];
        });
    });
    return self;
}

- (void)startCamera {
    __weak typeof(self) weakSelf = self;
    [cameraOperationQueue addOperationWithBlock: ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [videoCamera start];
        }
    }];
}

- (void)stopCamera {
    [videoCamera stop];
}

- (void)setAutoDetectionActivated:(BOOL)isActivated {
    isAutoDetectionActivated = isActivated;
}

- (void) setUIDetectionActivated:(BOOL) isActivated {
    isUIDetectionActivated = isActivated;
}

- (void)toggleFlash:(BOOL)enable {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = enable ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
            [device unlockForConfiguration];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }
}

- (NSArray<NSValue*> *)convertPoint:(const std::vector<cv::Point> *)currentPoints {
    if (!currentPoints) return @[];
    NSMutableArray* cgPoints = [NSMutableArray array];
    for (const cv::Point& point : *currentPoints) {
        CGPoint cg = CGPointMake(point.x, point.y);
        NSValue *cgValue = [NSValue valueWithCGPoint:cg];
        [cgPoints addObject:cgValue];
    }
    return cgPoints;
}

#pragma mark - Protocol CvVideoCameraDelegate

- (void)processImage:(Mat&) image;
{
    Mat copy;
    image.copyTo(copy);
    __weak typeof(self) weakSelf = self;
    
    [detector detectDocumentIn:image completion:^(Mat processedImage, std::vector<cv::Point> cornerPoints) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PointToCGConverter *converter = [[PointToCGConverter alloc] init];
            NSArray<NSValue*> *convertedPoints = [converter convertPoint:cornerPoints];
            [weakSelf.delegate onDocumentDetected:convertedPoints andImage:MatToUIImage(processedImage)];
        });
        
        if(cornerPoints.empty()) {
            return;
        }
        
        if (isUIDetectionActivated) {
            Mat mask = Mat::zeros(image.size(), CV_8UC4);
            fillPoly(mask, cornerPoints, cv::Scalar(165, 255, 128, 255));
            addWeighted(image, 1.0, mask, 0.8, 0.0, image);
        }
        
        if (!isAutoDetectionActivated) {
            return;
        }
        snapHandler->addPoints(cornerPoints, processedImage);
    }];
}

@end
