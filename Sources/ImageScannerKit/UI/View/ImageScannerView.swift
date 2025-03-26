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
    var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void { get set}
    var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void { get set}
    
    init(onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void,
         onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void)
    
    init()
}

public struct ImageScannerView: ImageScannerViewProtocol {
    
    @Environment(\.cameraHandler) var cameraViewHandler

    public var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    public var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    
    public init(onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in},
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in}) {
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
        
    public init() {
      
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
        SharedCamera.shared.cameraViewHandler.setFlashEnabled(enabled)
        return .init(
            onDocumentDetected: onDocumentDetected,
            onDocumentSnapped: onDocumentSnapped
        )
    }
    
    /// Overrides onDocumentDetected from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        SharedCamera.shared.cameraViewHandler.DocumentDetected = callback
        return .init(onDocumentDetected: callback,
                     onDocumentSnapped: onDocumentSnapped)
    }
    
    /// Overrides onDocumentSnapped from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func onDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        SharedCamera.shared.cameraViewHandler.DocumentSnapped = callback
        return .init(onDocumentDetected: onDocumentDetected,
                     onDocumentSnapped: callback)
    }
    
    /// Add an action to the current DocumentDetected action from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func addActionOnDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        SharedCamera.shared.cameraViewHandler.moreDetectionActions.append(callback)
        return .init(onDocumentDetected: callback,
                     onDocumentSnapped: onDocumentSnapped)
    }
    
    /// Add an action to the current DocumentSnapped action from the CameraHandler
    /// - Parameter callback: reports an nsarray or corners and the frame image from which corners have been discovered
    /// - Returns: ImageScannerView
    func addActionOnDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        SharedCamera.shared.cameraViewHandler.moreSnappedActions.append(callback)
        return .init(onDocumentDetected: onDocumentDetected,
                     onDocumentSnapped: callback)
    }
}

#Preview {
    ImageScannerView()
    .isFlashEnabled(false)
    .onDocumentDetected { points, uiImage in
        
    }
    .onDocumentSnapped { points, uiImage in
        
    }
}
