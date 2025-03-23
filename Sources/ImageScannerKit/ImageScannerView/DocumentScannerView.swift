//
//  ContentView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 23/03/2025.
//


import SwiftUI
import Combine

public struct DocumentScannerView: View {
    
    let snappedEvent: PassthroughSubject<Flow, Never> = .init()
    @State var flow: Flow = .camera
    @State var detectedPoint: [CGPoint] = []
    @State var scaleX: Double = 0.0
    @State var scaleY: Double = 0.0
    @Namespace var perspective
    
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
        ContentAvailable()
            .onReceive(snappedEvent) { s in
                withAnimation {
                    flow = s
                }
            }
    }
    
    @ViewBuilder
    func ContentAvailable() -> some View {
        switch flow {
        case .camera:
            scanView()
                .onAppear {
                    cameraViewHandler.startCamera()
                }
        case .snap(let image):
            snapView(image: image)
        case .cropped(let previous, let image):
            croppedView(previous: previous, image: image)
        case .perspective(let image):
            perspective(image: image)
        @unknown default:
            ContentUnavailableView("Run the camera template on a device", image: "camera")
        }
    }
    
    func scanView() -> some View {
        GeometryReader { geo in
            ImageScannerView(cameraViewHandler: cameraViewHandler)
                .onDocumentDetected { points, uiImage in
                    let pts = points.map { $0.cgPointValue }
                    withAnimation(.interactiveSpring(duration: 0.5)) {
                        if points.isEmpty {
                            scaleX = 1.0
                            scaleY = 1.0
                            detectedPoint = []
                        } else {
                            scaleX = geo.size.width / uiImage.size.width
                            scaleY = geo.size.height / uiImage.size.height
                            detectedPoint = [
                                pts[3],
                                pts[2],
                                pts[1],
                                pts[0]
                            ]
                        }
                    }
                }
                .onDocumentSnapped { points, uiImage in
                    let snapped = Snapped(uiImage: uiImage, points: points)
                    let cropped = Snapped(uiImage: snapped.crop(), points: points)
                    snappedEvent.send(.cropped(previous: snapped, image: cropped))
                }
                .overlay {
                    DocumentShape(detectedPoint: detectedPoint, scaleX: scaleX, scaleY: scaleY)
                        .stroke(style: .init(lineWidth: 4, lineCap: .round, dash: [8]))
                }
        }
    }
    
    func snapView(image: Snapped) -> some View {
        ImageLayer(snappedEvent: snappedEvent, snapped: image)
            .matchedGeometryEffect(id: "P", in: perspective)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        snappedEvent.send(.camera)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Crop") {
                        snappedEvent.send(.cropped(previous: image, image: .init(uiImage: image.crop(), points: image.points)))
                    }
                }
            }
    }
    
    func croppedView(previous: Snapped, image: Snapped) -> some View {
        ZStack {
            LightScannerAnimatedView {
                ImageLayer(snappedEvent: snappedEvent, snapped: previous)
            }
            ImageLayer(snappedEvent: snappedEvent, snapped: image)
                .shadow(radius: 8)
                .matchedGeometryEffect(id: "P", in: perspective)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            snappedEvent.send(.camera)
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button("transform") {
                            snappedEvent.send(.perspective(image: .init(uiImage: image.perspectiveTransformed(), points: image.points)))
                        }
                    }
                }
        }
        .onTapGesture {
            snappedEvent.send(.camera)
        }
    }
    
    func perspective(image: Snapped) -> some View {
        ImageLayer(snappedEvent: snappedEvent, snapped: image)
            .matchedGeometryEffect(id: "P", in: perspective)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        snappedEvent.send(.camera)
                    }
                }
            }
    }
}
