//
//  DocumentShape.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import SwiftUI

public struct DocumentShape: Shape {
    
    var detectedPoint: [CGPoint]
    var scaleX: Double
    var scaleY: Double
    
    public init(detectedPoint: [CGPoint], scaleX: Double, scaleY: Double) {
        self.detectedPoint = detectedPoint
        self.scaleX = scaleX
        self.scaleY = scaleY
    }
    
    public var animatableData: AnimatablePair<Double, Double> {
        get { .init(scaleX, scaleY) }
        set {
            scaleX = newValue.first
            scaleY = newValue.second
        }
    }
    
    func scalePoints(points: [CGPoint], to size: CGSize) -> [CGPoint] {
        if points.isEmpty {
            return []
        } else {
            let newPoints = points.map { point in
                let scaledX = point.x * scaleX
                let scaledY = point.y * scaleY
                return CGPoint(x: scaledX, y: scaledY)
            }
            return newPoints
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        
        let points = scalePoints(points: detectedPoint, to: rect.size)
        
        return Path { path in
            guard let firstPoint = points.first else { return }
            path.move(to: .init(x: firstPoint.x, y: firstPoint.y))
            for point in points.dropFirst() {
                path.addLine(to: .init(x: point.x, y: point.y))
            }
            path.closeSubpath()
        }
    }
}
