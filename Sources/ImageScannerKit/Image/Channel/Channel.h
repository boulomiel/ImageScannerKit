//
//  Channel.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 22/03/2025.
//

#ifndef Channel_h
#define Channel_h

#import <UIKit/UIKit.h>

@interface Channel: NSObject


/// Check if the current image contains 4 channels (RGBA, BGRA, HSVA...)
/// - Parameter image: Image to be checked
/// - Returns: true if the image is a four channel matrix
-(bool) hasFourChannels: (UIImage *) image;

@end

#endif /* Channel_h */
