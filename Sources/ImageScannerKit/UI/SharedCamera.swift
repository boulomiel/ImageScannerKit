//
//  SharedCamera.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 25/03/2025.
//

import Combine
import SwiftUI

@MainActor
final public class SharedCamera {
    
    static let shared: SharedCamera = .init()
    
    let cameraViewHandler: CameraView.CameraViewHandler
    let cameraEvent: PassthroughSubject<Flow, Never>
    
    private init() {
        self.cameraViewHandler = .init()
        self.cameraEvent = .init()
    }
}

struct CameraViewHandlerKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: CameraView.CameraViewHandler = SharedCamera.shared.cameraViewHandler
}

struct CameraEventKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: PassthroughSubject<Flow, Never> = SharedCamera.shared.cameraEvent
}


public extension EnvironmentValues {
 
    var cameraHandler: CameraView.CameraViewHandler {
        get { self[CameraViewHandlerKey.self] }
        set { self[CameraViewHandlerKey.self] = newValue }
    }
    
    var cameraEvent:  PassthroughSubject<Flow, Never> {
        get { self[CameraEventKey.self] }
        set { self[CameraEventKey.self] = newValue }
    }
}
