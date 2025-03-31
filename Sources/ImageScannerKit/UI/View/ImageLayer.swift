//
//  ImageLayer.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import SwiftUI
import Combine

public struct ImageLayer: View {
    
    let snappedEvent: CurrentValueSubject<Flow, Never>
    let snapped: Snapped
    
    public init(snappedEvent: CurrentValueSubject<Flow, Never>, snapped: Snapped) {
        self.snappedEvent = snappedEvent
        self.snapped = snapped
    }
    
    public var body: some View {
        Image(uiImage: UIImage(cgImage: snapped.cgImage))
            .resizable()
    }
}
