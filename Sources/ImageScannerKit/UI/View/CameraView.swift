//
//  CameraView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 23/03/2025.
//

public typealias CameraViewAction = CameraHandlerFrameHolder & CameraHandlerDelegate

import SwiftUI

public struct CameraView: UIViewRepresentable {
    
    public typealias UIViewType = UIImageView
    
    let cameraViewHandler: CameraViewAction
    var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void
    var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void
    
    public init(
        cameraViewHandler: CameraViewAction,
        onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void,
        onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void) {
            self.onDocumentDetected = onDocumentDetected
            self.onDocumentSnapped = onDocumentSnapped
            self.cameraViewHandler = cameraViewHandler
        }
    
    public func makeUIView(context: Context) -> UIImageView {
        return cameraViewHandler.frameView
    }
    
    public func updateUIView(_ uiView: UIImageView, context: Context) {
       
    }
    
    public class CameraViewHandler: NSObject, CameraViewAction {
        
        var cameraHandler: CameraHandler!
        public var frameView: UIImageView = .init(image: nil)
        var DocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void
        var DocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void
        
        var moreDetectionActions: [(_ points: [NSValue], _ uiImage: UIImage) -> Void]
        var moreSnappedActions: [(_ points: [NSValue], _ uiImage: UIImage) -> Void]
        
        public init(onDocumentDetected: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void,
                    onDocumentSnapped: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void
        ) {
            self.frameView = .init(image: nil)
            self.DocumentSnapped = onDocumentDetected
            self.DocumentDetected = onDocumentSnapped
            self.moreSnappedActions = []
            self.moreDetectionActions = []
            super.init()
            self.cameraHandler = .init(frameHolder: self, andDelegate: self)
        }
        
        public override init() {
            self.frameView = .init(image: nil)
            self.DocumentSnapped = { _, _ in }
            self.DocumentDetected = { _, _ in }
            self.moreSnappedActions = []
            self.moreDetectionActions = []
            super.init()
            self.cameraHandler = .init(frameHolder: self, andDelegate: self)
        }
        
        public func startCamera() {
            cameraHandler.startCamera()
        }
        
        public func stopCamera() {
            cameraHandler.stopCamera()
        }
        
        public func snap() {
            if let image = cameraHandler.onSnap(), let cgImage = image.cgImage {
                SharedCamera.shared.cameraEvent.send(.snap(image: .init(cgImage: cgImage, points: image.corners())))
            }
        }
        
        public func setFlashEnabled(_ isEnabled: Bool) {
            cameraHandler.toggleFlash(isEnabled)
        }
        
        public func setUIDetectionEnabled(_ isEnabled: Bool) {
            cameraHandler.setUIDetectionActivated(isEnabled)
        }
        
        public func setAutoDetectionEnabled(_ isEnabled: Bool) {
            cameraHandler.setAutoDetectionActivated(isEnabled)
        }
        
        public func onDocumentSnapped(_ points: [Any], andImage uiImage: UIImage) {
            setAutoDetectionEnabled(false)
            let cgPoints = points.compactMap { $0 as? NSValue }
            print("Swift !", "snapped", cgPoints)
            DocumentSnapped(cgPoints, uiImage)
            moreSnappedActions.forEach { action in
                action(cgPoints, uiImage)
            }
        }
        
        public func onDocumentDetected(_ points: [Any], andImage uiImage: UIImage) {
            let cgPoints = points.compactMap { $0 as? NSValue }
            DocumentDetected(cgPoints, uiImage)
            moreDetectionActions.forEach { action in
                action(cgPoints, uiImage)
            }
        }
    }
}

public class PreviewCameraHandler: NSObject, CameraViewAction {
    public func snap() { }
    
    public func onDocumentDetected(_ points: [Any]!, andImage uiImage: UIImage!) { }
    
    public var frameView: UIImageView? = nil
    
}
