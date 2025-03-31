//
//  Snapped.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import UIKit

public struct Snapped: Identifiable {
    public let id: UUID = .init()
    public let cgImage: CGImage
    public let points: [Any]
    
    public init(cgImage: CGImage, points: [Any]) {
        self.cgImage = cgImage
        self.points = points
    }
    
    var pointNSValues: [NSValue] {
        points.map { $0 as! NSValue }
    }
    
    public func crop() -> CGImage {
        autoreleasepool {
            let image = UIImage(cgImage: cgImage)
            return image.crop(pointNSValues).cgImage!
        }
    }
    
    public func perspectiveTransformed() -> CGImage {
        autoreleasepool {
            let image = UIImage(cgImage: cgImage)
            let cropped = UIImage(cgImage: crop())
           return image.perspectiveTransform(pointNSValues, with: cropped, toDestination: image).cgImage!
        }
    }
}
