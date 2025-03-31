//
//  Flow.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

public enum Flow {
    case camera
    case detected(snapped: Snapped, cropped: Snapped)
    case perspective(image: Snapped)
    case snap(image: Snapped)
}
