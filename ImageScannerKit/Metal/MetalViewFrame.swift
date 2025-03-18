//
//  MetalViewFrame.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/03/2025.
//
import UIKit

public class MetalViewFrame: UIView {
    
    private var metalView: MetalView?
    
    public func onAppear() {
        print(Self.self, frame, bounds)
        metalView = .init(frame: frame)
        addSubview(metalView!)
        bringSubviewToFront(metalView!)
    }
    
    public func draw(_ ciImage: CIImage) {
        metalView?.image = ciImage
        metalView?.draw()
    }

    public override func layoutSubviews() {
         super.layoutSubviews()
         DispatchQueue.main.async { [weak self] in
             guard let self = self else { return }
             self.metalView?.frame = self.bounds
         }
     }
    
    public override func removeFromSuperview() {
        metalView?.removeFromSuperview()
        super.removeFromSuperview()
    }
    
}
