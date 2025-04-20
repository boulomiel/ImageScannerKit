//
//  ImageMethod.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/04/2025.
//

import SwiftUI

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
    ImageMethod()
}
