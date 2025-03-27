//
//  Channel.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 22/03/2025.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation Channel

- (bool)hasFourChannels:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    return mat.channels() == 4;
}


@end
