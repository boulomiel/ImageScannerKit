//
//  MetalView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/03/2025.
//

import UIKit
import MetalKit
import CoreGraphics
import CoreImage

public class MetalView: MTKView {
    
    private var context: CIContext!
    private var queue: MTLCommandQueue!
    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    public var image: CIImage?
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.drawCIImge()
//            }
//        }
//    }
    
    public var snapShot: CIImage? {
        if let texture = self.currentDrawable?.texture,
           let cImg = CIImage(mtlTexture: texture, options: [.colorSpace: colorSpace]) {
            return cImg.oriented(.downMirrored)
        } else {
            return nil
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.isOpaque = false
        self.device = MetalDevice.shared.device
        self.framebufferOnly = false
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        self.context = CIContext(mtlDevice: MetalDevice.shared.device)
        self.queue = MetalDevice.shared.device.makeCommandQueue()
    }
    
    public init()  {
        super.init(frame: .zero, device: MetalDevice.shared.device)
        self.isOpaque = false
        framebufferOnly = false
        isPaused = true
        self.enableSetNeedsDisplay = false
        self.context = CIContext(mtlDevice: device!)
        self.queue = device!.makeCommandQueue()
        delegate = self
    }
    
    public init(frame: CGRect)  {
        super.init(frame: frame, device: MetalDevice.shared.device)
        self.isOpaque = false
        framebufferOnly = false
        isPaused = true
        self.enableSetNeedsDisplay = false
        self.context = CIContext(mtlDevice: device!)
        self.queue = device!.makeCommandQueue()
        delegate = self

    }
    
    private func drawCIImge() {
        guard let image = image else { return }
        guard let buffer = queue.makeCommandBuffer() else { return }
        guard let currentDrawable else { return }

        let destination = CIRenderDestination(
            width: Int(drawableSize.width),
            height: Int(drawableSize.height),
            pixelFormat: .rgba8Unorm,
            commandBuffer: buffer) {
                return currentDrawable.texture
            }
        do {
            try context.startTask(toRender: image, to: destination)
            buffer.present(currentDrawable)
            buffer.commit()
            draw()
        } catch {
            print(error)
        }
    }
}

extension MetalView: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    public func draw(in view: MTKView) {
        //create command buffer for ciContext to use to encode it's rendering instructions to our GPU
        guard let commandBuffer =  queue.makeCommandBuffer() else {
            return
        }
        
        //make sure we actually have a ciImage to work with
        guard let ciImage = image else {
            return
        }
        
        //make sure the current drawable object for this metal view is available (it's not in use by the previous draw cycle)
        guard let currentDrawable = view.currentDrawable else {
            return
        }
        
        //make sure frame is centered on screen
        let heightOfciImage = ciImage.extent.height
        let heightOfDrawable = view.drawableSize.height
        
        let widthOfciImage = ciImage.extent.width
        let widthOfDrawable = view.drawableSize.width
        
        let yOffsetFromBottom = (heightOfDrawable - heightOfciImage)/2
        let xOffsetFromLeft = (widthOfciImage - widthOfDrawable)/2
        
        //render into the metal texture
        self.context.render(ciImage,
                              to: currentDrawable.texture,
                   commandBuffer: commandBuffer,
                          bounds: CGRect(origin: CGPoint(x: xOffsetFromLeft, y: -yOffsetFromBottom), size: view.drawableSize),
                      colorSpace: CGColorSpaceCreateDeviceRGB())
        
        //register where to draw the instructions in the command buffer once it executes
        commandBuffer.present(currentDrawable)
        //commit the command to the queue so it executes
        commandBuffer.commit()
    }
    
    
}
