//
//  Flow.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 16/03/2025.
//

public enum Flow {
    case camera
    case snap(image: Snapped)
    case cropped(previous: Snapped, image: Snapped)
    case perspective(image: Snapped)
}
