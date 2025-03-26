//
//  DocumentShape.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import SwiftUI
import enum Accelerate.vDSP

public struct AnimatableVector: VectorArithmetic, Sendable {
    
    nonisolated(unsafe) public static var zero = AnimatableVector(values: [0.0])

    public static func + (lhs: Self, rhs: Self) -> Self {
        let count = max(lhs.values.count, rhs.values.count)
        let lhs = lhs.values + Array(repeating: 0, count: count - lhs.values.count)
        let rhs = rhs.values + Array(repeating: 0, count: count - rhs.values.count)
        return AnimatableVector(values: vDSP.add(lhs, rhs))
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        let count = max(lhs.values.count, rhs.values.count)
        let lhs = lhs.values + Array(repeating: 0, count: count - lhs.values.count)
        let rhs = rhs.values + Array(repeating: 0, count: count - rhs.values.count)
        return AnimatableVector(values: vDSP.subtract(lhs, rhs))
    }

    public var values: [Double]

    public  mutating func scale(by rhs: Double) {
        values = vDSP.multiply(rhs, values)
    }

    public var magnitudeSquared: Double {
        vDSP.sum(vDSP.multiply(values, values))
    }

}

public struct DocumentShape: Shape {
    
    var detectedPoint: [CGPoint]
    var scaleX: Double
    var scaleY: Double
    var size: CGSize
    
    var vector: AnimatableVector

    public var animatableData: AnimatableVector {
        get { vector }
        set { vector = newValue }
    }
    
    public init(vector: AnimatableVector) {
        self.vector = vector
        self.detectedPoint = []
        self.scaleX = 1
        self.scaleY = 10
        self.size = .zero
    }
    
    public func path(in rect: CGRect) -> Path {
        guard vector.values.count > 2 else {
            return Path { _ in }
        }
        return Path { path in
            let xStep = rect.width / CGFloat(vector.values.count)
            var currentX: CGFloat = xStep
            path.move(to: .init(x: vector.values[0], y: vector.values[1]))
            path.addLine(to: .init(x: vector.values[2], y: vector.values[3]))
            path.addLine(to: .init(x: vector.values[4], y: vector.values[5]))
            path.addLine(to: .init(x: vector.values[6], y: vector.values[7]))
            path.closeSubpath()
        }
    }
}
