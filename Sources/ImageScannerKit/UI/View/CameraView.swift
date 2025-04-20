//
//  CameraView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/04/2025.
//

import SwiftUI

@MainActor
public enum CameraRequest: @preconcurrency CaseIterable {
    
    public static var allCases: [CameraRequest] = [.documentScanner(cameraHandler: SharedCamera.shared.cameraViewHandler), .textDetector]
    
    case documentScanner(cameraHandler: CameraViewAction)
    case textDetector
}

public struct CameraView: View {
    
    public let cameraRequest: CameraRequest
    
    public init(cameraRequest: CameraRequest) {
        self.cameraRequest = cameraRequest
    }
    
    public var body: some View {
        switch cameraRequest {
        case .documentScanner(let cameraHandler):
            DocumentCameraView(cameraViewHandler: cameraHandler)
        case .textDetector:
            MetalCameraView()
        }
    }
}
