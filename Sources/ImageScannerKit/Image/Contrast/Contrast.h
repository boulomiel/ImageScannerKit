//
//  Contrast.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Contrast_h
#define Contrast_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Contrast : NSObject

/**
 * Adjusts the contrast and brightness of the given UIImage.
 *
 * - Parameter image: The input UIImage to be processed.
 * - Parameter alpha: The contrast factor ( >1 increases contrast, 0-1 decreases contrast).
 * - Parameter beta: The brightness adjustment (positive values increase brightness, negative values decrease it).
 * - Returns: A new UIImage with the applied contrast and brightness adjustments.
 */
-(UIImage*) contrast: (UIImage*) image withAlpha:(float) alpha andBeta:(float) beta;

@end


#endif /* Contrast_h */
