//
//  ContentView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 23/03/2025.
//


import SwiftUI
import Combine

public struct DocumentScannerView: ImageScannerViewProtocol {
    
    @Environment(\.cameraHandler) var cameraViewHandler
    @Environment(\.cameraEvent) var snappedEvent
    @State var flow: Flow = .camera
    @State var detectedPoint: [CGPoint] = []
    @State var scaleX: Double = 0.0
    @State var scaleY: Double = 0.0
    @State private var vector: AnimatableVector = .zero
    @Namespace var perspective
    
    public var onDocumentDetected: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    public var onDocumentSnapped: (_ points: [NSValue], _ uiImage: UIImage) -> Void = { _, _ in}
    
    public init(onDocumentDetected: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in},
                onDocumentSnapped: @escaping (_: [NSValue], _: UIImage) -> Void = { _, _ in}) {
        self.onDocumentDetected = onDocumentDetected
        self.onDocumentSnapped = onDocumentSnapped
    }
    
    public init() { }
        
    public var body: some View {
        ContentAvailable()
            .onDisappear(perform: {
                self.cameraViewHandler.stopCamera()
            })
            .onReceive(snappedEvent) { s in
                withAnimation {
                    flow = s
                }
            }
    }
    
    @ViewBuilder
    func ContentAvailable() -> some View {
        VStack {
            switch flow {
            case .camera:
                scanView()
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.cameraViewHandler.startCamera()
                            self.cameraViewHandler.setAutoDetectionEnabled(true)
                        }
                    })
            case .detected(let snapped, let cropped):
                detectedView(snapped: snapped, cropped: cropped)
            case .snap(image: let snapped):
                detectedView(snapped: snapped, cropped: .init(cgImage: snapped.crop(), points: snapped.points))
            case .perspective(let image):
                perspective(image: image)
            @unknown default:
                ContentUnavailableView("Run the camera template on a device", image: "camera")
            }
        }
    }
    
    func scanView() -> some View {
        GeometryReader { geo in
            let size = geo.size
            ImageScannerView()
                .onDocumentDetected { points, uiImage in
                    let pts = points.map { $0.cgPointValue }
                    withAnimation(.interactiveSpring(duration: 0.5)) {
                        if points.isEmpty {
                            scaleX = 1.0
                            scaleY = 1.0
                            detectedPoint = [.zero, .init(x: size.width, y: 0), .init(x: size.width, y: size.height), .init(x: 0, y: size.height)]
                            vector = .init(values: [
                                0, 0,
                                size.width, 0,
                                size.width, size.height,
                                0, size.height
                            ])
                        } else {
                            scaleX = geo.size.width / uiImage.size.width
                            scaleY = geo.size.height / uiImage.size.height
                            detectedPoint = [
                                pts[0],
                                pts[1],
                                pts[2],
                                pts[3]
                            ]
                            vector = .init(values: [
                                pts[0].x * scaleX, pts[0].y * scaleY,
                                pts[1].x * scaleX, pts[1].y * scaleY,
                                pts[2].x * scaleX, pts[2].y * scaleY,
                                pts[3].x * scaleX, pts[3].y * scaleY,
                            ])
                        }
                    }
                }
                .onDocumentSnapped { points, uiImage in
                    self.cameraViewHandler.stopCamera()
                    let snapped = Snapped(cgImage: uiImage.cgImage!, points: points)
                    let cropped = Snapped(cgImage: snapped.crop(), points: points)
                    snappedEvent.send(.detected(snapped: snapped, cropped: cropped))
                }
                .overlay {
                    DocumentShape(vector: vector)
                        .stroke(style: .init(lineWidth: 4, lineCap: .round, dash: [8]))
                }
        }
    }
    
    func detectedView(snapped: Snapped, cropped: Snapped) -> some View {
        LightScannerAnimatedView {
            ImageLayer(snappedEvent: snappedEvent, snapped: snapped)
        }
        .overlay(content: {
            ImageLayer(snappedEvent: snappedEvent, snapped: cropped)
                .shadow(radius: 8)
        })
        .matchedGeometryEffect(id: "P", in: perspective)
        .onTapGesture {
            snappedEvent.send(.camera)
        }
    }
    
    func perspective(image: Snapped) -> some View {
        ImageLayer(snappedEvent: snappedEvent, snapped: image)
            .matchedGeometryEffect(id: "P", in: perspective)
    }
}
