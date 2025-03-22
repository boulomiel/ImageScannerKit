// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
@_exported import ImageScannerKit

struct ImageTest: View {
    
    @State var image: UIImage = .init(systemName: "paperplane")!
    
    var body: some View {
        VStack {
            Image(uiImage: image)
            HStack {
                Button("Brigthness") {
                    image.brightness(100)
                }
            }
        }
    }
}
