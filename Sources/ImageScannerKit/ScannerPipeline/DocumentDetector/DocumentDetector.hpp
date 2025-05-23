//
//  DocumentDetector.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/03/2025.
//

#ifndef DocumentDetector_h
#define DocumentDetector_h

#include <UIKit/UIKit.h>
#include <opencv2/opencv.hpp>

@interface DocumentDetector : NSObject

 // Detects a document in the given UIImage and returns the processed image along with detected corner points.
 // - Parameter image: The input UIImage containing the document.
 // - Parameter completion: A callback that returns a processed UIImage and an NSArray of NSValue containing CGPoint coordinates of detected corners.
- (void)detectDocumentIn:(cv::Mat &)image
              completion:(void (^)(cv::Mat processedImage, std::vector<cv::Point> cornerPoints))completion;

@end


#endif /* DocumentDetector_h */
