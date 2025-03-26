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
        
    var body: some View {
        DocumentScannerView()
            .addActionOnDocumentSnapped { pts, img in
                print("Action Added")
            }
            .overlay(alignment: .top) {
                Button("Flash") {
                    flashToggle.toggle()
                }
            }
            .onChange(of: flashToggle) { oldValue, newValue in
                handler.setFlashEnabled(newValue)
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
