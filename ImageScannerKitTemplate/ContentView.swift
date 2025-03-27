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
    
    @State var autoDetectionToggle = false
    @State var flashToggle: Bool = false
    @State var detectFromImage: Bool = false

    @Environment(\.cameraHandler) var handler
    @Environment(\.cameraEvent) var event
        
    let detector = DocumentDetectorIOS()
    
    @State var image: UIImage?
    @State var detectedPts: [CGPoint] = []



    var body: some View {
        NavigationStack {
            DocumentScannerView()
                .addActionOnDocumentSnapped { pts, img in
                    print("Action Added")
                }
                .onAppear(perform: {
                    handler.setAutoDetectionEnabled(false)
                })
                .overlay(alignment: .top) {

                }
                .overlay(alignment: .top) {
                    HStack {
                        Button("Autodetection \(autoDetectionToggle ? "ON" : "OFF")") {
                            autoDetectionToggle.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Flash") {
                            flashToggle.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
                .overlay(alignment: .bottom) {
                    HStack {
                        Button("Snap") {
                            if let image = handler.snap() {
                                self.image = image
                                handler.stopCamera()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Image") {
                            detectFromImage = true
                            self.image = UIImage(resource: .doc5)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.bottom)
                }
                .onChange(of: autoDetectionToggle) { oldValue, newValue in
                    handler.setAutoDetectionEnabled(newValue)
                }
                .onChange(of: flashToggle) { oldValue, newValue in
                    handler.setFlashEnabled(newValue)
                }
                .navigationDestination(item: $image) { img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            if detectFromImage {
                                let points: [CGPoint] = img.corners().compactMap { $0.cgPointValue }
                                self.detectedPts = points
                            } else {
                                detector.detectDocument(in: img) { uiImage, pts in
                                    let points: [CGPoint] = pts?.compactMap { $0.cgPointValue } ?? []
                                    self.detectedPts = points
                                }
                            }
                        }
                        .overlay {
                            if !detectedPts.isEmpty {
                                docPath(points: detectedPts, imageSize: img.size)
                            }
                        }
                }
        }
    }
    
    @ViewBuilder
    func docPath(points: [CGPoint], imageSize: CGSize) -> some View {
        GeometryReader { geo in
            let size = geo.size
            let widthRatio = size.width / imageSize.width
            let heightRatio = size.height  / imageSize.height
            
            let pts = points.map { CGPoint(x: $0.x * widthRatio, y: $0.y * heightRatio) }
            
            Path { p in
                p.move(to: pts[0])
                p.addLine(to: pts[1])
                p.addLine(to: pts[2])
                p.addLine(to: pts[3])
                p.closeSubpath()
            }
            .stroke(lineWidth: 3)
            .shadow(radius: 4)
        }
    }
    
}


struct ImageMethod: View {
    
    @State var image: UIImage = .init(named: "paperplane")!
    
    var body: some View {
        VStack {
            Image(uiImage: image)
            HStack {
                Button("brighness"){
                    image.brightness(100)
                }
            }
        }
    }
    
}


#Preview {
    ContentView()
}

#Preview {
    ImageMethod()
}
