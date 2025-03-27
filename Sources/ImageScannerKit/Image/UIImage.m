//
//  UIImage.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import "Crop/Crop.h"
#import "Rotate/Rotate.h"
#import "Binary/Binary.h"
#import "Contrast/Contrast.h"
#import "Brightness/Brightness.h"
#import "Sharpness/Sharpness.h"
#import "Channel/Channel.h"
#import "Corners/Corners.h"
#import "PerspectiveTransform/PerspectiveTransform.h"

@implementation UIImage(OpencvExtension)

/// Check if the current image contains 4 channels (RGBA, BGRA, HSVA...)
/// - Parameter image: Image to be checked
/// - Returns: true if the image is a four channel matrix
-(bool) hasFourChannels: (UIImage *) image {
    Channel *channel = [[Channel alloc] init];
    return [channel hasFourChannels:self];
}

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

-(UIImage*) contrast: (float) alpha andBeta:(float) beta {
    Contrast* contrast = [[Contrast alloc] init];
    return [contrast contrast:self withAlpha:alpha andBeta:beta];
}

-(UIImage*) brightness:(float) value {
    Brightness* brightness = [[Brightness alloc] init];
    return [brightness brightness:self andValue:value];
}

- (UIImage *)sharpness:(float) strength {
    Sharpness* sharpness = [[Sharpness alloc] init];
    return [sharpness sharpness:self withStrength:strength];
}

- (NSArray<NSValue*> *) corners {
    Corners* corners = [[Corners alloc] init];
    return [corners corners:self];
}

@end
