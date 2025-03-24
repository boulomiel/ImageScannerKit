//
//  ContentView.swift
//  ImageScannerKitTemplate
//
//  Created by Ruben Mimoun on 27/02/2025.
//

import SwiftUI
import SwiftData
import Combine

public protocol ImageScannerViewProtocol: View {
    var cameraViewHandler: CameraView.CameraViewHandler { get }
    var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void { get set}
    var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void { get set}
    
    init(cameraViewHandler: CameraView.CameraViewHandler,
                onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void,
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void)
    
    init(cameraViewHandler: CameraView.CameraViewHandler)
}

public struct ImageScannerView: ImageScannerViewProtocol {
    
    public let cameraViewHandler: CameraView.CameraViewHandler
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

public extension ImageScannerViewProtocol {
    
    func isFlashEnabled(_ enabled: Bool) -> Self {
        cameraViewHandler.setFlashEnabled(enabled)
        return .init(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: onDocumentDetected,
                                onDocumentSnapped: onDocumentSnapped)
    }
    
    /// Overrides onDocumentDetected from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        cameraViewHandler.DocumentDetected = [callback]
        return .init(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: callback,
                                onDocumentSnapped: onDocumentSnapped)
    }
    
    /// Overrides onDocumentSnapped from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        cameraViewHandler.DocumentSnapped = [callback]
        return .init(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: onDocumentDetected,
                                onDocumentSnapped: callback)
    }
    
    /// Add an action to the current DocumentDetected action from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func addActionOnDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        cameraViewHandler.DocumentDetected.append(callback)
        return .init(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: callback,
                                onDocumentSnapped: onDocumentSnapped)
    }
    
    /// Add an action to the current DocumentSnapped action from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func addActionOnDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        cameraViewHandler.DocumentSnapped.append(callback)
        return .init(cameraViewHandler: cameraViewHandler,
                                onDocumentDetected: onDocumentDetected,
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
