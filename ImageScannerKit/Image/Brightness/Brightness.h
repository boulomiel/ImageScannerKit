//
//  Brightness.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Brightness_h
#define Brightness_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Brightness : NSObject

/**
 * Adjusts the brightness of the given UIImage.
 *
 * - Parameter image: The input UIImage to be processed.
 * - Parameter value: The brightness adjustment (positive values increase brightness, negative values decrease it).
 * - Returns: A new UIImage with the applied brightness adjustment.
 */
-(UIImage*) brightness: (UIImage*) image andValue:(float) value;

@end

#endif /* Brightness_h */
