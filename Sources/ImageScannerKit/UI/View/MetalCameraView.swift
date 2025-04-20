//
//  MetalCameraView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/04/2025.
//

import MetalKit
import SwiftUI
@preconcurrency import AVFoundation
@preconcurrency import CoreVideo

public struct MetalCameraView: View {
    
    public init() {}
    
    public var body: some View {
        MetalCameraViewWrapper()
           // .background(Color.red)
    }
}

struct MetalCameraViewWrapper: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.device = MetalDevice.shared.device
        metalView.delegate = context.coordinator
     //   metalView.clearColor = MTLClearColorMake(0, 0.5, 1, 1)
        metalView.framebufferOnly = false
        context.coordinator.setupCamera()
        return metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
       // uiView.draw()
    }
    
    public final class Coordinator: NSObject, MTKViewDelegate, VideoCaptureDelegate {
        
        let parent: MetalCameraViewWrapper
        let camera: MetalCamera
        let commandQueue: MTLCommandQueue
        var ciImage: CIImage?
        var textDetector: EASTDetector?
        
        init(parent: MetalCameraViewWrapper) {
            self.parent = parent
            self.camera = MetalCamera()
            self.commandQueue = MetalDevice.shared.device.makeCommandQueue()!
            super.init()
            self.camera.delegate = self
        }
        
        func setupCamera() {
            camera.setUp(sessionPreset: .hd1280x720)
            textDetector = EASTDetector()
            textDetector?.initDetector()
        }
        
        func start() {
            camera.start()
        }
        
        public func videoCapture(_ capture: MetalCamera, didCaptureVideoFrame: sending CIImage, timestamp: CMTime) {
            self.ciImage = didCaptureVideoFrame
        }
        
        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        public func draw(in view: MTKView) {
            guard let commandBuffer = commandQueue.makeCommandBuffer() else {
                return
            }
            guard let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
            guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)  else { return }
            commandEncoder.endEncoding()
            guard let ciImage else { return }
            guard let drawable = view.currentDrawable else { return }
            var transform = CGAffineTransform.identity
            
            let (xScale, yScale) = (view.drawableSize.width / ciImage.extent.width,
                                    view.drawableSize.height / ciImage.extent.height)
            let scale = xScale < yScale ? xScale : yScale
            transform = transform.scaledBy(x: scale, y: scale)
            let newImg = ciImage.transformed(by: transform)
            
            let yOffsetFromBottom = (view.drawableSize.height - newImg.extent.height)/2
            let xOffsetFromBottom = (view.drawableSize.width - newImg.extent.width)/2
            let bounds =  CGRect(origin: CGPoint(x: -xOffsetFromBottom, y: -yOffsetFromBottom), size: view.drawableSize)
            MetalDevice.shared.context.render(newImg,
                                              to: drawable.texture,
                                              commandBuffer: commandBuffer,
                                              bounds: bounds,
                                              colorSpace: CGColorSpaceCreateDeviceRGB())
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}


