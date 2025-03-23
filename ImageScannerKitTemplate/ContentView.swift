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
    
    let handler = CameraView.CameraViewHandler()
    
    var body: some View {
        DocumentScannerView(cameraViewHandler: handler)
            .overlay(alignment: .top) {
                Button("Flash") {
                    handler.setFlashEnabled(true)
                }
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
