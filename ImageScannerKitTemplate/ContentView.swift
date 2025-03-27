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
    
    @State var flashToggle: Bool = false
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
                    Button("Flash") {
                        flashToggle.toggle()
                    }
                }
                .onChange(of: flashToggle) { oldValue, newValue in
                    handler.setFlashEnabled(newValue)
                }
                .overlay(alignment: .bottom) {
                    Button("Snap") {
                        if let image = handler.snap() {
                            self.image = image
                            handler.stopCamera()

                        }
                    }
                }
                .navigationDestination(item: $image) { img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            detector.detectDocument(in: img) { uiImage, pts in
                                let points = pts?.compactMap { $0.cgPointValue } ?? []
                                self.detectedPts = points
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
