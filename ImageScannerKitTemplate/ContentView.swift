//
//  ContentView.swift
//  ImageScannerKitTemplate
//
//  Created by Ruben Mimoun on 27/02/2025.
//

import SwiftUI
import SwiftData
import ImageScannerKit
import Combine

struct ContentView: View {
    
    let snappedEvent: PassthroughSubject<Flow, Never> = .init()
    @State var isFlashEnabled: Bool = false
    @State var flow: Flow = .camera
    @State var detectedPoint: [CGPoint] = []
    @State var scaleX: Double = 0.0
    @State var scaleY: Double = 0.0
    @Namespace var perspective
    
    var body: some View {
        NavigationStack {
#if targetEnvironment(simulator)
            ContentUnavailableView("Run the camera template on a device", image: "camera")
#else
            ZStack {
                switch flow {
                case .camera:
                    GeometryReader { geo in
                        ImageScannerView()
                            .isFlashEnabled($isFlashEnabled)
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
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Toggle Flash") {
                                isFlashEnabled.toggle()
                            }
                        }
                    }
                case .snap(let image):
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
                case .cropped(let previous, let image):
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
                case .perspective(let image):
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
            .onReceive(snappedEvent) { s in
                withAnimation {
                    flow = s
                }
            }
#endif
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
