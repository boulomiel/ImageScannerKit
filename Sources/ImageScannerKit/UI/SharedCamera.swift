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
    
    let cameraViewHandler: DocumentCameraView.CameraViewHandler
    let cameraEvent: CurrentValueSubject<Flow, Never>
    
    private init() {
        self.cameraViewHandler = .init()
        self.cameraEvent = .init(.camera)
    }
}

struct CameraViewHandlerKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: CameraViewAction = SharedCamera.shared.cameraViewHandler
}

struct CameraEventKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue: CurrentValueSubject<Flow, Never> = SharedCamera.shared.cameraEvent
}


public extension EnvironmentValues {
 
    var cameraHandler: CameraViewAction {
        get { self[CameraViewHandlerKey.self] }
        set { self[CameraViewHandlerKey.self] = newValue }
    }
    
    var cameraEvent:  CurrentValueSubject<Flow, Never> {
        get { self[CameraEventKey.self] }
        set { self[CameraEventKey.self] = newValue }
    }
}
