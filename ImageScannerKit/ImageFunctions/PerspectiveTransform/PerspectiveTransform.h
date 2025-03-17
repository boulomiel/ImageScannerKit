//
//  PerspectiveTransform.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 12/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerspectiveTransform : NSObject

-(UIImage *)perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination;


@end

NS_ASSUME_NONNULL_END
