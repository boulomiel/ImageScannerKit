//
//  Crop.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Crop: NSObject

-(UIImage *)crop: (UIImage *) image toPoints:(NSArray<NSValue *> *)points;

@end

NS_ASSUME_NONNULL_END
