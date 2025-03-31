//
//  Channel.h
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 22/03/2025.
//

#ifndef Channel_h
#define Channel_h

#import <opencv2/opencv.hpp>

class Channel {
public:
    /// Check if the given image contains 4 channels (RGBA, BGRA, HSVA...)
    /// - Parameter image: cv::Mat image reference
    /// - Returns: true if the image has 4 channels
    static bool hasFourChannels(const cv::Mat& image) {
        return image.channels() == 4;
    }
};

#endif /* Channel_h */

