//
//  Sharpness.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef Sharpness_h
#define Sharpness_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sharpness : NSObject

-(UIImage*) sharpness: (UIImage*) image withStrength:(float) strength;

@end

#endif /* Sharpness_h */
