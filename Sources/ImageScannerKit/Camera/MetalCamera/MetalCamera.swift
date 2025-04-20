//
//  CameraMetalViewController.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 18/04/2025.
//


import UIKit
import AVFoundation
import MetalKit
@preconcurrency import CoreImage

public protocol VideoCaptureDelegate: AnyObject {
    func videoCapture(_ capture: MetalCamera, didCaptureVideoFrame: sending CIImage, timestamp: CMTime)
}

public class MetalCamera: NSObject, @unchecked Sendable {

    public weak var delegate: VideoCaptureDelegate?
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let queue = DispatchQueue(label: "camera-queue")
    
    public func setUp(sessionPreset: AVCaptureSession.Preset) {
        queue.async {
            self.setUpCamera(sessionPreset: sessionPreset)
            self.start()
        }
    }
    
    @discardableResult
    func setUpCamera(sessionPreset: AVCaptureSession.Preset) -> Bool {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Error: no video devices available")
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            fatalError("Error: could not create AVCaptureDeviceInput")
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let settings: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        ]
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        videoOutput.connections.first?.videoRotationAngle = 90
        captureSession.commitConfiguration()
        return true
    }
    
    public func start() {
        queue.async {[weak self] in
          //  if !self?.captureSession.isRunning == false {
                self?.captureSession.startRunning()
          //  }
        }
    }
    
    public func stop() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension MetalCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let bufferedImage = CIImage(cvPixelBuffer: imageBuffer)
        delegate?.videoCapture(self, didCaptureVideoFrame: bufferedImage, timestamp: CMTime())
    }
}
