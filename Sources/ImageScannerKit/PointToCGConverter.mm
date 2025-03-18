//
//  NSObject+PointToCGConverter.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 13/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PointToCGConverter.hpp"
#include <opencv2/opencv.hpp>

@implementation PointToCGConverter

-(NSArray<NSValue*> *)convertPoint:(const std::vector<cv::Point>&)currentPoints {
    NSMutableArray* cgPoints = [NSMutableArray array];
    for (const cv::Point& point : currentPoints) {
        CGPoint cg = CGPointMake(point.x, point.y);
        NSValue *cgValue = [NSValue valueWithCGPoint:cg];
        [cgPoints addObject:cgValue];
    }
    return cgPoints;
}


@end
