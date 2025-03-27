//
//  NSObject+PointToCGConverter.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 13/03/2025.
//

#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface PointToCGConverter: NSObject

-(NSArray<NSValue*> *)convertPoint:(const std::vector<cv::Point> &)currentPoints;
-(NSArray<NSValue*> *)convertPoint2f:(const std::vector<cv::Point2f>&)currentPoints;

@end

NS_ASSUME_NONNULL_END
