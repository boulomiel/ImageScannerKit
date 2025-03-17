//
//  DocumentDetector.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef DocumentDetector_h
#define DocumentDetector_h

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

@interface DocumentDetectorIOS : NSObject

 // Detects a document in the given UIImage and returns the processed image along with detected corner points.
 // - Parameter image: The input UIImage containing the document.
 // - Parameter completion: A callback that returns a processed UIImage and an NSArray of NSValue containing CGPoint coordinates of detected corners.
- (void)detectDocumentIn:(UIImage *)image
              completion:(void (^)(UIImage *processedImage, NSArray<NSValue *> *cornerPoints))completion;

@end


#endif /* DocumentDetector_h */
