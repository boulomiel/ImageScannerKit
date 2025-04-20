//
//  MetalKitView.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 19/04/2025.
//
import CoreMedia
import MetalKit
@preconcurrency import CoreVideo

final class MetalKitView: MTKView {
    
    private var ciImage: CIImage?
    private let commandQueue: MTLCommandQueue
    
    private lazy var context: CIContext = CIContext(mtlDevice: MetalDevice.shared.device)
    
    private lazy var descriptor: MTLTextureDescriptor = {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.usage = [.shaderWrite, .shaderRead]
        return descriptor
    }()
    
    required init(coder: NSCoder) {
        fatalError("Not initialized")
    }
    
    init() {
        guard let commandQueue = MetalDevice.shared.device.makeCommandQueue() else {
            fatalError("Could not create comman queue")
        }
        self.commandQueue = commandQueue
        super.init(frame: .zero, device: MetalDevice.shared.device)
        self.device = MetalDevice.shared.device
//        drawableSize.width = 720
//        drawableSize.height = 1280
        delegate = self
        isPaused = true
        framebufferOnly = true
        addSubview(imageView)
      //  autoResizeDrawable = true
        imageView.frame = .init(origin: .zero, size: .init(width: 100, height: 100))
    }
    
    var imageView: UIImageView = .init()
    
    var subImage: UIImage? {
        didSet {
            self.imageView.image = subImage
        }
    }
    
    nonisolated public func addPixelBuffer(buffer: sending CIImage) {
        Task { @MainActor  in
            self.ciImage = buffer
            draw()
            self.subImage = UIImage(ciImage: buffer)
        }
    }
}


extension MetalKitView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print(#function, "resized", size)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        guard let ciImage else {
            return
        }
        guard let currentDrawable = currentDrawable else {
            return
        }
        
        let widthScale = drawableSize.width / ciImage.extent.width
        let heightScale = drawableSize.height / ciImage.extent.height
        let scale = min(widthScale, heightScale)
        let scaledImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let yPos = drawableSize.height / 2 - scaledImage.extent.height / 2
        let bounds = CGRect(x: 0, y: CGFloat(-yPos), width: drawableSize.width, height: drawableSize.height)

        context.render(ciImage,
                       to: currentDrawable.texture,
                       commandBuffer: commandBuffer,
                       bounds: bounds,
                       colorSpace: CGColorSpaceCreateDeviceRGB())
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
