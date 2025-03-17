//
//  NSObject+Rotate.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Rotate: NSObject


/// Rotate images around center
/// - Parameters:
///   - image: uiimage to rotate
///   - flag: 0 - ROTATE_90_CLOCKWISE, 1 - ROTATE_180, 2 - ROTATE_90_COUNTERCLOCKWISE
-(UIImage*) rotate: (UIImage*) image andFlag:(int) flag;

/// Rotate images around center
/// - Parameters:
///   - image: uiimage to rotate
///   - amgle: float value of angle in degrees
-(UIImage*) rotate: (UIImage*) image toAngle:(float) angle;


@end

NS_ASSUME_NONNULL_END
