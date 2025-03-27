//
//  Corners.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 27/03/2025.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Corners : NSObject


/// Detect and returns the corners of a rectangle shape in an image
/// - Parameter image: image to look for rectangles corners in
/// - Returns: An array of cgPointsValue 
- (NSArray<NSValue*> *) corners:(UIImage *) image;

@end
