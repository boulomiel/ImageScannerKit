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
    
    public var isFlashEnabled: Binding<Bool>
    public var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    public var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    
    public init(isFlashEnabled: Binding<Bool>,
                onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in},
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in}) {
        self.isFlashEnabled = isFlashEnabled
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
    
    public init(onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in},
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in}) {
        self.isFlashEnabled = .constant(false)
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
    
    public init() {
        self.isFlashEnabled = .constant(false)
        self.onDocumentDetected = { _, _ in}
        self.onDocumentSnapped = { _, _ in}
    }
    
    public var body: some View {
#if targetEnvironment(simulator)
        ContentUnavailableView("No camera in simulator", systemImage: "camera")
#else
        CameraView(isFlashEnabled: isFlashEnabled,
                   onDocumentDetected: onDocumentDetected,
                   onDocumentSnapped: onDocumentSnapped)
#endif
    }
}

public struct CameraView: UIViewRepresentable {
    
    public typealias UIViewType = UIImageView
    
    @Binding var isFlashEnabled: Bool
    var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void
    var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void
    
    public init(isFlashEnabled: Binding<Bool>,
                onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void,
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void) {
        self._isFlashEnabled = isFlashEnabled
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
    
    public func makeUIView(context: Context) -> UIImageView {
        context.coordinator.start()
        return context.coordinator.frameView
    }
    
    public func updateUIView(_ uiView: UIImageView, context: Context) {
        context.coordinator.cameraHandler.toggleFlash(isFlashEnabled)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onDocumentDetected: onDocumentDetected, onDocumentSnapped: onDocumentSnapped)
    }
    
    @MainActor
    public class Coordinator: NSObject, CameraHandlerFrameHolder, CameraHandlerDelegate {
        
        lazy var cameraHandler: CameraHandler = .init(frameHolder: self, andDelegate: self)
        public var frameView: UIImageView = .init(image: nil)
        var parent: CameraView
        var DocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void
        var DocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void
        
        init(parent: CameraView,
             uiImage: UIImage? = nil,
             onDocumentDetected: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void,
             onDocumentSnapped: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void
        ) {
            self.parent = parent
            self.frameView = .init(image: uiImage)
            self.DocumentSnapped = onDocumentSnapped
            self.DocumentDetected = onDocumentDetected
        }
        
        func start() {
            cameraHandler.startCamera()
        }
        
        public func onDocumentSnapped(_ points: [Any], andImage uiImage: UIImage) {
            let cgPoints = points.compactMap { $0 as? NSValue }
            print("Swift !", "snapped", cgPoints)
            DocumentSnapped(cgPoints, uiImage)
            cameraHandler.stopCamera()
        }
        
        public func onDocumentDetected(_ points: [Any], andImage uiImage: UIImage) {
            let cgPoints = points.compactMap { $0 as? NSValue }
            DocumentDetected(cgPoints, uiImage)
        }
    }
}

public extension ImageScannerView {
    
    func isFlashEnabled(_ enabled: Binding<Bool>) -> Self {
        let copy = self
        return ImageScannerView(isFlashEnabled: enabled, onDocumentDetected: copy.onDocumentDetected, onDocumentSnapped: copy.onDocumentSnapped)
    }
    
    func onDocumentDetected(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        let copy = self
        return ImageScannerView(isFlashEnabled: copy.isFlashEnabled, onDocumentDetected: callback, onDocumentSnapped: copy.onDocumentSnapped)
    }
    
    func onDocumentSnapped(_ callback: @escaping (_ points: [NSValue], _ uiImage: UIImage) -> Void) -> Self {
        let copy = self
        return ImageScannerView(isFlashEnabled: copy.isFlashEnabled, onDocumentDetected: copy.onDocumentDetected, onDocumentSnapped: callback)
    }
}

#Preview {
    ImageScannerView()
        .isFlashEnabled(.constant(false))
        .onDocumentDetected { points, uiImage in
            
        }
        .onDocumentSnapped { points, uiImage in
            
        }
}
