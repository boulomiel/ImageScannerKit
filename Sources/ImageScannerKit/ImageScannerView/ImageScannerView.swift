//
//  ContentView.swift
//  ImageScannerKitTemplate
//
//  Created by Ruben Mimoun on 27/02/2025.
//

import SwiftUI
import SwiftData
import Combine

public struct ImageScannerView: View {
    
    let cameraViewHandler: CameraView.CameraViewHandler
    public var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    public var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    
    public init(cameraViewHandler: CameraView.CameraViewHandler,
                onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in},
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in}) {
        self.cameraViewHandler = cameraViewHandler
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
        
    public init(cameraViewHandler: CameraView.CameraViewHandler) {
        self.cameraViewHandler = cameraViewHandler
    }
    
    public var body: some View {
#if targetEnvironment(simulator)
        ContentUnavailableView("No camera in simulator", systemImage: "camera")
#else
        CameraView(cameraViewHandler: cameraViewHandler,
                   onDocumentDetected: onDocumentDetected,
                   onDocumentSnapped: onDocumentSnapped)
#endif
    }
}

public extension ImageScannerView {
    
    func isFlashEnabled(_ enabled: Bool) -> Self {
        let copy = self
        cameraViewHandler.setFlashEnabled(enabled)
        return ImageScannerView(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: copy.onDocumentDetected,
                                onDocumentSnapped: copy.onDocumentSnapped)
    }
    
    
    /// Overrides onDocumentDetected from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        let copy = self
        cameraViewHandler.DocumentDetected = callback
        return ImageScannerView(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: callback,
                                onDocumentSnapped: copy.onDocumentSnapped)
    }
    
    /// Overrides onDocumentSnapped from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        let copy = self
        cameraViewHandler.DocumentSnapped = callback
        return ImageScannerView(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: copy.onDocumentDetected,
                                onDocumentSnapped: callback)
    }
}

#Preview {
    ImageScannerView(cameraViewHandler: .init(onDocumentDetected: { points, uiImage in
        
    }, onDocumentSnapped: { points, uiImage in
        
    }))
    .isFlashEnabled(false)
    .onDocumentDetected { points, uiImage in
        
    }
    .onDocumentSnapped { points, uiImage in
        
    }
}
