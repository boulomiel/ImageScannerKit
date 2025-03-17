//
//  ImageLayer.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import SwiftUI
import Combine

public struct ImageLayer: View {
    
    let snappedEvent: PassthroughSubject<Flow, Never>
    let snapped: Snapped
    
    public init(snappedEvent: PassthroughSubject<Flow, Never>, snapped: Snapped) {
        self.snappedEvent = snappedEvent
        self.snapped = snapped
    }
    
    public var body: some View {
        Image(uiImage: snapped.uiImage)
            .resizable()
    }
}
