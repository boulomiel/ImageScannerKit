//
//  OCVWrapper.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 26/02/2025.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCVWrapper: NSObject

+ (UIImage *)toGray:(UIImage *)source;

@end

NS_ASSUME_NONNULL_END
