//
//  MetalDevice.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/03/2025.
//


@preconcurrency import Metal
@preconcurrency import CoreImage

final public class MetalDevice: @unchecked Sendable {
    public let device: MTLDevice
    public let context: CIContext
    static let shared: MetalDevice = .init()
    
    public init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not run metal device")
        }
        self.device = device
        self.context = CIContext(mtlDevice: device)
    }
}
