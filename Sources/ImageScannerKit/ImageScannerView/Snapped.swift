//
//  Snapped.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import UIKit

public struct Snapped: Identifiable {
    public let id: UUID = .init()
    public let uiImage: UIImage
    public let points: [Any]
    
    public init(uiImage: UIImage, points: [Any]) {
        self.uiImage = uiImage
        self.points = points
    }
    
    var pointNSValues: [NSValue] {
        points.map { $0 as! NSValue }
    }
    
    public func crop() -> UIImage {
        uiImage.crop(pointNSValues)
    }
    
    public func perspectiveTransformed() -> UIImage {
        uiImage.perspectiveTransform(pointNSValues, with: crop(), toDestination: uiImage)
    }
}
