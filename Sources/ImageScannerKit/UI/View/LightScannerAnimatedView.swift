//
//  LightScannerAnimatedView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

import SwiftUI

public struct LightScannerAnimatedView<OnView: View>: View {
    
    @State var isAnimated: Bool = false
    @State var rectY: CGFloat = 0
    @State var blurRect: CGFloat = 8
    @State var rectOpacity: CGFloat = 0.8
    @State var blurView: CGFloat = 4
    @State var rectHeight: CGFloat = 40
    @ViewBuilder var view: () -> OnView
    
    public init(view: @escaping () -> OnView) {
        self.view = view
    }
    
    public  var body: some View {
        GeometryReader { geo in
            let size = geo.size
            view()
                .blur(radius: blurView, opaque: true)
                .position(x: size.width * 0.5, y: size.height * 0.5)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(height: rectHeight)
                        .blur(radius: blurRect, opaque: false)
                        .opacity(rectOpacity)
                        .shadow(radius: 12)
                        .position(x: size.width * 0.5, y: rectY)
                }
                .onAppear {
                    withAnimation(.linear(duration: 2.0).repeatForever()) {
                        rectY = geo.size.height
                        blurRect = 12
                        blurView = 20
                        rectOpacity = 0.4
                        rectHeight = 70
                    }
                }
        }
    }
}
