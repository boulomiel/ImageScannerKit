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
    
    @Environment(\.cameraHandler) var handler
        
    var body: some View {
        DocumentScannerView()
            .addActionOnDocumentSnapped { pts, img in
                print("Action Added")
            }
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
