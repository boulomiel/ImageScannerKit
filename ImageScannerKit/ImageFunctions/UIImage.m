//
//  UIImage.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import "Crop/Crop.h"
#import "Rotate/Rotate.h"
#import "Binary/Binary.h"
#import "PerspectiveTransform/PerspectiveTransform.h"

@implementation UIImage(Crop)

-(UIImage *)crop: (NSArray<NSValue *> *) toPoints {
    Crop *crop = [[Crop alloc] init];
    return [crop crop:self toPoints: toPoints];
}

-(UIImage *)perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination {
    PerspectiveTransform *transform = [[PerspectiveTransform alloc] init];
    return [transform perspectiveTransform:sourcePoints with:sourceImage toDestination:destination];
}

- (UIImage *)rotate: (int)flag {
    Rotate* rotate = [[Rotate alloc] init];
    return [rotate rotate:self andFlag:flag];
}

- (UIImage *)rotateToAngle: (float)angle {
    Rotate* rotate = [[Rotate alloc] init];
    return [rotate rotate:self toAngle:angle];
}

-(UIImage*) toAdaptiveBinary {
    Binary* binary = [[Binary alloc] init];
    return [binary toAdaptiveBinary:self];
}

-(UIImage*) toBinary: (float) threshold {
    Binary* binary = [[Binary alloc] init];
    return [binary toBinary:self withThreshold:threshold];
}

@end
