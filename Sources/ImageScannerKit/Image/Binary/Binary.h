//
//  Binary.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Binary_h
#define Binary_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Binary : NSObject

/// Creates a adaptive threshold binary image  https://docs.opencv.org/4.x/d7/d4d/tutorial_py_thresholding.html
/// - Parameter image: Image to be thresholded
-(UIImage*) toAdaptiveBinary: (UIImage*) image;


/// Creates a adaptive threshold binary image  https://docs.opencv.org/4.x/d7/d4d/tutorial_py_thresholding.html
/// - Parameters:
///   - image: Image to be transformed to a binary image
///   - threshold: float value up to 255 - Whatever channel (B,G,R,A) value below this threshold will be set to 0.
-(UIImage*) toBinary: (UIImage*) image withThreshold:(float) threshold;

@end

#endif /* Binary_h */
